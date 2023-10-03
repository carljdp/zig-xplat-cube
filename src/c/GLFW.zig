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
        pub const KEY_UP: Int = c.GLFW_KEY_UP;
        pub const KEY_DOWN: Int = c.GLFW_KEY_DOWN;
        pub const KEY_LEFT: Int = c.GLFW_KEY_LEFT;
        pub const KEY_RIGHT: Int = c.GLFW_KEY_RIGHT;
        // pub const KEY_SPACE: Int = c.GLFW_KEY_SPACE;
        // pub const KEY_ENTER: Int = c.GLFW_KEY_ENTER;
        // pub const KEY_BACKSPACE: Int = c.GLFW_KEY_BACKSPACE;
        // pub const KEY_TAB: Int = c.GLFW_KEY_TAB;
        // pub const KEY_LEFT_SHIFT: Int = c.GLFW_KEY_LEFT_SHIFT;
        // pub const KEY_RIGHT_SHIFT: Int = c.GLFW_KEY_RIGHT_SHIFT;
        // pub const KEY_LEFT_CONTROL: Int = c.GLFW_KEY_LEFT_CONTROL;
        // pub const KEY_RIGHT_CONTROL: Int = c.GLFW_KEY_RIGHT_CONTROL;
        // pub const KEY_LEFT_ALT: Int = c.GLFW_KEY_LEFT_ALT;
        // pub const KEY_RIGHT_ALT: Int = c.GLFW_KEY_RIGHT_ALT;
        // pub const KEY_LEFT_SUPER: Int = c.GLFW_KEY_LEFT_SUPER;
        // pub const KEY_RIGHT_SUPER: Int = c.GLFW_KEY_RIGHT_SUPER;

        /// Straight passthrough ref to glfwGetProcAddress
        pub const getProcAddress = c.glfwGetProcAddress;
        /// non-optional variant of GLFWkeyfun
        pub const KeyCallbackFn = *const fn (window: ?*Window, key: Int, scancode: Int, action: Int, mods: Int) callconv(.C) void;
        // non-optional variant of GLFWerrorfun
        pub const ErrorCallbackFn = *const fn (errorCode: Int, description: cString) callconv(.C) void;
        /// non-optional variant of GLFWglproc
        pub const GlProc = *const fn () callconv(.C) void;
        /// non-optional variant of glfw scroll callback
        pub const ScrollCallbackFn = *const fn (window: ?*Window, xOffset: f64, yOffset: f64) callconv(.C) void;

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

        /// glfwSetScrollCallback()
        pub fn setScrollCallback(glfwWindow: *Window, callback: ScrollCallbackFn) void {
            // The previously set callback, or NULL if no callback was set or an error occurred.
            _ = c.glfwSetScrollCallback(glfwWindow, callback);
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

        /// glfwGetCursorPos()
        pub fn getCursorPos(glfwWindow: *Window, x: [*c]f64, y: [*c]f64) void {
            c.glfwGetCursorPos(glfwWindow, x, y);
            return void{};
        }

        /// glfwSetCursorPos()
        pub fn setCursorPos(glfwWindow: *Window, x: f64, y: f64) void {
            c.glfwSetCursorPos(glfwWindow, x, y);
            return void{};
        }

        /// glfwGetMouseWheel()
        pub fn getMouseWheel(glfwWindow: *Window) f64 {
            return c.glfwGetMouseWheel(glfwWindow);
        }

        /// glwfGetWindowSize()
        pub fn getWindowSize(glfwWindow: *Window, width: [*c]Int, height: [*c]Int) void {
            c.glfwGetWindowSize(glfwWindow, width, height);
            return void{};
        }

        /// glfwGetTime()
        pub fn getTime() f64 {
            return c.glfwGetTime();
        }

        /// glfwGetKey()
        pub fn getKey(window: *Window, key: Int) Int {
            return c.glfwGetKey(window, key);
        }

        pub var callbackState = glfwCallbackState{};

        const glfwCallbackState = struct {
            errorCb: ?errorCallbackState = null,
            keyCb: ?keyCallbackState = null,
            scrollCb: ?scrollCallbackState = null,

            pub const errorCallbackState = struct {
                code: Int = undefined,
                description: cString = undefined,
            };

            pub const keyCallbackState = struct {
                window: *Window = undefined,
                key: Int = undefined,
                scancode: Int = undefined,
                action: Int = undefined,
                mods: Int = undefined,
            };

            pub const scrollCallbackState = struct {
                window: *Window = undefined,
                xOffset: f64 = undefined,
                yOffset: f64 = undefined,
            };
        };

        pub fn getScroll() ?glfwCallbackState.scrollCallbackState {
            if (self.callbackState.scrollCb) |value| {
                self.callbackState.scrollCb = null;
                return value;
            }
            return null;
        }

        pub const defaultFn = struct {
            /// Default error callback
            pub fn errorCallback(code: Int, description: [*c]const Char) callconv(.C) void {
                callbackState.errorCb = glfwCallbackState.errorCallbackState{
                    .code = code,
                    .description = description,
                };
                @panic("[GLFW] Error\n");
            }
            /// Default key callback
            pub fn keyCallback(window: ?*Window, key: Int, scancode: Int, action: Int, mods: Int) callconv(.C) void {
                callbackState.keyCb = glfwCallbackState.keyCallbackState{
                    .window = window.?,
                    .key = key,
                    .scancode = scancode,
                    .action = action,
                    .mods = mods,
                };

                if (key == KEY_ESCAPE and action == PRESS) {
                    c.glfwSetWindowShouldClose(window, True);
                }
                return void{};
            }
            /// Default scroll callback
            /// Possible errors include GLFW_NOT_INITIALIZED.
            pub fn scrollCallback(window: ?*Window, xOffset: f64, yOffset: f64) callconv(.C) void {
                callbackState.scrollCb = glfwCallbackState.scrollCallbackState{
                    .window = window.?,
                    .xOffset = xOffset,
                    .yOffset = yOffset,
                };
                return void{};
            }
        };
    };
}
