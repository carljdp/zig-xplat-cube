// generics
const std = @import("std");

// 3rd party
const zm = @import("zmath");

const c = @import("c.zig");
const gl = @import("cImportRemap.zig").gl;

const OCDP2 = @import("OCDP2.zig").OCDP2;
const ShaderUtils = @import("OCDP2.zig").ShaderUtils;

/// Bind GLFW from C imports to a zig struct with native types
/// ```zig
/// const glfw = GLFW(c);
/// ```
pub fn glfwRemap(comptime cImports: anytype) type {
    // should throw error if any of these are missing
    // const _c = blk: {
    //     _ = cImports.glfwInit;
    //     _ = cImports.glfwTerminate;
    //     _ = cImports.glfwCreateWindow;
    //     _ = cImports.glfwDestroyWindow;
    //     _ = cImports.glfwSetWindowShouldClose;
    //     break :blk cImports;
    // };

    return struct {
        const self = @This();
        const c = cImports;

        pub const Int = c_int;

        pub const False: self.Int = self.c.GLFW_FALSE;
        pub const True: self.Int = self.c.GLFW_TRUE;

        pub const CONTEXT_VERSION_MAJOR: self.Int = self.c.GLFW_CONTEXT_VERSION_MAJOR;
        pub const CONTEXT_VERSION_MINOR: self.Int = self.c.GLFW_CONTEXT_VERSION_MINOR;
        pub const KEY_ESCAPE: self.Int = self.c.GLFW_KEY_ESCAPE;
        pub const OPENGL_CORE_PROFILE: self.Int = self.c.GLFW_OPENGL_CORE_PROFILE;
        pub const OPENGL_DEBUG_CONTEXT: self.Int = self.c.GLFW_OPENGL_DEBUG_CONTEXT;
        pub const OPENGL_FORWARD_COMPAT: self.Int = self.c.GLFW_OPENGL_FORWARD_COMPAT;
        pub const OPENGL_PROFILE: self.Int = self.c.GLFW_OPENGL_PROFILE;
        pub const PRESS: self.Int = self.c.GLFW_PRESS;
        pub const RESIZABLE: self.Int = self.c.GLFW_RESIZABLE;
        pub const SAMPLES: self.Int = self.c.GLFW_SAMPLES;

        pub const Window = *self.c.GLFWwindow;

        /// Straight passthrough ref to glfwGetProcAddress
        pub const getProcAddress = self.c.glfwGetProcAddress;

        /// non-optional variant of GLFWkeyfun
        const KeyCallbackFn = *const fn (window: ?*self.c.GLFWwindow, key: self.Int, scancode: self.Int, action: self.Int, mods: self.Int) callconv(.C) void;
        // non-optional variant of GLFWerrorfun
        const ErrorCallbackFn = *const fn (errorCode: self.Int, description: [*c]const u8) callconv(.C) void;
        /// non-optional variant of GLFWglproc
        const GlProc = *const fn () callconv(.C) void;

        /// glfwInit(), error on failure
        pub fn init() !void {
            if (self.c.glfwInit() == self.False) return error.GLFW_Init_Failed;
        }

        /// glfwTerminate()
        pub fn terminate() void {
            self.c.glfwTerminate();
        }

        /// glfwWindowHint()
        pub fn windowHint(hint: self.Int, value: self.Int) void {
            self.c.glfwWindowHint(hint, value);
        }

        /// Create and return handle to window, or error on failure
        pub fn createWindow(width: self.Int, height: self.Int, title: [*c]const u8, monitor: ?*self.c.GLFWmonitor, share: ?*self.c.GLFWwindow) !*self.c.GLFWwindow {
            return if (self.c.glfwCreateWindow(width, height, title, monitor, share)) |result| result else error.GLFW_CreateWindow_Failed;
        }

        /// glfwDestroyWindow()
        pub fn destroyWindow(glfwWindow: self.Window) void {
            self.c.glfwDestroyWindow(glfwWindow);
        }

        /// glfwSetWindowShouldClose()
        pub fn setWindowShouldClose(glfwWindow: self.Window, shouldClose: bool) void {
            self.c.glfwSetWindowShouldClose(glfwWindow, if (shouldClose) self.True else self.False);
        }

        /// glfwMakeContextCurrent()
        pub fn makeContextCurrent(glfwWindow: self.Window) void {
            self.c.glfwMakeContextCurrent(glfwWindow);
        }

        /// glfwSwapInterval()
        pub fn swapInterval(interval: self.Int) void {
            self.c.glfwSwapInterval(interval);
        }

        /// glfwSetKeyCallback()
        pub fn setKeyCallback(glfwWindow: self.Window, callback: self.KeyCallbackFn) void {
            // The previously set callback, or NULL if no callback was set or the library had not been initialized.
            const previous = self.c.glfwSetKeyCallback(glfwWindow, callback);
            _ = previous;
        }

        /// glfwSetErrorCallback()
        pub fn setErrorCallback(callback: self.ErrorCallbackFn) void {
            // he previously set callback, or NULL if no callback was set.
            const previous = self.c.glfwSetErrorCallback(callback);
            _ = previous;
        }

        /// glfwSwapBuffers()
        pub fn swapBuffers(glfwWindow: self.Window) void {
            self.c.glfwSwapBuffers(glfwWindow);
        }

        /// glfwPollEvents()
        pub fn pollEvents() void {
            self.c.glfwPollEvents();
        }

        pub const defaultFn = struct {
            /// Default error callback
            pub fn errorCallback(err: self.Int, description: [*c]const u8) callconv(.C) void {
                std.debug.panic("[GLFW] Error '{d}' - {s}\n", .{ err, description });
            }
            /// Default key callback
            pub fn keyCallback(glfwWindow: ?*self.c.GLFWwindow, key: self.Int, scancode: self.Int, action: self.Int, mods: self.Int) callconv(.C) void {
                _ = scancode;
                _ = mods;

                if (key == self.KEY_ESCAPE and action == self.PRESS) {
                    self.c.glfwSetWindowShouldClose(glfwWindow, self.True);
                }
            }
        };
    };
}

