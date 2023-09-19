const std = @import("std");
const print = std.debug.print;

const ComplexTypeTags = enum {
    ok,
    not_ok,
};
const ComplexType = union(ComplexTypeTags) {
    ok: u8,
    not_ok: void,
};

const AnyError = anyerror;

// fn Maybe(comptime T: type) type {
//     _ = T;
//     // return !T;
//     return union {
//         val: type,
//         noVal: anyerror,
//     };
// }

// fn Maybe(comptime T: type) !T {
//     return @as(!T,T);
// }

// fn Maybe(comptime T: type) !T {
//     return union { T, anyerror};
// }

// comptime fn qq(comptime T: anytype) string, ComplexType {
//     _ = T;
//     return "qq";
// }

// const point = struct {
//     x: u8,
//     y: u8,
// };

// var p: Maybe(point) = undefined;

pub fn add_inferred(comptime T: type, a: T, b: T) !T {
    const ov = @addWithOverflow(a, b);
    if (ov[1] != 0) return error.Overflow;
    return ov[0];
}

fn nil() u8 {
    return 0;
}

const y = nil;

fn Some(comptime T: type) type {
    return T;
}

const expect = @import("std").testing.expect;

test "error union" {
    var foo: anyerror!?i32 = undefined;

    // Coerce from child type of an error union:
    foo = 1234;

    // Coerce from an error set:
    foo = error.SomeError;

    // Use compile-time reflection to access the payload type of an error union:
    try comptime expect(@typeInfo(@TypeOf(foo)).ErrorUnion.payload == ?i32);

    // Use compile-time reflection to access the error set type of an error union:
    try comptime expect(@typeInfo(@TypeOf(foo)).ErrorUnion.error_set == anyerror);
}

// pub fn print(ty: Type, writer: anytype, mod: *Module) @TypeOf(writer).Error!void {

fn Maybe(comptime T: type) type {
    return anyerror!T;
}

pub fn someFunc() Maybe(u8) {
    // Here you can return either a u8 value or an error
    if (true) { // Replace with your condition
        return 42; // Example value
    } else {
        return error.SomeError; // Example error
    }
}

