// generics
const std = @import("std");
const C = @import("c/imports.zig");

pub const ExplicitActions = struct {
    pub fn unwrapOrPanic(thing: anytype) @typeInfo(@TypeOf(thing)).Optional.child {
        if (thing) |val| return val else @panic("OptionalIsNull");
    }
    pub fn unwrapOrError(thing: anytype) !@typeInfo(@TypeOf(thing)).Optional.child {
        if (thing) |val| return val else return error.OptionalIsNull;
    }
    // pub fn unwrapThen(thing: anytype, ) !void {
    //     if (thing) |val| return val else @panic("nothing to unwrap");
    // }
};

// test "ExplicitActions.unwrapOptional()" {
//     var maybeInt: ?u8 = 42;
//     try std.testing.expect(ExplicitActions.unwrapOrPanic(maybeInt) == 42);
//     maybeInt = null;
//     try std.testing.expectError(ExplicitActions.unwrapOrPanic(maybeInt));
// }

pub const ExplicitTypes = struct {
    // z cant handle 'const' after '='
    // we need to manually prefix const to all the types
    // pub const Const = struct {
    pub const SingleItemPointer = struct {
        //
        pub const Constant = struct {
            //
            pub const Character = struct {
                pub const z = u8;
                pub const c = [*c]C.GLchar;
            };
            //
            pub const String = struct {
                // pub const z = *ExplicitTypes.SingleItemPointer.Constant.Character.z;
                pub const z = *[]const u8;
                // pub const c = [*c]ExplicitTypes.SingleItemPointer.Constant.Character.c;
                pub const c = [*c]const C.GLchar;

                pub const SentinelTerminated = struct {
                    pub const z = [*:0]const u8;
                    pub const c = [*c]const C.GLchar;
                };
            };
        };
    };
};

pub const TT = struct {

    // ConstPointerToModif
    pub fn ConstPointerTo(T: type) type {
        // std.meta.trait.is(.Pointer)(T);

        // const isConstPointer = std.meta.trait.isConstPtr(T);
        // return if (isConstPointer) {
        //     return T;
        // } else {
        //     return *const T;
        // };
        return T;
    }

    pub fn PointerTo(comptime T: type) type {
        return *T;
    }
    pub fn PointerToConst(comptime T: type) type {
        return *const (T);
    }
    pub fn cPointerTo(comptime T: type) type {
        return [*c]T;
    }
    pub fn cPointerToConst(comptime T: type) type {
        return [*c]const T;
    }

    pub fn SliceOf(comptime T: type) type {
        return []T;
    }
    pub fn SliceOfConst(comptime T: type) type {
        return []const T;
    }

    pub const Char = u8;
    pub const String = SliceOf(Char);
    pub const StringConst = SliceOfConst(Char);

    // typically be represented as a pointer to the first char of a null-terminated string.
    pub const zPointerToConstNuLLTermArrayOfChar = [*:0]const u8; // ` .. unknown-length pointer type '[*:0]const u8'`
    pub const zPointerToConstNuLLTermSliceOfChar = []const u8;
    pub const cPointerToConstNuLLTermString = [*c]const u8;

    pub const cString = cPointerTo(Char); // = [*c] u8;
    pub const cStringConst = cPointerToConst(Char); // = [*c]const u8;

    pub fn Maybe(comptime T: type) type {
        return anyerror!T;
    }
};

const ByValEnum = enum {
    Char,
    SliceOfMutChar,
    SliceOfConstChar,
};
const ByVal = union(ByValEnum) {
    Char: TT.Char,
    SliceOfMutChar: []TT.Char,
    SliceOfConstChar: []const TT.Char,
};

const ByRefEnum = enum {
    // single-item pointer
    SliceOfMutChar,
    SliceOfConstChar,
    // many-item pointer
    zStringMut,
    zStringConst,
    cStringMut,
    cStringConst,
};
const ByRef = union(ByRefEnum) {
    // single-item pointer
    // SliceOfMutChar: _T.PointerTo(ByVal.SliceOfMutChar),
    // SliceOfConstChar: _T.PointerTo(ByVal.SliceOfConstChar),
    // many-item pointer
    zStringMut: [*]TT.Char,
    zStringConst: [*]const TT.Char,
    cStringMut: [*c]TT.Char,
    cStringConst: [*c]const TT.Char,
};

const StringInput = union(enum) {
    ByVal: ByVal,
    ByRef: ByRef,
};

// const Str = struct {
//     fn toCString(input: StringInput) !ByRef.cStringConst {
//         const s = switch (input) {
//             StringInput.ByVal.SliceOfConstChar => |slice| &slice[0],
//             StringInput.ByRef.SliceOfConstChar => |ptr| ptr.*,
//             else => return error.NotImplemented,
//         };

//         std.debug.print("String: {}\n", .{s});
//     }
// };

//- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
// test "Str.toCString()" {
//     std.testing.expect(@TypeOf(Str.toCString("hello")) == !Str.ByRef.cStringConst);
// }
