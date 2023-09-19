const std = @import("std");
const c = @import("c.zig");

/// TTypes etc. (imported)
const TT = @import("TT.zig").TT;

//debug
const assert = std.debug.assert;
const print = std.debug.print;
const panic = std.debug.panic;

// testing
const expect = std.testing.expect;

//=============================================================================
// Shaders stuffs
//
// inspired by: https://github.com/tiehuis/zstack/blob/master/src/window_gl.zig

pub const Options = struct {
    width: c_int = 640,
    height: c_int = 480,
    render_3d: bool = false,
    render_lighting: bool = false,
    debug: bool = true,
};

// Name with underlying c.GLenum (c_uint), which refers to a shader type
const ShaderSymName = enum(c.GLenum) {
    Vertex = c.GL_VERTEX_SHADER,
    Fragment = c.GL_FRAGMENT_SHADER,
    Geometry = c.GL_GEOMETRY_SHADER, // unused for now
};

const ShaderObject = struct {
    id: c.GLuint,
    type: Gl.Shader,
};

// Aliases for readability
const ShaderId = c.GLuint;

//-----------------------------------------------------------------------------

const ShaderOrProgramEnum = enum {
    Shader,
    Program,
};

const ShaderOrProgramUnion = union(ShaderOrProgramEnum) {
    Shader,
    Program,
};

const sh = ShaderOrProgramUnion{.Shader};
const glThing: ShaderOrProgramUnion.Shader = undefined;

//-----------------------------------------------------------------------------

pub const Gl = union { // enum - no root level val, needs a .
    Shader: Shader,
    Program: Program,

    // Shader Type
    pub const Shader = union { // union => can be 1 of:
        Vertex: Vertex,
        Fragment: Fragment,
        Geometry: Geometry,

        pub const Vertex = struct {
            // v: c_int = 1, // <- field only for testing/debugging
        };
        pub const Fragment = struct {
            // f: c_int = 2, // <- field only for testing/debugging
        };
        pub const Geometry = struct {
            // g: c_int = 3, // <- field only for testing/debugging
        };
    };

    // pub const Shader = struct { // has all at same time
    //     Vertex: Vertex,
    //     Fragment: Fragment,
    //     Geometry: Geometry,

    //     pub const Vertex = struct {};
    //     pub const Fragment = struct {};
    //     pub const Geometry = struct {};
    // };
    pub const Program = struct {};
};

const aa: Gl = undefined; // a GL can be a Shader or Program

const bb0: Gl.Shader = undefined; // a GL.Shader can be a Vertex, Fragment, or Geometry
const bb1: Gl.Shader = Gl.Shader{.Vertex};

const cc: Gl.Shader = undefined;

// pub const Gl = enum(ShaderOrProgramEnum) { // enum - no root level val, needs a .
//     Shader = Shader,
//     Program = Program,

//     pub const Shader = struct { // has all at same time
//         Vertex: Vertex,
//         Fragment: Fragment,
//         Geometry: Geometry,

//         pub const Vertex = struct {};
//         pub const Fragment = struct {};
//         pub const Geometry = struct {};
//     };
//     pub const Program = struct {};
// };

// pub const Gl = struct { // has all at same time
//     Shader: Shader,
//     Program: Program,

//     pub const Shader = struct { has all at same time
//         Vertex :Vertex,
//         Fragment :Fragment,
//         Geometry :Geometry,

//         pub const Vertex = struct {};
//         pub const Fragment = struct {};
//         pub const Geometry = struct {};

//     };
//     pub const Program = struct {};
// };

const thingOfType_Glx: ShaderSymName = ShaderSymName;
const thingOfType_Gl: Gl = Gl;
const thingOfType_GlShader: type = Gl.Shader;
const thingOfType_GlProgram: type = Gl.Program;

const ttt = Gl.Shader.Vertex;

const ShaderParam = enum(c.GLuint) {
    ShaderType = c.GL_SHADER_TYPE,
    DeleteStatus = c.GL_DELETE_STATUS,
    CompileStatus = c.GL_COMPILE_STATUS,
    InfoLogLength = c.GL_INFO_LOG_LENGTH,
    ShaderSourceLength = c.GL_SHADER_SOURCE_LENGTH,
};

const MaybeShaderId = TT.Maybe(ShaderId);

/// you need to call `defer deleteShader()` on the returned shaderId
pub fn createShader(shaderType: Gl.Shader, source: TT.String) !ShaderId {
    const shaderId = c.glCreateShader(shaderType);
    if (shaderId) |id| {
        if (id > 0) {

            // success

            c.glShaderSource(shaderId, 1, &source, null);
            c.glCompileShader(shaderId);

            try checkShader(shaderId, ShaderParam.CompileStatus);

            // TODO if above 2 steps fail, delete shader and return error

            return shaderId;
        } else {
            // glCreateShader() returned 0
            return error.Unknown;
        }
    } else |err| {
        _ = err;
        // glCreateShader() failed
        return error.Unknown;
    }
    unreachable;
}

pub fn deleteShader(shaderId: ShaderId) void {
    c.glDeleteShader(shaderId);
}

