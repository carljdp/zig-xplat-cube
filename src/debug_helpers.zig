// generics
const std = @import("std");

// aliases
const expect = std.testing.expect;
const print = std.debug.print;
const Type = std.builtin.Type;

// flags
const _DEBUG_TESTS_ = true;

// NOT sure if NI code is supposed to be in here
const NI = @import("NI.zig");

// pub const DebugUtils = struct {

// };

//-----------------------------------------------------------------------------
// Checks if `subject` is a Static Struct, returns predicate
pub fn isStaticStruct(comptime subject: anytype) bool {
    switch (typeInfo(TypeOf(subject))) {
        .Type => return true,
        .Struct => return false,

        // Checks for other types not implemented/supported at this time
        else => return false,
    }
}
//- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
test "isStaticStruct()" {
    const _static = struct {};
    const _instance = _static{};
    const _neither = 42;

    try std.testing.expect(isStaticStruct(_static) == true);
    try std.testing.expect(isStaticStruct(_instance) == false);
    try std.testing.expect(isStructInstance(_neither) == false);
}

//-----------------------------------------------------------------------------
// Checks if `subject` is a Struct Instance, returns predicate
pub fn isStructInstance(comptime subject: anytype) bool {
    switch (typeInfo(TypeOf(subject))) {
        .Struct => return true,
        .Type => return false,

        // Checks for other types not implemented/supported at this time
        else => return false,
    }
}
//- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
test "isStructInstance()" {
    const _static = struct {};
    const _instance = _static{};
    const _neither = 42;

    try expect(isStructInstance(_instance) == true);
    try expect(isStructInstance(_static) == false);
    try expect(isStructInstance(_neither) == false);
}

//-----------------------------------------------------------------------------
pub fn isSameType(comptime a: anytype, comptime b: anytype) bool {
    return TypeOf(a) == TypeOf(b);
}
//- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
test "isSameType()" {
    const _print_ = false;

    const _staticA = struct {
        x: u8 = 0,
        const a = 'a';
    };
    const _staticB = struct {
        y: u16 = 1,
        const a = 'a';
    };
    const _instanceA = _staticA{};
    const _instanceB = _staticB{};

    if (_DEBUG_TESTS_ and _print_) {
        print(" \n", .{});
        print(" \nA:\n", .{});
        print("  {any}\n", .{TypeOf(_staticA)});
        print("  {any}\n", .{typeInfo(TypeOf(_staticA))});
        print("  {any}\n", .{std.meta.activeTag(typeInfo(TypeOf(_staticA)))});
        print(" \nB:\n", .{});
        print("  {any}\n", .{TypeOf(_staticB)});
        print("  {any}\n", .{typeInfo(TypeOf(_staticB))});
        print("  {any}\n", .{std.meta.activeTag(typeInfo(TypeOf(_staticB)))});
        print(" \n \n", .{});
    }

    try expect(isSameType(_staticA, _staticA) == true); // A == A
    try expect(isSameType(_staticA, _staticB) == true); // TypeOf static == type
    try expect(isSameType(_staticA.a, _staticB.a) == true); // const u8 == const u8

    try expect(isSameType(_instanceA, _instanceA) == true); // A == A
    try expect(isSameType(_instanceA, _instanceB) == false); // A != B
    try expect(isSameType(_instanceA.x, _instanceB.y) == false); // u8 != u16

    try expect(isSameType(u8, u16) == true); // TypeOf u8|u16 == type
}

//-----------------------------------------------------------------------------
pub fn isOfType(actual: anytype, comptime expected: std.builtin.Type) bool {
    _ = expected;
    _ = actual;
    // return std.meta.activeTag(@TypeOf(actual)) == expected;
    return true;
}

//-----------------------------------------------------------------------------
/// Alias of builtin `@TypeOf`, but with hints
pub fn TypeOf(comptime T: anytype) type {
    return @TypeOf(T);
}
//- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
test "TypeOf() alias of @TypeOf()" {
    const _static = struct {};
    const _instance = _static{};

    try expect(TypeOf(void) == @TypeOf(void));
    try expect(TypeOf(null) == @TypeOf(null));
    try expect(TypeOf({}) == void);
    // try expect(TypeOf(.{}) == ??);

    try expect(TypeOf(_static) == type);
    try expect(TypeOf(_instance) == @TypeOf(_instance));
}

