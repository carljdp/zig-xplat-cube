// generics
const std = @import("std");
const c = @import("c.zig");

// debug helpers
const is_test = @import("builtin").is_test;
const NameUtils = @import("debug_helpers.zig").DotNotation;
const FsUtils = @import("build_helpers.zig").CFS;

// aliases for navigation
// const Type = std.builtin.Type;

//=============================================================================
// DEPENDENCIES
const GL = @import("cImportRemap.zig").GL;
const MyGl = @import("OCDP.zig").MyGl;
const ShaderUtils = @import("OCDP.zig").ShaderUtils;
const BasicShape = @import("OCDP.zig").BasicShape;
const MatricesSuppliedIn = @import("OCDP.zig").MatricesSuppliedIn;
const testShape = @import("OCDP.zig").triangle;
const _transform = @import("OCDP.zig")._transform;

//=============================================================================
// IMPLEMENTATION

pub const MemLocationTag = enum { Heap, Stack, NoWhere };

pub const OCDP2Options = struct {
    allocator: ?*const std.mem.Allocator = null,
};

pub const GlObjectStuff = struct {
    vertexShader: ?GL._uint = null,
    fragmentShader: ?GL._uint = null,
    program: ?GL._uint = null,
    vao: ?GL._uint = null,
    vbo: ?GL._uint = null,
    ebo: ?GL._uint = null,
    shape: BasicShape = testShape,
};

