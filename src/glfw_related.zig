const std = @import("std");
const c = @import("c.zig");
const TT = @import("TT.zig").TT;
const XT = @import("TT.zig").ExplicitTypes;

const expect = std.testing.expect;
const print = std.debug.print;
const panic = std.debug.panic;

/// ChatGPT 'plan' (imported)
const _OCDP_ = @import("OCDP.zig");
const OCDP2 = @import("OCDP2.zig").OCDP2;
const OCDP = _OCDP_.OCDP;
const ShaderProgramId = _OCDP_.Gl.ProgramId;
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
    c.glfwWindowHint(c.GLFW_OPENGL_FORWARD_COMPAT, c.GL_TRUE);
    c.glfwWindowHint(c.GLFW_OPENGL_PROFILE, c.GLFW_OPENGL_CORE_PROFILE);
    c.glfwWindowHint(c.GLFW_OPENGL_DEBUG_CONTEXT, c.GL_TRUE);

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

    //- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    // Make the context current
    c.glfwMakeContextCurrent(window);

    //- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    // Load OpenGL functions via GLAD
    if (c.gladLoadGL(@as(c.GLADloadfunc, @ptrCast(&c.glfwGetProcAddress))) == 0) return error.GLAD_Init_Failed;
    std.debug.print("[GLAD] ✅ Initialized\n", .{});

    //- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    // get version info
    const renderer = c.glGetString(c.GL_RENDERER); // get renderer string
    const version = c.glGetString(c.GL_VERSION); // version as a string
    std.debug.print("[_GL_] Rederer: {s}\n", .{renderer});
    std.debug.print("[_GL_] Version: {s}\n", .{version});

    // tell GL to only draw onto a pixel if the shape is closer to the viewer
    c.glEnable(c.GL_DEPTH_TEST); // enable depth-testing
    c.glDepthFunc(c.GL_LESS); // depth-testing interprets a smaller value as "closer"

    //- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    c.glfwSwapInterval(1);

    //- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    //-----------------------------------------------------------------------------
    // var testShape = triangle;

    // // compile shaders, link program
    // const shaderProgramId: ShaderProgramId = try OCDP._1_shaderCompilation();
    // std.debug.print("[OCDP] ProgramId: {d}\n", .{shaderProgramId});

    // // set up uniforms and attributes
    // const vertexArrayObjectRef = try OCDP._2_UniformsAndAttributesSetup(shaderProgramId, &testShape);

    // // set up buffers and vertex array object
    // try OCDP._3_BuffersAndVertexArraySetup();

    // // set up wireframe
    // try OCDP._4_CubeGeometrySetup_wireframe(vertexArrayObjectRef, &testShape);

    var ocdp2 = OCDP2.onStack(null);
    try ocdp2.init();
    defer ocdp2.deinit();

    try ocdp2.setup();
    try ocdp2.render();

    //-----------------------------------------------------------------------------
    // Main / render / draw loop

    // var width: c_int = undefined;
    // var height: c_int = undefined;
    // var ratio: c.float_t =undefined;

    while (c.glfwWindowShouldClose(window) == c.GL_FALSE) {
        // c.glfwGetFramebufferSize(windowRef, &width, &height);
        // ratio = @as(c.float_t, @floatFromInt(width)) / @as(c.float_t, @floatFromInt(height));

        // c.glfwSwapBuffers(window);
        // c.glfwPollEvents();

        // wipe the drawing surface clear
        c.glClear(c.GL_COLOR_BUFFER_BIT | c.GL_DEPTH_BUFFER_BIT);
        c.glUseProgram(ocdp2.glObjects.program.?);
        c.glBindVertexArray(ocdp2.glObjects.vao.?);
        // draw points 0-3 from the currently bound VAO with current in-use shader
        c.glDrawArrays(c.GL_TRIANGLES, 0, 3);
        // update other events like input handling
        c.glfwPollEvents();
        // put the stuff we've been drawing onto the display
        c.glfwSwapBuffers(window);
    }
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
