// generics
const std = @import("std");
const c = @import("c.zig");

// 3rd party
const zm = @import("zmath");

// debug helpers
const is_test = @import("builtin").is_test;
const NameUtils = @import("debug_helpers.zig").DotNotation;
const FsUtils = @import("build_helpers.zig").CFS;

// aliases for navigation
// const Type = std.builtin.Type;

//=============================================================================
// DEPENDENCIES
const gl = @import("cImportRemap.zig").gl;
const MyGl = @import("OCDP.zig").MyGl;
const BasicShape = @import("OCDP.zig").BasicShape;
const MatricesSuppliedIn = @import("OCDP.zig").MatricesSuppliedIn;

// Test shape
const testShape = @import("OCDP.zig").cube;
// const testShape = @import("OCDP.zig").triangle;

//=============================================================================
// UTILS

/// OpenGL Shader related helper functions / abstractions
pub const ShaderUtils = struct {
    //

    /// Assert success, or return error.
    pub const assert = struct {
        //

        /// Error if shader compilation failed.
        pub fn shaderCompiled(shader: MyGl.ShaderId) !void {
            var status: i32 = undefined;
            gl.getShaderiv(shader, gl.COMPILE_STATUS, &status);
            if (status == gl.TRUE) return void{};

            // ..else log it, and return an error

            // TODO: look at programLinked() below, to remove const maxLength = 512;

            const maxLength = 512;
            var string: [maxLength]gl._char = undefined;
            var stringLength: gl._sizei = undefined;
            gl.getShaderInfoLog(shader, maxLength, &stringLength, &string);
            std.debug.print("Failed to compile shader. GL Info Log:\n{s}\n", .{string[0..string.len]});
            return error.GL_ShaderCompile_Failed;
        }

        /// Error if shader program linking failed.
        pub fn programLinked(program: MyGl.ProgramId) !void {
            var status: gl._int = undefined;
            gl.getProgramiv(program, gl.LINK_STATUS, &status);
            if (status == gl.TRUE) return void{};

            // ..else log it, and return an error

            var infoLogLength: gl._int = undefined;
            gl.getProgramiv(program, gl.INFO_LOG_LENGTH, &infoLogLength);
            const allocator: std.mem.Allocator = std.heap.page_allocator;

            // '+1' from tutorial, maybe for null termination?
            // - should we add null manually?
            const _infoLength: usize = @intCast(infoLogLength);
            var programErrorMessage = try allocator.alloc(gl._char, _infoLength + 1);
            defer allocator.free(programErrorMessage);

            // ## TODO ## should this not be .ptr instead of @ptrCast(&..) ? like we did with GL.bufferData() ?
            var cCompatPtrToStringBuffer: [*c]gl._char = @ptrCast(&programErrorMessage);

            gl.getProgramInfoLog(program, infoLogLength, null, cCompatPtrToStringBuffer);
            std.debug.print("Failed to link shader. GL Info Log:\n{s}\n", .{programErrorMessage[0..programErrorMessage.len]});
            return error.GL_ShaderProgramLink_Failed;
        }

        /// Check GL error flag after GL operation.
        /// NB: Does not report shader compilation failures.
        pub fn noGlError(mark: []const u8) !void {
            //

            // TODO: glGetError is suppose to be called in a loop until it returns GL_NO_ERROR
            // - As there may be multiple errors queued up
            // - see: https://docs.gl/gl4/glGetError

            // fetch and clear queued error
            const status: gl._enum = gl.getError();
            if (status == gl.NO_ERROR) return void{};
            // If result == GL_NO_ERROR:
            // - there has been no detectable error since the last call to glGetError,
            // - or since the GL was initialized.
            // - List of defined errors: https://docs.gl/gl4/glGetError

            // TODO: see todo above

            const errString = switch (status) {
                gl.INVALID_ENUM => "GL_INVALID_ENUM",
                gl.INVALID_VALUE => "GL_INVALID_VALUE",
                gl.INVALID_OPERATION => "GL_INVALID_OPERATION",
                gl.INVALID_FRAMEBUFFER_OPERATION => "GL_INVALID_FRAMEBUFFER_OPERATION",
                gl.OUT_OF_MEMORY => "GL_OUT_OF_MEMORY",
                else => "Unknown",
            };

            // ..else log it, and return an error
            std.debug.print("[{s}] GL Error '{s}' (0x{x}) occured during recent GL operation.\n", .{ mark, errString, status });
            return error.GL_Operation_Error;
        }
    };

    /// Compile shader, returns shader Id, or error.
    /// Does not check compilation status
    /// `source` is plain zig slice (no null termination required for this function)
    /// Caller responsiple to check for successful compilation
    pub fn compile(shaderType: MyGl.ShaderTypeTag, source: []const u8) !MyGl.ShaderId {
        // If we know the length of the source string (like with a zig slice),
        // then it doesn't need to be in null terminated c-style

        // safe-cast usize of source.len to GLint
        var validLength: gl._int = undefined;
        if (source.len > std.math.maxInt(gl._int)) {
            std.debug.print("source.len too large", .{});
            return error.GL_compileShader_SourceTooLong;
        } else validLength = @intCast(source.len);

        // create gl shader, returns Id (ref) of object, 0 if error
        const shaderId: MyGl.ShaderId = gl.createShader(@as(gl._uint, @intFromEnum(shaderType)));
        if (shaderId == 0) {
            std.debug.print("Failed to create {s} shader object.", .{@tagName(shaderType)});
            return error.GL_compileShader_CreateShaderFailed;
        }

        // set shader source on shader object
        const arraySize = 1;
        const arrayOfStrings = [arraySize][*c]const gl._char{source.ptr};
        const arrayOfLengths = [arraySize]gl._int{validLength};
        gl.shaderSource(shaderId, arraySize, &arrayOfStrings, &arrayOfLengths);

        // compile shader source
        gl.compileShader(shaderId);

        // return without checking if compilation was successful
        return shaderId;
    }

    /// Generate buffer object id (aka name), and bind it as `bufferType`.
    /// - TODO: make arg typea local / not-external
    /// - kind: `gl.ARRAY_BUFFER`, `gl.ELEMENT_ARRAY_BUFFER`, etc
    /// - mark: text tag for debug printing
    pub fn generateAndBindBufferAs(bufferType: gl._enum, comptime mark: []const u8) !gl._uint {
        //
        var buffer: gl._uint = undefined;
        const count = 1;
        gl.genBuffers(count, &buffer);
        try ShaderUtils.assert.noGlError(mark ++ "_genBuffers");

        // No buffer objects are associated with the returned buffer object names
        // until they are first bound by calling glBindBuffer.
        gl.bindBuffer(bufferType, buffer);
        try ShaderUtils.assert.noGlError(mark ++ "_bindBuffer");

        return buffer;
    }
    pub fn generateAndBindVertexArray(comptime mark: []const u8) !gl._uint {
        //
        var vertexArray: gl._uint = undefined;
        gl.genVertexArrays(1, &vertexArray);
        try ShaderUtils.assert.noGlError(mark ++ "_genVertexArrays");

        gl.bindVertexArray(vertexArray);
        try ShaderUtils.assert.noGlError(mark ++ "_bindVertexArray");

        return vertexArray;
    }
};

