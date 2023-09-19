
# PATH MVP (SCOPE)

## ITERATION A1 - String Manipulation (Windows)

- [ ] support only filesystem paths (files & directories)
- [ ] support only utf8 chars encoding (implicitly includes ascii)
- [ ] support windows path style only (for now)
- [ ] join path strings

## ITERATION A2 - Validation & Parsing (Windows)

- [ ] validate path string syntax (excluding resolving)
- [ ] resolve path via Sys call
- [ ] check if exists

## ITERATION A2 - System Calls (Windows)

- [ ] resolve path via Sys call
- [ ] check if exists

## ITERATION A3 - Predicates

- [ ] predicates:
  - [ ] isAbsolute
  - [ ] isRelative
  - [ ] isRoot
  - [ ] isDir
  - [ ] isFile
  - [ ] isSymlink
  - [ ] isHidden
  - [ ] isReadable
  - [ ] isWritable
  - [ ] isExecutable
  - [ ] isSameFileAs
  - [ ] isWindowsStyle
  - [ ] isPosixStyle
  - [ ] isUefiStyle
  - [ ] isNetworkStyle
  - [ ] isUrlStyle
  - [ ] isUriStyle
  - [ ] isDeviceStyle
  - [ ] isRegistryStyle
  - [ ] isWinObjStyle
  - [ ] isSocketStyle

- [ ] check if exists

## ITERATION B

- [ ] support posix path style

## ITERATION C

- [ ] support posix path style

# [cwalk](https://likle.github.io/cwalk/reference/)

Reference

#### Basics

- The ***basename*** is the last portion of the path, which determines the ***name of the file or folder*** which is being pointed to.
  - For instance, the path /var/log/test.txt would have the basename test.txt.  

- The ***dirname*** is the opposite - the ***path up to the basename***.
  - In that example the dirname would be /var/log.

#### Navigation

One might specify paths containing relative components ../. These functions help to resolve or create relative paths based on a base path.

#### Extensions

Extensions are the portion of a path which come after a `.`, For instance, the file extension of the `/var/log/test.txt` would be `.txt` - which indicates that the content is text.

#### Segments / Components

- A segment represents a single component of a path.
  - For instance, on linux a path might look like this /var/log/, which consists of two segments var and log.

#### Style

The path style describes how paths are generated and parsed. cwalk currently supports two path styles,

## From `std.fs.path.zig`

### Enumerations

#### Existing

- native_os
  - posix
  - uefi
  - windows

#### Missing

- target type
  - filesystem (default)
  - network
  - url
  - uri
  - device
  - registry
  - winObj
  - socket

### Constants

#### Existing

- sep [ Windows, Posix, ]
- sep_str [ Windows, Posix, ]
- delimiter [ Windows, Posix, ]

- PathType
  - posix
  - uefi
  - windows

- WindowsPath
  - is_absolute
  - disk_designator
  - kind <None|Drive|NetworkShare>

#### Missing

- relative
  - here/current
  - parent/up
- absolute
  - root
  - home
  - temp
- null
- empty
- default locations ?
  - todo

### Predicates

| Status   | Member       |
|----------|--------------|
| existing | isSep        |
| existing | isAbsolute   |
| new      | isRelative   |
| new      | hasExtension |

### Properties / Components

| Status   | Member    | Feature Set | For     | Purpose                                  |
|----------|-----------|-------------|---------|------------------------------------------|
| existing | disk      | get / set   | Windows | disk designator / drive letter           |
| existing | dirname   | get / set   | all     | path without last component              |
| existing | basename  | get / set   | all     | last component of path with extension    |
| existing | stem      | get / set   | all     | last component of path without extension |
| existing | extension | get / set   | all     | extention only                           |
| new      | segmentContent | get / set | all  | determine/change segment content (text)  |
| new      | segmentType    | get / set | all  | determine/change segment type (dir|file) |
| new      | root      | get / set   | all     | determine/change root                    |
| new      | style     | get         | all     | determin style                           |

### Input/Parsing & Output/Generation

