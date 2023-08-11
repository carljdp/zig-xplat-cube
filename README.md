
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
zig build run
```

## Prerequisites / Dependencies
- `zig`
- `vcpkg` - for installing `glfw` on windows
- `glfw` - for windowing and opengl context
  - I have not yet decided between `glad` and `glew` for opengl loading. I'm currently using `glad` because it seems to be the more modern of the two.
    - `glfw` is a C library, so we need to use `c_import` to use it in Zig.


# Project Conventions

## Structure

- `src/` - zig source files
- `src/main.zig` - main entry point
- `build.zig` - zig build config

## Configuration

- `.env` - nothing here yet
- `.env.example` - nothing here yet

# Other Stuff

## Disclaimer & Acknowledgements
Used paid versions of both ChatGPT and GitHub Copilot

## License
// TODO: choose license
