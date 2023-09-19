const std = @import("std");

// project settings / manifest
const Project = @import("project.zig").Project;

// debug helpers
const is_test = @import("builtin").is_test;
const Name = @import("src/debug_helpers.zig").DotNotation;
const CFS = @import("src/build_helpers.zig").CFS;

//
//=============================================================================
//

/// `build.zig` entry point
pub fn build(b: *std.Build) !void {
    // Log out this function name at entry and exit` ` ` ` ` `
    const memo = comptime Name.ofFunction(build).full();
    if (!is_test) std.debug.print("[{s}] ..\n", .{memo});
    defer if (!is_test) std.debug.print("[{s}] done.\n", .{memo});
    // ` ` ` ` ` ` ` ` ` ` ` ` ` ` ` ` ` ` ` ` ` ` ` ` ` ` ` `

    var test_buildHelpers = false;
    if (b.args) |_args| {
        for (_args) |_arg| {
            if (std.mem.startsWith(u8, _arg, "--test=build_helpers")) {
                // const value = _arg["-DmyFlag=".len..];
                // _ = value;
                // // Use 'value'
                test_buildHelpers = true;
                break;
            }
        }
    }

    // switch used, for when you add more arg functionality above
    return switch (test_buildHelpers) {
        true => try go.test_build_helpers(b),
        else => try go.build_project(b),
    };
}

//-----------------------------------------------------------------------------

// Optimize options
const optimizeOptions = struct {
    const default = .{
        // .default_target = .{ .os_tag = .windows, .cpu_arch = .x86_64, .abi = .msvc },
        // // ... other options
    };
    const debug = .{
        .preferred_optimize_mode = std.builtin.OptimizeMode.Debug,
    };
};

// target options
// const target = b.standardTargetOptions(.{
//     .default_target = .{ .os_tag = .windows, .cpu_arch = .x86_64, .abi = .msvc },
//     // ... other options
// });

//
//=============================================================================
//

const go = struct {
    /// builds the project
    fn build_project(b: *std.Build) !void {
        // Log out this function name at entry and exit` ` ` ` ` `
        const memo = comptime Name.ofFunction(build_project).full();
        if (!is_test) std.debug.print("[{s}] ..\n", .{memo});
        defer if (!is_test) std.debug.print("[{s}] done.\n", .{memo});
        // ` ` ` ` ` ` ` ` ` ` ` ` ` ` ` ` ` ` ` ` ` ` ` ` ` ` ` `

        const _targetOptions = b.standardTargetOptions(.{});
        const _optimizeOptions = b.standardOptimizeOption(optimizeOptions.default);
        _ = _optimizeOptions;
        const _optimizeOptionsDebug = b.standardOptimizeOption(optimizeOptions.debug);

        //-----------------------------------------------------------------------------
        // [Compile] executable for install

        const compileExecutable = b.addExecutable(.{
            .name = Project.name,
            .root_source_file = .{ .path = Project.DirectoryStructure.Source.root ++ "/" ++ Project.FileNames.mainEntrypoint },
            .target = _targetOptions,
            .optimize = _optimizeOptionsDebug,
            .link_libc = true,
            .main_pkg_path = .{ .cwd_relative = b.pathFromRoot(".") }, // saw this in bun repo, not sure if it's helpful ?
        });
        Project.addExternalDependenciesTo(&compileExecutable);

        //-----------------------------------------------------------------------------
        // [PUB STEP] "install", triggered by `zig build [install]`

        const commandTo_installExecutable = b.addInstallArtifact(compileExecutable, .{});

        const publicStep_install = b.getInstallStep();
        publicStep_install.dependOn(&commandTo_installExecutable.step);

        //-----------------------------------------------------------------------------
        // [cmd] run executable (with optional args) compiled for install

        const commandTo_runExecutable = b.addRunArtifact(compileExecutable);
        if (b.args) |args| commandTo_runExecutable.addArgs(args);
        commandTo_runExecutable.step.dependOn(&commandTo_installExecutable.step);

        //-----------------------------------------------------------------------------
        // [PUB STEP] "run", triggered by `zig build run`

        const publicStep_run = b.step("run", "Build & Run");
        publicStep_run.dependOn(&commandTo_runExecutable.step);

        //-----------------------------------------------------------------------------
        // [Compile] executable for tests

        const compileTestable = b.addTest(.{
            .root_source_file = .{ .path = Project.DirectoryStructure.Source.root ++ "/" ++ Project.FileNames.mainEntrypoint },
            .target = _targetOptions,
            .optimize = _optimizeOptionsDebug,
            .link_libc = true,
        });
        Project.addExternalDependenciesTo(&compileTestable);

        //-----------------------------------------------------------------------------
        // [cmd] run executable compiled for tests

        const commandTo_runTastable = b.addRunArtifact(compileTestable);

        //-----------------------------------------------------------------------------
        // [PUB STEP] "test", triggered by `zig build test`

        const publicStep_test = b.step("test", "Build & Test");
        publicStep_test.dependOn(&commandTo_runTastable.step);

        //-----------------------------------------------------------------------------
        // When you run `zig build -l` also print this:

        _ = b.step("\nOther:", "");
        _ = b.step("-- --test=build_helpers", "Test build_helpers.zig");
        const publicStep__ = b.step("_", "");
        publicStep__.dependOn(&commandTo_runExecutable.step);
        _ = b.step(" \\_(ツ)_/¯", "");

        // //-----------------------------------------------------------------------------
        // // [PUB STEP] "watchTxt", triggered by `zig build watchTxt`
        // //  - invalidate the step when the text file changes

        // // Create a custom step to watch the text file
        // const watchTxtStep = B.step("watchTxt", "Watch text file for changes");
        // watchTxtStep.addFile("somefile.txt"); // NOT A FUNCTION
        // watchTxtStep.dependOn(&compileExecutable.step);
    }

    /// tests `build_helpers` (which themselves depend on a `*std.Build`)
    fn test_build_helpers(B: *std.Build) !void {
        // Log out this function name at entry and exit` ` ` ` ` `
        const memo = comptime Name.ofFunction(test_build_helpers).full();
        if (!is_test) std.debug.print("[{s}] ..\n", .{memo});
        defer if (!is_test) std.debug.print("[{s}] done.\n", .{memo});
        // ` ` ` ` ` ` ` ` ` ` ` ` ` ` ` ` ` ` ` ` ` ` ` ` ` ` ` `

        var cfs = CFS.onStack();
        _ = try cfs.init(&B.allocator);
        defer cfs.deinit();

        const fileName = "generated";
        try cfs.readFileToInternalBuffer(Project.DirectoryStructure.Comptime.source ++ "/" ++ fileName ++ ".txt", null);

        try cfs.writeFile(
            Project.DirectoryStructure.Comptime.cache ++ "/" ++ fileName ++ ".zig",
            try cfs.getBufferAsIs(),
        );
    }
};
