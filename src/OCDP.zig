// generics
const std = @import("std");
const c = @import("c.zig");

// types debugging
const TT = @import("TT.zig").TT;
const XT = @import("TT.zig").ExplicitTypes;
const TypeOf = @import("debug_helpers.zig").TypeOf;

// debug helpers
const is_test = @import("builtin").is_test;
const Name = @import("debug_helpers.zig").DotNotation;
const CFS = @import("build_helpers.zig").CFS;

// aliases
const expect = std.testing.expect;

// Here's an outline for drawing a wireframe cube

// pub fn embedFile(path: []const u8) ![]const u8 {
//     const allocator = std.heap.page_allocator;
//     var file = try allocator.openFile(path, .{});
//     defer allocator.closeFile(&file);

//     var data = try file.readUntilDelimiterAlloc('\0', allocator);
//     return data;
// }

// comptime Embed = struct {
//     path: []const u8,
//     data: []const u8,

//     fn textFile(path: []const u8) !Embed {
//         const _data = @embedFile(path)
//     }
//     // fn file(path: []const u8) !Embed {
//     //     const allocator = std.heap.page_allocator;
//     //     var file = try allocator.openFile(path, .{});
//     //     defer allocator.closeFile(&file);

//     //     var data = try file.readUntilDelimiterAlloc('\0', allocator);
//     //     return Embed{ .path = path, .data = data };
//     // }
// }

const MyStruct = struct {
    allocator: *const std.mem.Allocator,
    resources: std.ArrayList(*u8),

    pub fn init(allocator: *const std.mem.Allocator) !MyStruct {
        var resources = std.ArrayList(*u8).init(allocator);
        return MyStruct{ .allocator = allocator, .resources = resources };
    }

    pub fn allocateNewT(self: *MyStruct, comptime T: type) !*T {
        const resource = try self.allocator.create(T);
        try self.resources.append(@as(*u8, @ptrCast(resource)));
        return resource;
    }

    pub fn deinit(self: *MyStruct) void {
        for (self.resources.items) |resource| {
            _ = resource;
            // Custom logic to free each type of resource
            // ...
        }
        self.resources.deinit();
    }
};

//------------------------------------------------------------------------------

pub const ShaderStuff = struct {
    // pub fn getShaderSource(path: []const u8) ![]const u8 {
    //     const allocator = std.heap.page_allocator;
    //     var file = try allocator.openFile(path, .{});
    //     defer allocator.closeFile(&file);

    //     var data = try file.readUntilDelimiterAlloc('\0', allocator);
    //     return data;
    // }

    pub const assert = struct {
        /// Error if shader compilation failed.
        pub fn compileSuccess(shader: ShaderRef) !void {
            var compilationResult: i32 = undefined;
            c.glGetShaderiv(shader, c.GL_COMPILE_STATUS, &compilationResult);
            if (compilationResult == c.GL_TRUE) return void{};
            // else print and return error
            const maxLength = 512;
            var string: [maxLength]c.GLchar = undefined;
            var stringLength: c.GLsizei = undefined;
            c.glGetShaderInfoLog(shader, maxLength, &stringLength, &string);
            std.debug.print("Failed to compile shader. GL Info Log:\n{s}\n", .{string[0..string.len]});
            return error.GL_ShaderCompile_Failed;
        }
    };

    /// Compile shader, returns shader Id, or error.
    /// Does not check compilation status
    /// `source` is plain zig slice (no null termination required for this function)
    pub fn compileShader(shaderType: ShaderType, source: []const u8) !ShaderRef {
        // If we know the length of the source string (like with a zig slice),
        // then it doesn't need to be in null terminated c-style

        // safe-cast usize of source.len to GLint
        var validLength: c.GLint = undefined;
        if (source.len > std.math.maxInt(c.GLint)) {
            std.debug.print("source.len too large", .{});
            return error.GL_compileShader_SourceTooLong;
        } else validLength = @intCast(source.len);

        // create gl shader, returns Id (ref) of object, 0 if error
        const shaderId: ShaderRef = c.glCreateShader(@as(c.GLuint, @intFromEnum(shaderType)));
        if (shaderId == 0) {
            std.debug.print("Failed to create {s} shader object.", .{@tagName(shaderType)});
            return error.GL_compileShader_CreateShaderFailed;
        }

        // set shader source on shader object
        const arraySize = 1;
        const arrayOfStrings = [arraySize][*c]const c.GLchar{source.ptr};
        const arrayOfLengths = [arraySize]c.GLint{validLength};
        c.glShaderSource(shaderId, arraySize, &arrayOfStrings, &arrayOfLengths);

        // compile shader source
        c.glCompileShader(shaderId);

        // return without checking if compilation was successful
        return shaderId;
    }
};

