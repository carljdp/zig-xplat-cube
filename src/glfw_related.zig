// generics
const std = @import("std");

// 3rd party
const zm = @import("zmath");

const OCDP2 = @import("OCDP2.zig").OCDP2;
const ShaderUtils = @import("OCDP2.zig").ShaderUtils;

const gl = @import("c/OpenGL.zig").remapped();
const glfw = @import("c/GLFW.zig").remapped();
const glad = @import("c/GLAD.zig").remapped();

//=============================================================================
pub fn main2(alloc: ?*const std.mem.Allocator) !void {
    const allocator = alloc;

    //- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    glfw.setErrorCallback(glfw.defaultFn.errorCallback);

    try glfw.init();
    defer glfw.terminate();

    std.debug.print("[GLFW] ✅ Initialized\n", .{});

    //- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    // ### OPENGL VERSION ###
    // OpenGL has been deprecated on Apple devices since iOS 12 and macOS 10.14
    // in favor of Metal. The latest version of OpenGL supported is 4.1 (2011)

    glfw.windowHint(glfw.SAMPLES, 4);
    glfw.windowHint(glfw.Context.Version.Major, 4);
    glfw.windowHint(glfw.Context.Version.Minor, 1);

    glfw.windowHint(glfw.OpenGL.Profile, glfw.OpenGL.Core.Profile);
    glfw.windowHint(glfw.OpenGL.Forward.Compat, glfw.True);
    glfw.windowHint(glfw.RESIZABLE, glfw.False);
    // glfw.windowHint(glfw.OpenGL.Debug.Comtext, glfw.True);

    const windowWidth: glfw.Int = 640;
    const windowHeight: glfw.Int = 480;
    const windowTitle: glfw.cString = "zig-xplat-cube";

    const windowId = try glfw.createWindow(windowWidth, windowHeight, windowTitle, null, null);
    defer glfw.destroyWindow(windowId);

    std.debug.print("[GLFW] ✅ Window created\n", .{});

    //- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    // Set up key (as-in 'key-press') callback
    glfw.setKeyCallback(windowId, glfw.defaultFn.keyCallback);

    // Make the context current
    glfw.makeContextCurrent(windowId);

    //- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    // Load OpenGL functions via GLAD
    const version = glad.loadGl(@as(glad.LoadFunc, @ptrCast(&glfw.getProcAddress)));
    if (version == 0) return error.GLAD_Init_Failed;
    std.debug.print("[GLAD] ✅ Initialized\n", .{});

    //- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    // get version info
    const glRenderer = gl.getString(gl.RENDERER); // get renderer string
    const glVersion = gl.getString(gl.VERSION); // version as a string
    std.debug.print("[OPGL] Renderer: {s}\n", .{glRenderer});
    std.debug.print("[OPGL] Version:  {s}\n", .{glVersion});

    glfw.swapInterval(1);

    gl.clearColor(0.0, 0.0, 0.4, 0.0);

    gl.enable(gl.DEPTH_TEST);
    gl.depthFunc(gl.LESS);

    gl.enable(gl.CULL_FACE);

    var ocdp2 = OCDP2.onStack(allocator);
    try ocdp2.init();
    defer ocdp2.deinit();

    // setup before render loop
    try ocdp2.setup();

    // render loop

    // ## TODO ##
    // - ocdp2.render is reaching to external glfw (which it imports seperately)
    // - where should window live?
    try ocdp2.render(windowId);

    // cleanup happens in defer'ed deinit()
    return void{};
}

//=============================================================================
