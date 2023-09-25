const std = @import("std");
const c = @import("c.zig");
const TT = @import("TT.zig").TT;
const XT = @import("TT.zig").ExplicitTypes;

const expect = std.testing.expect;
const print = std.debug.print;
const panic = std.debug.panic;

// ChatGPT 'plan' (imported)
const ShaderUtils = @import("OCDP.zig").ShaderUtils;
const GL = @import("cImportRemap.zig").GL;
const _OCDP_ = @import("OCDP.zig");
const OCDP2 = @import("OCDP2.zig").OCDP2;
const OCDP = _OCDP_.OCDP;
const ShaderProgramId = _OCDP_.MyGl.ProgramId;
const BasicShape = _OCDP_.BasicShape;
var cube: BasicShape = _OCDP_.cube;
var triangle: BasicShape = _OCDP_.triangle;

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
    c.glfwWindowHint(c.GLFW_OPENGL_FORWARD_COMPAT, GL.TRUE);
    c.glfwWindowHint(c.GLFW_RESIZABLE, GL.FALSE);
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
    const renderer = GL.getString(GL.RENDERER); // get renderer string
    const version = GL.getString(GL.VERSION); // version as a string
    std.debug.print("[_GL_] Rederer: {s}\n", .{renderer});
    std.debug.print("[_GL_] Version: {s}\n", .{version});

    c.glfwSwapInterval(1);

    var ocdp2 = OCDP2.onStack(null);
    try ocdp2.init();
    defer ocdp2.deinit();

    try ocdp2.setup();

    while (c.glfwWindowShouldClose(window) == GL.FALSE) {
        // c.glfwGetFramebufferSize(window, @constCast(&windowWidth), @constCast(&windowHeight));
        // var ratio = @as(c.float_t, @floatFromInt(windowWidth)) / @as(c.float_t, @floatFromInt(windowHeight));
        // _ = ratio;
        GL.viewport(0, 0, windowWidth, windowHeight);

        GL.clearColor(0.0, 0.0, 0.4, 0.0);
        GL.clear(GL.COLOR_BUFFER_BIT);

        GL.useProgram(ocdp2.glObjects.program.?);
        GL.bindVertexArray(ocdp2.glObjects.vao.?);
        // GL.drawElements(GL.TRIANGLES, 6, c.GL_UNSIGNED_INT, null);
        GL.drawElements(GL.TRIANGLES, 3, c.GL_UNSIGNED_INT, null);

        c.glfwSwapBuffers(window);
        c.glfwPollEvents();
    }
    //- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    // Cleanup
    GL.deleteBuffers(1, &ocdp2.glObjects.vbo.?);
    GL.deleteVertexArrays(1, &ocdp2.glObjects.vao.?);
    GL.deleteProgram(ocdp2.glObjects.program.?);

    try ShaderUtils.assert.noGlError("cleanup");

    // Clean up glfw already handled via defer

    //- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    return void{};
}

//=============================================================================

// most of glfw's functions use a callback for error handling
fn errorCallback(err: c_int, description: [*c]const u8) callconv(.C) void {
    _ = err;
    _ = c.printf("Error: %s\n", description);

    std.debug.panic("Error: {*}\n", .{description});
    unreachable;
}

//- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

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

//- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
