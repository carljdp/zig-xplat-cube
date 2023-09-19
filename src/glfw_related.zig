const std = @import("std");
const c = @import("c.zig");
const TT = @import("TT.zig").TT;
const XT = @import("TT.zig").ExplicitTypes;

const expect = std.testing.expect;
const print = std.debug.print;
const panic = std.debug.panic;

/// ChatGPT plan (imported)
const OCDP = @import("OCDP.zig").OCDP;

var window: ?*c.GLFWwindow = undefined;
// var all_shaders: AllShaders = undefined;
// var static_geometry: StaticGeometry = undefined;
// var font: Spritesheet = undefined;

// most of glfw's functions use a callback for error handling
fn errorCallback(err: c_int, description: [*c]const u8) callconv(.C) void {
    _ = err;
    _ = c.printf("Error: %s\n", description);

    panic("Error: {*}\n", .{description});
    // c.abort();
}

// GLFW key_callback
// supposed to have the form:
// GLFWkeyfun = ?*const fn (?*GLFWwindow, c_int, c_int, c_int, c_int) callconv(.C) void;
fn keyCallback(glfwWindow: ?*c.GLFWwindow, key: c_int, scancode: c_int, action: c_int, mods: c_int) callconv(.C) void {
    // _ = glfwWindow;
    // _ = key;
    _ = scancode;
    // _ = action;
    _ = mods;

    if (key == c.GLFW_KEY_ESCAPE and action == c.GLFW_PRESS) {
        c.glfwSetWindowShouldClose(glfwWindow, c.GLFW_TRUE);
    }
}

// GL assert no errors
// from: https://github.com/andrewrk/tetris/blob/73fad7bc42777637e1f67374d5cb4dfe62b27e0c/src/debug_gl.zig
fn assertNoGLError() callconv(.C) void {
    var err = c.glGetError();
    if (err != c.GL_NO_ERROR) {
        panic("GL error: {any}\n", .{err});
    }
}

//-----------------------------------------------------------------------------
pub fn main2() !u8 {

    // Set up error callback
    _ = c.glfwSetErrorCallback(errorCallback);

    // Initialize GLFW
    if (c.glfwInit() == c.GL_FALSE) {
        std.debug.print("[GLFW] ✘ Initialization failed\n", .{});
        return 1;
    }
    defer c.glfwTerminate();
    std.debug.print("[GLFW] ✅ Initialized\n", .{});

    // OpenGL has been deprecated on Apple devices since iOS 12 and macOS 10.14
    // in favor of Metal. The latest version of OpenGL supported is 4.1 (2011)

    c.glfwWindowHint(c.GLFW_CONTEXT_VERSION_MAJOR, 4);
    c.glfwWindowHint(c.GLFW_CONTEXT_VERSION_MINOR, 1);

    // Create window
    window = c.glfwCreateWindow(640, 480, "zig-xplat-cube", null, null);
    if (window == null) {
        std.debug.print("[GLFW] ✘ Window or OpenGL context creation failed\n", .{});
        return 1;
    }
    defer c.glfwDestroyWindow(window);
    std.debug.print("[GLFW] ✅ Window created\n", .{});

    // Set up key (as-in 'key-press') callback
    _ = c.glfwSetKeyCallback(window, keyCallback);

    // Make the context current
    c.glfwMakeContextCurrent(window);

    // Load OpenGL functions via GLAD
    if (c.gladLoadGL(@as(c.GLADloadfunc, @ptrCast(&c.glfwGetProcAddress))) == 0) {
        panic("[GLAD] ✘ Initialization failed\n", .{});
        return 1;
        // return error.GLADInitFailed;
    }
    std.debug.print("[GLAD] ✅ Initialized\n", .{});

    try OCDP._1_shaderCompilation();

    c.glfwSwapInterval(1);

    while (c.glfwWindowShouldClose(window) == c.GL_FALSE) {
        var width: c_int = undefined;
        var height: c_int = undefined;
        c.glfwGetFramebufferSize(window, &width, &height);
        var ratio: c.float_t = @as(c.float_t, @floatFromInt(width)) / @as(c.float_t, @floatFromInt(height));
        _ = ratio;

        c.glfwSwapBuffers(window);
        c.glfwPollEvents();

        assertNoGLError();
    }

    return 0;
}