//=============================================================================
// IMPLEMENTATION

pub const MemLocationTag = enum { Heap, Stack, NoWhere };

pub const OCDP2Options = struct {
    allocator: ?*const std.mem.Allocator = null,
};

pub const GlContext = struct {
    vertexShader: ?gl._uint = null, // vertex shader id
    fragmentShader: ?gl._uint = null, // fragment shader id
    program: ?gl._uint = null, // shader program id
    vao: ?gl._uint = null, // vertex array object
    vbo: ?gl._uint = null, // vertex buffer object
    ebo: ?gl._uint = null, // element buffer object
    colorBuffer: ?gl._uint = null, // color buffer
    mvpLocation: ?gl._int = null, // matrix id ?
    mvpData: ?zm.Mat = null, // model-view-projection matrix
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
    context: GlContext = GlContext{},

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
        // Log out this function name at entry and exit` ` ` ` ` `
        const memo = comptime NameUtils.ofFunction(deinit).full();
        if (!is_test) std.debug.print("[{s}] ..\n", .{memo});
        defer if (!is_test) std.debug.print("[{s}] done.\n", .{memo});
        // ` ` ` ` ` ` ` ` ` ` ` ` ` ` ` ` ` ` ` ` ` ` ` ` ` ` ` `

        // Cleanup
        gl.deleteBuffers(1, &self.context.vbo.?);
        gl.deleteBuffers(1, &self.context.colorBuffer.?);
        gl.deleteProgram(self.context.program.?);
        gl.deleteVertexArrays(1, &self.context.vao.?);

        ShaderUtils.assert.noGlError("cleanup") catch |err| {
            std.debug.print("Error during cleanup:\n{!}", .{err});
        };

        if (!self.initialized) return;

        self.allocator = undefined;
        self.initialized = false;
    }

    pub fn setup(self: *OCDP2) !void {
        // Log out this function name at entry and exit` ` ` ` ` `
        const memo = comptime NameUtils.ofFunction(setup).full();
        if (!is_test) std.debug.print("[{s}] ..\n", .{memo});
        defer if (!is_test) std.debug.print("[{s}] done.\n", .{memo});
        // ` ` ` ` ` ` ` ` ` ` ` ` ` ` ` ` ` ` ` ` ` ` ` ` ` ` ` `

        //-----------------------------------------------------------------------------

        // Can be re-used for reading all shader files
        var cfs = FsUtils.onStack();
        _ = try cfs.init(&std.heap.page_allocator);
        defer cfs.deinit();

        //- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
        // [vertex shader]

        self.context.vertexShader = blk: {
            try cfs.readFileToInternalBuffer("./src/shaders/shader.vert", 1024 * 1024);
            const vertexShaderSource = try cfs.getBufferAsIs();
            const vertexShaderId = try ShaderUtils.compile(MyGl.ShaderTypeTag.Vertex, vertexShaderSource);
            try ShaderUtils.assert.shaderCompiled(vertexShaderId);
            break :blk vertexShaderId;
        };

        //- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
        // [fragment shader]

        self.context.fragmentShader = blk: {
            try cfs.readFileToInternalBuffer("./src/shaders/shader.frag", 1024 * 1024);
            const fragmentShaderSource = try cfs.getBufferAsIs();
            const fragmentShaderId = try ShaderUtils.compile(MyGl.ShaderTypeTag.Fragment, fragmentShaderSource);
            try ShaderUtils.assert.shaderCompiled(fragmentShaderId);
            break :blk fragmentShaderId;
        };

        //- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
        // Link shaders into a program

        self.context.program = blk: {
            const shaderProgramId: MyGl.ProgramId = gl.createProgram();
            gl.attachShader(shaderProgramId, self.context.vertexShader.?);
            gl.attachShader(shaderProgramId, self.context.fragmentShader.?);
            gl.linkProgram(shaderProgramId);
            try ShaderUtils.assert.programLinked(shaderProgramId);
            break :blk shaderProgramId;
        };

        gl.detachShader(self.context.program.?, self.context.vertexShader.?);
        gl.detachShader(self.context.program.?, self.context.fragmentShader.?);
        try ShaderUtils.assert.noGlError("detachShaders");

        gl.deleteShader(self.context.vertexShader.?);
        gl.deleteShader(self.context.fragmentShader.?);
        try ShaderUtils.assert.noGlError("deleteShaders");

        self.context.vertexShader = null;
        self.context.fragmentShader = null;

        //-----------------------------------------------------------------------------
        // VAO: Generate & Bind

        self.context.vao = try ShaderUtils.generateAndBindVertexArray("VAO");

        // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
        // VBO: Generate, Bind, set data

        self.context.vbo = try ShaderUtils.generateAndBindBufferAs(gl.ARRAY_BUFFER, "VBO");
        gl.bufferData(gl.ARRAY_BUFFER, testShape.verticesLen(), testShape.vertices.ptr, gl.STATIC_DRAW);
        try ShaderUtils.assert.noGlError("VBO_data");

        // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

        // EBO: Generate, Bind, set data
        // Type: ELEMENT_ARRAY_BUFFER (no need for bind or vertexAttribPointer)

        self.context.ebo = try ShaderUtils.generateAndBindBufferAs(gl.ELEMENT_ARRAY_BUFFER, "EBO");
        gl.bufferData(gl.ELEMENT_ARRAY_BUFFER, testShape.indicesLenAs(gl._sizeiptr), testShape.indices.ptr, gl.STATIC_DRAW);
        try ShaderUtils.assert.noGlError("EBO_data");

        // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

        // Color buffer: generate, bind, set data

        self.context.colorBuffer = try ShaderUtils.generateAndBindBufferAs(gl.ARRAY_BUFFER, "ColorBuffer");
        gl.bufferData(gl.ARRAY_BUFFER, testShape.colorsLen(), testShape.colors.ptr, gl.STATIC_DRAW);
        try ShaderUtils.assert.noGlError("3_ColorBuffer_data");

        // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

        // unbind VBO & VAO
        gl.bindBuffer(gl.ARRAY_BUFFER, 0);
        gl.bindVertexArray(0);

        //-----------------------------------------------------------------------------
        // Create matrices

        // Projection matrix
        const projection = zm.perspectiveFovLh(std.math.pi * 0.25, 16.0 / 9.0, 0.1, 100.0);

        // View (camera) matrix
        const view = zm.lookAtLh(zm.f32x4(4.0, 3.0, 3.0, 1.0), zm.f32x4(0.0, 0.0, 0.0, 1.0), zm.f32x4(0.0, 1.0, 0.0, 0.0));

        // Model matrix
        const model = zm.identity();

        // Multiply matrices
        const mv = zm.mul(model, view);
        self.context.mvpData = zm.mul(mv, projection);

        self.context.mvpLocation = gl.getUniformLocation(self.context.program.?, "MVP");

        //-----------------------------------------------------------------------------
    }

    pub fn render(self: *OCDP2, window: *c.GLFWwindow) !void {
        //

        const attributeLocation_color = 1; // "location=1" in vertex shader
        const attributeLocation_vbo = 0; // "location=0" in vertex shader
        // TODO: locations like above to be handles/stored in some similar way as below mvp
        const uniformLocation_mvp = self.context.mvpLocation.?;

        while (c.glfwWindowShouldClose(window) == gl.FALSE) {
            //

            // which shader program to use
            gl.useProgram(self.context.program.?);
            // set it's uniform(s)
            gl.uniformMatrix4fv(uniformLocation_mvp, 1, gl.FALSE, &self.context.mvpData.?[0][0]);

            // clear the screen
            gl.clear(gl.COLOR_BUFFER_BIT | gl.DEPTH_BUFFER_BIT);

            // Change polygon mode to wireframe
            // gl.polygonMode(gl.FRONT_AND_BACK, gl.LINE);

            // bind a vertex array object
            gl.bindVertexArray(self.context.vao.?);
            // enable the attributes we want to use
            gl.enableVertexAttribArray(attributeLocation_vbo);
            gl.enableVertexAttribArray(attributeLocation_color);

            // Vertex data (bind and set attribute data)
            gl.bindBuffer(gl.ARRAY_BUFFER, self.context.vbo.?);
            gl.vertexAttribPointer(attributeLocation_vbo, 3, gl.FLOAT, gl.FALSE, 0, null);

            // Color data (bind and set attribute data)
            gl.bindBuffer(gl.ARRAY_BUFFER, self.context.colorBuffer.?);
            gl.vertexAttribPointer(attributeLocation_color, 3, gl.FLOAT, gl.FALSE, 0, null);

            // EBO  (elements) is already bound to the VAO
            // - and of type ELEMENT_ARRAY_BUFFER
            // - thus no need for bind or vertexAttribPointer like above
            gl.drawElements(gl.TRIANGLES, self.context.shape.indicesLenAs(gl._sizei), gl.UNSIGNED_INT, null);

            // not strictly necessary in 'modern', but convention /  good practice
            gl.disableVertexAttribArray(attributeLocation_vbo);
            gl.disableVertexAttribArray(attributeLocation_color);

            // Unbind your VAO
            gl.bindVertexArray(0);

            // Revert polygon mode back to fill if you wish to draw other objects normally
            gl.polygonMode(gl.FRONT_AND_BACK, gl.FILL);

            c.glfwSwapBuffers(window);
            c.glfwPollEvents();

            try ShaderUtils.assert.noGlError("render");
        }
    }
};

test "OCDP2: onStack, init, deinit" {
    var ocdp2 = OCDP2.onStack(null);
    try ocdp2.init();
    defer ocdp2.deinit();
}
