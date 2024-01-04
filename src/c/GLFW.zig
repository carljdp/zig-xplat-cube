// generics
const std = @import("std");

/// Wrapper for GLFW with remapped types and functions
pub fn remapped() type {
    return struct {
        const self = @This();
        const c = struct {
            usingnamespace @import("imports.zig");
        };

        // CUSTOM STATE

        // TYPES (partial rename)
        pub const Void = void;
        pub const Bool = c.GLint; // c_int
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
        pub const RESIZABLE: Int = c.GLFW_RESIZABLE;
        pub const DECORATED: Int = c.GLFW_DECORATED;

        pub const SAMPLES: Int = c.GLFW_SAMPLES;

        pub const KEY_ESCAPE: Int = c.GLFW_KEY_ESCAPE;

        pub const FOCUSED: Int = c.GLFW_FOCUSED;
        pub const PRESS: Int = c.GLFW_PRESS;
        pub const RELEASE: Int = c.GLFW_RELEASE;

        pub const KEY_UP: Int = c.GLFW_KEY_UP;
        pub const KEY_W: Int = c.GLFW_KEY_W;

        pub const KEY_DOWN: Int = c.GLFW_KEY_DOWN;
        pub const KEY_S: Int = c.GLFW_KEY_S;

        pub const KEY_LEFT: Int = c.GLFW_KEY_LEFT;
        pub const KEY_A: Int = c.GLFW_KEY_A;

        pub const KEY_RIGHT: Int = c.GLFW_KEY_RIGHT;
        pub const KEY_D: Int = c.GLFW_KEY_D;

        pub const KEY_R: Int = c.GLFW_KEY_R;

        pub const KEY_TAB: Int = c.GLFW_KEY_TAB;

        // pub const KEY_SPACE: Int = c.GLFW_KEY_SPACE;
        // pub const KEY_ENTER: Int = c.GLFW_KEY_ENTER;
        // pub const KEY_BACKSPACE: Int = c.GLFW_KEY_BACKSPACE;
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
        /// non-optional variant of glfw window size callback
        pub const WindowSizeCallbackFn = *const fn (window: ?*Window, width: Int, height: Int) callconv(.C) void;
        /// non-optional variant of glfw cursor position callback
        pub const CursorPosCallbackFn = *const fn (window: ?*Window, x: f64, y: f64) callconv(.C) void;
        /// non-optional variant of glfw window focus callback
        pub const WindowFocusCallbackFn = *const fn (window: ?*Window, focused: Bool) callconv(.C) void;
        /// non-optional variant of glfw cursor enter callback
        pub const CursorEnterCallbackFn = *const fn (window: ?*Window, entered: Bool) callconv(.C) void;

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
        pub fn destroyWindow(window: *Window) void {
            c.glfwDestroyWindow(window);
            return void{};
        }

        /// glfwSetWindowShouldClose()
        pub fn setWindowShouldClose(window: *Window, shouldClose: bool) void {
            c.glfwSetWindowShouldClose(window, if (shouldClose) True else False);
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
        pub fn setKeyCallback(window: *Window, callback: KeyCallbackFn) void {
            // The previously set callback, or NULL if no callback was set or the library had not been initialized.
            _ = c.glfwSetKeyCallback(window, callback);
            return void{};
        }

        /// glfwSetErrorCallback()
        pub fn setErrorCallback(callback: ErrorCallbackFn) void {
            // he previously set callback, or NULL if no callback was set.
            _ = c.glfwSetErrorCallback(callback);
            return void{};
        }

        /// glfwSetScrollCallback()
        pub fn setScrollCallback(window: *Window, callback: ScrollCallbackFn) void {
            // The previously set callback, or NULL if no callback was set or an error occurred.
            _ = c.glfwSetScrollCallback(window, callback);
            return void{};
        }

        /// glfwSetWindowSizeCallback()
        pub fn setWindowSizeCallback(window: *Window, callback: WindowSizeCallbackFn) void {
            // The previously set callback, or NULL if no callback was set or an error occurred.
            _ = c.glfwSetWindowSizeCallback(window, callback);
            return void{};
        }

        /// glfwSetCursorPosCallback()
        pub fn setCursorPosCallback(window: *Window, callback: CursorPosCallbackFn) void {
            // The previously set callback, or NULL if no callback was set or an error occurred.
            _ = c.glfwSetCursorPosCallback(window, callback);
            return void{};
        }

        /// glfwSetWindowFocusCallback()
        pub fn setWindowFocusCallback(window: *Window, callback: WindowFocusCallbackFn) void {
            // The previously set callback, or NULL if no callback was set or an error occurred.
            _ = c.glfwSetWindowFocusCallback(window, callback);
            return void{};
        }

        /// glfwSetCursorEnterCallback()
        pub fn setCursorEnterCallback(window: *Window, callback: CursorEnterCallbackFn) void {
            // The previously set callback, or NULL if no callback was set or an error occurred.
            _ = c.glfwSetCursorEnterCallback(window, callback);
            return void{};
        }

        /// glfwSwapBuffers()
        pub fn swapBuffers(window: *Window) void {
            c.glfwSwapBuffers(window);
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
        pub fn windowShouldClose(window: *Window) bool {

            // TODO: should this return an error?

            return c.glfwWindowShouldClose(window) == True;
        }

        /// glfwGetCursorPos()
        pub fn getCursorPos(window: *Window, x: [*c]f64, y: [*c]f64) void {
            c.glfwGetCursorPos(window, x, y);
            return void{};
        }

        /// glfwSetCursorPos()
        pub fn setCursorPos(window: *Window, x: f64, y: f64) void {
            c.glfwSetCursorPos(window, x, y);
            return void{};
        }

        /// glfwGetMouseWheel()
        pub fn getMouseWheel(window: *Window) f64 {
            return c.glfwGetMouseWheel(window);
        }

        /// glwfGetWindowSize()
        pub fn getWindowSize(window: *Window, width: [*c]Int, height: [*c]Int) void {
            c.glfwGetWindowSize(window, width, height);
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

        /// Exposes state obtained from callbacks
        pub var callbackState = glfwCallbackState{};

        const glfwCallbackState = struct {
            errorCb: ?errorCallbackState = null,
            keyCb: ?keyCallbackState = null,
            scrollCb: ?scrollCallbackState = null,
            windowSizeCb: ?windowSizeCallbackState = null,
            cursorPosCb: ?cursorPosCallbackState = null,
            windowFocusCb: ?windowFocusCallbackState = null,
            cursorEnterCb: ?cursorEnterCallbackState = null,

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

            pub const windowSizeCallbackState = struct {
                window: *Window = undefined,
                width: Int = undefined,
                height: Int = undefined,
            };

            pub const cursorPosCallbackState = struct {
                window: *Window = undefined,
                x: f64 = undefined,
                y: f64 = undefined,
            };

            pub const windowFocusCallbackState = struct {
                window: *Window = undefined,
                focused: bool = undefined,
            };

            pub const cursorEnterCallbackState = struct {
                window: *Window = undefined,
                entered: bool = undefined,
            };
        };

        /// read and clear the current error callback state
        pub fn getScrollStateIfChanged() ?glfwCallbackState.scrollCallbackState {
            if (self.callbackState.scrollCb) |value| {
                self.callbackState.scrollCb = null;
                return value;
            }
            return null;
        }

        /// read and clear the current key callback state
        pub fn getWindowFocusStateIfChanged() ?glfwCallbackState.windowFocusCallbackState {
            if (self.callbackState.windowFocusCb) |value| {
                self.callbackState.windowFocusCb = null;
                return value;
            }
            return null;
        }

        pub fn getCursorEnterStateIfChanged() ?glfwCallbackState.cursorEnterCallbackState {
            if (self.callbackState.cursorEnterCb) |value| {
                self.callbackState.cursorEnterCb = null;
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
            /// Default window size callback
            pub fn windowSizeCallback(window: ?*Window, width: Int, height: Int) callconv(.C) void {
                callbackState.windowSizeCb = glfwCallbackState.windowSizeCallbackState{
                    .window = window.?,
                    .width = width,
                    .height = height,
                };
                return void{};
            }
            /// Default cursor position callback
            pub fn cursorPosCallback(window: ?*Window, x: f64, y: f64) callconv(.C) void {
                callbackState.cursorPosCb = glfwCallbackState.cursorPosCallbackState{
                    .window = window.?,
                    .x = x,
                    .y = y,
                };
                return void{};
            }
            /// Default window focus callback
            pub fn windowFocusCallback(window: ?*Window, focused: Bool) callconv(.C) void {
                callbackState.windowFocusCb = glfwCallbackState.windowFocusCallbackState{
                    .window = window.?,
                    .focused = if (focused == True) true else false,
                };
                return void{};
            }

            /// Default cursor enter callback
            pub fn cursorEnterCallback(window: ?*Window, entered: Bool) callconv(.C) void {
                callbackState.cursorEnterCb = glfwCallbackState.cursorEnterCallbackState{
                    .window = window.?,
                    .entered = if (entered == True) true else false,
                };
                return void{};
            }
        };
    };
}
