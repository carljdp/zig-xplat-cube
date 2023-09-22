// generics
const std = @import("std");

// debug helpers
const is_test = @import("builtin").is_test;
const NameUtils = @import("debug_helpers.zig").DotNotation;

// const MyStruct = struct {
//     allocator: *const std.mem.Allocator,
//     resources: std.ArrayList(*u8),

//     pub fn init(allocator: *const std.mem.Allocator) !MyStruct {
//         var resources = std.ArrayList(*u8).init(allocator);
//         return MyStruct{ .allocator = allocator, .resources = resources };
//     }

//     pub fn allocateNewT(self: *MyStruct, comptime T: type) !*T {
//         const resource = try self.allocator.create(T);
//         try self.resources.append(@as(*u8, @ptrCast(resource)));
//         return resource;
//     }

//     pub fn deinit(self: *MyStruct) void {
//         for (self.resources.items) |resource| {
//             _ = resource;
//             // Custom logic to free each type of resource
//             // ...
//         }
//         self.resources.deinit();
//     }
// };

pub const StructTemplate = struct {
    allocator: *const std.mem.Allocator = undefined,
    array: std.ArrayList(*anyopaque) = undefined,
    count: usize = undefined,
    capacity: usize = undefined,
    initialized: bool = false,

    // pub fn shaderCompilation() !void {
    //     // Import, compile, and check the vertex and fragment shaders.
    //     // Create a shader program, attach shaders, and link.
    //     return void;
    // }

    /// -----------------------------------------------------------------------
    /// Create new instance **by-value** & return to the caller's stack,
    ///  remember to `instance.init()`
    ///
    /// Caller's Responsibilities:
    /// - None (freed automatically when caller's stack frame is popped).
    /// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    /// *Returning a 'struct{} instance by value', implies that:*
    /// - returns an [copyOf|instance] of that struct (by value)
    /// - caller is [responsibleFor|owns] the returned instance
    /// - since returned by value:
    ///   - it will be [storedOn|copiedTo] the caller's stack
    ///   - it will be [deinitialized|destroyed|cleanedUp] automatically
    ///     when it goes out of scope, when the caller's stack frame is popped
    /// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    /// possible future synonyms: <create|new><Stack|Static|ByValue|Comptime>
    /// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    pub fn onStack() StructTemplate {
        // Log out this function name at entry and exit` ` ` ` ` `
        const memo = comptime NameUtils.ofFunction(StructTemplate.onStack).full();
        if (!is_test) std.debug.print("[{s}] ..\n", .{memo});
        defer if (!is_test) std.debug.print("[{s}] done.\n", .{memo});
        // ` ` ` ` ` ` ` ` ` ` ` ` ` ` ` ` ` ` ` ` ` ` ` ` ` ` ` `

        // return copy of original struct by value.
        return StructTemplate{};
    }

    /// -----------------------------------------------------------------------
    /// Create new instance **by-reference** on the heap,
    ///  remember to `instance.init()`.
    ///
    /// Caller's Responsibilities:
    /// - Free resources via `defer allocator.destroy(instance)`.
    /// - Possible error on allocation failure.
    /// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    /// *Returning a 'pointer to a struct instance', implies that:*
    /// - returns a [pointerTo] new memory allocated for that struct (by reference)
    /// - caller is [responsibleFor|owns] the [memory|resources] that's pointed to
    /// - since returned by reference:
    ///   - if it was on the stack in this function, it would go out of scope
    ///   - only way to return a valid reference is to allocate on the heap
    ///   - it will not be automatically [managed|deinitialized|destroyed|cleanedUp],
    ///     that's the caller's responsibility
    /// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    /// possible future synonyms: <create|new><Heap|Dynamic|ByRef|Runtime|Alloc|Unmanaged>
    /// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    pub fn onHeap(allocator: *const std.mem.Allocator) !*StructTemplate {
        // Log out this function name at entry and exit` ` ` ` ` `
        const memo = comptime NameUtils.ofFunction(StructTemplate.onHeap).full();
        if (!is_test) std.debug.print("[{s}] ..\n", .{memo});
        defer if (!is_test) std.debug.print("[{s}] done.\n", .{memo});
        // ` ` ` ` ` ` ` ` ` ` ` ` ` ` ` ` ` ` ` ` ` ` ` ` ` ` ` `

        const instancePtr: *StructTemplate = try allocator.create(StructTemplate);
        instancePtr.* = StructTemplate.onStack();
        return instancePtr;
    }

    /// -----------------------------------------------------------------------
    /// **Initialize instance** created via `onStack()` or `onHeap()`.
    /// - `allocator` Your prefered allocator the intenal ArrayList,
    ///     defaults to `std.heap.page_allocator`.
    /// - `capacity` Initial capacity of the internal ArrayList,
    ///     defaults to `0`.
    /// - Returns `self` for chaining.
    ///
    /// Caller's Responsibilities:
    /// - Free internal resources via `defer instance.deinit()`
    /// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    pub fn init(self: *StructTemplate, allocator: ?*const std.mem.Allocator, capacity: ?usize) !*StructTemplate {
        // Log out this function name at entry and exit` ` ` ` ` `
        const memo = comptime NameUtils.ofFunction(StructTemplate.init).full();
        if (!is_test) std.debug.print("[{s}] ..\n", .{memo});
        defer if (!is_test) std.debug.print("[{s}] done.\n", .{memo});
        // ` ` ` ` ` ` ` ` ` ` ` ` ` ` ` ` ` ` ` ` ` ` ` ` ` ` ` `

        // set from arg value, or default to a not-null value
        self.allocator = if (allocator) |alloc| alloc else &std.heap.page_allocator;
        self.capacity = if (capacity) |cap| cap else 0; // TODO - really default to 0 ?
        // try allocate
        // var _allocator = self.allocator.?.*;
        self.array = try std.ArrayList(*anyopaque).initCapacity(self.allocator.*, self.capacity);
        self.count = self.array.items.len;
        self.capacity = self.array.capacity;

        self.initialized = true;
        return self;
    }

    /// -----------------------------------------------------------------------
    /// **Deinitialize instance** initialized with `init()`.
    /// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    pub fn deinit(self: *StructTemplate) void {
        // Log out this function name at entry and exit` ` ` ` ` `
        const memo = comptime NameUtils.ofFunction(StructTemplate.deinit).full();
        if (!is_test) std.debug.print("[{s}] ..\n", .{memo});
        defer if (!is_test) std.debug.print("[{s}] done.\n", .{memo});
        // ` ` ` ` ` ` ` ` ` ` ` ` ` ` ` ` ` ` ` ` ` ` ` ` ` ` ` `

        self.array.deinit(); // free allocated stuff
        self.array = undefined;
        self.allocator = undefined;
        self.count = undefined;
        self.capacity = undefined;

        self.initialized = false;
        return self;
    }

    /// TODO - Not needed? Does nothing, except calling `deinit()` if you didn't, to free internal resources.
    pub fn destroy(self: *StructTemplate) void {
        // Log out this function name at entry and exit` ` ` ` ` `
        const memo = comptime NameUtils.ofFunction(StructTemplate.destroy).full();
        if (!is_test) std.debug.print("[{s}] ..\n", .{memo});
        defer if (!is_test) std.debug.print("[{s}] done.\n", .{memo});
        // ` ` ` ` ` ` ` ` ` ` ` ` ` ` ` ` ` ` ` ` ` ` ` ` ` ` ` `

        _ = if (self.initialized) self.deinit();

        return void{};
    }
};

test "StructTemplate.onStack()" {
    std.debug.print(" \n", .{}); // newline for better output

    var instance = StructTemplate.onStack();
    defer instance.destroy();

    try std.testing.expect(instance.initialized == false);

    _ = try instance.init(null, null);
    defer instance.deinit();

    try std.testing.expect(instance.initialized == true);

    // TODO - how to test that it's actually on the stack?
}

test "StructTemplate.onHeap()" {
    std.debug.print(" \n", .{}); // newline for better output

    const allocator = &std.heap.page_allocator;
    var instance = try StructTemplate.onHeap(allocator);
    defer allocator.destroy(instance);

    try std.testing.expect(instance.initialized == false);

    _ = try instance.init(null, null);
    defer instance.deinit();

    try std.testing.expect(instance.initialized == true);

    // TODO - how to test that it's actually on the heap?
}
