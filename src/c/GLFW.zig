// generics
const std = @import("std");

/// Wrapper for GLFW with remapped types and functions
pub fn remapped() type {
    return struct {
        const self = @This();
        const c = struct {
            usingnamespace @import("imports.zig");
        };

        // TYPES (partial rename)
        pub const Void = void;
        pub const Int = c.GLint; // c_int
        pub const Char = c.GLchar; // u8
        pub const Window = c.GLFWwindow; // opaque
        // TYPES (custom)
        pub const cString = [*c]const Char;

        // CONSTANTS (built-ins)
        pub const Null = null;
        pub const False: Int = c.GLFW_FALSE;
        pub const True: Int = c.GLFW_TRUE;

        pub const Context = struct {
            pub const Version = struct {
                pub const Major: Int = c.GLFW_CONTEXT_VERSION_MAJOR;
                pub const Minor: Int = c.GLFW_CONTEXT_VERSION_MINOR;
            };
        };

        pub const OpenGL = struct {
            pub const Core = struct {
                pub const Profile: Int = c.GLFW_OPENGL_CORE_PROFILE;
            };
            pub const Debug = struct {
                pub const Context: Int = c.GLFW_OPENGL_DEBUG_CONTEXT;
            };
            pub const Forward = struct {
                pub const Compat: Int = c.GLFW_OPENGL_FORWARD_COMPAT;
            };
            pub const Profile: Int = c.GLFW_OPENGL_PROFILE;
        };

        // TODO restructure?
        pub const KEY_ESCAPE: Int = c.GLFW_KEY_ESCAPE;
        pub const PRESS: Int = c.GLFW_PRESS;
        pub const RESIZABLE: Int = c.GLFW_RESIZABLE;
        pub const SAMPLES: Int = c.GLFW_SAMPLES;

        /// Straight passthrough ref to glfwGetProcAddress
        pub const getProcAddress = c.glfwGetProcAddress;
        /// non-optional variant of GLFWkeyfun
        pub const KeyCallbackFn = *const fn (window: ?*c.GLFWwindow, key: Int, scancode: Int, action: Int, mods: Int) callconv(.C) void;
        // non-optional variant of GLFWerrorfun
        pub const ErrorCallbackFn = *const fn (errorCode: Int, description: cString) callconv(.C) void;
        /// non-optional variant of GLFWglproc
        pub const GlProc = *const fn () callconv(.C) void;

        /// glfwInit(), error on failure
        pub fn init() !void {
            const success = c.glfwInit() == True;
            return if (success) void{} else error.GLFW_Init_Failed;
        }

        /// glfwTerminate()
        pub fn terminate() void {
            c.glfwTerminate();
            return void{};
        }

        /// glfwWindowHint()
        pub fn windowHint(hint: Int, value: Int) void {
            c.glfwWindowHint(hint, value);
        }

        /// Create and return handle to window, or error on failure
        pub fn createWindow(width: Int, height: Int, title: [*c]const u8, monitor: ?*c.GLFWmonitor, share: ?*c.GLFWwindow) !*Window {
            return if (c.glfwCreateWindow(width, height, title, monitor, share)) |result| result else error.GLFW_CreateWindow_Failed;
        }

        /// glfwDestroyWindow()
        pub fn destroyWindow(glfwWindow: *Window) void {
            c.glfwDestroyWindow(glfwWindow);
            return void{};
        }

        /// glfwSetWindowShouldClose()
        pub fn setWindowShouldClose(glfwWindow: *Window, shouldClose: bool) void {
            c.glfwSetWindowShouldClose(glfwWindow, if (shouldClose) True else False);
            return void{};
        }

        /// glfwMakeContextCurrent()
        pub fn makeContextCurrent(glfwWindow: *Window) void {
            c.glfwMakeContextCurrent(glfwWindow);
            return void{};
        }

        /// glfwSwapInterval()
        pub fn swapInterval(interval: Int) void {
            c.glfwSwapInterval(interval);
            return void{};
        }

        /// glfwSetKeyCallback()
        pub fn setKeyCallback(glfwWindow: *Window, callback: KeyCallbackFn) void {
            // The previously set callback, or NULL if no callback was set or the library had not been initialized.
            _ = c.glfwSetKeyCallback(glfwWindow, callback);
            return void{};
        }

        /// glfwSetErrorCallback()
        pub fn setErrorCallback(callback: ErrorCallbackFn) void {
            // he previously set callback, or NULL if no callback was set.
            _ = c.glfwSetErrorCallback(callback);
            return void{};
        }

        /// glfwSwapBuffers()
        pub fn swapBuffers(glfwWindow: *Window) void {
            c.glfwSwapBuffers(glfwWindow);
            return void{};
        }

        /// glfwPollEvents()
        pub fn pollEvents() void {
            c.glfwPollEvents();
            return void{};
        }

        /// returns the value of the close flag of the specified window.
        /// #### Parameters
        /// - [in] `window` The window to query.
        /// - Possible errors include GLFW_NOT_INITIALIZED.
        /// - Also see [docs](https://www.glfw.org/docs/latest/group__window.html#ga24e02fbfefbb81fc45320989f8140ab5) / [guide](https://www.glfw.org/docs/latest/window_guide.html#window_close)
        pub fn windowShouldClose(glfwWindow: *Window) bool {

            // TODO: should this return an error?

            return c.glfwWindowShouldClose(glfwWindow) == True;
        }

        pub const defaultFn = struct {
            /// Default error callback
            pub fn errorCallback(err: Int, description: [*c]const Char) callconv(.C) void {
                std.debug.panic("[GLFW] Error '{d}' - {s}\n", .{ err, description });
            }
            /// Default key callback
            pub fn keyCallback(glfwWindow: ?*Window, key: Int, scancode: Int, action: Int, mods: Int) callconv(.C) void {
                _ = scancode;
                _ = mods;

                if (key == KEY_ESCAPE and action == PRESS) {
                    c.glfwSetWindowShouldClose(glfwWindow, True);
                }
            }
        };
    };
}
