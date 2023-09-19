const std = @import("std");
const builtin = @import("builtin");
const native_os = builtin.target.os.tag;

const _127: i8 = std.math.maxInt(i8); // 127
const _255: u8 = std.math.maxInt(u8); // 255
const _32767: i16 = std.math.maxInt(i16); // 32767

/// max file name lenth (from MS docs)
pub const Windows = struct {
    /// .
    pub const MaxLength_Path_unicode = _32767;
    pub const MaxLength_PathComponent = _255;

    /// The 4 main Windows file systems.
    pub const FileSystems = enum {
        exfat,
        fat32,
        ntfs,
        udf,
    };

    /// Windows max file name length.
    pub const MaxLength_FileName = struct {
        pub const exfat_unicode = _255;
        pub const fat32_unicode = _255;
        pub const ntfs_unicode = _255;
        pub const udf_unicode = _255;
        pub const udf_ascii = _127;
    };

    /// Reserved characters (can't be used in dir/file names / paths)
    pub const Reserved = struct {
        pub const less_than: u8 = '<';
        pub const greater_than: u8 = '>';
        pub const colon = ':';
        pub const double_quote: u8 = '"';
        pub const forward_slash: u8 = '/';
        pub const backslash: u8 = '\\';
        pub const vertical_bar_or_pipe: u8 = '|';
        pub const question_mark: u8 = '?';
        pub const asterisk: u8 = '*';

        // Integer value zero, sometimes referred to as the ASCII NUL character.

        // Characters whose integer representations are in the range from 1 through 31, except for alternate data streams where these characters are allowed. For more information about file streams, see File Streams.

        // Any other character that the target file system does not allow.
    };
};

const t = Windows.MaxLength_FileName.ntfs_unicode;

/// Path represents a path to a file or directory, cross-platform.
pub const Path = struct {
    /// Raw path, as it was passed to the constructor.
    raw: []const u8 = []const u8{},
    /// Parsed path, if it was parsed successfully, empty otherwise.
    /// TODO ? At this time, not set to null if parsing failed.
    parsed: []const u8 = []const u8{},

    /// for any operations that require memory allocation
    allocator: std.mem.Allocator = std.heap.page_allocator,

    /// New Path instance from a string.
    pub fn new(raw: []const u8) !Path {
        var instance = Path{};
        try instance.parse(raw);
        return instance;
    }

    /// Tries to resolve (and thus sort of 'check') the path without a system call.
    /// Depends on the OS currently running on. Std function could be deprecated in the future.
    pub fn parse(this: *Path, raw: []const u8) !void {
        // TODO: relies on `resolve` feature that might be removed from std
        this.parsed = try this.resolve(this.allocator, raw);
    }
};

test "Path new() & parse()" {
    const rawInput = "/foo/bar";

    const expect_pathRaw = rawInput;
    const expect_pathParsed = switch (native_os) {
        .windows => "\\foo\\bar",
        else => "/foo/bar",
    };

    const actual = try Path.new(rawInput);
    try std.mem.eql(u8, actual.raw, expect_pathRaw);
    try std.mem.eql(u8, actual.parsed, expect_pathParsed);
}
