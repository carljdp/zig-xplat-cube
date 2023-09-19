
# zig-xplat-cube

A Zig based attempt to rotate a cube on multiple platforms.

## Rationale

I want to learn Zig, and I want to learn how to make cross platform applications. I also want to learn how to make 3D graphics. This project is an attempt to do all of those things at once.

## Description

// TODO: add more detailed description

## Table of Contents

// TODO: add table of contents

# Developer Guide

## Quickstart

```shell
git clone https://github.com/carljdp/zig-xplat-cube.git
cd zig-xplat-cube
zig build run -Dtarget=x86_64-windows-msvc 
```

If you want to *see* the tests pass:

```shell
zig build test --summary all
```

## Prerequisites / Dependencies

- `zig`
- `vcpkg` - for installing `glfw` on windows
- `glfw` - for windowing and opengl context
  - I have not yet decided between `glad` and `glew` for opengl loading. I'm currently using `glad` because it seems to be the more modern of the two.
    - `glfw` is a C library, so we need to use `c_import` to use it in Zig.


### dependencies used by vscode extentions

- ZLS [pre-built binary](https://install.zigtools.org/)
- GLSLang [pre-built binary](https://github.com/KhronosGroup/glslang/releases)

# Project Conventions

## Structure

- `src/` - zig source files
- `src/main.zig` - main entry point
- `build.zig` - zig build config

## Configuration

- `.env` - nothing here yet
- `.env.example` - nothing here yet

# Other Stuff

## on windows

### dependencies

you need to install extarnal dependencies with `vcpkg`:

```shell
# prior to spet 2023, you might need to use a --triplet flag, unless you want x86
vcpkg install glfw3:x64-windows
```

initially i installed with `vcpkg install glfw3`, which only provided `glfw3dll.lib`, but i needed `glfw3.lib` for static linking. 
?? => i had to uninstall and reinstall with `vcpkg install glfw3:x64-windows-static` to get the static lib. ??

- `glfw3:x64-windows`
- `glfw3:x64-windows-static` ???
- `opengl:x64-windows` ???
- `libepoxy:x64-windows` ???

<!-- - `glew:x64-windows`
- `glad:x64-windows` -->

<!-- - `stb:x64-windows`
- `fmt:x64-windows` -->

<!-- - `imgui:x64-windows`
- `imgui[glfw-binding]:x64-windows`
- `imgui[opengl3-glad-binding]:x64-windows`
- `imgui[opengl3-glew-binding]:x64-windows`
- `imgui[opengl3-glfw-binding]:x64-windows`
- `imgui[opengl3-binding]:x64-windows`
- `imgui[opengl2-binding]:x64-windows`
- `imgui[dx11-binding]:x64-windows`
- `imgui[dx12-binding]:x64-windows`
- `imgui[vulkan-binding]:x64-windows`
- `imgui[metal-binding]:x64-windows`
- `imgui[examples]:x64-windows`
- `imgui[tools]:x64-windows`
- `imgui[metrics]:x64-windows`
- `imgui[docking]:x64-windows`
- `imgui[tables]:x64-windows`
- `imgui[viewport]:x64-windows` -->

### terminal character encoding

for some reason my PS char encoding was `Code Page 437` (OEM United States), so i had to set PS encoding to UTF-8 with `chcp 65001` to get the unicode characters to display properly in the terminal

```powershell
# check current encoding
[Console]::OutputEncoding

# set encoding to UTF-8
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8
```

## Disclaimer & Acknowledgements

Used paid versions of both ChatGPT and GitHub Copilot

## License

// TODO: choose license

## Building Dependencies

### GLFW

- Install MSYS2

In MSYS2 shell:

```shell
pacman -S --needed --noconfirm git
```

In MSYS2 shell:

```shell
pacman -S --needed --noconfirm mingw-w64-x86_64-toolchain mingw-w64-x86_64-cmake mingw-w64-x86_64-glfw
```

In any shell:

```shell
git clone https://github.com/glfw/glfw.git
cd glfw
```

In MSYS2 MinGW 64-bit shell:

```shell
mkdir build-mingw
cd build-mingw
rm -rf *
cmake -G "Unix Makefiles" ..
# cmake -G "Unix Makefiles" -DCMAKE_SYSTEM_NAME=Windows -DCMAKE_INSTALL_PREFIX=/path/to/install ..
make
make install
```
