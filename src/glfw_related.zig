// generics
const std = @import("std");

// 3rd party
const zm = @import("zmath");

const c = @import("c.zig");
const gl = @import("cImportRemap.zig").gl;

const OCDP2 = @import("OCDP2.zig").OCDP2;
const ShaderUtils = @import("OCDP2.zig").ShaderUtils;

//=============================================================================
pub fn main2() !void {

    //- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    // Set up error callback
    _ = c.glfwSetErrorCallback(errorCallback);

    // Initialize GLFW
    if (c.glfwInit() == c.GL_FALSE) return error.GLFW_Init_Failed;
    defer c.glfwTerminate();
    std.debug.print("[GLFW] ✅ Initialized\n", .{});

    //- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    // ### OPENGL VERSION ###
    // OpenGL has been deprecated on Apple devices since iOS 12 and macOS 10.14
    // in favor of Metal. The latest version of OpenGL supported is 4.1 (2011)

    c.glfwWindowHint(c.GLFW_SAMPLES, 4);
    c.glfwWindowHint(c.GLFW_CONTEXT_VERSION_MAJOR, 4);
    c.glfwWindowHint(c.GLFW_CONTEXT_VERSION_MINOR, 1);

    c.glfwWindowHint(c.GLFW_OPENGL_PROFILE, c.GLFW_OPENGL_CORE_PROFILE);
    c.glfwWindowHint(c.GLFW_OPENGL_FORWARD_COMPAT, gl.TRUE);
    c.glfwWindowHint(c.GLFW_RESIZABLE, gl.FALSE);
    // c.glfwWindowHint(c.GLFW_OPENGL_DEBUG_CONTEXT, c.GL_TRUE);

    const windowWidth: c_int = 640;
    const windowHeight: c_int = 480;
    const windowTitle: [*c]const u8 = "zig-xplat-cube";
    const window: ?*c.GLFWwindow = c.glfwCreateWindow(windowWidth, windowHeight, windowTitle, null, null);
    if (window == null) return error.GLFW_CreateWindow_Failed;
    defer c.glfwDestroyWindow(window);
    std.debug.print("[GLFW] ✅ Window created\n", .{});

    //- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    // Set up key (as-in 'key-press') callback
    _ = c.glfwSetKeyCallback(window, keyCallback);

    // Make the context current
    c.glfwMakeContextCurrent(window);

    //- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    // Load OpenGL functions via GLAD
    if (c.gladLoadGL(@as(c.GLADloadfunc, @ptrCast(&c.glfwGetProcAddress))) == 0) return error.GLAD_Init_Failed;
    std.debug.print("[GLAD] ✅ Initialized\n", .{});

    //- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    // get version info
    const renderer = gl.getString(gl.RENDERER); // get renderer string
    const version = gl.getString(gl.VERSION); // version as a string
    std.debug.print("[_GL_] Rederer: {s}\n", .{renderer});
    std.debug.print("[_GL_] Version: {s}\n", .{version});

    c.glfwSwapInterval(1);
    gl.clearColor(0.0, 0.0, 0.4, 0.0);
    gl.enable(gl.DEPTH_TEST);
    gl.depthFunc(gl.LESS);

    var ocdp2 = OCDP2.onStack(null);
    try ocdp2.init();
    defer ocdp2.deinit();

    // setup before render loop
    try ocdp2.setup();

    // render loop
    try ocdp2.render(window);

    // cleanup happens in defer'ed deinit()
    return void{};
}

//=============================================================================

fn errorCallback(err: c_int, description: [*c]const u8) callconv(.C) void {
    _ = err;
    _ = c.printf("Error: %s\n", description);

    std.debug.panic("Error: {*}\n", .{description});
    unreachable;
}

fn keyCallback(glfwWindow: ?*c.GLFWwindow, key: c_int, scancode: c_int, action: c_int, mods: c_int) callconv(.C) void {
    _ = scancode;
    _ = mods;

    if (key == c.GLFW_KEY_ESCAPE and action == c.GLFW_PRESS) {
        c.glfwSetWindowShouldClose(glfwWindow, c.GLFW_TRUE);
    }
}
