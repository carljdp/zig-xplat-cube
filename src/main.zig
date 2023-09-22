//=============================================================================
// generics
const std = @import("std");
const c = @import("c.zig");

//- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
// aliases
const Type = std.builtin.Type;
const Allocator = std.mem.Allocator;
const memEql = std.mem.eql;
const metaEql = std.meta.eql;
const expect = std.testing.expect;
const print = std.debug.print;
const panic = std.debug.panic;
// const compilePrint = @compileLog("COMPTIME! AGAIN! WHY??");
// const compilePanic = @compileError("COMPTIME! AGAIN! WHY??");

//- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
// Flags
const isTest = @import("builtin").is_test;
const is_debug = false;

//- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
// just for easier dev time code navigation
const _std_builtin_ = @import("std").builtin;
const _std_meta____ = @import("std").meta;

//- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
// Own file imports

/// Math3D (imported)
const math3d = @import("math3d.zig");
/// Debug Utils (imported)
const Du = @import("debug_helpers.zig");
/// Graph Data Structure (imported)
const Graph = @import("data_structure.zig").Graph;
/// Non-Idiomatic Zig (imported)
const NI = @import("NI.zig");
/// TTypes etc. (imported)
const TT = @import("TT.zig").TT;
const XT = @import("TT.zig").ExplicitTypes;
/// ChatGPT plan (imported)
const OCDP = @import("OCDP.zig").OCDP;
/// General Purpose Allocator (imported)
const GPA = @import("memory_allocations.zig").GPA;

const main2 = @import("glfw_related.zig").main2;

//=============================================================================
// MAIN()
//-----------------------------------------------------------------------------

pub fn main() !void {
    // @breakpoint();
    //
    // try OCDP.shaderCompilation();
    // _ = try main2();

    // _ = main2() catch |err| {
    //     print("\n->main2() failed:\n {!}", .{err});
    // };
    _ = try main2();

    // const ctx = "world";
    // std.debug.print(" \n Hello, {s}!\n", .{ctx});
}

test "main()" {
    // OCDP._1_shaderCompilation() catch |err| {
    //     print(" \nOCDP._1_shaderCompilation() failed:\n {}", .{err});
    // };
    _ = main2() catch |err| {
        print("\n->main2() failed:\n {!}", .{err});
    };
}
