const std = @import("std");

// short hands | aliases
const debug = std.debug;
const testing = std.testing;
const builtin = std.builtin; // != @import("builtin")
const meta = std.meta;
const mem = std.mem;
const heap = std.heap;

// debug printing
const logInfo = debug.logInfo;
const print = debug.print;
// debug testing
const expect = testing.expect;
const MemEql = @import("std").mem.eql;
const MetaEql = @import("std").meta.eql;
const isTest = @import("builtin").is_test; // != std.builtin

// type introspection
const Type = builtin.Type;
const trait = meta.trait;

// memory
const Allocator = mem.Allocator;
const pageAllocator = heap.page_allocator;

// index | lookup | nav | search
// exclusively for dev-time navigation
const _std_builtin_ = @import("std").builtin;
const _std_meta____ = @import("std").meta;

// START | THIS | SELF | IMPLEMENTATION

// static only / anon constructor
pub const NI = @This();

pub fn new() NI {
    return NI{
        .instanceField = InstanceField{ .predicate = true },
    };
}
pub fn newWithOptions(options: anytype) NI {
    _ = options; //TODO
    return NI{
        .instanceField = InstanceField{ .predicate = true },
    };
}

// static member initializer
pub var alpha = NI{};

// optional instance field
instanceField: InstanceField = undefined, // becomes required if not initialized

//just a definition for above
const InstanceField = struct {
    predicate: bool = undefined,
};

// Class NI
// - static constructor anon:    NI{}
// - static constructor named:   NI.new()
// - static 'original' instance: NI.alpha