pub const ShaderRef = c.GLuint;
pub const ShaderType = enum(c.GLenum) {
    Vertex = c.GL_VERTEX_SHADER,
    Fragment = c.GL_FRAGMENT_SHADER,
};

//- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

// /// Assert struct has init method.
// pub fn expectFn_init(comptime T: type) void {
//     _ = T.init; // Check for init method
// }

// /// Assert struct has deinit method.
// pub fn expectFn_deinit(comptime T: type) void {
//     _ = T.deinit; // Check for deinit method
// }

// test "ShaderStuff" {
//     expectFn_init(ShaderStuff);
//     expectFn_deinit(ShaderStuff);
// }

//------------------------------------------------------------------------------

/// OpenGL Cube Drawing Plan (OCDP):
pub const OCDP = struct {

    // pub fn shaderCompilation() !void {
    //     // Import, compile, and check the vertex and fragment shaders.
    //     // Create a shader program, attach shaders, and link.
    //     return void;
    // }

    /// [static] because it doesnt take an instance as an argument
    /// Read shader source code from file, compile, and check for errors.
    /// Assumes you've properly initialized OpenGL and its function pointers..
    pub fn _1_shaderCompilation() !void {
        // Log out this function name at entry and exit` ` ` ` ` `
        const memo = comptime Name.ofFunction(_1_shaderCompilation).full();
        if (!is_test) std.debug.print("[{s}] ..\n", .{memo});
        defer if (!is_test) std.debug.print("[{s}] done.\n", .{memo});
        // ` ` ` ` ` ` ` ` ` ` ` ` ` ` ` ` ` ` ` ` ` ` ` ` ` ` ` `

        //-----------------------------------------------------------------------------

        // Can be re-used for reading all shader files
        var cfs = CFS.onStack();
        _ = try cfs.init(&std.heap.page_allocator);
        defer cfs.deinit();

        // [vertex shader]
        try cfs.readFileToInternalBuffer("./src/shaders/shader.vert", 1024 * 1024);
        const vertexShaderSource = try cfs.getBufferAsIs();
        const vertexShader = try ShaderStuff.compileShader(ShaderType.Vertex, vertexShaderSource);
        try ShaderStuff.assert.compileSuccess(vertexShader);

        //- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

        // [fragment shader]
        try cfs.readFileToInternalBuffer("./src/shaders/shader.frag", 1024 * 1024);
        const fragmentShaderSource = try cfs.getBufferAsIs();
        const fragmentShader = try ShaderStuff.compileShader(ShaderType.Fragment, fragmentShaderSource);
        try ShaderStuff.assert.compileSuccess(fragmentShader);

        //- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

        // TODO - move this to fn?
        // - move to end?
        // - duplicate at end?
        {
            const err = c.glGetError();
            if (err != c.GL_NO_ERROR) {
                std.debug.print("[ERR] Context or some other GL call failed\n", .{});
            }
        }

        //-----------------------------------------------------------------------------

        // Link shaders into a program
        const shaderProgram = c.glCreateProgram();
        c.glAttachShader(shaderProgram, vertexShader);
        c.glAttachShader(shaderProgram, fragmentShader);
        c.glLinkProgram(shaderProgram);

        //- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

        // TODO - move this to fn?
        // Check/verify shader program linking
        {
            var status: c.GLint = undefined;
            c.glGetProgramiv(shaderProgram, c.GL_LINK_STATUS, &status);
            if (status == 0) {
                var infoLog: [512]c.GLchar = undefined;
                c.glGetProgramInfoLog(shaderProgram, 512, null, &infoLog);
                @panic(infoLog[0..]);
            }
        }

        //- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

        // Delete the individual shaders, as they're linked into the program
        c.glDeleteShader(vertexShader);
        c.glDeleteShader(fragmentShader);

        // TODO, should we verify that the shaders were deleted?

        return void{};
    }

    pub fn _2_UniformsAndAttributesSetup() !void {

        // Define and enable the attributes (e.g., vertex positions).
        // Define uniform variables (e.g., color, model-view-projection matrices).

        return void;
    }

    pub fn _3_BuffersAndVertexArraySetup() !void {

        // Create and bind Vertex Buffer Object (VBO) for vertices.
        // Create and bind Vertex Array Object (VAO).
        // Specify vertex attributes and how data is stored in the VBO.

        return void;
    }

    pub fn _4_CubeGeometrySetup_wireframe() !void {

        // Define vertices for a cube.
        // Set drawing mode to wireframe (GL_LINE_STRIP).

        return void;
    }

    pub fn _5_Lighting_optional() !void {

        // Set up a simple ambient light source.

        return void;
    }

    pub fn _6_ProjectionAndViewSetup() !void {

        // Calculate and set up the projection matrix for perspective viewing.
        // Define view matrix for camera positioning.

        return void;
    }

    pub fn _7_DrawingTheScene() !void {

        // Clearing the screen.
        // Activating the shader program.
        // Binding the VAO.
        // Setting up uniforms (e.g., transformation matrices, color).
        // Drawing the cube.

        return void;
    }

    pub fn _8_CleanUp() !void {

        // Deleting shaders, buffers, and other resources.

        return void;
    }
};

