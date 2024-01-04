// generics
const std = @import("std");

// debug helpers
const is_test = @import("builtin").is_test;
const Name = @import("debug_helpers.zig").DotNotation;

// Original idea here was to try and replicate 'comptime' @embedFile functionality
//
// I suppose it's kinda 'comptime', because it replies on being initialized with
//   a build object, which is only available at compile time

/// Comptime FS (or build-time)
pub const CFS = struct {
    // for reading files
    allocator: *const std.mem.Allocator = undefined,
    dir: std.fs.Dir = undefined,
    realpath: []const u8 = undefined,
    rwBuffer: ?[]u8 = undefined, // because it is allocated on demand

    initialized: bool = false,

    const default = struct {
        const maxFileSize: usize = 1024 * 1024;
        const maxPathSize: usize = std.fs.MAX_PATH_BYTES;
    };

    /// Create new instance, return by-value to caller's stack
    pub fn onStack() CFS {
        // Log out this function name at entry and exit` ` ` ` ` `
        const memo = comptime Name.ofFunction(onStack).full();
        if (!is_test) std.debug.print("[{s}] ..\n", .{memo});
        defer if (!is_test) std.debug.print("[{s}] done.\n", .{memo});
        // ` ` ` ` ` ` ` ` ` ` ` ` ` ` ` ` ` ` ` ` ` ` ` ` ` ` ` `

        return CFS{
            .allocator = undefined,
            .dir = undefined,
            .realpath = undefined,
            .rwBuffer = undefined,
            .initialized = false,
        };
    }

    /// Initialize instance
    /// - `allocator` - used for both realpath resolution & internal file read/write buffer
    /// - Possible error if `realpathAlloc()` resolution fails
    /// - Caller responsible to trigger `defer instance.deinit()` to free internal allocations
    pub fn init(self: *CFS, allocator: ?*const std.mem.Allocator) !*CFS {
        // Log out this function name at entry and exit` ` ` ` ` `
        const memo = comptime Name.ofFunction(init).full();
        if (!is_test) std.debug.print("[{s}] ..\n", .{memo});
        defer if (!is_test) std.debug.print("[{s}] done.\n", .{memo});
        // ` ` ` ` ` ` ` ` ` ` ` ` ` ` ` ` ` ` ` ` ` ` ` ` ` ` ` `

        // try things that can fail
        var _allocator = if (allocator) |ptr| ptr else &std.heap.page_allocator;
        const _dir = std.fs.cwd();
        const _realPath = try _dir.realpathAlloc(_allocator.*, ".");

        // still here? Set values and return
        self.allocator = _allocator;
        self.dir = _dir;
        self.realpath = _realPath;
        self.rwBuffer = null; // allocated on demand

        self.initialized = true;
        return self;
    }

    /// Free internal allocations
    pub fn deinit(self: *CFS) void {
        // Log out this function name at entry and exit` ` ` ` ` `
        const memo = comptime Name.ofFunction(deinit).full();
        if (!is_test) std.debug.print("[{s}] ..\n", .{memo});
        defer if (!is_test) std.debug.print("[{s}] done.\n", .{memo});
        // ` ` ` ` ` ` ` ` ` ` ` ` ` ` ` ` ` ` ` ` ` ` ` ` ` ` ` `

        if (!self.initialized) std.debug.panic("CFS.deinit() called on uninitialized instance\n", .{});

        if (self.rwBuffer) |buf| self.allocator.free(buf);
        self.allocator.free(self.realpath);

        // not sure if these are really needed ?
        self.allocator = undefined;
        self.dir = undefined;
        self.realpath = undefined;
        self.rwBuffer = undefined;

        self.initialized = false;

        return void{};
    }

    /// Read file (up to `maxFileSize`)
    /// - File content stored internally at `.rwBuffer`
    /// - Caller responsible to trigger `defer instance.deinit()` to free internal allocations
    pub fn readFileToInternalBuffer(self: *CFS, filePath: []const u8, maxFileSize: ?usize) !void {
        // Log out this function name at entry and exit` ` ` ` ` `
        const memo = comptime Name.ofFunction(readFileToInternalBuffer).full();
        if (!is_test) std.debug.print("[{s}] ..\n", .{memo});
        defer if (!is_test) std.debug.print("[{s}] done.\n", .{memo});
        // ` ` ` ` ` ` ` ` ` ` ` ` ` ` ` ` ` ` ` ` ` ` ` ` ` ` ` `

        if (!self.initialized) std.debug.panic("CFS.readFileToInternalBuffer() called on uninitialized instance\n", .{});

        const _maxFileSize = if (maxFileSize) |size| size else CFS.default.maxFileSize;
        self.rwBuffer = try self.dir.readFileAlloc(self.allocator.*, filePath, _maxFileSize);
        return void{};
    }

    /// Get buffer as-is and return plain zig[]-style
    /// - Returns non-terminated plain-zig-slice of internal allocated array.
    /// - `.len` is the length of the buffer
    pub fn getBufferAsIs(self: *CFS) ![]const u8 {
        // Log out this function name at entry and exit` ` ` ` ` `
        const memo = comptime Name.ofFunction(getBufferAsIs).full();
        if (!is_test) std.debug.print("[{s}] ..\n", .{memo});
        defer if (!is_test) std.debug.print("[{s}] done.\n", .{memo});
        // ` ` ` ` ` ` ` ` ` ` ` ` ` ` ` ` ` ` ` ` ` ` ` ` ` ` ` `

        if (!self.initialized) std.debug.panic("CFS.getBufferAsIs() called on uninitialized instance\n", .{});

        // TODO: what if buffer is empty, or contains 1 or more nulls already?

        return if (self.rwBuffer) |buf| buf[0..buf.len] else error.BufferNotAllocated;
    }

    /// Null terminate internal buffer and return zig[:0]-style
    /// - Returns null-sentinel-terminated zig-style slice of internal allocated array.
    /// - .len excludes the newly added null terminator
    pub fn getBufferNullTerminatedZ(self: *CFS) ![:0]const u8 {
        // Log out this function name at entry and exit` ` ` ` ` `
        const memo = comptime Name.ofFunction(getBufferNullTerminatedZ).full();
        if (!is_test) std.debug.print("[{s}] ..\n", .{memo});
        defer if (!is_test) std.debug.print("[{s}] done.\n", .{memo});
        // ` ` ` ` ` ` ` ` ` ` ` ` ` ` ` ` ` ` ` ` ` ` ` ` ` ` ` `

        if (!self.initialized) std.debug.panic("CFS.getBufferNullTerminatedZ() called on uninitialized instance\n", .{});

        // TODO: what if buffer is empty, or contains 1 or more nulls already?

        // Check if the buffer is non-null and handle appropriately
        if (self.rwBuffer) |currentBuffer| {
            // if empty or not null terminated
            if (currentBuffer.len == 0 or currentBuffer[currentBuffer.len - 1] != 0) {
                // resize buffer +1, to make room for null terminator
                self.rwBuffer = try self.allocator.realloc(currentBuffer, currentBuffer.len + 1);

                if (self.rwBuffer) |newBuffer| {
                    newBuffer[newBuffer.len - 1] = 0; // Assign null terminator to the new last element
                }
            }
        } else {
            // TODO - what when buffer is null?
        }

        // returns a slice to the buffer -1 (excluding the null terminator)
        // [:0] makes zig aware that it is null terminated under the hood
        // return self.rwBuffer[0 .. self.rwBuffer.len - 1 :0];
        return if (self.rwBuffer) |buf| buf[0 .. buf.len - 1 :0] else error.BufferNotAllocated;
    }

    /// Null terminate internal buffer and return c-style
    /// - Returns null-sentinel-terminated c-style pointer to internal allocated array.
    /// - `.len` is undefined, because it points only to the first element.
    pub fn getBufferNullTerminatedC(self: *CFS) ![*c]const u8 {
        // Log out this function name at entry and exit` ` ` ` ` `
        const memo = comptime Name.ofFunction(getBufferNullTerminatedC).full();
        if (!is_test) std.debug.print("[{s}] ..\n", .{memo});
        defer if (!is_test) std.debug.print("[{s}] done.\n", .{memo});
        // ` ` ` ` ` ` ` ` ` ` ` ` ` ` ` ` ` ` ` ` ` ` ` ` ` ` ` `

        if (!self.initialized) std.debug.panic("CFS.getBufferNullTerminatedC() called on uninitialized instance\n", .{});

        // TODO: what if buffer is empty, or contains 1 or more nulls already?

        // Check if the buffer is non-null and handle appropriately
        if (self.rwBuffer) |currentBuffer| {
            // if empty or not null terminated
            if (currentBuffer.len == 0 or currentBuffer[currentBuffer.len - 1] != 0) {
                // resize buffer +1, to make room for null terminator
                self.rwBuffer = try self.allocator.realloc(currentBuffer, currentBuffer.len + 1);

                if (self.rwBuffer) |newBuffer| {
                    newBuffer[newBuffer.len - 1] = 0; // Assign null terminator to the new last element
                }
            }
        } else {
            // TODO - what when buffer is null?
        }

        // returns a c-style slice to the entire buffer (without length info)
        // Pointer to the first element of the slice, assumed to be null-terminated.
        // return &self.rwBuffer[0];
        return if (self.rwBuffer) |buf| &buf[0] else error.BufferNotAllocated;
    }

    /// write file. to where? i think relative to here?
    pub fn writeFile(self: *CFS, file: []const u8, contents: []const u8) anyerror!void {
        // Log out this function name at entry and exit` ` ` ` ` `
        const memo = comptime Name.ofFunction(writeFile).full();
        if (!is_test) std.debug.print("[{s}] ..\n", .{memo});
        defer if (!is_test) std.debug.print("[{s}] done.\n", .{memo});
        // ` ` ` ` ` ` ` ` ` ` ` ` ` ` ` ` ` ` ` ` ` ` ` ` ` ` ` `

        if (!self.initialized) std.debug.panic("CFS.writeFile() called on uninitialized instance\n", .{});

        //
        const f = self.dir.createFile(file, .{}) catch |err| {
            std.debug.print("[CFS] could not create file '{s}'\n {!}\n", .{ file, err });
            return err;
        };
        defer f.close();

        //
        const writer = f.writer();
        writer.print("{s}", .{contents}) catch |err| {
            std.debug.print("[CFS] could not write to file '{s}'\n {!}\n", .{ file, err });
            return err;
        };

        return void{};
    }
};