| Status   | Member   | for            | Purpose                | Depends on | Allocator? |
|----------|----------|----------------|------------------------|------------|------------|
| new      | pathMode   | internal op. mode | use for processing            | init |   |
| new      | StringMode | internal op. mode | use for processing            | init |   |
| new      | absolute   | in, op, out       | generate absolute path        | mode |   |
| new      | relative   | in, op, out       | generate reletive path        | mode |   |
| existing | join       | in, op, out       | join 2 paths                  |      | ! |
| existing | resolve    | in, op, out       | resolve dots via z or os      |      | ! |
| existing | relative   | in, op, out       | generate rel path from inputs |      | ! |
| existing | parseWin   | in, op, internal? | returns WinPath instance      |      |   |
| new      | parse      | in, op, internal? | guess/infer/determine style   |      |   |
| new      | normalize  | in, op, internal? | to native_os style ?          |      |   |
| new      | intersect  | in, op, internal? | determine common/intersect ?  |      |   |
| new      | diff       | in, op, internal? | determine diff ?              |      |   |
| new      | joinMultiple | in, op, out     | join multiple paths           |      | ? |

#### Existing

- Instance: componentIterator
- Generic Type: ComponentIterator
  - init
  - root
  - first
  - last
  - next
  - previous

#### Missing

### Other concerns / questions / init / setup

#### Failure mode

- Error
- Panic
- Null
- Empty
- Default

#### Memory / Ownership

- External/unmanaged (heap)
- Internal/managed (stack/heap)

- Caller owns returned memory?

- Copy
- Reference/Pointer

#### Text Encoding Mode

- UTF / Unicode
- ASCII

#### Target Type

- Filesystem / Path / File / Directory
- Network / URL / URI
- Device
- Registry
- WinObj
- Wasi ??

### Existing Issues

#### untangle std.fs.path.resolve from the current working directory #13613

<https://github.com/ziglang/zig/issues/13613>

> std.fs.path.resolve is trying to do too much at once, and it results in a leaky abstraction. It can be a nice substitute for realpath when trying to avoid this syscall, however, it suffers from not taking symlinks into account, as well as asking the OS for the cwd unnecessarily.
>
>I propose to change it to be purely a string manipulation function and lose the ability to call cwd().
>
>Any callsites that break from this change should be audited for potential pre-existing bugs.

#### CLI: more careful resolution of paths #13652

<https://github.com/ziglang/zig/pull/13652>

>In general, we prefer compiler code to use relative paths based on open directory handles because this is the most portable. However, sometimes absolute paths are used, and sometimes relative paths are used that go up a directory.
>
>The recent improvements in 81d2135 regressed the use case when an absolute path is used for the zig lib directory mixed with a relative path used for the root source file. This could happen when, for example, running the standard library tests, like this:
>
>stage3/bin/zig test ../lib/std/std.zig

---