//=============================================================================
pub fn main2(alloc: ?*const std.mem.Allocator) !void {
    const allocator = alloc;

    //- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    const glfw = glfwRemap(c);

    glfw.setErrorCallback(glfw.defaultFn.errorCallback);

    try glfw.init();
    defer glfw.terminate();

    std.debug.print("[GLFW] ✅ Initialized\n", .{});

    //- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    // ### OPENGL VERSION ###
    // OpenGL has been deprecated on Apple devices since iOS 12 and macOS 10.14
    // in favor of Metal. The latest version of OpenGL supported is 4.1 (2011)

    glfw.windowHint(glfw.SAMPLES, 4);
    glfw.windowHint(glfw.CONTEXT_VERSION_MAJOR, 4);
    glfw.windowHint(glfw.CONTEXT_VERSION_MINOR, 1);

    glfw.windowHint(glfw.OPENGL_PROFILE, glfw.OPENGL_CORE_PROFILE);
    glfw.windowHint(glfw.OPENGL_FORWARD_COMPAT, glfw.True);
    glfw.windowHint(glfw.RESIZABLE, glfw.False);
    // glfw.windowHint(glfw.OPENGL_DEBUG_CONTEXT, glfw.TRUE);

    const windowWidth: c_int = 640;
    const windowHeight: c_int = 480;
    const windowTitle: [*c]const u8 = "zig-xplat-cube";

    const window = try glfw.createWindow(windowWidth, windowHeight, windowTitle, null, null);
    defer glfw.destroyWindow(window);

    std.debug.print("[GLFW] ✅ Window created\n", .{});

    //- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    // Set up key (as-in 'key-press') callback
    glfw.setKeyCallback(window, glfw.defaultFn.keyCallback);

    // Make the context current
    glfw.makeContextCurrent(window);

    //- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    // Load OpenGL functions via GLAD
    if (c.gladLoadGL(@as(c.GLADloadfunc, @ptrCast(&glfw.getProcAddress))) == 0) return error.GLAD_Init_Failed;
    std.debug.print("[GLAD] ✅ Initialized\n", .{});

    //- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    // get version info
    const renderer = gl.getString(gl.RENDERER); // get renderer string
    const version = gl.getString(gl.VERSION); // version as a string
    std.debug.print("[_GL_] Rederer: {s}\n", .{renderer});
    std.debug.print("[_GL_] Version: {s}\n", .{version});

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
    try ocdp2.render(window);

    // cleanup happens in defer'ed deinit()
    return void{};
}

//=============================================================================