pub const StructTemplate = struct {
    allocator: *const std.mem.Allocator = undefined,
    array: std.ArrayList(*anyopaque) = undefined,
    count: usize = undefined,
    capacity: usize = undefined,
    initialized: bool = false,

    // pub fn shaderCompilation() !void {
    //     // Import, compile, and check the vertex and fragment shaders.
    //     // Create a shader program, attach shaders, and link.
    //     return void;
    // }

    /// -----------------------------------------------------------------------
    /// Create new instance **by-value** & return to the caller's stack,
    ///  remember to `instance.init()`
    ///
    /// Caller's Responsibilities:
    /// - None (freed automatically when caller's stack frame is popped).
    /// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    /// *Returning a 'struct{} instance by value', implies that:*
    /// - returns an [copyOf|instance] of that struct (by value)
    /// - caller is [responsibleFor|owns] the returned instance
    /// - since returned by value:
    ///   - it will be [storedOn|copiedTo] the caller's stack
    ///   - it will be [deinitialized|destroyed|cleanedUp] automatically
    ///     when it goes out of scope, when the caller's stack frame is popped
    /// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    /// possible future synonyms: <create|new><Stack|Static|ByValue|Comptime>
    /// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    pub fn onStack() StructTemplate {
        // Log out this function name at entry and exit` ` ` ` ` `
        const memo = comptime Name.ofFunction(StructTemplate.onStack).full();
        if (!is_test) std.debug.print("[{s}] ..\n", .{memo});
        defer if (!is_test) std.debug.print("[{s}] done.\n", .{memo});
        // ` ` ` ` ` ` ` ` ` ` ` ` ` ` ` ` ` ` ` ` ` ` ` ` ` ` ` `

        // return copy of original struct by value.
        return StructTemplate{};
    }

    /// -----------------------------------------------------------------------
    /// Create new instance **by-reference** on the heap,
    ///  remember to `instance.init()`.
    ///
    /// Caller's Responsibilities:
    /// - Free resources via `defer allocator.destroy(instance)`.
    /// - Possible error on allocation failure.
    /// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    /// *Returning a 'pointer to a struct instance', implies that:*
    /// - returns a [pointerTo] new memory allocated for that struct (by reference)
    /// - caller is [responsibleFor|owns] the [memory|resources] that's pointed to
    /// - since returned by reference:
    ///   - if it was on the stack in this function, it would go out of scope
    ///   - only way to return a valid reference is to allocate on the heap
    ///   - it will not be automatically [managed|deinitialized|destroyed|cleanedUp],
    ///     that's the caller's responsibility
    /// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    /// possible future synonyms: <create|new><Heap|Dynamic|ByRef|Runtime|Alloc|Unmanaged>
    /// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    pub fn onHeap(allocator: *const std.mem.Allocator) !*StructTemplate {
        // Log out this function name at entry and exit` ` ` ` ` `
        const memo = comptime Name.ofFunction(StructTemplate.onHeap).full();
        if (!is_test) std.debug.print("[{s}] ..\n", .{memo});
        defer if (!is_test) std.debug.print("[{s}] done.\n", .{memo});
        // ` ` ` ` ` ` ` ` ` ` ` ` ` ` ` ` ` ` ` ` ` ` ` ` ` ` ` `

        const instancePtr: *StructTemplate = try allocator.create(StructTemplate);
        instancePtr.* = StructTemplate.onStack();
        return instancePtr;
    }

    /// -----------------------------------------------------------------------
    /// **Initialize instance** created via `onStack()` or `onHeap()`.
    /// - `allocator` Your prefered allocator the intenal ArrayList,
    ///     defaults to `std.heap.page_allocator`.
    /// - `capacity` Initial capacity of the internal ArrayList,
    ///     defaults to `0`.
    /// - Returns `self` for chaining.
    ///
    /// Caller's Responsibilities:
    /// - Free internal resources via `defer instance.deinit()`
    /// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    pub fn init(self: *StructTemplate, allocator: ?*const std.mem.Allocator, capacity: ?usize) !*StructTemplate {
        // Log out this function name at entry and exit` ` ` ` ` `
        const memo = comptime Name.ofFunction(StructTemplate.init).full();
        if (!is_test) std.debug.print("[{s}] ..\n", .{memo});
        defer if (!is_test) std.debug.print("[{s}] done.\n", .{memo});
        // ` ` ` ` ` ` ` ` ` ` ` ` ` ` ` ` ` ` ` ` ` ` ` ` ` ` ` `

        // set from arg value, or default to a not-null value
        self.allocator = if (allocator) |alloc| alloc else &std.heap.page_allocator;
        self.capacity = if (capacity) |cap| cap else 0; // TODO - really default to 0 ?
        // try allocate
        // var _allocator = self.allocator.?.*;
        self.array = try std.ArrayList(*anyopaque).initCapacity(self.allocator.*, self.capacity);
        self.count = self.array.items.len;
        self.capacity = self.array.capacity;

        self.initialized = true;
        return self;
    }

    /// -----------------------------------------------------------------------
    /// **Deinitialize instance** initialized with `init()`.
    /// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    pub fn deinit(self: *StructTemplate) void {
        // Log out this function name at entry and exit` ` ` ` ` `
        const memo = comptime Name.ofFunction(StructTemplate.deinit).full();
        if (!is_test) std.debug.print("[{s}] ..\n", .{memo});
        defer if (!is_test) std.debug.print("[{s}] done.\n", .{memo});
        // ` ` ` ` ` ` ` ` ` ` ` ` ` ` ` ` ` ` ` ` ` ` ` ` ` ` ` `

        self.array.deinit(); // free allocated stuff
        self.array = undefined;
        self.allocator = undefined;
        self.count = undefined;
        self.capacity = undefined;

        self.initialized = false;
        return self;
    }

    /// TODO - Not needed? Does nothing, except calling `deinit()` if you didn't, to free internal resources.
    pub fn destroy(self: *StructTemplate) void {
        // Log out this function name at entry and exit` ` ` ` ` `
        const memo = comptime Name.ofFunction(StructTemplate.destroy).full();
        if (!is_test) std.debug.print("[{s}] ..\n", .{memo});
        defer if (!is_test) std.debug.print("[{s}] done.\n", .{memo});
        // ` ` ` ` ` ` ` ` ` ` ` ` ` ` ` ` ` ` ` ` ` ` ` ` ` ` ` `

        _ = if (self.initialized) self.deinit();

        return void{};
    }
};

test "StructTemplate.onStack()" {
    std.debug.print(" \n", .{}); // newline for better output

    var instance = StructTemplate.onStack();
    defer instance.destroy();

    try std.testing.expect(instance.initialized == false);

    _ = try instance.init(null, null);
    defer instance.deinit();

    try std.testing.expect(instance.initialized == true);

    // TODO - how to test that it's actually on the stack?
}

test "StructTemplate.onHeap()" {
    std.debug.print(" \n", .{}); // newline for better output

    const allocator = &std.heap.page_allocator;
    var instance = try StructTemplate.onHeap(allocator);
    defer allocator.destroy(instance);

    try std.testing.expect(instance.initialized == false);

    _ = try instance.init(null, null);
    defer instance.deinit();

    try std.testing.expect(instance.initialized == true);

    // TODO - how to test that it's actually on the heap?
}