```zig

std.mem.tokenize( path, dellimiter) 


cwd()

fullpath ?



std.fs.File.Kind{ .file, .directory, .sym_link, .unknown, .... }
== std.fs.Dir.Stat.Kind

std.fs.path.PathType{ .windows, .posix, .uefi }

std.fs.Dir .{ fd: os.fd_t }

std.fs.Dir.makePath

std.fs.selfExePath
std.fs.selfExeDirPath

std.fs.path.WindowsPath
std.fs.path.windowsParsePath

std.mem.DelimiterType
std.fs.path.delimiter
std.fs.path.delimiter_posix
std.fs.path.delimiter_windows

std.cstr.line_sep
std.fs.path.sep
std.fs.path.isSep
std.fs.path.sep_str
std.fs.path.sep_posix
std.fs.path.sep_windows
std.fs.path.sep_str_posix
std.fs.path.sep_str_windows
std.http.Headers.formatCommaSeparated
std.fs.path.PathType.isSep

std.http.protocol
std.os.uefi.protocol
std.http.Client.protocol_map
std.os.windows.FileRemoteProtocolInfo

std.fs.path.diskDesignator
std.fs.path.diskDesignatorWindows
std.os.uefi.DevicePath.Media.RamDiskDevicePath

std.fmt.charToDigit
std.fmt.digitToChar
std.fmt.formatAsciiChar
std.zig.parseCharLiteral
std.zig.ParsedCharLiteral
std.fmt.Parser.char
std.os.windows.CHAR
std.unicode.replacement_character
std.base64.standard_alphabet_chars
std.base64.url_safe_alphabet_chars
std.os.windows.ws2_32.LmCharSetASCII
std.os.windows.ws2_32.LmCharSetUNICODE

std.os.windows.KNOWNFOLDERID.parse
std.os.windows.KNOWNFOLDERID.parseNoBraces

std.net.isValidHostName
std.unicode.utf8ValidateSlice
std.unicode.utf8ValidCodepoint

std.fs.path.sep_posix
std.fs.path.delimiter_posix
std.fs.path.relativePosix
std.fs.path.sep_windows
std.fs.path.delimiter_windows
std.fs.path.diskDesignatorWindows

std.fs.path.isAbsoluteWindowsW
std.fs.path.isAbsoluteWindowsZ
std.fs.path.isAbsoluteWindowsWTF16

std.fs.MAX_NAME_BYTES
This represents the maximum size of a UTF-8 encoded file name component that the platform’s common file systems support. File nam…

std.fs.MAX_PATH_BYTES
This represents the maximum size of a UTF-8 encoded file path that the operating system will accept. Paths, including those retur…

std.fs.path.resolveWindows
std.fs.path.dirnameWindows
std.fs.path.windowsParsePath
std.os.toPosixPath - converts a given slice into a null-terminated slice suitable for POSIX systems.
std.os.windows.normalizePath

std.fs.path.sep_str_windows
std.fs.path.basenameWindows
std.fs.path.relativeWindows
std.fs.File.MetadataWindows

std.os.windows.wToPrefixedFileW
std.os.windows.ntToWin32Namespace
std.os.windows.cStrToPrefixedFileW
std.os.windows.sliceToPrefixedFileW
std.os.windows.ntdll.RtlDosPathNameToNtPathName_U

/// On Windows, `\\server` or `\\server\share` was not found.
MakeDirError.NetworkNotFound,

/// On Windows, file paths cannot contain these characters:
/// '/', '*', '?', '"', '<', '>', '|'
BadPathName,

/// On Windows, file paths must be valid Unicode.
ChangeCurDirError.InvalidUtf8,


std.cstr.addNullByte
std.unicode.utf8ToUtf16LeWithNull


std.unicode.utf16leToUtf8
std.unicode.utf8ToUtf16Le
std.unicode.utf16leToUtf8Alloc
std.unicode.utf16leToUtf8AllocZ
std.unicode.utf8ToUtf16LeWithNull
std.unicode.utf8ToUtf16LeStringLiteral

std.os.getFdPath
std.os.RealPathError

std.os.linux.PATH_MAX
std.os.linux.NAME_MAX
std.os.linux.HOST_NAME_MAX

std.os.wasi.path_open
std.os.wasi.path_link
std.os.wasi.path_symlink

std.os.windows.PathSpace
std.os.windows.PATH_MAX_WIDE
std.os.windows.normalizePath
std.os.windows.getUnprefixedPathType
std.os.windows.GetFinalPathNameByHandle
std.os.windows.GetFinalPathNameByHandleError
std.os.windows.shell32.SHGetKnownFolderPath
std.os.windows.kernel32.GetFullPathNameW
std.os.windows.ntdll.RtlGetFullPathName_U
std.os.windows.kernel32.GetFinalPathNameByHandleW
std.os.windows.ntdll.RtlDosPathNameToNtPathName_U

std.os.uefi.DevicePath
std.os.uefi.protocol.DevicePath

std.Uri.escapePath

std.zig.system.NativePaths
std.zig.system.NativePaths.addRPath

std.unicode

std.ascii



```

## From <https://doc.rust-lang.org/std/path/struct.Path.html>

ancestors
as_mut_os_str
as_os_str
canonicalize
components
display
ends_with
exists
extension
file_name
file_prefix
file_stem
has_root
into_path_buf
is_absolute
is_dir
is_file
is_relative
is_symlink
iter
join
metadata
new
parent
read_dir
read_link
starts_with
strip_prefix
symlink_metadata
to_path_buf
to_str
to_string_lossy
try_exists
with_extension
with_file_name

