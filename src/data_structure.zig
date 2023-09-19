const std = @import("std");

pub fn uninitialized(comptime T: type) T {
    return T{};
}

// Avoid implicit comptime:
//  - @This() -> implicitly makes it comptime
//  - union of function types, rather of function pointers

fn PreventImplicitComptime(comptime inlineFunction: type) type {
    return *const inlineFunction;
}

const StaticFn_returnGraph = PreventImplicitComptime(fn () Graph);
const InstanceFn_returnVoid = PreventImplicitComptime(fn (*Graph) void);
const WithAllocatorFn = PreventImplicitComptime(fn (*const std.mem.Allocator) anyerror!void);
const WithoutAllocatorFn = PreventImplicitComptime(fn () void);

// type alias for readability
const TriggerFn = InstanceFn_returnVoid;
const ConstructorFn = StaticFn_returnGraph;

pub const Graph = struct {

    // PUPLIC

    // INSTANCE > FIELDS (always public, can be set at instantiation time)
    name: ?[]const u8 = undefined,

    // PUBLIC > STATIC > MEMBERS
    // - value set at compile time
    // - var/const 'data' members are not callable like function members

    // pub const new: ConstructorFn = DefaultImplementation.newGraphOnStack;
    pub fn new(args: anytype) Graph {
        // return Graph{};
        return @call(std.builtin.CallModifier.auto, DefaultImplementation.newGraphOnStack, args);
    }

    // pub const print: TriggerFn = DefaultImplementation.print;
    pub fn print(self: *Graph) bool {
        // return @call(std.builtin.CallModifier.auto, DefaultImplementation.print, .{self});
        return self.name == null;
    }

    // pub const init: TriggerFn = undefined;
    // pub fn init(args: anytype) void {
    //     // switch (@typeInfo(@TypeOf(args))) {}

    //     // const ArgsType = @TypeOf(args);
    //     // const args_type_info = @typeInfo(ArgsType);
    //     // if (args_type_info != .Struct) {
    //     //     @compileError("expected tuple or struct argument, found " ++ @typeName(ArgsType));
    //     // }

    //     // const fields_info = args_type_info.Struct.fields;
    //     // if (fields_info.len > max_format_args) {
    //     //     @compileError("32 arguments max are supported per format call");
    //     // }

    //     // std.log.info("[GRAPH] init()  {any}\n", .{args});
    //     // std.log.info("[GRAPH] init()  {any}\n", .{@TypeOf(args)});
    //     // std.log.info("[GRAPH] init()  {any}\n", .{@typeInfo(@TypeOf(args))});

    //     // std.debug.assert(std.builtin.Type.Struct != @TypeOf(@typeInfo(@TypeOf(args)).Struct));

    //     comptime {
    //         const Type = std.builtin.Type;
    //         _ = Type;
    //         const typeOfArgs = @TypeOf(args);

    //         switch (@typeInfo(typeOfArgs)) {
    //             .Struct, .Enum, .Union => {
    //                 //
    //                 // std.log.info("[GRAPH] init() tagName : {any}\n", .{@tagName(args)});
    //                 std.log.info("\n[GRAPH] init() TypeOf  : {any}\n", .{@TypeOf(args)});
    //                 std.log.info("\n[GRAPH] init() typeInfo: {any}\n", .{@typeInfo(@TypeOf(args))});
    //                 std.log.info("\n[GRAPH] init() isTuple : {any}\n", .{std.meta.trait.isTuple(@TypeOf(args))});

    //                 // std.log.info("\n\n[GRAPH] arg is a struct\n", .{});
    //                 // if (typeInfo.is_tuple) std.log.info("[GRAPH] ..and tuple-like\n", .{});
    //             },
    //             else => {
    //                 std.debug.print("\n\n[GRAPH] found type '{s}'\n", .{@typeName(typeOfArgs)});
    //                 // @compileError("Expected tuple or anon struct, found '" ++ @typeName(typeOfArgs) ++ "'");
    //             },
    //         }
    //     }
    //     // return @call(std.builtin.CallModifier.auto, DefaultImplementation.init0, args);
    // }

    const Type = std.builtin.Type;
    const trait = std.meta.trait;
    const anonStruct = @TypeOf(.{});

    pub fn init(args: anytype) void {
        // const args = args;
        comptime {
            const typeOfArgs = @TypeOf(args);
            switch (@typeInfo(typeOfArgs)) {
                .Struct => |info| {
                    @compileLog(typeOfArgs);
                    @compileLog("typeInfo", @typeInfo(typeOfArgs));
                    @compileLog("");
                    @compileLog("isTuple ", trait.isTuple(typeOfArgs), info.backing_integer);

                    const fieldMembers = info.fields;
                    const pubMembers = info.decls;

                    @compileLog("");
                    @compileLog("fields", fieldMembers);
                    @compileLog("");
                    @compileLog("decls", pubMembers);
                    @compileLog("");
                    @compileLog("");
                },
                else => {
                    @compileLog("! found type: ", @typeName(typeOfArgs));
                },
            }
        }
    }
    // pub fn init(args: anytype) void {
    //     const _argsType = @TypeOf(args);
    //     comptime var _isStruct: bool = undefined;
    //     comptime var _typeInfo: std.builtin.Type = undefined;
    //     comptime var _isTupleViaProp: bool = undefined;
    //     comptime var _isTupleViaFn: bool = undefined;

    //     comptime {
    //         switch (@typeInfo(_argsType)) {
    //             .Struct => |typeInfo| {
    //                 _isStruct = true;
    //                 _typeInfo = @typeInfo(_argsType);
    //                 _isTupleViaFn = std.meta.trait.isTuple(_argsType);
    //                 _isTupleViaProp = typeInfo.is_tuple;
    //             },
    //             else => {
    //                 @compileError("Expected tuple or anon struct, found '" ++ @typeName(_argsType) ++ "'");
    //             },
    //         }
    //     }
    //     std.debug.print("\n[GRAPH] init() TypeOf  : {any}\n", .{_argsType});
    //     std.debug.print("\n[GRAPH] init() typeInfo: {any}\n", .{_typeInfo});
    //     std.debug.print("\n[GRAPH] init() isTuple : {any}\n", .{_isTupleViaFn});
    //     std.debug.print("\n\n[GRAPH] arg is a struct\n", .{});
    //     if (_isTupleViaProp) std.debug.print("[GRAPH] ..and also tuple-like\n", .{});
    // }
    // pub fn init(args: anytype) void {
    //     comptime {
    //         switch (@typeInfo(@TypeOf(args))) {
    //             .Struct => |typeInfo| {
    //                 // std.log.info("[GRAPH] init() tagName : {any}\n", .{@tagName(args)});
    //                 std.log.info("\n[GRAPH] init() TypeOf  : {any}\n", .{@TypeOf(args)});
    //                 std.log.info("\n[GRAPH] init() typeInfo: {any}\n", .{@typeInfo(@TypeOf(args))});
    //                 std.log.info("\n[GRAPH] init() isTuple : {any}\n", .{std.meta.trait.isTuple(@TypeOf(args))});

    //                 std.log.info("\n\n[GRAPH] arg is a struct\n", .{});
    //                 if (typeInfo.is_tuple) std.log.info("[GRAPH] ..and also tuple-like\n", .{});
    //             },
    //             .Enum, .Union => |typeInfo| {
    //                 std.log.info("[GRAPH] init() tagName : {any}\n", .{@tagName(args)});
    //                 std.log.info("\n[GRAPH] init() TypeOf  : {any}\n", .{@TypeOf(args)});
    //                 std.log.info("\n[GRAPH] init() typeInfo: {any}\n", .{@typeInfo(@TypeOf(args))});
    //                 std.log.info("\n[GRAPH] init() isTuple : {any}\n", .{std.meta.trait.isTuple(@TypeOf(args))});

    //                 std.log.info("\n\n[GRAPH] arg is a struct\n", .{});
    //                 if (typeInfo.is_tuple) std.log.info("[GRAPH] ..and also tuple-like\n", .{});
    //             },
    //             else => {
    //                 std.debug.print("\n\n[GRAPH] found type '{s}'\n", .{@typeName(@TypeOf(args))});
    //                 // @compileError("Expected tuple or anon struct, found '" ++ @typeName(typeOfArgs) ++ "'");
    //             },
    //         }
    //     }
    // }

    // pub fn _init(args: anytype) void {
    //     @compileError("Expected tuple or anon struct, found '" ++ @typeName(typeOfArgs) ++ "'");
    // }

    // pub const deinit: TriggerFn = undefined;
    pub fn deinit(args: anytype) void {
        return @call(std.builtin.CallModifier.auto, DefaultImplementation.deinit0, args);
    }

    // PRIVATE > STATIC >MEMBERS
    // - value set at compile time
    // - var/const 'data' members are not callable like function members

    var _initFnPtr: ptrToAnyInitFn = undefined;
    const setGlobalInit: fn (ptrToAnyInitFn) void = DefaultImplementation.set_initFnPtr;

    var _deinitFnPtr: ptrToAnyInitFn = undefined;
    const setGlobalDeinit: fn (ptrToAnyDeinitFn) void = DefaultImplementation.set_deinitFnPtr;

    const Allocator = std.mem.Allocator;
    const pageAllocator = std.heap.page_allocator;

    const withOrWithoutAllocator = enum {
        withAllocator,
        withoutAllocator,
    };
    const ptrToAnyInitFn = union(withOrWithoutAllocator) {
        withAllocator: WithAllocatorFn,
        withoutAllocator: WithoutAllocatorFn,
    };
    const ptrToAnyDeinitFn = union(withOrWithoutAllocator) {
        withAllocator: WithAllocatorFn,
        withoutAllocator: WithoutAllocatorFn,
    };

    const DefaultImplementation = struct {
        fn newGraphOnStack() Graph {
            std.log.info("[GRAPH] Default.onStack()\n", .{});
            // return Graph{
            //     .name = "Graph.DefaultImplementation",
            //     .init = Graph.DefaultImplementation.trigger_initFn,
            //     .deinit = Graph.DefaultImplementation.trigger_deinitFn,
            // };
            return Graph{
                .name = "Graph.DefaultImplementation",
                // .init = Graph.DefaultImplementation.trigger_initFn,
                // .deinit = Graph.DefaultImplementation.trigger_deinitFn,
            };
        }
        fn print(self: *Graph) void {
            std.log.info("[GRAPH] Default.print() -> '{s}'\n", .{self.name.?});
            // return error.IsInterfaceNotImplementaion;
            return void{};
        }
        fn init(allocator: *const Allocator) !void {
            _ = allocator;
            std.log.info("[GRAPH] Default.init()\n", .{});
            // return error.IsInterfaceNotImplementaion;
            if (false) return error.ToKeepCompilerHappy;
            return void{};
        }
        fn init0() void {
            std.log.info("[GRAPH] Default.init0()\n", .{});
            // return error.IsInterfaceNotImplementaion;
            // if (false) return error.ToKeepCompilerHappy;
            // return void{};
        }
        fn deinit(allocator: *const Allocator) !void {
            _ = allocator;
            std.log.info("[GRAPH] Default.deinit()\n", .{});
            // return error.IsInterfaceNotImplementaion;
            if (false) return error.ToKeepCompilerHappy;
            return void{};
        }
        fn deinit0() void {
            std.log.info("[GRAPH] Default.deinit0()\n", .{});
            // return error.IsInterfaceNotImplementaion;
            // if (false) return error.ToKeepCompilerHappy;
            // return void{};
        }

        // ?

        fn set_initFnPtr(func: Graph.ptrToAnyInitFn) void {
            std.log.info("[GRAPH] Default.set_init()\n", .{});
            const _func: ptrToAnyInitFn = switch (func) {
                .withoutAllocator => Graph.DefaultImplementation.init0,
                .withAllocator => Graph.DefaultImplementation.init,
                else => unreachable,
            };
            Graph._initFnPtr = _func;
        }

        fn set_deinitFnPtr(func: Graph.ptrToAnyDeinitFn) void {
            std.log.info("[GRAPH] Default.set_deinit()\n", .{});
            const _func: ptrToAnyDeinitFn = switch (func) {
                .withoutAllocator => Graph.DefaultImplementation.deinit0,
                .withAllocator => Graph.DefaultImplementation.deinit,
                else => unreachable,
            };
            Graph._deinitFnPtr = _func;
        }

        fn trigger_initFn(self: *Graph) void {
            std.log.info("[GRAPH] Default.trigger_init()\n", .{});
            self._initFnPtr.*();
        }

        fn trigger_deinitFn(self: *Graph) void {
            std.log.info("[GRAPH] Default.trigger_deinit()\n", .{});
            self._deinitFnPtr.*();
        }
    };
};
