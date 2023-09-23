// generics
const std = @import("std");
const c = @import("c.zig");

// types debugging
const TT = @import("TT.zig").TT;

// debug helpers
const is_test = @import("builtin").is_test;
const NameUtils = @import("debug_helpers.zig").DotNotation;
const FsUtils = @import("build_helpers.zig").CFS;

// aliases for navigation
const Type = std.builtin.Type;

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

//------------------------------------------------------------------------------

pub const MatricesSuppliedIn = struct {
    pub const rowMajorOrder: c.GLboolean = c.GL_TRUE;
    pub const colMajorOrder: c.GLboolean = c.GL_FALSE;
};

pub const _transform = [4][4]f32{
    [4]f32{ 1.0, 0.0, 0.0, 0.0 },
    [4]f32{ 0.0, 1.0, 0.0, 0.0 },
    [4]f32{ 0.0, 0.0, 1.0, 0.0 },
    [4]f32{ 0.0, 0.0, 0.0, 1.0 },
};

//------------------------------------------------------------------------------

pub const BasicShape = struct {
    vertices: []const f32,
    indices: []const c.GLuint,
};

pub const cube = BasicShape{
    .vertices = &[_]f32{
        // Front face
        -1.0, -1.0, 1.0,
        1.0,  -1.0, 1.0,
        1.0,  1.0,  1.0,
        -1.0, -1.0, 1.0,
        1.0,  1.0,  1.0,
        -1.0, 1.0,  1.0,

        // Back face
        -1.0, -1.0, -1.0,
        -1.0, 1.0,  -1.0,
        1.0,  1.0,  -1.0,
        -1.0, -1.0, -1.0,
        1.0,  1.0,  -1.0,
        1.0,  -1.0, -1.0,

        // Top face
        -1.0, 1.0,  -1.0,
        -1.0, 1.0,  1.0,
        1.0,  1.0,  1.0,
        -1.0, 1.0,  -1.0,
        1.0,  1.0,  1.0,
        1.0,  1.0,  -1.0,

        // Bottom face
        -1.0, -1.0, -1.0,
        1.0,  -1.0, -1.0,
        1.0,  -1.0, 1.0,
        -1.0, -1.0, -1.0,
        1.0,  -1.0, 1.0,
        -1.0, -1.0, 1.0,

        // Right face
        1.0,  -1.0, -1.0,
        1.0,  1.0,  -1.0,
        1.0,  1.0,  1.0,
        1.0,  -1.0, -1.0,
        1.0,  1.0,  1.0,
        1.0,  -1.0, 1.0,

        // Left face
        -1.0, -1.0, -1.0,
        -1.0, -1.0, 1.0,
        -1.0, 1.0,  1.0,
        -1.0, -1.0, -1.0,
        -1.0, 1.0,  1.0,
        -1.0, 1.0,  -1.0,
    },

    // Example indices for a cube
    .indices = &[_]c.GLuint{
        0, 1, 2, 2, 3, 0, // Front face
        4, 5, 6, 6, 7, 4, // Back face
        8, 9, 10, 10, 11, 8, // Top face
        12, 13, 14, 14, 15, 12, // Bottom face
        16, 17, 18, 18, 19, 16, // Right face
        20, 21, 22, 22, 23, 20, // Left face
    },
};

pub const triangle = BasicShape{
    .vertices = &[_]f32{
        // Front face
        0.0,  0.5,  0.0,
        0.5,  -0.5, 0.0,
        -0.5, -0.5, 0.0,
    },

    // Example indices for a cube
    .indices = &[_]c.GLuint{
        0, 1, 2, // Front face
    },
};

//------------------------------------------------------------------------------

