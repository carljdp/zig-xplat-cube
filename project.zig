//! Project settings / constants / configuration / manifest / etc.
//! .. defaults defined explicitly - no magic here!

const std = @import("std");

/// (explicit) Project constants
pub const Project = struct {
    pub const name = "zig-xplat-cube";
    pub const FileNames = struct {
        pub const mainEntrypoint = "main.zig";
        // pub const buildEntrypoint = "build.zig"; // not used
    };

    pub const cwd: []const u8 = bkl: {
        var _buffer: [std.fs.MAX_PATH_BYTES]u8 = undefined;
        std.fs.cwd().realpath(".", _buffer[0..]);
        break :bkl std.fs.cwd().realpath(".", _buffer[0..]) orelse "";
    };

    /// Project's directory structure
    pub const DirectoryStructure = struct {
        // pub const root = std.fs.cwd(); // not used

        /// Project's source directory structure
        pub const Source = struct {
            pub const root = "src";
        };

        /// Project module `Comptime`'s directory structure
        pub const Comptime = struct {
            // pub const root = "comptime"; // not used
            pub const source = "comptime/src";
            pub const cache = "comptime/.cache";
        };
    };

    pub const addExternalDependenciesTo = _addExternalDependenciesTo;
};

// TODO: still contains hardcoded paths
/// Grouping of external dependencies.
fn _addExternalDependenciesTo(compileTarget: *const *@import("std").Build.Step.Compile) void {
    const target = compileTarget.*; // to get a '*std.Build.Step.Compile'

    // TODO: Does the order of the below statements matter?

    // Use the C standard library, beacuse we're using C functions
    target.linkLibC();
    // exe.linkSystemLibrary("c"); // does it matter which of these we use?

    // System libraries - Windows - not sure if these are needed
    target.linkSystemLibrary("User32");
    target.linkSystemLibrary("Gdi32");
    target.linkSystemLibrary("shell32");
    target.linkSystemLibrary("OpenGL32");

    // Glad2, for loading OpenGL functions
    target.addIncludePath(.{ .cwd_relative = "D:/__WIN10/Users/carljdp/Downloads/_SOFTWARE/dev/GLFW/glad2-gl4.1-core/include" });
    target.addCSourceFile(.{ .file = .{ .cwd_relative = "D:/__WIN10/Users/carljdp/Downloads/_SOFTWARE/dev/GLFW/glad2-gl4.1-core/src/gl.c" }, .flags = &[_][]const u8{} });
    // unit_tests.linkSystemLibrary("gl"); // why is this not needed, but glfw3 is?

    // GLFW3, for creating a window and OpenGL context
    // glfw3 was built locally with mingw64
    target.addIncludePath(.{ .cwd_relative = "C:/Program Files (x86)/GLFW/include" });
    target.addLibraryPath(.{ .cwd_relative = "C:/Program Files (x86)/GLFW/lib" });
    target.linkSystemLibrary("glfw3");

    // Not used currently

    // exe.addIncludePath("C:/Program Files (x86)/Microsoft Visual Studio/2022/BuildTools/VC/Tools/MSVC/14.37.32822/include");
    // exe.addLibraryPath("C:/Program Files (x86)/Microsoft Visual Studio/2022/BuildTools/VC/Tools/MSVC/14.37.32822/lib");
    // exe.linkSystemLibrary("msvcrtd");

    // exe.addIncludePath("C:/Tools/vcpkg/packages/libepoxy_x86-windows/include");
    // exe.addLibraryPath("C:/Tools/vcpkg/packages/libepoxy_x86-windows/lib");
    // exe.linkSystemLibrary("epoxy");

    return void{};
}
