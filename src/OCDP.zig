// generics
const std = @import("std");
const c = @import("c/imports.zig");

const gl = @import("c/OpenGL.zig").remapped();

// types debugging
const TT = @import("TT.zig").TT;

// debug helpers
const is_test = @import("builtin").is_test;
const NameUtils = @import("debug_helpers.zig").DotNotation;
const FsUtils = @import("build_helpers.zig").CFS;
const ShaderUtils = @import("OCDP2.zig").ShaderUtils;

// aliases for navigation
const Type = std.builtin.Type;

//------------------------------------------------------------------------------

pub const MatricesSuppliedIn = struct {
    pub const rowMajorOrder: gl.Boolean = gl.TRUE;
    pub const colMajorOrder: gl.Boolean = gl.FALSE;
};

//------------------------------------------------------------------------------

pub const BasicShape = struct {
    vertices: []const f32,
    indices: []const gl.Uint,
    colors: []const f32,

    pub fn verticesLen(self: *const BasicShape) gl.Sizeiptr {
        const maxValue = @as(usize, @intCast(std.math.maxInt(gl.Sizeiptr)));
        const length = if (self.vertices.len <= maxValue) @as(gl.Sizeiptr, @intCast(self.vertices.len)) else std.debug.panic("shape.vertices.len too large", .{});

        // * size of vertexComponent's type i.e. f32
        const byteCount: gl.Sizeiptr = length * @sizeOf(f32);
        if (byteCount == 0) std.debug.panic("verticesDataStoreSize is 0\n", .{});

        return byteCount;
    }

    /// Cast length to correct type (gl.Sizei) to be passed to `gl.drawElements()` as `count` arg.
    /// - T: `gl.Sizei` for drawElements(), `gl.Sizeiptr` for bufferData()
    pub fn indicesLenAs(self: *const BasicShape, comptime T: anytype) T {
        if (T != gl.Sizei and T != gl.Sizeiptr) std.debug.panic("Unexpected type T", .{});

        const maxValue = @as(usize, @intCast(std.math.maxInt(T)));
        const length = if (self.indices.len <= maxValue) @as(T, @intCast(self.indices.len)) else std.debug.panic("shape.indices.len too large", .{});

        // * size of index's type i.e. GL.Uint
        const byteCount: T = length * @sizeOf(gl.Uint);
        if (byteCount == 0) std.debug.panic("indicesDataStoreSize is 0\n", .{});

        return byteCount;
    }

    pub fn colorsLen(self: *const BasicShape) gl.Sizeiptr {
        const maxValue = @as(usize, @intCast(std.math.maxInt(gl.Sizeiptr)));
        const length = if (self.colors.len <= maxValue) @as(gl.Sizeiptr, @intCast(self.colors.len)) else std.debug.panic("shape.colors.len too large", .{});

        // * size of colBuff's type i.e. f32
        const byteCount: gl.Sizeiptr = length * @sizeOf(f32);
        if (byteCount == 0) std.debug.panic("colBuffDataStoreSize is 0\n", .{});

        return byteCount;
    }
};