//-----------------------------------------------------------------------------
/// Alias of builtin `@typeInfo`, but with hints
pub fn typeInfo(comptime T: type) std.builtin.Type {
    return @typeInfo(T);

    // switch (typeInfo(T)) {
    //     .Struct, .Union, .Enum, .ErrorSet, .Opaque => return true,
    //     .Type => return false,

    //     // Not sure yet id @typeInfo() gracefully handles the other types
    //     else => return false,
    // }
}
//- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
test "typeInfo() alias of @typeInfo()" {
    const _print_ = false;

    const a = u8;
    const b = struct {};

    if (_DEBUG_TESTS_ and _print_) {
        print(" \n \n", .{});
        print("Actual:   {any}\n", .{typeInfo(b)});
        print("Expected: {any}\n", .{@typeInfo(b)});
        print(" \n \n", .{});
    }

    try expect(isOfSameShape(typeInfo(a), @typeInfo(a)));
    try expect(isOfSameShape(typeInfo(b), @typeInfo(b)));
}

//-----------------------------------------------------------------------------

// ? pub fn optionalTypeIs() bool
// Use compile-time reflection to access the child type of the optional:
// try comptime expect(@typeInfo(@TypeOf(foo)).Optional.child == i32);

//-----------------------------------------------------------------------------
/// Compare by name and type of fields and declarations
pub fn isOfSameShape(comptime A: anytype, comptime B: anytype) bool {
    //
    const typeA = if (comptime isStaticStruct(A)) A else TypeOf(A);
    const typeB = if (comptime isStaticStruct(B)) B else TypeOf(B);
    if (typeA != typeB) return false;

    // make return type of fields() nullable
    const optionalFields = ?switch (@typeInfo(typeA)) {
        .Struct => []const Type.StructField,
        .Union => []const Type.UnionField,
        .ErrorSet => []const Type.Error,
        .Enum => []const Type.EnumField,
        else => @compileError("Expected struct, union, error set or enum type, found '" ++ @typeName(typeA) ++ "'"),
    };
    // make return type of .decls nullable
    const optionalDecls = ?[]const Type.Declaration;

    const infoA = @typeInfo(typeA);
    const fieldsA: optionalFields = switch (infoA) {
        .Struct, .Union, .ErrorSet, .Enum => std.meta.fields(typeA),
        else => null,
    };
    const declsA: optionalDecls = switch (infoA) {
        .Struct => |val| val.decls,
        else => null,
    };

    const infoB = @typeInfo(typeB);
    const fieldsB: optionalFields = switch (infoB) {
        .Struct, .Union, .ErrorSet, .Enum => std.meta.fields(typeB),
        else => null,
    };
    const declsB: optionalDecls = switch (infoB) {
        .Struct => |val| val.decls,
        else => null,
    };

    // if one is null and the other is not
    // if ((fieldsA and !fieldsB) or (!fieldsA and fieldsB)) return false;
    if (fieldsA == null and fieldsB != null) return false;
    if (fieldsA != null and fieldsB == null) return false;
    if (declsA == null and declsB != null) return false;
    if (declsA != null and declsB == null) return false;

    // fields compare by name and type
    if (fieldsA != null and fieldsB != null) {
        if (fieldsA) |a| {
            if (fieldsB) |b| {
                // short circuit if lengths are different
                if (a.len != b.len) return false;
                // deeper check
                inline for (a, 0..) |fieldA, i| {
                    const fieldB = b[i];
                    if (!std.mem.eql(u8, fieldA.name, fieldB.name) or fieldA.type != fieldB.type) {
                        return false;
                    }
                }
            }
        }
    }

    // decls compare by name and type
    if (declsA != null and declsB != null) {
        if (fieldsA) |a| {
            if (fieldsB) |b| {
                // short circuit if lengths are different
                if (a.len != b.len) return false;
                // deeper check
                inline for (a, 0..) |declA, i| {
                    const declB = b[i];
                    if (!std.mem.eql(u8, declA.name, declB.name) or declA.type != declB.type) {
                        return false;
                    }
                }
            }
        }
    }

    // seems legit if we made it this far
    return true;
}
//- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
test "isOfSameShape(A, B)" {
    const _print_ = false;

    const A = struct { x: i32, y: i32 };
    const B = struct { x: i32, y: i32 };
    const C = struct { x: i32, z: i32 };

    if (_DEBUG_TESTS_ and _print_) {
        print(" \n \n", .{});
        print(" {any}\n", .{if (comptime isStaticStruct(A)) A else @TypeOf(A)});
        // print(" {any}\n", .{@typeInfo(A)});
        print(" {any}\n", .{if (comptime isStaticStruct(B)) B else @TypeOf(B)});
        print(" {any}\n", .{(if (comptime isStaticStruct(A)) A else @TypeOf(A)) == (if (comptime isStaticStruct(B)) B else @TypeOf(B))});
        // print(" {any}\n", .{@typeInfo(B)});
        print(" \n \n", .{});
    }

    try std.testing.expect(isOfSameShape(A, A) == true);
    try std.testing.expect(isOfSameShape(A, B) == false);
    try std.testing.expect(isOfSameShape(A, C) == false);
}

//- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
// test " isOfType()" {
//     print(" \n \n", .{});
//     // const actual1 = NI;
//     // const expected1 = std.meta.activeTag(@typeInfo(@TypeOf(type)));
//     // print("\n[TEST] isOfType(NI, type)     ?: {any}, {any}\n", .{ actual1, expected1 });
//     // try expect(isOfType(actual1, expected1));

//     print("[TEST] NI          ?: {any}\n", .{NI});
//     print("[TEST] @TypeOf(NI) ?: {any}\n", .{TypeOf(NI)});
//     print(" \n", .{});
//     print("[TEST] typeInfo(@TypeOf(NI)) ?: {any}\n", .{typeInfo(TypeOf(NI))});
//     print(" \n", .{});
//     print("[TEST] activeTag ?: {any}\n", .{std.meta.activeTag(typeInfo(TypeOf(NI)))});
//     print("[TEST] activeTag ?: {any}\n", .{@typeInfo(std.builtin.Type).Union.tag_type.?.Type});
//     print("[TEST] activeTag ?: {any}\n", .{std.meta.activeTag(typeInfo(TypeOf(NI))) == @typeInfo(std.builtin.Type).Union.tag_type.?.Type});
//     print(" \n", .{});
//     print(" \n", .{});

//     const ttttt1 = @TypeOf(NI);
//     print("[TEST] activeTag ?: {s}\n", .{@tagName(std.meta.activeTag(typeInfo(ttttt1)))});
//     print("[TEST] activeTag ?: {s}\n", .{@tagName(@typeInfo(std.builtin.Type).Union.tag_type.?.Type)});
//     print(" \n", .{});

//     const ttttt2 = @TypeOf(NI{});
//     print("[TEST] activeTag ?: {s}\n", .{@tagName(std.meta.activeTag(typeInfo(ttttt2)))});
//     print("[TEST] activeTag ?: {s}\n", .{@tagName(@typeInfo(std.builtin.Type).Union.tag_type.?.Struct)});
//     print(" \n", .{});
//     print(" \n", .{});

//     // const ww = NI{};
//     const ttttt3 = @TypeOf(NI.alpha);
//     print("[TEST] Is a  ?: {s}\n", .{@tagName(std.meta.activeTag(typeInfo(ttttt3)))});

//     print(" \n", .{});
//     // const ttttt4 = NI;
//     inline for (std.meta.fields(ttttt3)) |field|
//         print("[TEST] field ?: {s}\n", .{field.name});
//     print(" \n", .{});
//     inline for (@typeInfo(ttttt3).Struct.decls) |field|
//         print("[TEST] decl  ?: {s}\n", .{field.name});

//     const ttttt5 = NI{};
//     const ttttt6 = NI.alpha;

//     print(" \n", .{});
//     print(" \n", .{});
//     print(" {any}\n", .{NI});
//     print(" {any}\n", .{NI.alpha});
//     print(" {any}\n", .{NI{}});
//     print(" {any}\n", .{NI.new()});
//     print(" {any}\n", .{NI.newWithOptions(.{})});
//     print(" {any}\n", .{&NI.alpha == &NI.alpha});
//     print(" {any}\n", .{&ttttt5 == &ttttt5});
//     print(" {any}\n", .{&ttttt5 == &ttttt6});
//     print(" {any}\n", .{&ttttt5 == &NI.new()});
//     print(" {any}\n", .{&ttttt5 == &NI.newWithOptions(.{})});
//     // print(" {any}\n", .{NI.instanceField orelse null});

//     // const ttttt3 = @TypeOf({});
//     // print("[TEST] activeTag ?: {s}\n", .{@tagName(std.meta.activeTag(typeInfo(ttttt3)))});
//     // print("[TEST] activeTag ?: {s}\n", .{@tagName(@typeInfo(std.builtin.Type).Union.tag_type.?.Void)});
//     // print(" \n", .{});

//     // print("[TEST] activeTag ?: {any}\n", .{@typeInfo(ttttt).Union.tag_type.?.Type});
//     // print("[TEST] activeTag ?: {any}\n", .{@typeInfo(ttttt).Union.tag_type.?});
//     // print("[TEST] activeTag ?: {any}\n", .{@typeInfo(ttttt).Union.tag_type});
//     // print("[TEST] Union ?: {any}\n", .{@TypeOf(@typeInfo(ttttt).Union)});
//     // print("[TEST] Union ?: {any}\n", .{@TypeOf(@typeInfo(ttttt).Union) == std.builtin.Type});
//     // print("[TEST] Union ?: {any}\n", .{std.builtin.Type});