pub fn has_root(&self) -> bool

Returns true if the Path has a root.

    On Unix, a path has a root if it begins with /.

    On Windows, a path has a root if it:
        has no prefix and begins with a separator, e.g., \windows
        has a prefix followed by a separator, e.g., c:\windows but not c:windows
        has any non-disk prefix, e.g., \\server\share

Enum std::path::Component
1.0.0 · source ·

pub enum Component<'a> {
    Prefix(PrefixComponent<'a>),
    RootDir,
    CurDir,
    ParentDir,
    Normal(&'a OsStr),
}

Prefix(PrefixComponent<'a>)

A Windows path prefix, e.g., C: or \\server\share.

There is a large variety of prefix types, see Prefix’s documentation for more.

Does not occur on Unix.
RootDir

The root directory component, appears after any prefix and before anything else.

It represents a separator that designates that a path starts from root.
CurDir

A reference to the current directory, i.e., ..
ParentDir

A reference to the parent directory, i.e., ...
Normal(&'a OsStr)

A normal component, e.g., a and b in a/b.

This variant is the most common one, it represents references to files or directories.

### Module std::path

1.0.0 · source ·

Cross-platform path manipulation.

This module provides two types, PathBuf and Path (akin to String and str), for working with paths abstractly. These types are thin wrappers around OsString and OsStr respectively, meaning that they work directly on strings according to the local platform’s path syntax.

Paths can be parsed into Components by iterating over the structure returned by the components method on Path. Components roughly correspond to the substrings between path separators (/ or \). You can reconstruct an equivalent path from components with the push method on PathBuf; note that the paths may differ syntactically by the normalization described in the documentation for the components method.

#### Case sensitivity

Unless otherwise indicated path methods that do not access the filesystem, such as Path::starts_with and Path::ends_with, are case sensitive no matter the platform or filesystem. An exception to this is made for Windows drive letters.

#### Simple usage

Path manipulation includes both parsing components from slices and building new owned paths.

To parse a path, you can create a Path slice from a str slice and start asking questions:

```rust
use std::path::Path;
use std::ffi::OsStr;

let path = Path::new("/tmp/foo/bar.txt");

let parent = path.parent();
assert_eq!(parent, Some(Path::new("/tmp/foo")));

let file_stem = path.file_stem();
assert_eq!(file_stem, Some(OsStr::new("bar")));

let extension = path.extension();
assert_eq!(extension, Some(OsStr::new("txt")));

```

To build or modify paths, use PathBuf:

```rust
use std::path::PathBuf;

// This way works...
let mut path = PathBuf::from("c:\\");

path.push("windows");
path.push("system32");

path.set_extension("dll");

// ... but push is best used if you don't know everything up
// front. If you do, this way is better:
let path: PathBuf = ["c:\\", "windows", "system32.dll"].iter().collect();
```

### In std::path

#### Structs

- `Ancestors` - An iterator over Path and its ancestors.
- `Components` - An iterator over the Components of a Path.
- `Display` - Helper struct for safely printing paths with format! and {}.
- `Iter` - An iterator over the Components of a Path, as OsStr slices.
- `Path` - A slice of a path (akin to str).
- `PathBuf` - An owned, mutable path (akin to String).
- `PrefixComponent` - A structure wrapping a Windows path prefix as well as its unparsed string representation.
- `StripPrefixError` - An error returned from Path::strip_prefix if the prefix was not found.

#### Enums

- `Component` - A single component of a path.
- `Prefix` - Windows path prefixes, e.g., `C:` or `\\server\share`.

#### Constants

- `MAIN_SEPARATOR` - The primary separator of path components for the current platform.
- `MAIN_SEPARATOR_STR` - The primary separator of path components for the current platform.

#### Functions

- `absoluteExperimental` - Makes the path absolute without accessing the filesystem.
- `is_separator` - Determines whether the character is one of the permitted path separators for the current platform.
