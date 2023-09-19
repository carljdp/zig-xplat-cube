const std = @import("std");
const c = @import("c.zig");
const TT = @import("TT.zig").TT;

const expect = std.testing.expect;
const print = std.debug.print;
const panic = std.debug.panic;

const ParamType = struct {
    // Value: Value,
    // Reference: Reference,
    // Entity: Entity,
    // Constant: Constant,
    // Variable: Variable,

    const Constant = _Constant;
    const Variable = _Variable;
};

// A Concrete Value
const _Value = struct {
    Char: u8,
    String: []u8,
};

// A Reference to another Entity
const _Reference = struct {
    Entity: _Entity,
};

// A Concrete Value or a Reference to another Entity
const _Entity = struct {
    // Value: _Value,
    // Reference: _Reference,
};

// A Immutable Entity
const _Constant = struct {
    Entity: _Entity,
};

// A Mutable Entity
const _Variable = struct {
    Entity: _Entity,
};

const ExistentialTypeTag = enum {
    Concrete,
    Conduit,
    Type,
};
const ExistentialType = union(ExistentialTypeTag) {
    Concrete: ConcreteValue,
    Conduit: ConduitValue,
    Type: ShortCircuitValue,

    fn bigBang() ExistentialType {
        return ExistentialType.Conduit{
            ConduitValue{
                .selfExistentialTypeTag = ExistentialTypeTag.Type,
                .selfValueLocation = ConcreteValueTag.Void,
                .childType = null,
                .childLocation = null,
            },
        };
    }
};

const ShortCircuitValueTag = enum {
    Character,
    String,
    Void,
    Type,
};
const ShortCircuitValue = union(ShortCircuitValueTag) {
    Character: u8,
    String: []u8,
    Void: void,
    Type: type,
};
// const ShortCircuitValue = struct {
//     Character: u8,
//     String: []u8,
//     Void: void,
// };

const ConcreteValueTag = enum {
    Character,
    String,
    Null,
    Void,
};
const ConcreteValue = union(ConcreteValueTag) {
    Character: u8,
    String: []u8,
    Null: ?void,
    Void: void,
};

// enum => text labels for numbers
// here `enum` declares required interface for union
const TextualTypeTags = enum {
    Character,
    String,
};

// union => group of acceptable shapes/types
// here `union` implements the type for each tag defined in the enum interface
const TextualTypes = union(TextualTypeTags) {
    Character: type,
    String: type,
};

// struct => shape (not an instance/instanciated)
// no variable fields here, all are static / fixed
const TextualType = struct {
    // static fields
    const Character: TextualTypes.Character = u8;
    const String: TextualTypes.String = u8;
};

const textualCharTest: TextualType.Character = 'a';
const textualStrTest: TextualType.String = "hello";

const ConduitValue = struct {

    // Are You..
    // - Real (have concrete value of consequence) ?
    // - Imaginary (just a parent/reference/conduit to another) ?
    // - You don't decide yourself, it depends on whether you have children or not
    selfExistentialTypeTag: ?ExistentialTypeTag = null,
    // - What ever you are, what is it?
    selfPointsToInstance: ?*ExistentialType = null, // has to be pointer to avoid cyclic dependency error

    selfShortCircuitValue: ?ShortCircuitValueTag = null,

    // Is your Child..
    // - Real (have concrete value of consequence) ?
    // - Imaginary (just a parent/reference/conduit to another) ?
    childType: ?ExistentialTypeTag = null,
    childLocation: ?*ExistentialType = null, // has to be pointer to avoid cyclic dependency error

    fn t() !type {
        const self = @This();
        switch (self.selfExistentialTypeTag) {
            ExistentialTypeTag.Type => return self.selfValueLocation.*,
            else => return error.InvalidState,
        }
        unreachable;
    }
};

fn I() ExistentialType {
    return ExistentialType.bigBang();
}

// fn createReference(child: *ConduitValue) ConduitValue {
//     return ConduitValue{
//         .selfExistentialTypeTag = ExistentialType{.Branch}, // if i have children, then i am no longer Real (concrete), just a Conduit (branch)
//         .selfValueLocation = null, // cos i am no longer Real (concrete), just a Conduit (branch)
//         .childType = ChildTypes.Pointer,
//         .childNode = child,
//     };
// }

// fn createConcrete(child: *ConduitValue) ConduitValue {
//     return ConduitValue{
//         .childType = ChildTypes.Pointer,
//         .represents = ExistentialType.Const,
//         .child = child,
//     };
// }

// test "ParamTypes" {
//     // try comptime expect(ParamType.Constant == ParamType.Constant);

//     // print("Type: {any}\n", .{@TypeOf(b)});
//     // print("Info: {any}\n", .{@typeInfo(b)});

//     // print("{any}\n", .{ParamType.Constant == ParamType.Variable});
//     // print("{any}\n", .{@TypeOf(ParamType.Constant)});
//     // print("{any}\n", .{@TypeOf(ParamType.Variable)});
// }

// pub fn mainxx() void {
// //     var characterType = ConduitValue{
// //         .selfExistentialTypeTag = ExistentialTypeTag.Type,
// //         .selfShortCircuitValue = ShortCircuitValueTag.Character,
// //     };
// //     _ = characterType;
// //     // var character: characterType.t() = 'a';
// //     // _ = character;
// //     // var ptrToByte = createReference(&byteType);
// //     // var constPtrToByte = createConcrete(&ptrToByte);
// //     // _ = constPtrToByte;

// // }