//=============================================================================

// debug helpers
const Name = @import("debug_helpers.zig").DotNotation;
const CFS = @import("build_helpers.zig").CFS;

fn shadersInit(options: Options) !void {
    std.debug.print("[{s}] ..\n", .{Name.ofFunction(shadersInit).full()});
    defer std.debug.print("[{s}] done.\n", .{Name.ofFunction(shadersInit).full()});

    // # VERTEX SHADER
    const cfs = CFS.atComptime();
    // const vertextShaderSource = @embedFile("./shaders/shader.vert");
    const vertextShaderSource = cfs.readFile("./shaders/shader.vert");

    std.debug.print("[file] Data:\n{s}", .{vertextShaderSource});

    const vertexShaderId = try c.glCreateShader(c.GL_VERTEX_SHADER);
    errdefer c.glDeleteShader(vertexShaderId);
    c.glShaderSource(vertexShaderId, 1, &vertextShaderSource, null);
    c.glCompileShader(vertexShaderId);
    try checkShader(vertexShaderId, c.GL_COMPILE_STATUS);

    // # FRAGMENT SHADER
    const fragmentShaderSource = @embedFile("./shaders/shader.frag");
    const fragmentShaderId = c.glCreateShader(c.GL_FRAGMENT_SHADER);
    errdefer c.glDeleteShader(fragmentShaderId);
    c.glShaderSource(fragmentShaderId, 1, &fragmentShaderSource, null);
    c.glCompileShader(fragmentShaderId);
    try checkShader(fragmentShaderId, c.GL_COMPILE_STATUS);

    // # SHADER PROGRAM
    var programId: c_uint = undefined;
    programId = c.glCreateProgram();
    errdefer c.glDeleteProgram(programId);

    c.glAttachShader(programId, vertexShaderId);
    c.glAttachShader(programId, fragmentShaderId);
    c.glLinkProgram(programId);
    try checkProgram(programId, c.GL_LINK_STATUS);
    c.glUseProgram(programId);

    // vertex shader
    var attr_position = try getAttribute(programId, "position");
    var attr_face_normal = try getAttribute(programId, "faceNormal");
    var uniform_offset = try getUniform(programId, "offset");
    _ = uniform_offset;
    var uniform_scale = try getUniform(programId, "scale");
    _ = uniform_scale;
    var uniform_viewport = try getUniform(programId, "viewport");

    // fragment shader
    var uniform_view_pos = try getUniform(programId, "viewPos");
    var uniform_surface_color = try getUniform(programId, "surfaceColor");
    _ = uniform_surface_color;
    var uniform_light_color = try getUniform(programId, "lightColor");
    var uniform_light_pos = try getUniform(programId, "lightPos");
    var uniform_enable_lighting = try getUniform(programId, "enableLighting");

    var vao_id: c_uint = undefined;
    var vbo_id: c_uint = undefined;

    // Our offsets are percentages so assume a (0, 1) coordinate system.
    // Also includes face normals. TODO: orient so front-facing correctly.
    // (x, y, z, N_x, N_y, N_z),
    const vertices = [_]c.GLfloat{
        // Face 1 (Front)
        0, 0, 0, 0,  0,  -1,
        0, 1, 0, 0,  0,  -1,
        1, 0, 0, 0,  0,  -1,
        1, 0, 0, 0,  0,  -1,
        0, 1, 0, 0,  0,  -1,
        1, 1, 0, 0,  0,  -1,
        // Face 2 (Rear)
        0, 0, 1, 0,  0,  1,
        1, 0, 1, 0,  0,  1,
        1, 1, 1, 0,  0,  1,
        1, 1, 1, 0,  0,  1,
        0, 1, 1, 0,  0,  1,
        1, 1, 1, 0,  0,  1,
        // Face 3 (Left)
        0, 0, 0, -1, 0,  0,
        0, 1, 0, -1, 0,  0,
        0, 0, 1, -1, 0,  0,
        0, 0, 1, -1, 0,  0,
        0, 1, 0, -1, 0,  0,
        0, 1, 1, -1, 0,  0,
        // Face 4 (Right)
        1, 0, 0, 1,  0,  0,
        1, 1, 0, 1,  0,  0,
        1, 0, 1, 1,  0,  0,
        1, 0, 1, 1,  0,  0,
        1, 1, 0, 1,  0,  0,
        1, 1, 1, 1,  0,  0,
        // Face 5 (Bottom)
        0, 0, 0, 0,  -1, 0,
        0, 0, 1, 0,  -1, 0,
        1, 0, 0, 0,  -1, 0,
        1, 0, 0, 0,  -1, 0,
        1, 0, 0, 0,  -1, 0,
        1, 0, 1, 0,  -1, 0,
        // Face 6 (Top)
        0, 1, 0, 0,  1,  0,
        0, 1, 1, 0,  1,  0,
        1, 1, 0, 0,  1,  0,
        1, 1, 0, 0,  1,  0,
        1, 1, 0, 0,  1,  0,
        1, 1, 1, 0,  1,  0,
    };

    // # VERTEX ARRAYS
    c.glGenVertexArrays(1, &vao_id);
    errdefer c.glDeleteVertexArrays(1, &vao_id);

    // # BUFFERS
    c.glGenBuffers(1, &vbo_id);
    errdefer c.glDeleteBuffers(1, &vbo_id);

    c.glBindVertexArray(vao_id);
    c.glBindBuffer(c.GL_ARRAY_BUFFER, vbo_id);
    c.glBufferData(c.GL_ARRAY_BUFFER, vertices.len * @sizeOf(c.GLfloat), &vertices[0], c.GL_STATIC_DRAW);

    c.glVertexAttribPointer(attr_position, 3, c.GL_FLOAT, c.GL_FALSE, 6 * @sizeOf(c.GLfloat), null);
    c.glEnableVertexAttribArray(attr_position);
    c.glVertexAttribPointer(attr_face_normal, 3, c.GL_FLOAT, c.GL_FALSE, 6 * @sizeOf(c.GLfloat), null);
    c.glEnableVertexAttribArray(attr_face_normal);

    // Always bound, only use the one vertex array
    c.glBindVertexArray(vao_id);

    // Fixed viewport for now
    if (options.render_3d) {
        const viewport = [_]f32{
            1, 0, 0.5, 0,
            0, 1, 0.3, 0,
            0, 0, 1,   0,
            0, 0, 0,   1,
        };
        c.glUniformMatrix4fv(uniform_viewport, 1, c.GL_FALSE, &viewport[0]);
    } else {
        const viewport = [_]f32{
            1, 0, 0, 0,
            0, 1, 0, 0,
            0, 0, 1, 0,
            0, 0, 0, 1,
        };
        c.glUniformMatrix4fv(uniform_viewport, 1, c.GL_FALSE, &viewport[0]);
    }

    // Fixed light color for now
    c.glUniform3f(uniform_light_color, 0.5, 0.5, 0.5);
    c.glUniform3f(uniform_light_pos, 0.5, 0.5, 0.5);

    // Fixed camera position
    c.glUniform3f(uniform_view_pos, 0.5, 0.5, 0.5);

    // Enable lighting
    c.glUniform1i(uniform_enable_lighting, @as(c_int, options.render_lighting));
}