pub const cube = BasicShape{
    .vertices = &[_]f32{
        -1.0, -1.0, -1.0, // triangle 1 : begin
        -1.0, -1.0, 1.0,
        -1.0, 1.0, 1.0, // triangle 1 : end
        1.0,  1.0,  -1.0, // triangle 2 : begin
        -1.0, -1.0, -1.0,
        -1.0, 1.0,  -1.0, // triangle 2 : end
        1.0,  -1.0, 1.0,
        -1.0, -1.0, -1.0,
        1.0,  -1.0, -1.0,
        1.0,  1.0,  -1.0,
        1.0,  -1.0, -1.0,
        -1.0, -1.0, -1.0,
        -1.0, -1.0, -1.0,
        -1.0, 1.0,  1.0,
        -1.0, 1.0,  -1.0,
        1.0,  -1.0, 1.0,
        -1.0, -1.0, 1.0,
        -1.0, -1.0, -1.0,
        -1.0, 1.0,  1.0,
        -1.0, -1.0, 1.0,
        1.0,  -1.0, 1.0,
        1.0,  1.0,  1.0,
        1.0,  -1.0, -1.0,
        1.0,  1.0,  -1.0,
        1.0,  -1.0, -1.0,
        1.0,  1.0,  1.0,
        1.0,  -1.0, 1.0,
        1.0,  1.0,  1.0,
        1.0,  1.0,  -1.0,
        -1.0, 1.0,  -1.0,
        1.0,  1.0,  1.0,
        -1.0, 1.0,  -1.0,
        -1.0, 1.0,  1.0,
        1.0,  1.0,  1.0,
        -1.0, 1.0,  1.0,
        1.0,  -1.0, 1.0,
    },

    // Example indices for a cube
    .indices = &[_]gl.Uint{
        0,  1,  2,  3,  4,  5,
        6,  7,  8,  9,  10, 11,
        12, 13, 14, 15, 16, 17,
        18, 19, 20, 21, 22, 23,
        24, 25, 26, 27, 28, 29,
        30, 31, 32, 33, 34, 35,
    },

    .colors = &[_]f32{
        0.583, 0.771, 0.014,
        0.609, 0.115, 0.436,
        0.327, 0.483, 0.844,
        0.822, 0.569, 0.201,
        0.435, 0.602, 0.223,
        0.310, 0.747, 0.185,
        0.597, 0.770, 0.761,
        0.559, 0.436, 0.730,
        0.359, 0.583, 0.152,
        0.483, 0.596, 0.789,
        0.559, 0.861, 0.639,
        0.195, 0.548, 0.859,
        0.014, 0.184, 0.576,
        0.771, 0.328, 0.970,
        0.406, 0.615, 0.116,
        0.676, 0.977, 0.133,
        0.971, 0.572, 0.833,
        0.140, 0.616, 0.489,
        0.997, 0.513, 0.064,
        0.945, 0.719, 0.592,
        0.543, 0.021, 0.978,
        0.279, 0.317, 0.505,
        0.167, 0.620, 0.077,
        0.347, 0.857, 0.137,
        0.055, 0.953, 0.042,
        0.714, 0.505, 0.345,
        0.783, 0.290, 0.734,
        0.722, 0.645, 0.174,
        0.302, 0.455, 0.848,
        0.225, 0.587, 0.040,
        0.517, 0.713, 0.338,
        0.053, 0.959, 0.120,
        0.393, 0.621, 0.362,
        0.673, 0.211, 0.457,
        0.820, 0.883, 0.371,
        0.982, 0.099, 0.879,
    },
};

pub const triangle = BasicShape{
    .vertices = &[_]f32{
        0.5,  0.5,  0.0,
        0.5,  -0.5, 0.0,
        -0.5, -0.5, 0.0,
        -0.5, 0.5,  0.0,
    },

    // Example indices for a cube
    .indices = &[_]gl.Uint{
        0, 1, 3,
        1, 2, 3,
    },

    .colors = &[_]f32{
        0.583, 0.771, 0.014,
        0.609, 0.115, 0.436,
        0.327, 0.483, 0.844,
        0.822, 0.569, 0.201,
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
            const Name = gl.Uint;

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

            // GL_.OBJECT_TYPE
            // GL_.SHADER_TYPE
            // GL_.UNIFORM_TYPE
            // GL_.VERTEX_ATTRIB_ARRAY_TYPE
            // GL_.FRAMEBUFFER_ATTACHMENT_OBJECT_TYPE
        };

        // as is  / unsorted: `````````````````````````````````````````````

        // generic / internal types
        const ObjectId = gl.Uint;

        // shader related types
        pub const ShaderTypeTag = enum(gl.Enum) { Vertex = gl.VERTEX_SHADER, Fragment = gl.FRAGMENT_SHADER };
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

pub const MyGl = OpenGlTypes(4, 1);

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


    // TODO - i can't remember exactly what we were trying to do / debug here (below)


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