pub fn main() !void {
    comptime var result = someFunc();
    result = 1; // test for u8
    result = error.SomeError; // test for error
    print("{any}\n", .{result});
    print("{any}\n", .{@TypeOf(result)});
    print("{any}\n", .{@typeInfo(@TypeOf(result))});

    // switch (result) {
    //     u8 => |value| {
    //         std.debug.print("Got value: {}\n", .{value});
    //     },
    //     null => {},
    //     else => |err| {
    //         std.debug.print("Got error: {}\n", .{err});
    //     },
    // }

    // std.testing.expect(@TypeOf(add_inferred) == fn(comptime T: type, a: T, b: T) !T);

    // print("return type {?}\n", @typeName(@typeInfo(@TypeOf(add_inferred)).Fn.return_type.?));

    // print("plain     {any}\n", @typeInfo(add_inferred));
    // print("@typeInfo {any}\n", @typeInfo(add_inferred));
    // print("@typeName {any}\n", @typeName(add_inferred));
    // print("@Type     {any}\n", @Type(add_inferred));

    // const s = @typeName(@TypeOf(add_inferred));
    // print("{s}\n", s);

    // print("{s}\n", .{ @typeName(u8)} );
    // print("{any}\n", .{ u8 } );
    // print("{any}\n", .{ @TypeOf(u8) } );
    // print("{any}\n", .{ @TypeOf(ComplexType) } );
    // print("{any}\n", .{ @TypeOf(ComplexTypeTag) } );
    //print("{any}\n", .{ @TypeOf(@TypeOf(add_inferred)) } );

    const func = std.builtin.Type.Fn;
    _ = func;
    // // const fRT = func.return_type;
    // // _ = fRT;

    // // var someVal: Some(u8) = undefined;
    // var someVal: anyerror!?u8 = undefined;

    // someVal = null;
    // print("[{any}].[{any}]: {any}\n", .{ @TypeOf(@TypeOf(someVal)), @TypeOf(someVal), someVal} );

    // // someVal = undefined;
    // print("[{any}].[{any}]: {any}\n", .{ @TypeOf(@TypeOf(someVal)), @TypeOf(someVal), someVal} );

    // someVal = 1;
    // print("[{any}].[{any}]: {any}\n", .{ @TypeOf(@TypeOf(someVal)), @TypeOf(someVal), someVal} );

    // someVal = error.anyqwe;
    // print("[{any}].[{any}]: {any}\n", .{ @TypeOf(@TypeOf(someVal)), @TypeOf(someVal), someVal} );

    // // const zz = @typeInfo(@TypeOf(someVal)).ErrorUnion;
    // comptime var x = @typeInfo(@TypeOf(nil));
    // _ = x;
    // comptime var val: std.builtin.Type = undefined;
    // comptime var typeOfFn = @TypeOf(nil);
    // comptime var typeInfoOfFn = @typeInfo(typeOfFn);
    // print(">> {any}\n", .{ typeOfFn } );
    // print(">> {any}\n", .{ typeInfoOfFn } );

    // val = switch (typeInfoOfFn) {
    //     std.builtin.Type.Fn => std.builtin.Type.Fn,
    //     std.builtin.Type.ErrorUnion => std.builtin.Type.ErrorUnion,
    //     else => std.builtin.Type.Null,
    // };
    // print(">>> {any}\n", .{ val } );
    // print(">>> {any}\n", .{ @TypeOf(@TypeOf(nil)) } );
    // print(">>> {any}\n", .{ @TypeOf(nil) } );
    // print(">>> {any}\n", .{ @typeInfo(@TypeOf(nil)) } );
    // // print(">>> {any}\n", .{ @typeInfo(@typeInfo(@TypeOf(main))) } );

    // comptime var ut = union(type) {
    //     Fn: std.builtin.Type.Fn,
    //     ErrorUnion: std.builtin.Type.ErrorUnion,
    // };
    // print(">>> {any}\n", .{ ut } );

    // else prong required when switching on type 'fn() @typeInfo(@typeInfo(@TypeOf(scratchPad.main)).Fn.return_type.?).ErrorUnion.error_set!void'

    // print("[{any}]\n  = {any}\n",
    //    .{@Type(x), x}
    // );

    // print("{any}\n", .{ @typeInfo(@TypeOf(someVal)).Fn.return_type } );

    // std.debug.assert(@typeInfo(@TypeOf(nil)).Fn.return_type == u8);
    // print("{any}\n", .{ @typeInfo(@TypeOf(nil)).Fn.return_type } ); // u8
    // print("{any}\n", .{ @typeInfo(@TypeOf(nil)).Fn.return_type } ); // u8
    // print("{any}\n", .{ @typeInfo(@TypeOf(nil)).Fn } ); // builtin.Type.Fn{ ..
    // print("{any}\n", .{ @typeInfo(@TypeOf(nil)) } );

    // const returnType = try @typeName(@TypeOf(add_inferred).ReturnType);
    // try std.debug.print("Return type: {}\n", .{returnType});

    // std.debug.print("{any}\n", .{ @TypeOf(add_inferred) });

}

// # STRUCT
// - Root of type hierarchy
// - Members can be fields of different types
// - Members can be methods
// - All fields are active at the same time

// # ENUM
// - Members can be fields are all of the same  type (same type of underlying value)
// - Members can be methods

// # UNION
// - compose a list of possible types
// - Members are fields of different types
// - only one field (type) can be active at a time

// if you return a function with type FnType
// pub const FnType = fn (type) bool;

// const allocator = std.heap.page_allocator;

// // no variable fields here, all are static / fixed
// const MyTypes = struct {
//     const Character: type = u8;
//     const String: type = []u8;
//     const Byte: type = u8;
// };
// //
// const AnyOfMyTypes = union(enum) {
//     Character: MyTypes.Character,
//     String: MyTypes.String,
//     Byte: MyTypes.Byte,
// };

// std.meta.trait.is(.Int)(u8)

// pub fn isContainer(comptime T: type) bool {
//     return switch (@typeInfo(T)) {
//         .Struct, .Union, .Enum, .Opaque => true,
//         else => false,
//     };
// }

// ZIG TYPES QUESTION
// Whats diff between `@typeInfo(builtin.Type).Union.tag_type.?.Type` and `std.builtin.Type.Struct`
