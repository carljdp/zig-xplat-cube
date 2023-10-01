// generics
const std = @import("std");

const FailModeTag = enum {
    Panic,
    ReturnNull,
    ReturnError,
};

const ResourceModeTag = enum {
    CallerOwnFree,
    CallerInitDeinit,
};

const fnOpts = struct {
    allocator: ?*const std.mem.Allocator,
    failMode: FailModeTag,
    resourceMode: ResourceModeTag,
};