pub const Path = struct {
    const native_os: std.Target.Os.Tag = @import("builtin").target.os.tag;

    /// initial input
    raw: []const u8 = undefined,

    /// parsed input
    parsed: Parsed = undefined,

    // pub fn get(self: Path, part: ?Path.Descriptor.Part) []const u8 {
    //     return switch (part) {
    //         .Full => self.raw,
    //         .Path => self.parsed.parts.dir.path,
    //         .File => self.parsed.parts.file.name,
    //         .Extension => self.parsed.parts.file.extension,
    //         else => self.raw,
    //     };
    // }

    pub const Result = enum {
        /// Evaluated, result is good/valid
        Success,
        /// Evaluated, result is bad/invalid
        Fail,
        /// Not yet evaluated
        Pending,
    };

    pub const Parsed = struct {
        result: Result = Result.Pending,
        meta: Meta = Meta{},
        parts: Parts = Parts{},

        pub const Meta = struct {
            style: Path.Descriptor.Style = .unknown,
            relativity: Path.Descriptor.Relativity = .unknown,
        };

        pub const Parts = struct {
            dir: Dir = Dir{},
            file: ?File = null,

            const Dir = struct {
                driveLetter: ?u8 = null,
                path: []const u8 = "",
            };

            const File = struct {
                name: []const u8 = undefined,
                extension: ?[]const u8 = null,
            };

            pub const PartsOptions = struct {
                style: ?Path.Descriptor.Style = null,
                relativity: ?Path.Descriptor.Relativity = null,
            };

            pub fn newWithOptions(options: PartsOptions) Parts {
                _ = options;
                //

                //
            }

            pub fn newRelativeHerePosix() Parts {
                return Parts{
                    .dir = Dir{
                        .driveLetter = null,
                        .path = Path.hereSlashPosix,
                    },
                    .file = File{
                        .name = "",
                        .extension = null,
                    },
                };
            }

            pub fn newRelativeHereWindows() Parts {
                return Parts{
                    .dir = Dir{
                        .driveLetter = null,
                        .path = Path.hereSlashWindows,
                    },
                    .file = File{
                        .name = "",
                        .extension = null,
                    },
                };
            }
        };
    };

    pub fn inferStyleFrom(targetOsTag: std.Target.Os.Tag) Path.Descriptor.Style {
        return switch (targetOsTag) {
            .windows => Descriptor.Style.Windows, // '\', drive letter, not case sensitive
            .uefi => Descriptor.Style.Uefi, // '\', no drive letter, case sensitive
            else => Descriptor.Style.Posix, // '/', no drive letter, case sensitive
        };
    }

    fn countSeparatorPosix(path: []const u8) usize {
        return std.mem.count(u8, path, std.fs.path.sep_str_posix);
    }

    fn countSeparatorWindows(path: []const u8) usize {
        return std.mem.count(u8, path, std.fs.path.sep_str_windows);
    }

    fn indexOfFirstSeparatorPosix(path: []const u8) ?usize {
        return std.mem.indexOf(u8, path, std.fs.path.sep_str_posix);
    }

    fn indexOfFirstSeparatorWindows(path: []const u8) ?usize {
        return std.mem.indexOf(u8, path, std.fs.path.sep_str_windows);
    }

    fn startsWithDriveLetter(path: []const u8) bool {
        return path.len >= 3 and std.ascii.isAlphabetic(path[0]) and path[1] == ':' and path[2] == '\\';
    }

    // TODO: move this somewhere better
    pub fn stringsAreEqual(a: []const u8, b: []const u8) bool {
        return std.mem.eql(u8, a, b);
    }

    fn startsWithOptionalDotsAndBackslash(path: []const u8) bool {
        return path.len >= 1 and (path[0] == '\\' or (path[0] == '.' and path[1] == '\\') or stringsAreEqual(path[0..3], Path.upSlashWindows));
    }

    fn startsWithOptionalDotsAndForwardSlash(path: []const u8) bool {
        return path.len >= 1 and (path[0] == '/' or (path[0] == '.' and path[1] == '/') or stringsAreEqual(path[0..3], Path.upSlashPosix));
    }

    fn startsWithDot(path: []const u8) bool {
        return path.len >= 1 and path[0] == '.';
    }

    /// String helpers (for ascii strings)
    pub const AsciiStr = struct {
        /// ascii string
        str: []const u8 = undefined,

        pub fn value(self: AsciiStr) []const u8 {
            return self.str;
        }

        pub fn isValidChars(str: []const u8) bool {
            for (str) |char| {
                if (!std.ascii.isPrint(char)) {
                    return false;
                }
            }
            return true;
        }

        pub fn from(slice: []const u8) !AsciiStr {
            if (!isValidChars(slice)) {
                return error.NonPrintableAsciiChars;
            }
            return AsciiStr{ .str = slice };
        }

        pub fn startsWithAnyOfChars(self: AsciiStr, chars: []const u8) bool {
            if (self.str.len == 0) return false; // short circuit
            for (chars) |c| {
                if (self.str[0] == c) {
                    return true;
                }
            }
            return false;
        }

        pub fn startsWithAnyOfStrings(self: AsciiStr, prefixes: [][]const u8) bool {
            if (self.str.len == 0) return false; // short circuit
            for (prefixes) |prefix| {
                if (std.mem.startsWith(u8, self.str, prefix)) {
                    return true;
                }
            }
            return false;
        }

        /// Check char by char if the string contains any of the chars
        pub fn containsAnyOfChars(self: AsciiStr, chars: []const u8) bool {
            if (self.str.len == 0) return false; // short circuit
            return std.mem.indexOfAny(u8, self.str, chars) != null;
        }

        /// Check if the string contains any of the strings (consecutive chars)
        pub fn containsAnyOfStrings(self: AsciiStr, strs: [][]const u8) bool {
            if (self.str.len == 0) return false; // short circuit
            for (strs) |needle| {
                if (std.mem.indexOfAny(u8, self.str, needle)) {
                    return true;
                }
            }
            return false;
        }
    };

    /// [Dictionary|Map|LookupTable] of path navigation operators
    const PathNav = enum {
        Here,
        Home,
        Up,
        pub fn value(self: PathNav) []const u8 {
            return switch (self) {
                .Here => ".",
                .Home => "~",
                .Up => "..",
            };
        }
        pub fn key(val: []const u8) ?PathNav {
            if (std.mem.eql(u8, val, PathNav.Here.value())) {
                return PathNav.Here;
            } else if (std.mem.eql(u8, val, PathNav.Home.value())) {
                return PathNav.Home;
            } else if (std.mem.eql(u8, val, PathNav.Up.value())) {
                return PathNav.Up;
            } else return null;
        }

        pub const values = struct {
            pub fn all() [][]const u8 {
                return [_][]const u8{
                    PathNav.Here.value(),
                    PathNav.Up.value(),
                };
            }
        };
        pub const keys = struct {
            pub fn all() []PathNav {
                return [_]PathNav{
                    PathNav.Here,
                    PathNav.Up,
                };
            }
        };
    };

    /// [Dictionary|Map|LookupTable] of seperators
    const PathSeperator = enum {
        Windows,
        Posix,
        pub fn value(self: PathSeperator) []const u8 {
            return switch (self) {
                .Posix => "/",
                .Windows => "\\",
            };
        }
        pub fn key(val: []const u8) ?PathSeperator {
            if (std.mem.eql(u8, val, PathSeperator.Posix.value())) {
                return PathSeperator.Posix;
            } else if (std.mem.eql(u8, val, PathSeperator.Windows.value())) {
                return PathSeperator.Windows;
            } else return null;
        }
        pub fn all() []PathSeperator {
            return [_]PathSeperator{
                PathSeperator.Posix,
                PathSeperator.Windows,
            };
        }
        pub const values = struct {
            pub fn all() [][]const u8 {
                return [_][]const u8{
                    PathSeperator.Posix.value(),
                    PathSeperator.Windows.value(),
                };
            }
        };
        pub const keys = struct {
            pub fn all() []PathSeperator {
                return [_]PathSeperator{
                    PathSeperator.Posix,
                    PathSeperator.Windows,
                };
            }
        };
    };

    pub const anySlash = PathSeperator.values.all();

    pub const anyOperator = PathNav.values.all();

    pub const hereSlashPosix = PathNav.Here.value() ++ PathSeperator.Posix.value();
    pub const hereSlashWindows = PathNav.Here.value() ++ PathSeperator.Windows.value();

    pub const upSlashPosix = PathNav.Up.value() ++ PathSeperator.Posix.value();
    pub const upSlashWindows = PathNav.Up.value() ++ PathSeperator.Windows.value();

    pub const homeSlashPosix = PathNav.Home.value() ++ PathSeperator.Posix.value();
    pub const homeSlashWindows = PathNav.Home.value() ++ PathSeperator.Windows.value();

    pub const hereOp_anySlash = [_]u8{ hereSlashPosix, hereSlashWindows };

    pub const homeOp_anySlash = [_]u8{ homeSlashPosix, homeSlashWindows };

    pub const upOp_anySlash = [_]u8{ upSlashPosix, upSlashWindows };

    /// String helpers (for path strings)
    pub const PathInspect = struct {
        //
        string: AsciiStr = undefined,

        /// Constructor. Error if string contains non-printable ascii chars
        pub fn from(asciiString: []const u8) !PathInspect {
            const str = try AsciiStr.from(asciiString);
            return PathInspect{ .asciiStr = str };
        }

        /// starts with `/` or `\`
        fn startsWith_anySlash(self: PathInspect) bool {
            return self.string.startsWithAnyOfStrings(hereOp_anySlash);
        }

        /// starts with `.` or `..` or `~`
        fn startsWith_anyOperator(self: PathInspect) bool {
            return self.string.startsWithAnyOfStrings(anyOperator);
        }

        /// starts with `./` or `.\`
        fn startsWith_hereAnySlash(self: PathInspect) bool {
            return self.string.startsWithAnyOfStrings(hereOp_anySlash);
        }

        /// starts with `../` or `..\`
        fn startsWith_upAnySlash(self: PathInspect) bool {
            return self.string.startsWithAnyOfStrings(upOp_anySlash);
        }

        /// starts with `~/` or `~\` (powershell accepts latter too)
        fn startsWith_homeAnySlash(self: PathInspect) bool {
            return self.string.startsWithAnyOfStrings(homeOp_anySlash);
        }

        /// Check for too many dots like `..` or `....` or `.....`
        fn containsMoreThanTwoConsecutiveDots(self: PathInspect) bool {
            return std.mem.indexOf(u8, self.string.value(), PathNav.Here.value() ++ PathNav.Up.value()) != null;
        }

        /// Check for too many slashes like `\\` or `//` or `\\\\` or `////`
        // TODO: does not yet allow for network paths like `\\server\share\path\to\file`
        fn containsMoreThanOneConsecutiveSeperator(self: PathInspect) bool {
            return std.mem.indexOf(u8, self.string.value(), PathSeperator.Posix.value() ++ PathSeperator.Posix.value()) != null or std.mem.indexOf(u8, self.string.value(), PathSeperator.Windows.value() ++ PathSeperator.Posix.value()) != null;
        }
    };

    /// Constructor.
    pub fn newEmpty() Path {
        return Path{ .raw = undefined, .parsed = undefined };
    }
    /// Constructor.
    pub fn newFrom(asciiString: []const u8) Path {
        const _parsed = try Path.parse(asciiString, .{});

        return Path{ .raw = asciiString, .parsed = _parsed };
    }

    pub const ParseOptions = struct {
        style: ?Descriptor.Style = inferStyleFrom(native_os),
    };

    // pub const pathHelpers = struct {

    //     // pub fn resolve(path: []const u8) ![]u8 {
    //     //     const result = switch (osTag) {
    //     //         .windows => resolveWindows(self.allocator.*, paths),
    //     //         else => std.fs.path.resolvePosix(self.allocator.*, paths),
    //     //     };
    //     //     return result;
    //     // }

    //     pub fn determinePathType(path: []const u8) []const u8 {
    //         var forwardSlashCount: usize = 0;
    //         var backSlashCount: usize = 0;
    //         var dotCount: usize = 0;
    //         var colonCount: usize = 0;

    //         // TODO: what if win path uses double backslashes?

    //         for (path) |char| {
    //             switch (char) {
    //                 '/' => forwardSlashCount += 1,
    //                 '\\' => backSlashCount += 1,
    //                 '.' => dotCount += 1,
    //                 ':' => colonCount += 1,
    //                 else => {},
    //             }
    //         }
    //     }
    // };

    pub fn parse(
        asciiString: []const u8,
        // options: ParseOptions,
    ) !Path {
        //

        var path = Path{
            .raw = asciiString,
            .parsed = Path.Parsed{ .result = Path.Result.Pending },
        };
        _ = path;

        var couldBeRelative: u8 = 0;
        _ = couldBeRelative;
        var couldBeAbsolute: u8 = 0;
        _ = couldBeAbsolute;

        var couldBePosix: u8 = 0;
        _ = couldBePosix;
        var couldBeWindows: u8 = 0;
        _ = couldBeWindows;

        const inspect = try PathInspect.from(asciiString);

        if (inspect.containsMoreThanOneConsecutiveSeperator() or inspect.containsMoreThanTwoConsecutiveDots()) {

            // then is invalid path

            return error.InvalidPath;
        }

        if (inspect.startsWith_anyOperator()) {

            // change method above to check for absolute indicators like `~` , `/`, `\`, `C:\` etc

            // then is (probably) absolute path

            return error.Todo_NotImplemented;
        }

        if (inspect.startsWith_hereAnySlash() or inspect.startsWith_upAnySlash()) {

            // then is (probably) relative path

            return error.Todo_NotImplemented;
        }

        // determine if is of type windows or posix
        // i.e. seperator kind, drive letter, no-mixed seperators, etc

        // determine path part

        // determine file part

        return Path{
            .is_absolute = false,
            .drive = null,
            .path = asciiString,
            .file = null,
        };
    }

    // TODO: refactor/move/rework?
    // pub fn isRoot(self: Path) bool {
    //     return switch (self.meta.style) {
    //         .Posix => {
    //             return self.parsed == "/";
    //         },
    //         .Windows => {
    //             return self.parsed == "/";
    //         },
    //         else => false,
    //     };

    //     return self.path == "/";
    // }

    pub fn isFileValid(self: Path) bool {

        // TODO: check for invalid chars

        return self.file != null;
    }

    pub fn pointsToDir(self: Path) bool {
        return !isFileValid(self);
    }

    pub fn pointsToFile(self: Path) bool {
        return isFileValid(self);
    }

    /// Types used to describe path properties
    pub const Descriptor = struct {
        //

        pub const Style = enum { Posix, Windows, Uefi, unknown };
        pub const AnyStyle = union(Style) {
            Posix: void,
            Windows: void,
            Uefi: void,
            unknown: void,
        };

        // pub const Separator = enum {
        //     Posix: std.fs.path.sep_posix,
        //     Windows: std.fs.path.sep_windows,
        // };

        /// Path is absolute or relative?
        pub const Relativity = enum {
            Absolue,
            Relative,
            unknown,
        };
        pub const AnyRelativity = union(Relativity) {
            Absolue: void,
            Relative: void,
            unknown: void,
        };

        pub const Part = enum {
            Root, // top-level directory in filesystem
            RealPath, // absolute path with all symbolic links, relative resolved

            // First part (is a path)
            FullPath, // path, file, extension
            DirName, // the path, without the file or last folder name

            // Last part (could be file or dir)
            BaseName, // folder or file (with extension)
            Stem, // Basename without Extension
            File, // == Basename
            FileNameOnly, // == Stem
            FileExtensionOnly, // file extension
        };
    };

    // TODO: target or self?
    // pub fn isCaseSensitive(self: Path) bool {
    //     return switch (self.) {
    //         .Absolue => true,
    //         .Relative => false,
    //         else => false,
    //     };
    // }
};