//     // inline for (@typeInfo(std.builtin.Type).Union.fields) |field|
//     //     print("[TEST] Union field ?: {s}\n", .{field.name});

//     // const actual2 = NI.alpha;
//     // const expected2 = @typeInfo(@TypeOf(NI));
//     // print("\n[TEST] isOfType(NI.alpha, NI) ?: {any}, {any}\n", .{ actual2, expected2 });
//     // try expect(isOfType(actual2, expected2));
//     print(" \n \n", .{});
// }

//-----------------------------------------------------------------------------
fn isInstanceOfType(actual: anytype, comptime expected: type) bool {
    _ = expected;
    _ = actual;

    // std.meta.eql? takes thing and type ?

    return true;
}
//- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
test "isInstanceOfType()" {
    try expect(isInstanceOfType(NI, type));
    try expect(isInstanceOfType(NI.alpha, NI));
}

//-----------------------------------------------------------------------------
// fn field0IsConst(actual: anytype) bool {
//     if (isType(actual))
//         return @typeInfo(T).Struct.fields[0].is_comptime;

//     // Pointer.is_const ??
// }
//- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
// test " `NI` itself is not an instance" {
//     try expect(@TypeOf(NI) == type);
// }
//- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
// test " `NI.alpha` is a const instance of NI" {
//     // is instance of empty/default/uninitialized NI?
//     // try expect(metaEql(NI.alpha, NI{}));
//     // todo: how to do deep equality check?

//     // types match?
//     // try expect(typesMatch(NI.alpha, NI{}));

//     // try expect(@TypeOf(NI.alpha) != type);
//     // try expect(@TypeOf(NI.alpha) == @TypeOf(NI{}));
// }

/// Returns the name of the function passed to it in dot notation
pub fn fullNameOf(comptime arg: anytype) []const u8 {
    //
    const argType = @TypeOf(arg);
    const argTypeInfo = @typeInfo(if (argType == type) arg else argType);

    const name = switch (argTypeInfo) {
        .Fn => |_fn| blk: {
            const fullName = @typeName(_fn.return_type orelse break :blk "FN_NAME_NULL");

            // TODO: found cases where it does not start with this prefix
            // e.g. `StructName.StructName` when a stuct is called in a test in it's own file
            // e.g. `void` not sure, but think it happens at `defer _ = instance.deinit()`
            // So can not rely on the prefix being a specific length
            const prefix = "@typeInfo(@typeInfo(@TypeOf(";
            const start = prefix.len;

            // if (fullName.len < start) break :blk "FN_NAME_INVALID_LENGTH_1";
            if (fullName.len < start) break :blk fullName;

            const end = std.mem.indexOf(u8, fullName[start..], ")") orelse break :blk "FN_NAME_INVALID_LENGTH_2";

            break :blk fullName[start .. start + end];
        },
        else => |_any| blk: {
            _ = _any;
            break :blk "FN_NAME_NOT_A_FUNCTION";
        },
    };

    return name;
}

/// Represent.dot.notation.names
pub const DotNotation = struct {
    value: []const u8 = "",

    /// `comptime` Get function full name.
    pub fn ofFunction(comptime function: anytype) DotNotation {
        return DotNotation{
            .value = fullNameOf(function),
        };
    }

    // aliases for readability
    pub const get = leaf;
    pub const all = full;

    pub fn full(_self: DotNotation) []const u8 {
        return _self.value;
    }

    /// get part before first dot
    pub fn root(_self: DotNotation) []const u8 {
        const firstDot = std.mem.indexOf(u8, _self.value, ".") orelse return _self.value;
        return _self.value[0..firstDot];
    }

    /// get part after last dot
    pub fn leaf(_self: DotNotation) []const u8 {
        const lastDot = std.mem.lastIndexOf(u8, _self.value, ".") orelse return _self.value;
        return _self.value[lastDot + 1 ..];
    }

    /// get part before last dot
    pub fn ancestors(_self: DotNotation) []const u8 {
        const lastDot = std.mem.lastIndexOf(u8, _self.value, ".") orelse return _self.value;
        return _self.value[0..lastDot];
    }

    /// get part after first dot
    pub fn decendents(_self: DotNotation) []const u8 {
        const lastDot = std.mem.lastIndexOf(u8, _self.value, ".") orelse return _self.value;
        return _self.value[lastDot + 1 ..];
    }
};