pub fn OpenGlTypes(comptime majorVer: u8, comptime minorVer: u8) type {
    if ((majorVer != 4) or (minorVer != 1)) @compileError("Currently only OpenGL 4.1 is supported.");

    return struct {
        const this = @This();

        const version = struct {
            const major = majorVer;
            const minor = minorVer;
            const string = majorVer ++ "." ++ minorVer;
        };

        const Object = struct {
            const Name = c.GLuint;

            const Shaders = struct {};
            const VertexArray = struct {};
        };

        pub const ObjectTag = enum {
            // Texture,
            BufferObject,
            VertexArray,
            Shader,
            Program,
            // ProgramPipeline,
            // Query,
            // ProgramPipeline,
            // TransformFeedback,
            // Sampler,
            // Sync,
            // Renderbuffer,
            // Framebuffer,

            // c.GL_OBJECT_TYPE
            // c.GL_SHADER_TYPE
            // c.GL_UNIFORM_TYPE
            // c.GL_VERTEX_ATTRIB_ARRAY_TYPE
            // c.GL_FRAMEBUFFER_ATTACHMENT_OBJECT_TYPE
        };

        // as is  / unsorted: `````````````````````````````````````````````

        // generic / internal types
        const ObjectId = c.GLuint;

        // shader related types
        pub const ShaderTypeTag = enum(c.GLenum) { Vertex = c.GL_VERTEX_SHADER, Fragment = c.GL_FRAGMENT_SHADER };
        pub const ShaderId = ObjectId;
        pub const ProgramId = ObjectId;

        // vertex array related types
        pub const VertexArrayId = this.ObjectId;
        pub const VertexArrays = [*c]this.VertexArrayId;

        // buffer object related types
        pub const BufferId = this.ObjectId;
        pub const Buffers = [*c]this.BufferId;
    };
}

pub const Gl = OpenGlTypes(4, 1);

