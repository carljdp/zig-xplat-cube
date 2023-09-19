const std = @import("std");
const c = @import("c.zig");
const TT = @import("TT.zig").TT;

const expect = std.testing.expect;
const print = std.debug.print;
const panic = std.debug.panic;

// const nodeA = Graph.newGraph.Node(null);

// const nodeB = Graph.newGraph.Node(null);

// const edgeAB = Graph.newGraph.Edge(.{
//     .name = "edgeAB",
// });

// const edgeBA = Graph.newGraph.Edge(.{
//     .name = "edgeBA",
// });

// const edgeAB = DirectedEdge{
//     .parent = nodeA,
//     .child = nodeB,
// };

//     var g: Graph = undefined;
//     _ = g;
//     // var g = GG.new();
//     // _ = g;
//     // g.print();
//     // g.init();

//     // g.init0() catch |err| {
//     //     panic("GG.init0() failed: {any}\n", .{err});
//     // };
//     // g.deinit0() catch |err| {
//     //     panic("GG.init0() failed: {any}\n", .{err});
//     // };

// pub fn main() !void {
//     const someStruct = struct {
//         x: u8 = undefined,

//         pub const c = 42;
//         // pub const a = 'a';

//         pub var e = 'e';

//         pub fn d() u8 {
//             return 42;
//         }
//         // pub fn b() u8 {
//         //     return 42;
//         // }
//     };

//     // Graph.init(someStruct{});
//     // Graph.init(.{});
//     // Graph.init(GPA{});

//     // Tuple (type of anonymous struct literal)
//     // - identify via: no field types + no field names + value required
//     // - unnamed/tagless fields
//     // - ordered, has .len
//     // - can: use as a literal value
//     // - cant: be instantiated, or used as a type
//     // - cant: contain other declarations
//     const tupleLit = .{
//         42, // implicitly named "0"
//         "hi", // implicitly named "1"
//     };
//     expect(tupleLit[0] == 42) catch {};

//     // Anonymous Struct Literal
//     // - identify via: no field types + .field names + value required
//     // - named/tagged fields - explicitly named
//     // - Not ordered, no .len
//     // - can: use as a literal value
//     // - cant: be instantiated, or used as a type
//     // - cant: contain other declarations
//     const anonLit = .{
//         .a = 42, // explicitly named "a"
//         .b = "hi", // explicitly named "b"

//         // pub const c = 42;
//     };
//     expect(anonLit.a == 42) catch {};

//     // Named Struct / Type
//     // - named/tagged fields - explicitly named
//     // - Not ordered, no .len
//     // - cant: use as a literal value
//     // - can: be instantiated, or used as a type
//     // - can: contain other declarations

//     // expect(Named.StaticFunctions.getC() == 0) catch {};
//     var _namedI = anyNamedSt{ .inst = NamedSt{} };
//     var _namedP = anyNamedSt{ .inst = NamedSt{} };
//     // var _namedP = anyNamedSt{ .ptr = *NamedSt{} };
//     _namedI = _namedI.setName();
//     _namedP = _namedP.setName();
//     expect(mem.eql(u8, NamedSt.Static.getName(_namedP), _namedI.getName())) catch {};
//     // expect((Named{}).instanceFn.getA() == 42) catch {};

//     Graph.init(.{someStruct});
//     // Fields of `.{someStruct}`
//     //  = .{ .{.name = "0", .type = type, .default_value = main.main.someStruct, .is_comptime = true, .alignment = 0} }
//     // Decls of `.{someStruct}`
//     //  = .{  }

//     Graph.init(someStruct{});
//     // Fields of `someStruct{}`
//     //  = .{ .{.name = "x", .type = u8, .default_value = undefined, .is_comptime = false, .alignment = 1} }
//     // Decls of `someStruct{}`
//     //  = .{ .{.name = "c"}, .{.name = "e"}, .{.name = "d"} }

//     // const myAnonStruct = .{ .a = 42, .b = "hello" };
//     // Graph.init(.{ myAnonStruct.a, myAnonStruct.b });

//     // var g: Graph = Graph.new(.{});
//     // _ = g.print();
// }
