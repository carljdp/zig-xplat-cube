# Directory and File naming conventions

## Windows

### [File and Directory Names](https://learn.microsoft.com/en-us/windows/win32/fileio/naming-a-file?source=docs#file-and-directory-names)

- a base file name and an optional extension, separated by a period
- The base file name must consist of one or more characters, and must not contain the following characters:
  - < (less than)
  - > (greater than)
  - : (colon)
  - " (double quote)
  - / (forward slash)
  - \ (backslash)
  - | (vertical bar or pipe)
  - ? (question mark)
      - * (asterisk)
- The base file name must not have more than 255 characters.
- The extension must contain a least one character, but no more than 255 characters.
- The extension must not contain the following characters:
  - < (less than)
  - > (greater than)
  - : (colon)
  - " (double quote)
  - / (forward slash)
  - \ (backslash)
  - | (vertical bar or pipe)
  - ? (question mark)
      - * (asterisk)
- The extension must not have more than one period. The name cannot end with a period.

- each file system, such as NTFS, CDFS, exFAT, UDFS, FAT, and FAT32, can have specific and differing rules about the formation of the individual components in the path to a directory or file

- a directory is simply a file with a special attribute designating it as a directory

- The following reserved device names cannot be used as the name of a file:
  - CON, PRN, AUX, NUL, COM1, COM2, COM3, COM4, COM5, COM6, COM7, COM8, COM9, LPT1, LPT2, LPT3, LPT4, LPT5, LPT6, LPT7, LPT8, and LPT9
  
