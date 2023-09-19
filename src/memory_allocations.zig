// generics
const std = @import("std");
const c = @import("c.zig");
const TT = @import("TT.zig").TT;

// aliases
const expect = std.testing.expect;
const print = std.debug.print;
const panic = std.debug.panic;
const Allocator = std.mem.Allocator;

// flags
const is_debug = false;

/// General Purpose Allocator
pub const GPA = struct {
    const makeWith = std.heap.GeneralPurposeAllocator;

    // fn getOptions()  {  // returning a struct literal

    // }
    // fn getDebugAllocator() ?Allocator {
    //     var gpa = GPA.makeWith(GPA.debugOptions){};
    //     return gpa.allocator();
    // }
    fn getAllocator() ?Allocator {
        var gpa = GPA.makeWith(if (is_debug) .{
            .stack_trace_frames = 4,
            .enable_memory_limit = true,
            .safety = true,
            .never_unmap = true,
            .retain_metadata = true,
            .verbose_log = true,
        } else .{}){};
        return gpa.allocator();
    }
};