/// OpenGL Shader related helper functions / abstractions
pub const ShaderUtils = struct {
    //

    /// Assert success, or return error.
    pub const assert = struct {
        //

        /// Error if shader compilation failed.
        pub fn shaderCompiled(shader: Gl.ShaderId) !void {
            var status: i32 = undefined;
            c.glGetShaderiv(shader, c.GL_COMPILE_STATUS, &status);
            if (status == c.GL_TRUE) return void{};

            // ..else log it, and return an error
            const maxLength = 512;
            var string: [maxLength]c.GLchar = undefined;
            var stringLength: c.GLsizei = undefined;
            c.glGetShaderInfoLog(shader, maxLength, &stringLength, &string);
            std.debug.print("Failed to compile shader. GL Info Log:\n{s}\n", .{string[0..string.len]});
            return error.GL_ShaderCompile_Failed;
        }

        /// Error if shader program linking failed.
        pub fn programLinked(program: Gl.ProgramId) !void {
            var status: c.GLint = undefined;
            c.glGetProgramiv(program, c.GL_LINK_STATUS, &status);
            if (status == c.GL_TRUE) return void{};

            // ..else log it, and return an error
            const maxLength = 512;
            var string: [maxLength]c.GLchar = undefined;
            var stringLength: c.GLsizei = undefined;
            c.glGetProgramInfoLog(program, maxLength, &stringLength, &string);
            std.debug.print("Failed to link shader. GL Info Log:\n{s}\n", .{string[0..string.len]});
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
            const status: c.GLenum = c.glGetError();
            if (status == c.GL_NO_ERROR) return void{};
            // If result == GL_NO_ERROR:
            // - there has been no detectable error since the last call to glGetError,
            // - or since the GL was initialized.
            // - List of defined errors: https://docs.gl/gl4/glGetError

            // TODO: see todo above

            const errString = switch (status) {
                c.GL_INVALID_ENUM => "GL_INVALID_ENUM",
                c.GL_INVALID_VALUE => "GL_INVALID_VALUE",
                c.GL_INVALID_OPERATION => "GL_INVALID_OPERATION",
                c.GL_INVALID_FRAMEBUFFER_OPERATION => "GL_INVALID_FRAMEBUFFER_OPERATION",
                c.GL_OUT_OF_MEMORY => "GL_OUT_OF_MEMORY",
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
    pub fn compile(shaderType: Gl.ShaderTypeTag, source: []const u8) !Gl.ShaderId {
        // If we know the length of the source string (like with a zig slice),
        // then it doesn't need to be in null terminated c-style

        // safe-cast usize of source.len to GLint
        var validLength: c.GLint = undefined;
        if (source.len > std.math.maxInt(c.GLint)) {
            std.debug.print("source.len too large", .{});
            return error.GL_compileShader_SourceTooLong;
        } else validLength = @intCast(source.len);

        // create gl shader, returns Id (ref) of object, 0 if error
        const shaderId: Gl.ShaderId = c.glCreateShader(@as(c.GLuint, @intFromEnum(shaderType)));
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

//------------------------------------------------------------------------------
//------------------------------------------------------------------------------

// EXPERIMENTAL TYPE

const Matrix = struct {
    //

    fn cVec(comptime T: anytype) type {
        return [*c]const T;
    }

    fn arr1x4(comptime T: anytype, comptime e1: T, comptime e2: T, comptime e3: T, comptime e4: T) [4]T {
        return [4]T{ e1, e2, e3, e4 };
    }

    fn cCompat(comptime zArr: anytype) [*:0]const @typeInfo(@TypeOf(zArr)).Array.child {
        const typeInfo: std.builtin.Type.Array = @typeInfo(@TypeOf(zArr)).Array;
        const elementType = typeInfo.child;
        const elementCount = typeInfo.len;
        var nullTerminatedArray: [elementCount:0]elementType = undefined;
        inline for (0..elementCount) |i| nullTerminatedArray[i] = zArr[i];
        const sliceOfNullTerminatedArray = nullTerminatedArray[0..nullTerminatedArray.len :0];
        return sliceOfNullTerminatedArray;
    }
};

const cMat1x4 = Matrix.cVec(f32);
const cMat4x4 = Matrix.cVec(cMat1x4);

const transform = Matrix.arr1x4(
    @TypeOf(Matrix.cCompat(Matrix.arr1x4(f32, 0.0, 0.0, 0.0, 0.0))),
    Matrix.cCompat(Matrix.arr1x4(f32, 1.0, 0.0, 0.0, 0.0)),
    Matrix.cCompat(Matrix.arr1x4(f32, 0.0, 1.0, 0.0, 1.0)),
    Matrix.cCompat(Matrix.arr1x4(f32, 0.0, 0.0, 1.0, 0.0)),
    Matrix.cCompat(Matrix.arr1x4(f32, 0.0, 0.0, 0.0, 1.0)),
);

// const StrLit = "hello"; <- singleItemPointerTo(Array) e.g. *const [3:0]u8 OR [N:0]u8 OR [_:0]u8
// PointerToConst(SentinelTerminatedFixedArray(0, Byte)) -> *const [_:0]u8
//
// const ArrLit = [_]u8{ 'h', 'e', 'l', 'l', 'o' }; <- ArrayLiteral
//
//
// StrLit === &ArrLit

// @embedFile("path/to/file") returns comptime constant pointer to null-terminated, fixed-size array
// PointerToConst(SentinelTerminatedFixedArray(0, Byte)) -> *const [_:0]u8
// *const [N:0]u8
// .. This is equivalent to a string literal

fn SliceOfSentinelTerminatedFixedSizeArray(comptime sentinel: u8, comptime T: anytype) type {
    return [:sentinel]T;
}

fn findLengthZ(comptime manyItemPtrZ: [*]const u8) usize {
    var len: usize = 0;
    while (manyItemPtrZ[len] != 0) : (len += 1) {}
    return len;
}
fn findLengthC(comptime manyItemPtrC: [*c]const u8) usize {
    var len: usize = 0;
    while (manyItemPtrC[len] != 0) : (len += 1) {}
    return len;
}

fn sentinelTerminatedFixedSizeArray(comptime sentinel: u8, comptime T: anytype, comptime items: anytype) [items.len:sentinel]T {
    const itemsType = @TypeOf(items);
    const itemsTypeInfo = @typeInfo(itemsType);
    var itemsCount: usize = undefined;

    const sliceOfItems = switch (itemsTypeInfo) {
        .Struct => |_| blk: {
            if (!itemsTypeInfo.Struct.is_tuple) @compileError("Expected struct to be a tuple, found '" ++ @typeName(itemsType) ++ "'.");

            // Items in tuple (comptime known) could be of differing types, so we need to check each one
            inline for (items) |item| if (@TypeOf(@as(T, item)) != T) @compileError("Unxpected type in tuple, expected '" ++ @typeName(T) ++ "', found '" ++ @typeName(@TypeOf(item)) ++ "'.");

            // tuple items to array
            var array: [items.len]T = undefined;
            inline for (items, 0..) |item, i| array[i] = @as(T, item);

            itemsCount = items.len;
            break :blk array[0..items.len];
        },
        .Array => |arrayInfo| blk: {
            break :blk switch (@typeInfo(arrayInfo.child)) {
                .Pointer => |pointerInfo| blk2: {
                    break :blk2 switch (pointerInfo.size) {
                        .Slice => items,
                        .One => items.*[0..items.len],
                        .Many => if (items.len == 1) items[0][0..1] else @compileError("Multi item nested arrays not supported"),
                        .C => if (items.len == 1) items[0][0..1] else @compileError("Multi item nested arrays not supported"),
                        // else => @compileError("Not Implemened for pointer type " ++ @tagName(pointerInfo.size)),
                    };
                },
                else => items[0..items.len],
            };
        },

        .Pointer => |pointerInfo| switch (pointerInfo.size) {
            .One => items.*[0..items.len],
            .Many => items.*[0..items.len],
            .Slice => items.*[0..items.len],
            .C => items.*[0..items.len],
        },
        else => @compileError("Type of passed in items not supported, expected tuple or slice, found " ++ @typeName(itemsType)),
    };

    var _sentinelTerminatedFixedSizeArray: [sliceOfItems.len:sentinel]T = undefined;
    inline for (sliceOfItems, 0..) |item, i| _sentinelTerminatedFixedSizeArray[i] = @as(T, item);

    return _sentinelTerminatedFixedSizeArray;
}

// zig default string literal is null terminated
fn PointerToConst(comptime T: anytype) type {
    return *const T;
}

const Byte = u8;

// const zigDefaultStringLiteral = PointerToConst(SentinelTerminatedFixedSizeArray(0, Byte));

test "Manual String Literal" {
    const str1 = "hello";
    const str2a = &sentinelTerminatedFixedSizeArray(0, u8, .{ 'h', 'e', 'l', 'l', 'o' });
    const str2b = &sentinelTerminatedFixedSizeArray(0, u8, .{ 'h', 'e', 'l', 'l', 'o', 0 });
    const str3a = &sentinelTerminatedFixedSizeArray(0, u8, [_]u8{ 'h', 'e', 'l', 'l', 'o' });
    const str3b = &sentinelTerminatedFixedSizeArray(0, u8, [_]u8{ 'h', 'e', 'l', 'l', 'o', 0 });
    const str4 = &sentinelTerminatedFixedSizeArray(0, u8, [_:0]u8{ 'h', 'e', 'l', 'l', 'o' });
    const str5 = &sentinelTerminatedFixedSizeArray(0, u8, [_:0]u8{ 'h', 'e', 'l', 'l', 'o', 0 });
    const str6 = &sentinelTerminatedFixedSizeArray(0, u8, [_:0]u8{ 'h', 'e', 'l', 'l', 'o', 0, 0 });
    const str7 = &sentinelTerminatedFixedSizeArray(0, u8, str1);
    // const many_z: [*]u8 = &str1[0];
    // const str8 = &sentinelTerminatedFixedSizeArray(0, u8, many_z);
    // const many_c: [*c]u8 = &str1[0];
    // const str9 = &sentinelTerminatedFixedSizeArray(0, u8, many_c);

    // const str1zv = &sentinelTerminatedFixedSizeArray(0, u8, [1][*]u8{"hello"});
    const str1zc = &sentinelTerminatedFixedSizeArray(0, u8, [1][*]const u8{"hello"});
    // const str1cv = &sentinelTerminatedFixedSizeArray(0, u8, [1][*c]u8{"hello"});
    const str1cc = &sentinelTerminatedFixedSizeArray(0, u8, [1][*c]const u8{"hello"});

    std.debug.print("Expecting: '*const [5:0]u8'\n", .{});
    std.debug.print("plain:  {any}\n", .{@TypeOf(str1)});
    std.debug.print("manual: {any}\n", .{@TypeOf(str2a)});
    std.debug.print("manual: {any}\n", .{@TypeOf(str2b)});
    std.debug.print("manual: {any}\n", .{@TypeOf(str3a)});
    std.debug.print("manual: {any}\n", .{@TypeOf(str3b)});
    std.debug.print("manual: {any}\n", .{@TypeOf(str4)});
    std.debug.print("manual: {any}\n", .{@TypeOf(str5)});
    std.debug.print("manual: {any}\n", .{@TypeOf(str6)});
    std.debug.print("manual: {any}\n", .{@TypeOf(str7)});
    // std.debug.print("manual: {any}\n", .{@TypeOf(str8)});
    // std.debug.print("manual: {any}\n", .{@TypeOf(str9)});

    // std.debug.print("manual: {any}\n", .{@TypeOf(str1zv)});
    std.debug.print("manual: {any}\n", .{@TypeOf(str1zc)});
    // std.debug.print("manual: {any}\n", .{@TypeOf(str1cv)});
    std.debug.print("manual: {any}\n", .{@TypeOf(str1cc)});
}

test "cast *[1][*]const u8 to [*]const ?[*]const u8" {
    const window_name = [1][*]const u8{"window name"};
    const x: [*]const ?[*]const u8 = &window_name;
    try std.testing.expect(std.mem.eql(u8, std.mem.sliceTo(@as([*:0]const u8, @ptrCast(x[0].?)), 0), "window name"));
}

// fn strLit(comptime slice : []const u8) *const [_:0] u8 {
//     const constNullTerminatedArray = [slice.len:0]u8{ slice.ptr };
//     const pointerToConstNullTerminatedArray = &constNullTerminatedArray
//     return slice;
// }

//------------------------------------------------------------------------------
//------------------------------------------------------------------------------

/// OpenGL Cube Drawing Plan (OCDP):
/// https://chat.openai.com/c/b7e4a740-6dba-4f33-a5b8-e1ae238dfd1a
pub const OCDP = struct {
    //

    // pub fn _2_UniformsAndAttributesSetup(shaderProgramId: Gl.ProgramId, shape: *const BasicShape) !c.GLuint {
    //     _ = shaderProgramId;

    // Define and enable the attributes (e.g., vertex positions).

    // Define uniform variables (e.g., color, model-view-projection matrices).

    // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    // in this step, you'll set up the vertex attributes and uniform variables.
    // - Vertex attributes could be things like vertex coordinates, texture coordinates, or normals.
    // - Uniforms are variables that are consistent across the whole drawing operation.

    // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    // 1. Define Vertex Attributes:

    // Locate where you've set up your VAO (Vertex Array Object) and VBO (Vertex Buffer Object). Right after you've bound your VAO, use glVertexAttribPointer to define the attributes.

    // Here, we're defining one attribute (attribute 0), specifying that it has three components (x, y, z), of type GL_FLOAT, and they're tightly packed.

    // ### TODO ###
    // - [ ] glBindVertexArray(vao);
    // - [ ] glBindBuffer(GL_ARRAY_BUFFER, vbo);
    // - [ ] glEnableVertexAttribArray(0);
    // - [ ] glBindBuffer(GL_ARRAY_BUFFER, vertex_buffer); // vertex_buffer is retrieved from glGenBuffers
    // - [ ] glEnableVertexAttribArray(position_attrib_index); // Attribute indexes were received from calls to glGetAttribLocation, or passed into glBindAttribLocation.
    // - [x] glVertexAttribPointer(position_attrib_index, 3, GL_FLOAT, false, 0, vertex_data); // vertex_data is a float*, 3 per vertex, representing the position of each vertex

    // Enable the attribute arrays we've defined ?? We have? Where??

    // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    // 3. Uniform Setup:

    // In your drawing loop, you'll want to update any uniforms you have in your shader. For example, if you have a transformation matrix, you'd use glUniformMatrix4fv.

    // Here, transform would be a 4x4 matrix defining some transformation.

    // 3.1

    // That should get you set up with the basics. Once you've done this, you should be ready to move on to creating and binding buffers.

    // TODO - return the stuff that might be needed in the next step?
    //     return vertexArrayObject;
    // }

    pub fn _3_BuffersAndVertexArraySetup() !void {

        // Create and bind Vertex Buffer Object (VBO) for vertices.
        // Create and bind Vertex Array Object (VAO).
        // Specify vertex attributes and how data is stored in the VBO.

        // # TODO: Move 'unbind's to next step
        // c.glBindBuffer(c.GL_ARRAY_BUFFER, 0);
        // try ShaderUtils.assert.noGlError("UnbindBuffer");

        // # TODO: Move 'unbind's to next step
        // c.glBindVertexArray(0);
        // try ShaderUtils.assert.noGlError("UnbindVertexArray");

        try ShaderUtils.assert.noGlError("3-end");

        // TODO - return the stuff that might be needed in the next step?
        return void{};
    }

    pub fn _4_CubeGeometrySetup_wireframe(vertexArrayObject: c.GLuint, shape: *const BasicShape) !void {
        _ = shape;
        _ = vertexArrayObject;

        // Define vertices for a cube.
        // Set drawing mode to wireframe (GL_LINE_STRIP) vs. filled (GL_TRIANGLES|GL_FILL) vs. points (GL_POINTS) etc.

        // Change polygon mode to wireframe
        // c.glPolygonMode(c.GL_FRONT_AND_BACK, c.GL_LINE);
        // try ShaderUtils.assert.noGlError("PolygonMode");

        // Bind your VAO (Vertex Array Object)
        // c.glBindVertexArray(vertexArrayObject);
        // try ShaderUtils.assert.noGlError("BindVertexArray");

        // Draw the cube using GL_TRIANGLES and your element buffer
        // const numberOfIndices: c.GLsizei = @as(c.GLsizei, @intCast(cube.indices.len)); // Replace with your actual count
        // c.glDrawElements(c.GL_TRIANGLES, numberOfIndices, c.GL_UNSIGNED_INT, null);
        // try ShaderUtils.assert.noGlError("DrawElements"); // https://docs.gl/gl4/glDrawElements

        // Unbind your VAO
        // c.glBindVertexArray(0);
        // try ShaderUtils.assert.noGlError("UnbindVertexArray");

        // # TODO: unbind the other thing? (VBO?)

        // Revert polygon mode back to fill if you wish to draw other objects normally
        // c.glPolygonMode(c.GL_FRONT_AND_BACK, c.GL_FILL);
        // try ShaderUtils.assert.noGlError("PolygonMode");

        // TODO - return the stuff that might be needed in the next step?
        return void{};
    }

    pub fn _5_Lighting_optional() !void {

        // Set up a simple ambient light source.

        // is this needed here?
        try ShaderUtils.assert.noGlError("5-end");

        // TODO - return the stuff that might be needed in the next step?
        return void{};
    }

    pub fn _6_ProjectionAndViewSetup() !void {

        // Calculate and set up the projection matrix for perspective viewing.
        // Define view matrix for camera positioning.

        // is this needed here?
        try ShaderUtils.assert.noGlError("6-end");

        // TODO - return the stuff that might be needed in the next step?
        return void{};
    }

    pub fn _7_DrawingTheScene() !void {

        // Clearing the screen.
        // Activating the shader program.
        // Binding the VAO.
        // Setting up uniforms (e.g., transformation matrices, color).
        // Drawing the cube.

        // is this needed here?
        try ShaderUtils.assert.noGlError("7-end");

        // TODO - return the stuff that might be needed in the next step?
        return void{};
    }

    pub fn _8_CleanUp() !void {

        // Deleting shaders, buffers, and other resources.
        // ^^^ shaders already deleted in step 1

        // is this needed here?
        try ShaderUtils.assert.noGlError("8-end");

        // TODO - return the stuff that might be needed in the next step?
        return void{};
    }
};