- Also avoid these names followed immediately by an extension; for example, NUL.txt is not recommended. For more information, see [Namespaces](https://docs.microsoft.com/en-us/windows/win32/fileio/naming-a-file?source=docs#namespaces).

- Do not end a file or directory name with a space or a period. Although the underlying file system may support such names, the Windows shell and user interface does not. However, it is acceptable to specify a period as the first character of a name. For example, ".temp".

- Do not use the following reserved names for the name of a file:
  - . (dot)
  - .. (dot dot)

- general term file to encompass both concepts of directories and data files
- The term path refers to one or more directories, backslashes, and possibly a volume name
- and drive letter, and colon, that uniquely identifies a file system object within a file system

#### [Fully Qualified vs Relative Paths](https://docs.microsoft.com/en-us/windows/win32/fileio/naming-a-file?source=docs#fully-qualified-vs-relative-paths)

- A fully qualified path starts with a drive letter followed by a colon, such as D:.
- A relative path does not start with a drive letter or a colon. Instead, it starts with a file name or a directory name. For example, the path "temp\readme.txt" is a relative path. The path "D:temp\readme.txt" is a fully qualified path.

- A relative path is relative to the current drive and directory. The current drive and directory can be changed at the command prompt. For example, if the current drive and directory are C:\Windows, the relative path "temp\readme.txt" refers to C:\Windows\temp\readme.txt.

- A fully qualified path always contains the root element and the complete directory list required to locate the file. For example, the fully qualified path "C:\Windows\temp\readme.txt" starts with the root element (C:) and contains the complete directory list required to locate the file.

file names can often be relative to the current directory, while some APIs require a fully qualified path. A file name is relative to the current directory if it does not begin with one of the following:

- A UNC name of any format, which always start with two backslash characters ("\\"). For more information, see [UNC Names](https://docs.microsoft.com/en-us/windows/win32/fileio/naming-a-file?source=docs#unc-names).
- A disk designator with a backslash, for example "C:\" or "d:\".
- A single backslash, for example, "\directory" or "\file.txt". This is also referred to as an absolute path.

If a file name begins with only a disk designator but not the backslash after the colon, it is interpreted as a relative path to the current directory on the drive with the specified letter. Note that the current directory may or may not be the root directory depending on what it was set to during the most recent "change directory" operation on that disk. Examples of this format are as follows:

    "C:tmp.txt" refers to a file named "tmp.txt" in the current directory on drive C.
    "C:tempdir\tmp.txt" refers to a file in a subdirectory to the current directory on drive C.

A path is also said to be relative if it contains "double-dots"; that is, two periods together in one component of the path. This special specifier is used to denote the directory above the current directory, otherwise known as the "parent directory". Examples of this format are as follows:

    "..\tmp.txt" specifies a file named tmp.txt located in the parent of the current directory.
    "..\..\tmp.txt" specifies a file that is two directories above the current directory.
    "..\tempdir\tmp.txt" specifies a file named tmp.txt located in a directory named tempdir that is a peer directory to the current directory.

Relative paths can combine both example types, for example "C:..\tmp.txt". This is useful because, although the system keeps track of the current drive along with the current directory of that drive, it also keeps track of the current directories in each of the different drive letters (if your system has more than one), regardless of which drive designator is set as the current drive. This allows you to change drives and move to a directory on that drive in one operation. For example, the following sequence of operations is valid:

    C:\>cd \windows
    C:\WINDOWS>cd \temp
    C:\TEMP>cd d:\docs
    D:\DOCS>cd \windows
    D:\WINDOWS>cd \temp
    D:\TEMP>cd c:\windows
    C:\WINDOWS>

[Maximum Path Length Limitation](https://learn.microsoft.com/en-us/windows/win32/fileio/naming-a-file?source=docs#maximum-path-length-limitation)

In editions of Windows before Windows 10 version 1607, the maximum length for a path is MAX_PATH, which is defined as 260 characters. In later versions of Windows, changing a registry key or using the Group Policy tool is required to remove the limit. See [Maximum Path Length Limitation](https://learn.microsoft.com/en-us/windows/win32/fileio/maximum-file-path-limitation) for full details.

Namespace hierarchy

- NT (lowers level namespace), on which other subsystems and namespaces could exist, including:
  - Win32 subsystem, which includes the Win32 namespace
  - POSIX subsystem

Early versions of Windows also defined several predefined, or reserved, names for certain special devices such as communications (serial and parallel) ports and the default display console as part of what is now called the NT device namespace, and are still supported in current versions of Windows for backward compatibility.

Win32 File Namespaces

For file I/O, the "\\?\" prefix to a path string tells the Windows APIs to disable all string parsing and to send the string that follows it straight to the file system. For example, if the file system supports large paths and file names, you can exceed the MAX_PATH limits that are otherwise enforced by the Windows APIs.

Because it turns off automatic expansion of the path string, the "\\?\" prefix also allows the use of ".." and "." in the path names, which can be useful if you are attempting to perform operations on a file with these otherwise reserved relative path specifiers as part of the fully qualified path.

Note that Unicode APIs should be used to make sure the "\\?\" prefix allows you to exceed the MAX_PATH limit. For example, "\\?\D:\very long path".

Win32 Device Namespaces

The "\\.\" prefix will access the Win32 device namespace instead of the Win32 file namespace. This is how access to physical disks and volumes is accomplished directly, without going through the file system, You can access many devices other than disks this way (using the CreateFile and DefineDosDevice functions, for example).

Another example of using the Win32 device namespace is using the CreateFile function with "\\.\PhysicalDriveX" (where X is a valid integer value) or "\\.\CdRomX". This allows you to access those devices directly, bypassing the file system. This works because these device names are created by the system as these devices are enumerated, and some drivers will also create other aliases in the system. For example, the device driver that implements the name "C:\" has its own namespace that also happens to be the file system.

If you're working with Windows API functions, you should use the "\\.\" prefix to access devices only and not files.

Most APIs won't support "\\.\"; only those that are designed to work with the device namespace will recognize it. Always check the reference topic for each API to be sure.

NT Namespaces

using the Windows Sysinternals WinObj tool. When you run this tool, what you see is the NT namespace beginning at the root, or "\". The subfolder called "Global??" is where the Win32 namespace resides. Named device objects reside in the NT namespace within the "Device" subdirectory. Here you may also find Serial0 and Serial1, the device objects representing the first two COM ports if present on your system. A device object representing a volume would be something like "HarddiskVolume1", although the numeric suffix may vary. The name "DR0" under subdirectory "Harddisk0" is an example of the device object representing a disk, and so on.

o make these device objects accessible by Windows applications, the device drivers create a symbolic link (symlink) in the Win32 namespace, "Global??", to their respective device objects. For example, COM0 and COM1 under the "Global??" subdirectory are simply symlinks to Serial0 and Serial1, "C:" is a symlink to HarddiskVolume1, "Physicaldrive0" is a symlink to DR0, and so on. Without a symlink, a specified device "Xxx" will not be available to any Windows application using Win32 namespace conventions as described previously. However, a handle could be opened to that device using any APIs that support the NT namespace absolute path of the format "\Device\Xxx".

With the addition of multi-user support via Terminal Services and virtual machines, it has further become necessary to virtualize the system-wide root device within the Win32 namespace. This was accomplished by adding the symlink named "GLOBALROOT" to the Win32 namespace, which you can see in the "Global??" subdirectory of the WinObj browser tool previously discussed, and can access via the path "\\?\GLOBALROOT". This prefix ensures that the path following it looks in the true root path of the system object manager and not a session-dependent path.

### File System Functionality Comparison

<https://learn.microsoft.com/en-us/windows/win32/fileio/filesystem-functionality-comparison>

the four main Windows file systems, NTFS, exFAT, UDF, and FAT32:

case sensitivity

- ntfs: yes
- exfat: no
- udf: yes
- fat32: no

mount point support

- ntfs: yes

Limits:

max file name lenth:

- ntfs: 255 unicode characters
- exfat: 255 unicode characters
- udf: 127 unicode characters, or 254 ascii characters
- fat32: 255 unicode characters

max path length:
32,767 unicode characters, with each path component no more than 255 characters

Naming Conventions

The following fundamental rules enable applications to create and process valid names for files and directories, regardless of the file system:

    Use a period to separate the base file name from the extension in the name of a directory or file.

    Use a backslash (\) to separate the components of a path. The backslash divides the file name from the path to it, and one directory name from another directory name in a path. You cannot use a backslash in the name for the actual file or directory because it is a reserved character that separates the names into components.

    Use a backslash as required as part of volume names, for example, the "C:\" in "C:\path\file" or the "\\server\share" in "\\server\share\path\file" for Universal Naming Convention (UNC) names. For more information about UNC names, see the Maximum Path Length Limitation section.

    Do not assume case sensitivity. For example, consider the names OSCAR, Oscar, and oscar to be the same, even though some file systems (such as a POSIX-compliant file system) may consider them as different. Note that NTFS supports POSIX semantics for case sensitivity but this is not the default behavior. For more information, see CreateFile.

    Volume designators (drive letters) are similarly case-insensitive. For example, "D:\" and "d:\" refer to the same volume.

    Use any character in the current code page for a name, including Unicode characters and characters in the extended character set (128–255), except for the following:

        The following reserved characters:
            < (less than)
            > (greater than)
            : (colon)
            " (double quote)
            / (forward slash)
            \ (backslash)
            | (vertical bar or pipe)
            ? (question mark)
            * (asterisk)

        Integer value zero, sometimes referred to as the ASCII NUL character.

        Characters whose integer representations are in the range from 1 through 31, except for alternate data streams where these characters are allowed. For more information about file streams, see File Streams.

        Any other character that the target file system does not allow.

    Use a period as a directory component in a path to represent the current directory, for example ".\temp.txt". For more information, see Paths.

    Use two consecutive periods (..) as a directory component in a path to represent the parent of the current directory, for example "..\temp.txt". For more information, see Paths.

    Do not use the following reserved names for the name of a file:

    CON, PRN, AUX, NUL, COM0, COM1, COM2, COM3, COM4, COM5, COM6, COM7, COM8, COM9, LPT0, LPT1, LPT2, LPT3, LPT4, LPT5, LPT6, LPT7, LPT8, and LPT9. Also avoid these names followed immediately by an extension; for example, NUL.txt and NUL.tar.gz are both equivalent to NUL. For more information, see Namespaces.

    Do not end a file or directory name with a space or a period. Although the underlying file system may support such names, the Windows shell and user interface does not. However, it is acceptable to specify a period as the first character of a name. For example, ".temp".

Short vs. Long Names

A long file name is considered to be any file name that exceeds the short MS-DOS (also called 8.3) style naming convention. When you create a long file name, Windows may also create a short 8.3 form of the name, called the 8.3 alias or short name, and store it on disk also. This 8.3 aliasing can be disabled for performance reasons either systemwide or for a specified volume, depending on the particular file system.

Windows Server 2008, Windows Vista, Windows Server 2003 and Windows XP: 8.3 aliasing cannot be disabled for specified volumes until Windows 7 and Windows Server 2008 R2.

On many file systems, a file name will contain a tilde (~) within each component of the name that is too long to comply with 8.3 naming rules.

Note

Not all file systems follow the tilde substitution convention, and systems can be configured to disable 8.3 alias generation even if they normally support it. Therefore, do not make the assumption that the 8.3 alias already exists on-disk.

To request 8.3 file names, long file names, or the full path of a file from the system, consider the following options:

    To get the 8.3 form of a long file name, use the GetShortPathName function.
    To get the long file name version of a short name, use the GetLongPathName function.
    To get the full path to a file, use the GetFullPathName function.

On newer file systems, such as NTFS, exFAT, UDFS, and FAT32, Windows stores the long file names on disk in Unicode, which means that the original long file name is always preserved. This is true even if a long file name contains extended characters, regardless of the code page that is active during a disk read or write operation.

Files using long file names can be copied between NTFS file system partitions and Windows FAT file system partitions without losing any file name information. This may not be true for the older MS-DOS FAT and some types of CDFS (CD-ROM) file systems, depending on the actual file name. In this case, the short file name is substituted if possible.

Paths

The path to a specified file consists of one or more components, separated by a special character (a backslash), with each component usually being a directory name or file name, but with some notable exceptions discussed below. It is often critical to the system's interpretation of a path what the beginning, or prefix, of the path looks like. This prefix determines the namespace the path is using, and additionally what special characters are used in which position within the path, including the last character.

If a component of a path is a file name, it must be the last component.

Each component of a path will also be constrained by the maximum length specified for a particular file system. In general, these rules fall into two categories: short and long. Note that directory names are stored by the file system as a special type of file, but naming rules for files also apply to directory names. To summarize, a path is simply the string representation of the hierarchy between all of the directories that exist for a particular file or directory name.

Fully Qualified vs. Relative Paths

For Windows API functions that manipulate files, file names can often be relative to the current directory, while some APIs require a fully qualified path. A file name is relative to the current directory if it does not begin with one of the following:

    A UNC name of any format, which always start with two backslash characters ("\\"). For more information, see the next section.
    A disk designator with a backslash, for example "C:\" or "d:\".
    A single backslash, for example, "\directory" or "\file.txt". This is also referred to as an absolute path.

If a file name begins with only a disk designator but not the backslash after the colon, it is interpreted as a relative path to the current directory on the drive with the specified letter. Note that the current directory may or may not be the root directory depending on what it was set to during the most recent "change directory" operation on that disk. Examples of this format are as follows:

    "C:tmp.txt" refers to a file named "tmp.txt" in the current directory on drive C.
    "C:tempdir\tmp.txt" refers to a file in a subdirectory to the current directory on drive C.

A path is also said to be relative if it contains "double-dots"; that is, two periods together in one component of the path. This special specifier is used to denote the directory above the current directory, otherwise known as the "parent directory". Examples of this format are as follows:

    "..\tmp.txt" specifies a file named tmp.txt located in the parent of the current directory.
    "..\..\tmp.txt" specifies a file that is two directories above the current directory.
    "..\tempdir\tmp.txt" specifies a file named tmp.txt located in a directory named tempdir that is a peer directory to the current directory.

Relative paths can combine both example types, for example "C:..\tmp.txt". This is useful because, although the system keeps track of the current drive along with the current directory of that drive, it also keeps track of the current directories in each of the different drive letters (if your system has more than one), regardless of which drive designator is set as the current drive.

| partial path string | possible meaning |
| --- | --- |
| starts with `.` | the current directory |
| starts with `..` | the parent directory |
| starts with `\` | the root directory on the current drive |
| starts with `\\` | is
| \ | the root directory on the current drive |
| C:\ | the root directory on drive C: |
| .temp | a file named ".temp" in the current directory |

<!-- ============== -->

<https://ziglang.org/documentation/master/#toc-embedFile>

@embedFile §

@embedFile(comptime path: []const u8) *const [N:0]u8

This function returns a compile time constant pointer to null-terminated, fixed-size array with length equal to the byte count of the file given by path. The contents of the array are the contents of the file. This is equivalent to a string literal with the file contents.

path is absolute or relative to the current file, just like @import.

<!-- ============== -->

<https://ziglang.org/documentation/master/#toc-import>

@import §

@import(comptime path: []const u8) type

This function finds a zig file corresponding to path and adds it to the build, if it is not already added.

Zig source files are implicitly structs, with a name equal to the file's basename with the extension truncated. @import returns the struct type corresponding to the file.

Declarations which have the pub keyword may be referenced from a different source file than the one they are declared in.

path can be a relative path or it can be the name of a package. If it is a relative path, it is relative to the file that contains the @import function call.

The following packages are always available:

    @import("std") - Zig Standard Library
    @import("builtin") - Target-specific information The command zig build-exe --show-builtin outputs the source to stdout for reference.
    @import("root") - Root source file This is usually src/main.zig but depends on what file is built.

<!-- ============== -->

<https://ziglang.org/documentation/master/#toc-Merging-Error-Sets>

Merging Error Sets §

Use the || operator to merge two error sets together. The resulting error set contains the errors of both error sets. Doc comments from the left-hand side override doc comments from the right-hand side. In this example, the doc comments for C.PathNotFound is A doc comment.

This is especially useful for functions which return different error sets depending on comptime branches. For example, the Zig standard library uses LinuxFileOpenError || WindowsFileOpenError for the error set of opening files.
