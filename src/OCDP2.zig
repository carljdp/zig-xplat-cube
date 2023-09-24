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

        // [vertex shader]
        try cfs.readFileToInternalBuffer("./src/shaders/shader.vert", 1024 * 1024);
        const vertexShaderSource = try cfs.getBufferAsIs();
        const vertexShaderId = try ShaderUtils.compile(MyGl.ShaderTypeTag.Vertex, vertexShaderSource);
        try ShaderUtils.assert.shaderCompiled(vertexShaderId);

        //- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
        self.glObjects.vertexShader = vertexShaderId;
        //- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

        // [fragment shader]
        try cfs.readFileToInternalBuffer("./src/shaders/shader.frag", 1024 * 1024);
        const fragmentShaderSource = try cfs.getBufferAsIs();
        const fragmentShaderId = try ShaderUtils.compile(MyGl.ShaderTypeTag.Fragment, fragmentShaderSource);
        try ShaderUtils.assert.shaderCompiled(fragmentShaderId);

        //- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
        self.glObjects.fragmentShader = fragmentShaderId;
        //- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

        // Link shaders into a program
        const shaderProgramId: MyGl.ProgramId = GL.createProgram();
        GL.attachShader(shaderProgramId, self.glObjects.vertexShader.?);
        GL.attachShader(shaderProgramId, self.glObjects.fragmentShader.?);
        GL.linkProgram(shaderProgramId);
        try ShaderUtils.assert.programLinked(shaderProgramId);

        //- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
        self.glObjects.program = shaderProgramId;
        //- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

        // As shaders are now linked into the program, we no longer need them.
        GL.deleteShader(self.glObjects.vertexShader.?);
        GL.deleteShader(self.glObjects.fragmentShader.?);
        try ShaderUtils.assert.noGlError("glDeleteShader");

        //- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
        self.glObjects.vertexShader = null;
        self.glObjects.fragmentShader = null;
        //- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

        //=============================================================================

        // const nameArray = "transform";
        const cStringArray = [1][*c]const GL._char{"model"};
        const name: [*c]const GL._char = cStringArray[0];

        const targetUniformVariableLocation: GL._int = GL.getUniformLocation(self.glObjects.program.?, name);
        const targetUniformVariableNumberOfMatrices: GL._sizei = 1;

        try ShaderUtils.assert.noGlError("2_UniformLocation_get"); // https://docs.gl/gl4/glGetUniformLocation

        if (targetUniformVariableLocation == -1) {
            return error.InvalidUniformLocation;
        }

        GL.useProgram(self.glObjects.program.?);
        try ShaderUtils.assert.noGlError("2_UseProgram");

        var transform_flat: [16]GL._float = undefined;
        var idx: usize = 0;
        for (_transform) |row| {
            for (row) |cell| {
                transform_flat[idx] = cell;
                idx += 1;
            }
        }

        GL.uniformMatrix4fv(
            targetUniformVariableLocation,
            targetUniformVariableNumberOfMatrices,
            MatricesSuppliedIn.colMajorOrder,
            &transform_flat[0],
        );
        try ShaderUtils.assert.noGlError("2_UniformMatrix4fv"); // https://docs.gl/gl4/glUniform

        //=============================================================================

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

        // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
        // VBO: Set Data

        const maxVertexCount = @as(usize, @intCast(std.math.maxInt(c_longlong)));
        const verticesLengthOrPanic = if (testShape.vertices.len <= maxVertexCount) @as(c_longlong, @intCast(testShape.vertices.len)) else std.debug.panic("shape.vertices.len too large", .{});
        const verticesPtr: ?*const anyopaque = @ptrCast(&testShape.vertices);

        GL.bufferData(GL.ARRAY_BUFFER, verticesLengthOrPanic, verticesPtr, GL.STATIC_DRAW);
        try ShaderUtils.assert.noGlError("3_VBO_data");

        // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
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

        const attributeIndex: GL._uint = 0;

        GL.enableVertexAttribArray(attributeIndex);
        try ShaderUtils.assert.noGlError("2_VertexAttribArray_enable"); // https://docs.gl/gl4/glEnableVertexAttribArray

        const numberOfComponentsPerVertexAttribute: GL._int = 3;
        const dataTypeOfEachComponent: GL._enum = GL.FLOAT;
        const normalizeFixedPointDataValues: GL._boolean = GL.FALSE;
        const byteOffsetBetweenConsecutiveVertexAttribute: GL._sizei = 3 * @sizeOf(f32);
        const byteOffsetToFirstGenericVertexAttribute: ?*const GL._void = null;

        // didn't we already bind the buffer? why do we need to do it again?
        GL.bindBuffer(GL.ARRAY_BUFFER, self.glObjects.vbo.?);

        GL.vertexAttribPointer(
            attributeIndex,
            numberOfComponentsPerVertexAttribute,
            dataTypeOfEachComponent,
            normalizeFixedPointDataValues,
            byteOffsetBetweenConsecutiveVertexAttribute,
            byteOffsetToFirstGenericVertexAttribute,
        );
        try ShaderUtils.assert.noGlError("2_VertexAttribPointer_modify"); // https://docs.gl/gl4/glVertexAttribPointer

        // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

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