pub const OCDP2 = struct {
    /// Whether or not the instance is on the stack, or was allocated on the heap
    /// - Set to true if we return an instance for which we allocated memory
    /// - The caller is responsible for the allocated memory
    location: MemLocationTag = MemLocationTag.NoWhere,

    /// Whether or not the instance has been initialized
    initialized: bool = false,

    /// The allocator to use for allocating memory internally
    allocator: *const std.mem.Allocator = &std.heap.page_allocator,

    /// The GL objects
    glObjects: GlObjectStuff = GlObjectStuff{},

    // todo: to indicate this is static??
    // var location: MemLocationTag = MemLocationTag.NoWhere;

    /// Returns an instance of the stack. Example usage:
    /// ```
    /// var ocdp2 = OCDP2.onStack(null);
    /// try ocdp2.init();
    /// defer ocdp2.deinit();
    /// ```
    pub fn onStack(allocator: ?*const std.mem.Allocator) OCDP2 {
        return OCDP2{
            .location = MemLocationTag.Stack,
            .allocator = allocator orelse &std.heap.page_allocator,
            .initialized = false,
        };
    }

    /// Example usage:
    /// ```
    /// var ocdp2 = OCDP2.onStack(null);
    /// try ocdp2.init();
    /// defer ocdp2.deinit();
    /// ```
    pub fn init(self: *OCDP2) !void {
        // todo: perhaps only check this if passed in as option?
        //if (self.initialized) return [void|error|panic|etc];

        // init stuff

        self.initialized = true;
    }

    pub fn deinit(self: *OCDP2) void {
        if (!self.initialized) return;

        // deinit stuff

        self.allocator = undefined;
        self.initialized = false;
    }

    pub fn setup(self: *OCDP2) !void {
        // Log out this function name at entry and exit` ` ` ` ` `
        const memo = comptime NameUtils.ofFunction(setup).full();
        if (!is_test) std.debug.print("[{s}] ..\n", .{memo});
        defer if (!is_test) std.debug.print("[{s}] done.\n", .{memo});
        // ` ` ` ` ` ` ` ` ` ` ` ` ` ` ` ` ` ` ` ` ` ` ` ` ` ` ` `

        //- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

        // Can be re-used for reading all shader files
        var cfs = FsUtils.onStack();
        _ = try cfs.init(&std.heap.page_allocator);
        defer cfs.deinit();

        //- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
        // [vertex shader]

        self.glObjects.vertexShader = blk: {
            try cfs.readFileToInternalBuffer("./src/shaders/shader.vert", 1024 * 1024);
            const vertexShaderSource = try cfs.getBufferAsIs();
            const vertexShaderId = try ShaderUtils.compile(MyGl.ShaderTypeTag.Vertex, vertexShaderSource);
            try ShaderUtils.assert.shaderCompiled(vertexShaderId);
            break :blk vertexShaderId;
        };

        //- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
        // [fragment shader]

        self.glObjects.fragmentShader = blk: {
            try cfs.readFileToInternalBuffer("./src/shaders/shader.frag", 1024 * 1024);
            const fragmentShaderSource = try cfs.getBufferAsIs();
            const fragmentShaderId = try ShaderUtils.compile(MyGl.ShaderTypeTag.Fragment, fragmentShaderSource);
            try ShaderUtils.assert.shaderCompiled(fragmentShaderId);
            break :blk fragmentShaderId;
        };

        //- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
        // Link shaders into a program

        self.glObjects.program = blk: {
            const shaderProgramId: MyGl.ProgramId = GL.createProgram();
            GL.attachShader(shaderProgramId, self.glObjects.vertexShader.?);
            GL.attachShader(shaderProgramId, self.glObjects.fragmentShader.?);
            GL.linkProgram(shaderProgramId);
            try ShaderUtils.assert.programLinked(shaderProgramId);
            break :blk shaderProgramId;
        };

        GL.detachShader(self.glObjects.program.?, self.glObjects.vertexShader.?);
        GL.detachShader(self.glObjects.program.?, self.glObjects.fragmentShader.?);
        try ShaderUtils.assert.noGlError("detachShaders");

        GL.deleteShader(self.glObjects.vertexShader.?);
        GL.deleteShader(self.glObjects.fragmentShader.?);
        try ShaderUtils.assert.noGlError("deleteShaders");

        self.glObjects.vertexShader = null;
        self.glObjects.fragmentShader = null;

        //- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
        // VAO: Generate & Bind

        self.glObjects.vao = blk: {
            var arrayOfVaoNames: GL._uint = undefined;
            GL.genVertexArrays(1, &arrayOfVaoNames);
            try ShaderUtils.assert.noGlError("3_VAO_generate");

            // Acquires state and type only when they are first bound.
            GL.bindVertexArray(arrayOfVaoNames);
            try ShaderUtils.assert.noGlError("3_VAO_bind");

            break :blk arrayOfVaoNames;
        };

        // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
        // VBO: Generate & Bind

        self.glObjects.vbo = blk: {
            var arrayOfVboNames: GL._uint = undefined;
            GL.genBuffers(1, &arrayOfVboNames);
            try ShaderUtils.assert.noGlError("3_VBO_generate");

            // No buffer objects are associated with the returned buffer object names
            // until they are first bound by calling glBindBuffer.
            GL.bindBuffer(GL.ARRAY_BUFFER, arrayOfVboNames);
            try ShaderUtils.assert.noGlError("3_VBO_bind");

            break :blk arrayOfVboNames;
        };

        // VBO: Set Data

        const maxVertexCount = @as(usize, @intCast(std.math.maxInt(c_longlong)));
        const verticesLengthOrPanic = if (testShape.vertices.len <= maxVertexCount) @as(c_longlong, @intCast(testShape.vertices.len)) else std.debug.panic("shape.vertices.len too large", .{});

        // * size of vertexComponent's type i.e. f32
        const verticesDataStoreSize: GL._sizeiptr = verticesLengthOrPanic * @sizeOf(f32);
        if (verticesDataStoreSize == 0) std.debug.panic("verticesDataStoreSize is 0\n", .{});

        GL.bufferData(GL.ARRAY_BUFFER, verticesDataStoreSize, testShape.vertices.ptr, GL.STATIC_DRAW);
        try ShaderUtils.assert.noGlError("3_VBO_data");

        // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

        // EBO: Generate & Bind

        self.glObjects.ebo = blk: {
            var arrayOfEboNames: GL._uint = undefined;
            GL.genBuffers(1, &arrayOfEboNames);
            try ShaderUtils.assert.noGlError("3_EBO_generate");

            // Acquires state and type only when they are first bound.
            GL.bindBuffer(GL.ELEMENT_ARRAY_BUFFER, arrayOfEboNames);
            try ShaderUtils.assert.noGlError("3_EBO_bind");

            break :blk arrayOfEboNames;
        };

        // EBO: Set Data

        const maxIndexCount = @as(usize, @intCast(std.math.maxInt(c_longlong)));
        const indicesLengthOrPanic = if (testShape.indices.len <= maxIndexCount) @as(c_longlong, @intCast(testShape.indices.len)) else std.debug.panic("shape.indices.len too large", .{});

        // * size of index's type i.e. GL._uint
        const indicesDataStoreSize: GL._sizeiptr = indicesLengthOrPanic * @sizeOf(GL._uint);
        if (indicesDataStoreSize == 0) std.debug.panic("indicesDataStoreSize is 0\n", .{});

        GL.bufferData(GL.ELEMENT_ARRAY_BUFFER, indicesDataStoreSize, testShape.indices.ptr, GL.STATIC_DRAW);
        try ShaderUtils.assert.noGlError("3_EBO_data");

        // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

        GL.vertexAttribPointer(0, 3, GL.FLOAT, GL.FALSE, 3 * @sizeOf(f32), null);
        GL.enableVertexAttribArray(0);

        // unbind VBO
        GL.bindBuffer(c.GL_ARRAY_BUFFER, 0);
        // unbind VAO
        GL.bindVertexArray(0);
    }

    pub fn render(self: *OCDP2) !void {
        _ = self;
        // Log out this function name at entry and exit` ` ` ` ` `
        const memo = comptime NameUtils.ofFunction(render).full();
        if (!is_test) std.debug.print("[{s}] ..\n", .{memo});
        defer if (!is_test) std.debug.print("[{s}] done.\n", .{memo});
        // ` ` ` ` ` ` ` ` ` ` ` ` ` ` ` ` ` ` ` ` ` ` ` ` ` ` ` `
    }
};

test "OCDP2: onStack, init, deinit" {
    var ocdp2 = OCDP2.onStack(null);
    try ocdp2.init();
    defer ocdp2.deinit();
}
