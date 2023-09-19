const std = @import("std");

// // see https://github.com/ziglang/zig/issues/841#issuecomment-1175087234
// fn getEnvVar(allocator: *const Allocator, key: []const u8, fallback: ?[]const u8) ![]const u8 {
//     const _fallback: []const u8 = fallback orelse " ";

//     const env_map = allocator.create(std.process.EnvMap) catch |err| {
//         std.debug.print("Failed to allocate EnvMap, error: {any}\n", .{err});
//         return err;
//     };
//     env_map.* = std.process.getEnvMap(allocator.*) catch |err| {
//         std.debug.print("Failed to getEnvMap(), error: {any}\n", .{err});
//         return err;
//     };
//     defer env_map.deinit();

//     const val = env_map.get(key);

//     // TODO: remove print when done debugging
//     std.debug.print("{s}={any} (fallback={any})\n", .{ key, val, fallback });

//     return val orelse _fallback;
// }

// var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
// defer arena.deinit();

// var allocator = arena.allocator();

// const vcpkg_path = getEnvVar(&allocator, "VCPKG_PATH", "/c/Tools/vcpkg") catch |err| {
//     std.debug.print("Failed to getEnvVar(), error: {?}\n", .{err});
//     return err;
// };
// const glfw_include_path: []const u8 = heapConcatStrings(&allocator, vcpkg_path, "/packages/glfw3_x86-windows/include") catch |err| {
//     std.debug.print("Failed to heapConcatStrings() for include_path, error: {?}\n", .{err});
//     return err;
// };
// const glfw_lib_path: []const u8 = heapConcatStrings(&allocator, vcpkg_path, "/packages/glfw3_x86-windows/lib") catch |err| {
//     std.debug.print("Failed to heapConcatStrings() for lib_path, error: {?}\n", .{err});
//     return err;
// };

// allocator.free(vcpkg_path);