// pub fn shaderDeinit() void {
//     c.glDeleteProgram(program_id);
//     c.glDeleteShader(fragment_shader_id);
//     c.glDeleteShader(vertex_shader_id);
//     c.glDeleteBuffers(1, &vbo_id);
//     c.glDeleteVertexArrays(1, &vao_id);
// }

fn printShaderInfoLog(shaderId: ShaderId) !void {
    const ResultLengh_DontCare = comptime null;
    var infoLog = [_]u8{0} ** 512;

    // Returns the information log for a shader object (https://docs.gl/es3/glGetShaderInfoLog)
    c.glGetShaderInfoLog(shaderId, infoLog.len, ResultLengh_DontCare, &infoLog[0]);

    std.debug.print("{}\n", infoLog[0..]);
}

fn checkShader(shaderId: ShaderId, paramName: ShaderParam) !void {
    var paramValue: c_int = undefined;

    // Returns a parameter from a shader object (https://docs.gl/es3/glGetShaderiv)
    c.glGetShaderiv(shaderId, paramName, &paramValue);

    switch (paramName) {
        .ShaderType => return error.NotImplemented,
        .DeleteStatus => return error.NotImplemented,
        .CompileStatus => {
            if (paramValue == c.GL_TRUE) {
                // the last compile operation on shader was successful
                return void;
            } else {
                // the last compile operation on shader was not successful
                printShaderInfoLog(shaderId);
                return error.GlShaderError;
            }
            unreachable;
        },
        .InfoLogLength => return error.NotImplemented,
        .ShaderSourceLength => return error.NotImplemented,
        else => unreachable,
    }
    unreachable;
}

// helper from: https://github.com/tiehuis/zstack/blob/master/src/window_gl.zig
// not sure what it does
fn checkProgram(program: c_uint, pname: c_uint) !void {
    var status: c_int = undefined;
    var buffer = [_]u8{0} ** 512;

    c.glGetProgramiv(program, pname, &status);
    if (status != c.GL_TRUE) {
        c.glGetProgramInfoLog(program, buffer.len - 1, null, &buffer[0]);
        std.debug.warn("{}\n", buffer[0..]);
        return error.GlProgramError;
    }
}

// helper from: https://github.com/tiehuis/zstack/blob/master/src/window_gl.zig
// not sure what it does
fn getAttribute(id: c_uint, name: [*c]const u8) !c_uint {
    const attr_id = c.glGetAttribLocation(id, name);
    if (attr_id == -1) {
        return error.GlAttribError;
    }
    return @as(c_uint, attr_id);
}

// helper from: https://github.com/tiehuis/zstack/blob/master/src/window_gl.zig
// not sure what it does
fn getUniform(id: c_uint, name: [*c]const u8) !c_int {
    const uniform_id = c.glGetUniformLocation(id, name);
    if (uniform_id == -1) {
        return error.GlUniformError;
    }
    return uniform_id;
}
