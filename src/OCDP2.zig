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
const Gl = @import("OCDP.zig").Gl;
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
    vertexShader: ?c.GLuint = null,
    fragmentShader: ?c.GLuint = null,
    program: ?c.GLuint = null,
    vao: ?c.GLuint = null,
    vbo: ?c.GLuint = null,
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
        const vertexShaderId = try ShaderUtils.compile(Gl.ShaderTypeTag.Vertex, vertexShaderSource);
        try ShaderUtils.assert.shaderCompiled(vertexShaderId);

        //- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
        self.glObjects.vertexShader = vertexShaderId;
        //- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

        // [fragment shader]
        try cfs.readFileToInternalBuffer("./src/shaders/shader.frag", 1024 * 1024);
        const fragmentShaderSource = try cfs.getBufferAsIs();
        const fragmentShaderId = try ShaderUtils.compile(Gl.ShaderTypeTag.Fragment, fragmentShaderSource);
        try ShaderUtils.assert.shaderCompiled(fragmentShaderId);

        //- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
        self.glObjects.fragmentShader = fragmentShaderId;
        //- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

        // Link shaders into a program
        const shaderProgramId: Gl.ProgramId = c.glCreateProgram();
        c.glAttachShader(shaderProgramId, self.glObjects.vertexShader.?);
        c.glAttachShader(shaderProgramId, self.glObjects.fragmentShader.?);
        c.glLinkProgram(shaderProgramId);
        try ShaderUtils.assert.programLinked(shaderProgramId);

        //- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
        self.glObjects.program = shaderProgramId;
        //- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

        // As shaders are now linked into the program, we no longer need them.
        c.glDeleteShader(self.glObjects.vertexShader.?);
        c.glDeleteShader(self.glObjects.fragmentShader.?);
        try ShaderUtils.assert.noGlError("glDeleteShader");

        //- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
        self.glObjects.vertexShader = null;
        self.glObjects.fragmentShader = null;
        //- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

        //=============================================================================

        // const nameArray = "transform";
        const cStringArray = [1][*c]const c.GLchar{"model"};
        const name: [*c]const c.GLchar = cStringArray[0];

        const targetUniformVariableLocation: c.GLint = c.glGetUniformLocation(self.glObjects.program.?, name);
        const targetUniformVariableNumberOfMatrices: c.GLsizei = 1;

        try ShaderUtils.assert.noGlError("2_UniformLocation_get"); // https://docs.gl/gl4/glGetUniformLocation

        if (targetUniformVariableLocation == -1) {
            return error.InvalidUniformLocation;
        }

        c.glUseProgram(self.glObjects.program.?);
        try ShaderUtils.assert.noGlError("2_UseProgram");

        var transform_flat: [16]c.GLfloat = undefined;
        var idx: usize = 0;
        for (_transform) |row| {
            for (row) |cell| {
                transform_flat[idx] = cell;
                idx += 1;
            }
        }

        c.glUniformMatrix4fv(
            targetUniformVariableLocation,
            targetUniformVariableNumberOfMatrices,
            MatricesSuppliedIn.colMajorOrder,
            &transform_flat[0],
        );
        try ShaderUtils.assert.noGlError("2_UniformMatrix4fv"); // https://docs.gl/gl4/glUniform

        //=============================================================================

        // Vertex Buffer Object (VBO)

        var vertexBuffer: c.GLuint = undefined;
        c.glGenBuffers(1, &vertexBuffer);
        try ShaderUtils.assert.noGlError("3_VBO_generate");

        // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
        self.glObjects.vbo = vertexBuffer;
        // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

        // Bind VBO
        c.glBindBuffer(c.GL_ARRAY_BUFFER, self.glObjects.vbo.?);
        try ShaderUtils.assert.noGlError("3_VBO_bind");
        // set data
        // c.glBufferData(c.GL_ARRAY_BUFFER, @as(c.GLsizeiptr, @sizeOf(f32) * @as(c_longlong, shape.vertices.*.len)), &shape.vertices, c.GL_STATIC_DRAW);

        const maxVertexCount = @as(usize, @intCast(std.math.maxInt(c_longlong)));
        const verticesLengthOrPanic = if (testShape.vertices.len <= maxVertexCount) @as(c_longlong, @intCast(testShape.vertices.len)) else std.debug.panic("shape.vertices.len too large", .{});
        const verticesPtr: ?*const anyopaque = @ptrCast(&testShape.vertices);
        c.glBufferData(c.GL_ARRAY_BUFFER, verticesLengthOrPanic, verticesPtr, c.GL_STATIC_DRAW);
        try ShaderUtils.assert.noGlError("3_VBO_data");

        // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
        // Vertex Array Object (VAO)

        var vertexArrayObject: c.GLuint = undefined;
        c.glGenVertexArrays(1, &vertexArrayObject);
        try ShaderUtils.assert.noGlError("3_VAO_generate");

        // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
        self.glObjects.vao = vertexArrayObject;
        // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

        // Bind VAO
        c.glBindVertexArray(self.glObjects.vao.?);
        try ShaderUtils.assert.noGlError("3_VAO_bind");

        // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

        const indexOfVertexAttributeToEnable: c.GLuint = 0;
        c.glEnableVertexAttribArray(indexOfVertexAttributeToEnable);
        try ShaderUtils.assert.noGlError("2_VertexAttribArray_enable"); // https://docs.gl/gl4/glEnableVertexAttribArray

        const indexOfVertexAttributeToModify: c.GLuint = 0;
        const numberOfComponentsPerVertexAttribute: c.GLint = 3;
        const dataTypeOfEachComponent: c.GLenum = c.GL_FLOAT;
        const normalizeFixedPointDataValues: c.GLboolean = c.GL_FALSE;
        const byteOffsetBetweenConsecutiveVertexAttribute: c.GLsizei = 3 * @sizeOf(f32);
        const byteOffsetToFirstGenericVertexAttribute: ?*const c.GLvoid = null;

        // didn't we already bind the buffer? why do we need to do it again?
        c.glBindBuffer(c.GL_ARRAY_BUFFER, self.glObjects.vbo.?);

        c.glVertexAttribPointer(
            indexOfVertexAttributeToModify,
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
