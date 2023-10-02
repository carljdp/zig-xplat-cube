// generics
const std = @import("std");

/// Wrapper for OpenGL with remapped types and functions
pub fn remapped() type {
    return struct {
        const self = @This();
        const c = struct {
            usingnamespace @import("imports.zig");
        };

        // TYPES (partially renamed)
        pub const Bitfield = c.GLbitfield; // c_uint;
        pub const Boolean = c.GLboolean; // u8
        pub const Char = c.GLchar; // u8
        pub const Ubyte = c.GLubyte; // u8
        pub const Float = c.GLfloat; // f32
        pub const Enum = c.GLenum; // c_uint;
        pub const Void = c.GLvoid; // anyopaque
        pub const Int = c.GLint; // c_int;
        pub const Uint = c.GLuint; // c_uint;
        pub const Sizei = c.GLsizei;
        pub const Sizeiptr = c.GLsizeiptr;

        // TYPES (custom aliases)
        pub const Byte = u8;
        pub const cString = [*c]const Byte;
        pub const cStrings = [*c]const [*c]const Byte;

        pub const BOOL: Int = c.GL_BOOL; // enum type alias? val = 0x8B56
        pub const FLOAT: Int = c.GL_FLOAT;
        pub const UNSIGNED_INT: Int = c.GL_UNSIGNED_INT;

        pub const False: Int = c.GL_FALSE;
        pub const True: Int = c.GL_TRUE;
        pub const Zero: Int = c.GL_ZERO;

        // Straight-through constants

        // pub const ACTIVE_ATTRIBUTES: cInt = c.GL_ACTIVE_ATTRIBUTES;
        // pub const ACTIVE_ATTRIBUTE_MAX_LENGTH: cInt = c.GL_ACTIVE_ATTRIBUTE_MAX_LENGTH;
        // pub const ACTIVE_PROGRAM: cInt = c.GL_ACTIVE_PROGRAM;
        // pub const ACTIVE_SUBROUTINES: cInt = c.GL_ACTIVE_SUBROUTINES;
        // pub const ACTIVE_SUBROUTINE_MAX_LENGTH: cInt = c.GL_ACTIVE_SUBROUTINE_MAX_LENGTH;
        // pub const ACTIVE_SUBROUTINE_UNIFORMS: cInt = c.GL_ACTIVE_SUBROUTINE_UNIFORMS;
        // pub const ACTIVE_SUBROUTINE_UNIFORM_LOCATIONS: cInt = c.GL_ACTIVE_SUBROUTINE_UNIFORM_LOCATIONS;
        // pub const ACTIVE_SUBROUTINE_UNIFORM_MAX_LENGTH: cInt = c.GL_ACTIVE_SUBROUTINE_UNIFORM_MAX_LENGTH;
        // pub const ACTIVE_TEXTURE: cInt = c.GL_ACTIVE_TEXTURE;
        // pub const ACTIVE_UNIFORMS: cInt = c.GL_ACTIVE_UNIFORMS;
        // pub const ACTIVE_UNIFORM_BLOCKS: cInt = c.GL_ACTIVE_UNIFORM_BLOCKS;
        // pub const ACTIVE_UNIFORM_BLOCK_MAX_NAME_LENGTH: cInt = c.GL_ACTIVE_UNIFORM_BLOCK_MAX_NAME_LENGTH;
        // pub const ACTIVE_UNIFORM_MAX_LENGTH: cInt = c.GL_ACTIVE_UNIFORM_MAX_LENGTH;
        // pub const ALIASED_LINE_WIDTH_RANGE: cInt = c.GL_ALIASED_LINE_WIDTH_RANGE;
        // pub const ALL_SHADER_BITS: cInt = c.GL_ALL_SHADER_BITS;
        // pub const ALPHA: cInt = c.GL_ALPHA;
        // pub const ALREADY_SIGNALED: cInt = c.GL_ALREADY_SIGNALED;
        // pub const ALWAYS: cInt = c.GL_ALWAYS;
        // pub const AND: cInt = c.GL_AND;
        // pub const AND_INVERTED: cInt = c.GL_AND_INVERTED;
        // pub const AND_REVERSE: cInt = c.GL_AND_REVERSE;
        // pub const ANY_SAMPLES_PASSED: cInt = c.GL_ANY_SAMPLES_PASSED;
        pub const ARRAY_BUFFER: Int = c.GL_ARRAY_BUFFER;
        // pub const ARRAY_BUFFER_BINDING: cInt = c.GL_ARRAY_BUFFER_BINDING;
        // pub const ATTACHED_SHADERS: cInt = c.GL_ATTACHED_SHADERS;
        // pub const BACK: cInt = c.GL_BACK;
        // pub const BACK_LEFT: cInt = c.GL_BACK_LEFT;
        // pub const BACK_RIGHT: cInt = c.GL_BACK_RIGHT;
        // pub const BGR: cInt = c.GL_BGR;
        // pub const BGRA: cInt = c.GL_BGRA;
        // pub const BGRA_INTEGER: cInt = c.GL_BGRA_INTEGER;
        // pub const BGR_INTEGER: cInt = c.GL_BGR_INTEGER;
        // pub const BLEND: cInt = c.GL_BLEND;
        // pub const BLEND_COLOR: cInt = c.GL_BLEND_COLOR;
        // pub const BLEND_DST: cInt = c.GL_BLEND_DST;
        // pub const BLEND_DST_ALPHA: cInt = c.GL_BLEND_DST_ALPHA;
        // pub const BLEND_DST_RGB: cInt = c.GL_BLEND_DST_RGB;
        // pub const BLEND_EQUATION: cInt = c.GL_BLEND_EQUATION;
        // pub const BLEND_EQUATION_ALPHA: cInt = c.GL_BLEND_EQUATION_ALPHA;
        // pub const BLEND_EQUATION_RGB: cInt = c.GL_BLEND_EQUATION_RGB;
        // pub const BLEND_SRC: cInt = c.GL_BLEND_SRC;
        // pub const BLEND_SRC_ALPHA: cInt = c.GL_BLEND_SRC_ALPHA;
        // pub const BLEND_SRC_RGB: cInt = c.GL_BLEND_SRC_RGB;
        // pub const BLUE: cInt = c.GL_BLUE;
        // pub const BLUE_INTEGER: cInt = c.GL_BLUE_INTEGER;

        // pub const BOOL_VEC2: cInt = c.GL_BOOL_VEC2;
        // pub const BOOL_VEC3: cInt = c.GL_BOOL_VEC3;
        // pub const BOOL_VEC4: cInt = c.GL_BOOL_VEC4;
        // pub const BUFFER_ACCESS: cInt = c.GL_BUFFER_ACCESS;
        // pub const BUFFER_ACCESS_FLAGS: cInt = c.GL_BUFFER_ACCESS_FLAGS;
        // pub const BUFFER_MAPPED: cInt = c.GL_BUFFER_MAPPED;
        // pub const BUFFER_MAP_LENGTH: cInt = c.GL_BUFFER_MAP_LENGTH;
        // pub const BUFFER_MAP_OFFSET: cInt = c.GL_BUFFER_MAP_OFFSET;
        // pub const BUFFER_MAP_POINTER: cInt = c.GL_BUFFER_MAP_POINTER;
        // pub const BUFFER_SIZE: cInt = c.GL_BUFFER_SIZE;
        // pub const BUFFER_USAGE: cInt = c.GL_BUFFER_USAGE;
        // pub const BYTE: cInt = c.GL_BYTE;
        // pub const CCW: cInt = c.GL_CCW;
        // pub const CLAMP_READ_COLOR: cInt = c.GL_CLAMP_READ_COLOR;
        // pub const CLAMP_TO_BORDER: cInt = c.GL_CLAMP_TO_BORDER;
        // pub const CLAMP_TO_EDGE: cInt = c.GL_CLAMP_TO_EDGE;
        // pub const CLEAR: cInt = c.GL_CLEAR;
        // pub const CLIP_DISTANCE0: cInt = c.GL_CLIP_DISTANCE0;
        // pub const CLIP_DISTANCE1: cInt = c.GL_CLIP_DISTANCE1;
        // pub const CLIP_DISTANCE2: cInt = c.GL_CLIP_DISTANCE2;
        // pub const CLIP_DISTANCE3: cInt = c.GL_CLIP_DISTANCE3;
        // pub const CLIP_DISTANCE4: cInt = c.GL_CLIP_DISTANCE4;
        // pub const CLIP_DISTANCE5: cInt = c.GL_CLIP_DISTANCE5;
        // pub const CLIP_DISTANCE6: cInt = c.GL_CLIP_DISTANCE6;
        // pub const CLIP_DISTANCE7: cInt = c.GL_CLIP_DISTANCE7;
        // pub const COLOR: cInt = c.GL_COLOR;
        // pub const COLOR_ATTACHMENT0: cInt = c.GL_COLOR_ATTACHMENT0;
        // pub const COLOR_ATTACHMENT1: cInt = c.GL_COLOR_ATTACHMENT1;
        // pub const COLOR_ATTACHMENT10: cInt = c.GL_COLOR_ATTACHMENT10;
        // pub const COLOR_ATTACHMENT11: cInt = c.GL_COLOR_ATTACHMENT11;
        // pub const COLOR_ATTACHMENT12: cInt = c.GL_COLOR_ATTACHMENT12;
        // pub const COLOR_ATTACHMENT13: cInt = c.GL_COLOR_ATTACHMENT13;
        // pub const COLOR_ATTACHMENT14: cInt = c.GL_COLOR_ATTACHMENT14;
        // pub const COLOR_ATTACHMENT15: cInt = c.GL_COLOR_ATTACHMENT15;
        // pub const COLOR_ATTACHMENT16: cInt = c.GL_COLOR_ATTACHMENT16;
        // pub const COLOR_ATTACHMENT17: cInt = c.GL_COLOR_ATTACHMENT17;
        // pub const COLOR_ATTACHMENT18: cInt = c.GL_COLOR_ATTACHMENT18;
        // pub const COLOR_ATTACHMENT19: cInt = c.GL_COLOR_ATTACHMENT19;
        // pub const COLOR_ATTACHMENT2: cInt = c.GL_COLOR_ATTACHMENT2;
        // pub const COLOR_ATTACHMENT20: cInt = c.GL_COLOR_ATTACHMENT20;
        // pub const COLOR_ATTACHMENT21: cInt = c.GL_COLOR_ATTACHMENT21;
        // pub const COLOR_ATTACHMENT22: cInt = c.GL_COLOR_ATTACHMENT22;
        // pub const COLOR_ATTACHMENT23: cInt = c.GL_COLOR_ATTACHMENT23;
        // pub const COLOR_ATTACHMENT24: cInt = c.GL_COLOR_ATTACHMENT24;
        // pub const COLOR_ATTACHMENT25: cInt = c.GL_COLOR_ATTACHMENT25;
        // pub const COLOR_ATTACHMENT26: cInt = c.GL_COLOR_ATTACHMENT26;
        // pub const COLOR_ATTACHMENT27: cInt = c.GL_COLOR_ATTACHMENT27;
        // pub const COLOR_ATTACHMENT28: cInt = c.GL_COLOR_ATTACHMENT28;
        // pub const COLOR_ATTACHMENT29: cInt = c.GL_COLOR_ATTACHMENT29;
        // pub const COLOR_ATTACHMENT3: cInt = c.GL_COLOR_ATTACHMENT3;
        // pub const COLOR_ATTACHMENT30: cInt = c.GL_COLOR_ATTACHMENT30;
        // pub const COLOR_ATTACHMENT31: cInt = c.GL_COLOR_ATTACHMENT31;
        // pub const COLOR_ATTACHMENT4: cInt = c.GL_COLOR_ATTACHMENT4;
        // pub const COLOR_ATTACHMENT5: cInt = c.GL_COLOR_ATTACHMENT5;
        // pub const COLOR_ATTACHMENT6: cInt = c.GL_COLOR_ATTACHMENT6;
        // pub const COLOR_ATTACHMENT7: cInt = c.GL_COLOR_ATTACHMENT7;
        // pub const COLOR_ATTACHMENT8: cInt = c.GL_COLOR_ATTACHMENT8;
        // pub const COLOR_ATTACHMENT9: cInt = c.GL_COLOR_ATTACHMENT9;

        /// used with `glClear`
        pub const COLOR_BUFFER_BIT: Int = c.GL_COLOR_BUFFER_BIT;

        // pub const COLOR_CLEAR_VALUE: cInt = c.GL_COLOR_CLEAR_VALUE;
        // pub const COLOR_LOGIC_OP: cInt = c.GL_COLOR_LOGIC_OP;
        // pub const COLOR_WRITEMASK: cInt = c.GL_COLOR_WRITEMASK;
        // pub const COMPARE_REF_TO_TEXTURE: cInt = c.GL_COMPARE_REF_TO_TEXTURE;
        // pub const COMPATIBLE_SUBROUTINES: cInt = c.GL_COMPATIBLE_SUBROUTINES;

        /// Shader compilation status
        pub const COMPILE_STATUS: Int = c.GL_COMPILE_STATUS;

        // pub const COMPRESSED_RED: cInt = c.GL_COMPRESSED_RED;
        // pub const COMPRESSED_RED_RGTC1: cInt = c.GL_COMPRESSED_RED_RGTC1;
        // pub const COMPRESSED_RG: cInt = c.GL_COMPRESSED_RG;
        // pub const COMPRESSED_RGB: cInt = c.GL_COMPRESSED_RGB;
        // pub const COMPRESSED_RGBA: cInt = c.GL_COMPRESSED_RGBA;
        // pub const COMPRESSED_RG_RGTC2: cInt = c.GL_COMPRESSED_RG_RGTC2;
        // pub const COMPRESSED_SIGNED_RED_RGTC1: cInt = c.GL_COMPRESSED_SIGNED_RED_RGTC1;
        // pub const COMPRESSED_SIGNED_RG_RGTC2: cInt = c.GL_COMPRESSED_SIGNED_RG_RGTC2;
        // pub const COMPRESSED_SRGB: cInt = c.GL_COMPRESSED_SRGB;
        // pub const COMPRESSED_SRGB_ALPHA: cInt = c.GL_COMPRESSED_SRGB_ALPHA;
        // pub const COMPRESSED_TEXTURE_FORMATS: cInt = c.GL_COMPRESSED_TEXTURE_FORMATS;
        // pub const CONDITION_SATISFIED: cInt = c.GL_CONDITION_SATISFIED;
        // pub const CONSTANT_ALPHA: cInt = c.GL_CONSTANT_ALPHA;
        // pub const CONSTANT_COLOR: cInt = c.GL_CONSTANT_COLOR;
        // pub const CONTEXT_COMPATIBILITY_PROFILE_BIT: cInt = c.GL_CONTEXT_COMPATIBILITY_PROFILE_BIT;
        // pub const CONTEXT_CORE_PROFILE_BIT: cInt = c.GL_CONTEXT_CORE_PROFILE_BIT;
        // pub const CONTEXT_FLAGS: cInt = c.GL_CONTEXT_FLAGS;
        // pub const CONTEXT_FLAG_FORWARD_COMPATIBLE_BIT: cInt = c.GL_CONTEXT_FLAG_FORWARD_COMPATIBLE_BIT;
        // pub const CONTEXT_PROFILE_MASK: cInt = c.GL_CONTEXT_PROFILE_MASK;
        // pub const COPY: cInt = c.GL_COPY;
        // pub const COPY_INVERTED: cInt = c.GL_COPY_INVERTED;
        // pub const COPY_READ_BUFFER: cInt = c.GL_COPY_READ_BUFFER;
        // pub const COPY_WRITE_BUFFER: cInt = c.GL_COPY_WRITE_BUFFER;
        pub const CULL_FACE: Int = c.GL_CULL_FACE;
        // pub const CULL_FACE_MODE: cInt = c.GL_CULL_FACE_MODE;
        // pub const CURRENT_PROGRAM: cInt = c.GL_CURRENT_PROGRAM;
        // pub const CURRENT_QUERY: cInt = c.GL_CURRENT_QUERY;
        // pub const CURRENT_VERTEX_ATTRIB: cInt = c.GL_CURRENT_VERTEX_ATTRIB;
        // pub const CW: cInt = c.GL_CW;
        // pub const DECR: cInt = c.GL_DECR;
        // pub const DECR_WRAP: cInt = c.GL_DECR_WRAP;
        // pub const DELETE_STATUS: cInt = c.GL_DELETE_STATUS;
        // pub const DEPTH: cInt = c.GL_DEPTH;
        // pub const DEPTH24_STENCIL8: cInt = c.GL_DEPTH24_STENCIL8;
        // pub const DEPTH32F_STENCIL8: cInt = c.GL_DEPTH32F_STENCIL8;
        // pub const DEPTH_ATTACHMENT: cInt = c.GL_DEPTH_ATTACHMENT;

        /// used with `glClear`
        pub const DEPTH_BUFFER_BIT: Int = c.GL_DEPTH_BUFFER_BIT;

        // pub const DEPTH_CLAMP: cInt = c.GL_DEPTH_CLAMP;
        // pub const DEPTH_CLEAR_VALUE: cInt = c.GL_DEPTH_CLEAR_VALUE;
        // pub const DEPTH_COMPONENT: cInt = c.GL_DEPTH_COMPONENT;
        // pub const DEPTH_COMPONENT16: cInt = c.GL_DEPTH_COMPONENT16;
        // pub const DEPTH_COMPONENT24: cInt = c.GL_DEPTH_COMPONENT24;
        // pub const DEPTH_COMPONENT32: cInt = c.GL_DEPTH_COMPONENT32;
        // pub const DEPTH_COMPONENT32F: cInt = c.GL_DEPTH_COMPONENT32F;
        // pub const DEPTH_FUNC: cInt = c.GL_DEPTH_FUNC;
        // pub const DEPTH_RANGE: cInt = c.GL_DEPTH_RANGE;
        // pub const DEPTH_STENCIL: cInt = c.GL_DEPTH_STENCIL;
        // pub const DEPTH_STENCIL_ATTACHMENT: cInt = c.GL_DEPTH_STENCIL_ATTACHMENT;
        pub const DEPTH_TEST: Int = c.GL_DEPTH_TEST; // glEnable()
        // pub const DEPTH_WRITEMASK: cInt = c.GL_DEPTH_WRITEMASK;
        // pub const DITHER: cInt = c.GL_DITHER;
        // pub const DONT_CARE: cInt = c.GL_DONT_CARE;
        // pub const DOUBLE: cInt = c.GL_DOUBLE;
        // pub const DOUBLEBUFFER: cInt = c.GL_DOUBLEBUFFER;
        // pub const DOUBLE_MAT2: cInt = c.GL_DOUBLE_MAT2;
        // pub const DOUBLE_MAT2x3: cInt = c.GL_DOUBLE_MAT2x3;
        // pub const DOUBLE_MAT2x4: cInt = c.GL_DOUBLE_MAT2x4;
        // pub const DOUBLE_MAT3: cInt = c.GL_DOUBLE_MAT3;
        // pub const DOUBLE_MAT3x2: cInt = c.GL_DOUBLE_MAT3x2;
        // pub const DOUBLE_MAT3x4: cInt = c.GL_DOUBLE_MAT3x4;
        // pub const DOUBLE_MAT4: cInt = c.GL_DOUBLE_MAT4;
        // pub const DOUBLE_MAT4x2: cInt = c.GL_DOUBLE_MAT4x2;
        // pub const DOUBLE_MAT4x3: cInt = c.GL_DOUBLE_MAT4x3;
        // pub const DOUBLE_VEC2: cInt = c.GL_DOUBLE_VEC2;
        // pub const DOUBLE_VEC3: cInt = c.GL_DOUBLE_VEC3;
        // pub const DOUBLE_VEC4: cInt = c.GL_DOUBLE_VEC4;
        // pub const DRAW_BUFFER: cInt = c.GL_DRAW_BUFFER;
        // pub const DRAW_BUFFER0: cInt = c.GL_DRAW_BUFFER0;
        // pub const DRAW_BUFFER1: cInt = c.GL_DRAW_BUFFER1;
        // pub const DRAW_BUFFER10: cInt = c.GL_DRAW_BUFFER10;
        // pub const DRAW_BUFFER11: cInt = c.GL_DRAW_BUFFER11;
        // pub const DRAW_BUFFER12: cInt = c.GL_DRAW_BUFFER12;
        // pub const DRAW_BUFFER13: cInt = c.GL_DRAW_BUFFER13;
        // pub const DRAW_BUFFER14: cInt = c.GL_DRAW_BUFFER14;
        // pub const DRAW_BUFFER15: cInt = c.GL_DRAW_BUFFER15;
        // pub const DRAW_BUFFER2: cInt = c.GL_DRAW_BUFFER2;
        // pub const DRAW_BUFFER3: cInt = c.GL_DRAW_BUFFER3;
        // pub const DRAW_BUFFER4: cInt = c.GL_DRAW_BUFFER4;
        // pub const DRAW_BUFFER5: cInt = c.GL_DRAW_BUFFER5;
        // pub const DRAW_BUFFER6: cInt = c.GL_DRAW_BUFFER6;
        // pub const DRAW_BUFFER7: cInt = c.GL_DRAW_BUFFER7;
        // pub const DRAW_BUFFER8: cInt = c.GL_DRAW_BUFFER8;
        // pub const DRAW_BUFFER9: cInt = c.GL_DRAW_BUFFER9;
        // pub const DRAW_FRAMEBUFFER: cInt = c.GL_DRAW_FRAMEBUFFER;
        // pub const DRAW_FRAMEBUFFER_BINDING: cInt = c.GL_DRAW_FRAMEBUFFER_BINDING;
        // pub const DRAW_INDIRECT_BUFFER: cInt = c.GL_DRAW_INDIRECT_BUFFER;
        // pub const DRAW_INDIRECT_BUFFER_BINDING: cInt = c.GL_DRAW_INDIRECT_BUFFER_BINDING;
        // pub const DST_ALPHA: cInt = c.GL_DST_ALPHA;
        // pub const DST_COLOR: cInt = c.GL_DST_COLOR;
        // pub const DYNAMIC_COPY: cInt = c.GL_DYNAMIC_COPY;
        // pub const DYNAMIC_DRAW: cInt = c.GL_DYNAMIC_DRAW;
        // pub const DYNAMIC_READ: cInt = c.GL_DYNAMIC_READ;
        pub const ELEMENT_ARRAY_BUFFER: Int = c.GL_ELEMENT_ARRAY_BUFFER;
        // pub const ELEMENT_ARRAY_BUFFER_BINDING: cInt = c.GL_ELEMENT_ARRAY_BUFFER_BINDING;
        // pub const EQUAL: cInt = c.GL_EQUAL;
        // pub const EQUIV: cInt = c.GL_EQUIV;
        // pub const EXTENSIONS: cInt = c.GL_EXTENSIONS;

        // pub const FASTEST: cInt = c.GL_FASTEST;
        pub const FILL: Int = c.GL_FILL;
        // pub const FIRST_VERTEX_CONVENTION: cInt = c.GL_FIRST_VERTEX_CONVENTION;
        // pub const FIXED: cInt = c.GL_FIXED;
        // pub const FIXED_ONLY: cInt = c.GL_FIXED_ONLY;

        // pub const FLOAT_32_UNSIGNED_INT_24_8_REV: cInt = c.GL_FLOAT_32_UNSIGNED_INT_24_8_REV;
        // pub const FLOAT_MAT2: cInt = c.GL_FLOAT_MAT2;
        // pub const FLOAT_MAT2x3: cInt = c.GL_FLOAT_MAT2x3;
        // pub const FLOAT_MAT2x4: cInt = c.GL_FLOAT_MAT2x4;
        // pub const FLOAT_MAT3: cInt = c.GL_FLOAT_MAT3;
        // pub const FLOAT_MAT3x2: cInt = c.GL_FLOAT_MAT3x2;
        // pub const FLOAT_MAT3x4: cInt = c.GL_FLOAT_MAT3x4;
        // pub const FLOAT_MAT4: cInt = c.GL_FLOAT_MAT4;
        // pub const FLOAT_MAT4x2: cInt = c.GL_FLOAT_MAT4x2;
        // pub const FLOAT_MAT4x3: cInt = c.GL_FLOAT_MAT4x3;
        // pub const FLOAT_VEC2: cInt = c.GL_FLOAT_VEC2;
        // pub const FLOAT_VEC3: cInt = c.GL_FLOAT_VEC3;
        // pub const FLOAT_VEC4: cInt = c.GL_FLOAT_VEC4;
        // pub const FRACTIONAL_EVEN: cInt = c.GL_FRACTIONAL_EVEN;
        // pub const FRACTIONAL_ODD: cInt = c.GL_FRACTIONAL_ODD;
        // pub const FRAGMENT_INTERPOLATION_OFFSET_BITS: cInt = c.GL_FRAGMENT_INTERPOLATION_OFFSET_BITS;
        pub const FRAGMENT_SHADER: Int = c.GL_FRAGMENT_SHADER;
        // pub const FRAGMENT_SHADER_BIT: cInt = c.GL_FRAGMENT_SHADER_BIT;
        // pub const FRAGMENT_SHADER_DERIVATIVE_HINT: cInt = c.GL_FRAGMENT_SHADER_DERIVATIVE_HINT;
        // pub const FRAMEBUFFER: cInt = c.GL_FRAMEBUFFER;
        // pub const FRAMEBUFFER_ATTACHMENT_ALPHA_SIZE: cInt = c.GL_FRAMEBUFFER_ATTACHMENT_ALPHA_SIZE;
        // pub const FRAMEBUFFER_ATTACHMENT_BLUE_SIZE: cInt = c.GL_FRAMEBUFFER_ATTACHMENT_BLUE_SIZE;
        // pub const FRAMEBUFFER_ATTACHMENT_COLOR_ENCODING: cInt = c.GL_FRAMEBUFFER_ATTACHMENT_COLOR_ENCODING;
        // pub const FRAMEBUFFER_ATTACHMENT_COMPONENT_TYPE: cInt = c.GL_FRAMEBUFFER_ATTACHMENT_COMPONENT_TYPE;
        // pub const FRAMEBUFFER_ATTACHMENT_DEPTH_SIZE: cInt = c.GL_FRAMEBUFFER_ATTACHMENT_DEPTH_SIZE;
        // pub const FRAMEBUFFER_ATTACHMENT_GREEN_SIZE: cInt = c.GL_FRAMEBUFFER_ATTACHMENT_GREEN_SIZE;
        // pub const FRAMEBUFFER_ATTACHMENT_LAYERED: cInt = c.GL_FRAMEBUFFER_ATTACHMENT_LAYERED;
        // pub const FRAMEBUFFER_ATTACHMENT_OBJECT_NAME: cInt = c.GL_FRAMEBUFFER_ATTACHMENT_OBJECT_NAME;
        // pub const FRAMEBUFFER_ATTACHMENT_OBJECT_TYPE: cInt = c.GL_FRAMEBUFFER_ATTACHMENT_OBJECT_TYPE;
        // pub const FRAMEBUFFER_ATTACHMENT_RED_SIZE: cInt = c.GL_FRAMEBUFFER_ATTACHMENT_RED_SIZE;
        // pub const FRAMEBUFFER_ATTACHMENT_STENCIL_SIZE: cInt = c.GL_FRAMEBUFFER_ATTACHMENT_STENCIL_SIZE;
        // pub const FRAMEBUFFER_ATTACHMENT_TEXTURE_CUBE_MAP_FACE: cInt = c.GL_FRAMEBUFFER_ATTACHMENT_TEXTURE_CUBE_MAP_FACE;
        // pub const FRAMEBUFFER_ATTACHMENT_TEXTURE_LAYER: cInt = c.GL_FRAMEBUFFER_ATTACHMENT_TEXTURE_LAYER;
        // pub const FRAMEBUFFER_ATTACHMENT_TEXTURE_LEVEL: cInt = c.GL_FRAMEBUFFER_ATTACHMENT_TEXTURE_LEVEL;
        // pub const FRAMEBUFFER_BINDING: cInt = c.GL_FRAMEBUFFER_BINDING;
        // pub const FRAMEBUFFER_COMPLETE: cInt = c.GL_FRAMEBUFFER_COMPLETE;
        // pub const FRAMEBUFFER_DEFAULT: cInt = c.GL_FRAMEBUFFER_DEFAULT;
        // pub const FRAMEBUFFER_INCOMPLETE_ATTACHMENT: cInt = c.GL_FRAMEBUFFER_INCOMPLETE_ATTACHMENT;
        // pub const FRAMEBUFFER_INCOMPLETE_DRAW_BUFFER: cInt = c.GL_FRAMEBUFFER_INCOMPLETE_DRAW_BUFFER;
        // pub const FRAMEBUFFER_INCOMPLETE_LAYER_TARGETS: cInt = c.GL_FRAMEBUFFER_INCOMPLETE_LAYER_TARGETS;
        // pub const FRAMEBUFFER_INCOMPLETE_MISSING_ATTACHMENT: cInt = c.GL_FRAMEBUFFER_INCOMPLETE_MISSING_ATTACHMENT;
        // pub const FRAMEBUFFER_INCOMPLETE_MULTISAMPLE: cInt = c.GL_FRAMEBUFFER_INCOMPLETE_MULTISAMPLE;
        // pub const FRAMEBUFFER_INCOMPLETE_READ_BUFFER: cInt = c.GL_FRAMEBUFFER_INCOMPLETE_READ_BUFFER;
        // pub const FRAMEBUFFER_SRGB: cInt = c.GL_FRAMEBUFFER_SRGB;
        // pub const FRAMEBUFFER_UNDEFINED: cInt = c.GL_FRAMEBUFFER_UNDEFINED;
        // pub const FRAMEBUFFER_UNSUPPORTED: cInt = c.GL_FRAMEBUFFER_UNSUPPORTED;
        // pub const FRONT: cInt = c.GL_FRONT;
        pub const FRONT_AND_BACK: Int = c.GL_FRONT_AND_BACK;
        // pub const FRONT_FACE: cInt = c.GL_FRONT_FACE;
        // pub const FRONT_LEFT: cInt = c.GL_FRONT_LEFT;
        // pub const FRONT_RIGHT: cInt = c.GL_FRONT_RIGHT;
        // pub const FUNC_ADD: cInt = c.GL_FUNC_ADD;
        // pub const FUNC_REVERSE_SUBTRACT: cInt = c.GL_FUNC_REVERSE_SUBTRACT;
        // pub const FUNC_SUBTRACT: cInt = c.GL_FUNC_SUBTRACT;
        // pub const GEOMETRY_INPUT_TYPE: cInt = c.GL_GEOMETRY_INPUT_TYPE;
        // pub const GEOMETRY_OUTPUT_TYPE: cInt = c.GL_GEOMETRY_OUTPUT_TYPE;
        // pub const GEOMETRY_SHADER: cInt = c.GL_GEOMETRY_SHADER;
        // pub const GEOMETRY_SHADER_BIT: cInt = c.GL_GEOMETRY_SHADER_BIT;
        // pub const GEOMETRY_SHADER_INVOCATIONS: cInt = c.GL_GEOMETRY_SHADER_INVOCATIONS;
        // pub const GEOMETRY_VERTICES_OUT: cInt = c.GL_GEOMETRY_VERTICES_OUT;
        // pub const GEQUAL: cInt = c.GL_GEQUAL;
        // pub const GREATER: cInt = c.GL_GREATER;
        // pub const GREEN: cInt = c.GL_GREEN;
        // pub const GREEN_INTEGER: cInt = c.GL_GREEN_INTEGER;
        // pub const HALF_FLOAT: cInt = c.GL_HALF_FLOAT;
        // pub const HIGH_FLOAT: cInt = c.GL_HIGH_FLOAT;
        // pub const HIGH_INT: cInt = c.GL_HIGH_INT;
        // pub const IMPLEMENTATION_COLOR_READ_FORMAT: cInt = c.GL_IMPLEMENTATION_COLOR_READ_FORMAT;
        // pub const IMPLEMENTATION_COLOR_READ_TYPE: cInt = c.GL_IMPLEMENTATION_COLOR_READ_TYPE;
        // pub const INCR: cInt = c.GL_INCR;
        // pub const INCR_WRAP: cInt = c.GL_INCR_WRAP;
        pub const INFO_LOG_LENGTH: Int = c.GL_INFO_LOG_LENGTH;
        // pub const INT: cInt = c.GL_INT;
        // pub const INTERLEAVED_ATTRIBS: cInt = c.GL_INTERLEAVED_ATTRIBS;
        // pub const INT_2_10_10_10_REV: cInt = c.GL_INT_2_10_10_10_REV;
        // pub const INT_SAMPLER_1D: cInt = c.GL_INT_SAMPLER_1D;
        // pub const INT_SAMPLER_1D_ARRAY: cInt = c.GL_INT_SAMPLER_1D_ARRAY;
        // pub const INT_SAMPLER_2D: cInt = c.GL_INT_SAMPLER_2D;
        // pub const INT_SAMPLER_2D_ARRAY: cInt = c.GL_INT_SAMPLER_2D_ARRAY;
        // pub const INT_SAMPLER_2D_MULTISAMPLE: cInt = c.GL_INT_SAMPLER_2D_MULTISAMPLE;
        // pub const INT_SAMPLER_2D_MULTISAMPLE_ARRAY: cInt = c.GL_INT_SAMPLER_2D_MULTISAMPLE_ARRAY;
        // pub const INT_SAMPLER_2D_RECT: cInt = c.GL_INT_SAMPLER_2D_RECT;
        // pub const INT_SAMPLER_3D: cInt = c.GL_INT_SAMPLER_3D;
        // pub const INT_SAMPLER_BUFFER: cInt = c.GL_INT_SAMPLER_BUFFER;
        // pub const INT_SAMPLER_CUBE: cInt = c.GL_INT_SAMPLER_CUBE;
        // pub const INT_SAMPLER_CUBE_MAP_ARRAY: cInt = c.GL_INT_SAMPLER_CUBE_MAP_ARRAY;
        // pub const INT_VEC2: cInt = c.GL_INT_VEC2;
        // pub const INT_VEC3: cInt = c.GL_INT_VEC3;
        // pub const INT_VEC4: cInt = c.GL_INT_VEC4;

        /// Part of possible Error Codes
        pub const INVALID_ENUM: Int = c.GL_INVALID_ENUM;
        pub const INVALID_FRAMEBUFFER_OPERATION: Int = c.GL_INVALID_FRAMEBUFFER_OPERATION;
        pub const INVALID_OPERATION: Int = c.GL_INVALID_OPERATION;
        pub const INVALID_VALUE: Int = c.GL_INVALID_VALUE;

        /// error: type 'c_int' cannot represent integer value '4294967295'
        //pub const INVALID_INDEX: cInt = c.GL_INVALID_INDEX;

        // pub const INVERT: cInt = c.GL_INVERT;
        // pub const ISOLINES: cInt = c.GL_ISOLINES;
        // pub const KEEP: cInt = c.GL_KEEP;
        // pub const LAST_VERTEX_CONVENTION: cInt = c.GL_LAST_VERTEX_CONVENTION;
        // pub const LAYER_PROVOKING_VERTEX: cInt = c.GL_LAYER_PROVOKING_VERTEX;
        // pub const LEFT: cInt = c.GL_LEFT;
        // pub const LEQUAL: cInt = c.GL_LEQUAL;
        pub const LESS: Int = c.GL_LESS; // depthFunc()
        pub const LINE: Int = c.GL_LINE;
        // pub const LINEAR: cInt = c.GL_LINEAR;
        // pub const LINEAR_MIPMAP_LINEAR: cInt = c.GL_LINEAR_MIPMAP_LINEAR;
        // pub const LINEAR_MIPMAP_NEAREST: cInt = c.GL_LINEAR_MIPMAP_NEAREST;
        pub const LINES: Int = c.GL_LINES;
        // pub const LINES_ADJACENCY: cInt = c.GL_LINES_ADJACENCY;
        // pub const LINE_LOOP: cInt = c.GL_LINE_LOOP;
        // pub const LINE_SMOOTH: cInt = c.GL_LINE_SMOOTH;
        // pub const LINE_SMOOTH_HINT: cInt = c.GL_LINE_SMOOTH_HINT;
        // pub const LINE_STRIP: cInt = c.GL_LINE_STRIP;
        // pub const LINE_STRIP_ADJACENCY: cInt = c.GL_LINE_STRIP_ADJACENCY;
        // pub const LINE_WIDTH: cInt = c.GL_LINE_WIDTH;
        // pub const LINE_WIDTH_GRANULARITY: cInt = c.GL_LINE_WIDTH_GRANULARITY;
        // pub const LINE_WIDTH_RANGE: cInt = c.GL_LINE_WIDTH_RANGE;

        /// Shader program link status
        pub const LINK_STATUS: Int = c.GL_LINK_STATUS;

        // pub const LOGIC_OP_MODE: cInt = c.GL_LOGIC_OP_MODE;
        // pub const LOWER_LEFT: cInt = c.GL_LOWER_LEFT;
        // pub const LOW_FLOAT: cInt = c.GL_LOW_FLOAT;
        // pub const LOW_INT: cInt = c.GL_LOW_INT;
        pub const MAJOR_VERSION: Int = c.GL_MAJOR_VERSION;
        // pub const MAP_FLUSH_EXPLICIT_BIT: cInt = c.GL_MAP_FLUSH_EXPLICIT_BIT;
        // pub const MAP_INVALIDATE_BUFFER_BIT: cInt = c.GL_MAP_INVALIDATE_BUFFER_BIT;
        // pub const MAP_INVALIDATE_RANGE_BIT: cInt = c.GL_MAP_INVALIDATE_RANGE_BIT;
        // pub const MAP_READ_BIT: cInt = c.GL_MAP_READ_BIT;
        // pub const MAP_UNSYNCHRONIZED_BIT: cInt = c.GL_MAP_UNSYNCHRONIZED_BIT;
        // pub const MAP_WRITE_BIT: cInt = c.GL_MAP_WRITE_BIT;
        // pub const MAX: cInt = c.GL_MAX;
        // pub const MAX_3D_TEXTURE_SIZE: cInt = c.GL_MAX_3D_TEXTURE_SIZE;
        // pub const MAX_ARRAY_TEXTURE_LAYERS: cInt = c.GL_MAX_ARRAY_TEXTURE_LAYERS;
        // pub const MAX_CLIP_DISTANCES: cInt = c.GL_MAX_CLIP_DISTANCES;
        // pub const MAX_COLOR_ATTACHMENTS: cInt = c.GL_MAX_COLOR_ATTACHMENTS;
        // pub const MAX_COLOR_TEXTURE_SAMPLES: cInt = c.GL_MAX_COLOR_TEXTURE_SAMPLES;
        // pub const MAX_COMBINED_FRAGMENT_UNIFORM_COMPONENTS: cInt = c.GL_MAX_COMBINED_FRAGMENT_UNIFORM_COMPONENTS;
        // pub const MAX_COMBINED_GEOMETRY_UNIFORM_COMPONENTS: cInt = c.GL_MAX_COMBINED_GEOMETRY_UNIFORM_COMPONENTS;
        // pub const MAX_COMBINED_TESS_CONTROL_UNIFORM_COMPONENTS: cInt = c.GL_MAX_COMBINED_TESS_CONTROL_UNIFORM_COMPONENTS;
        // pub const MAX_COMBINED_TESS_EVALUATION_UNIFORM_COMPONENTS: cInt = c.GL_MAX_COMBINED_TESS_EVALUATION_UNIFORM_COMPONENTS;
        // pub const MAX_COMBINED_TEXTURE_IMAGE_UNITS: cInt = c.GL_MAX_COMBINED_TEXTURE_IMAGE_UNITS;
        // pub const MAX_COMBINED_UNIFORM_BLOCKS: cInt = c.GL_MAX_COMBINED_UNIFORM_BLOCKS;
        // pub const MAX_COMBINED_VERTEX_UNIFORM_COMPONENTS: cInt = c.GL_MAX_COMBINED_VERTEX_UNIFORM_COMPONENTS;
        // pub const MAX_CUBE_MAP_TEXTURE_SIZE: cInt = c.GL_MAX_CUBE_MAP_TEXTURE_SIZE;
        // pub const MAX_DEPTH_TEXTURE_SAMPLES: cInt = c.GL_MAX_DEPTH_TEXTURE_SAMPLES;
        // pub const MAX_DRAW_BUFFERS: cInt = c.GL_MAX_DRAW_BUFFERS;
        // pub const MAX_DUAL_SOURCE_DRAW_BUFFERS: cInt = c.GL_MAX_DUAL_SOURCE_DRAW_BUFFERS;
        // pub const MAX_ELEMENTS_INDICES: cInt = c.GL_MAX_ELEMENTS_INDICES;
        // pub const MAX_ELEMENTS_VERTICES: cInt = c.GL_MAX_ELEMENTS_VERTICES;
        // pub const MAX_FRAGMENT_INPUT_COMPONENTS: cInt = c.GL_MAX_FRAGMENT_INPUT_COMPONENTS;
        // pub const MAX_FRAGMENT_INTERPOLATION_OFFSET: cInt = c.GL_MAX_FRAGMENT_INTERPOLATION_OFFSET;
        // pub const MAX_FRAGMENT_UNIFORM_BLOCKS: cInt = c.GL_MAX_FRAGMENT_UNIFORM_BLOCKS;
        // pub const MAX_FRAGMENT_UNIFORM_COMPONENTS: cInt = c.GL_MAX_FRAGMENT_UNIFORM_COMPONENTS;
        // pub const MAX_FRAGMENT_UNIFORM_VECTORS: cInt = c.GL_MAX_FRAGMENT_UNIFORM_VECTORS;
        // pub const MAX_GEOMETRY_INPUT_COMPONENTS: cInt = c.GL_MAX_GEOMETRY_INPUT_COMPONENTS;
        // pub const MAX_GEOMETRY_OUTPUT_COMPONENTS: cInt = c.GL_MAX_GEOMETRY_OUTPUT_COMPONENTS;
        // pub const MAX_GEOMETRY_OUTPUT_VERTICES: cInt = c.GL_MAX_GEOMETRY_OUTPUT_VERTICES;
        // pub const MAX_GEOMETRY_SHADER_INVOCATIONS: cInt = c.GL_MAX_GEOMETRY_SHADER_INVOCATIONS;
        // pub const MAX_GEOMETRY_TEXTURE_IMAGE_UNITS: cInt = c.GL_MAX_GEOMETRY_TEXTURE_IMAGE_UNITS;
        // pub const MAX_GEOMETRY_TOTAL_OUTPUT_COMPONENTS: cInt = c.GL_MAX_GEOMETRY_TOTAL_OUTPUT_COMPONENTS;
        // pub const MAX_GEOMETRY_UNIFORM_BLOCKS: cInt = c.GL_MAX_GEOMETRY_UNIFORM_BLOCKS;
        // pub const MAX_GEOMETRY_UNIFORM_COMPONENTS: cInt = c.GL_MAX_GEOMETRY_UNIFORM_COMPONENTS;
        // pub const MAX_INTEGER_SAMPLES: cInt = c.GL_MAX_INTEGER_SAMPLES;
        // pub const MAX_PATCH_VERTICES: cInt = c.GL_MAX_PATCH_VERTICES;
        // pub const MAX_PROGRAM_TEXEL_OFFSET: cInt = c.GL_MAX_PROGRAM_TEXEL_OFFSET;
        // pub const MAX_PROGRAM_TEXTURE_GATHER_OFFSET: cInt = c.GL_MAX_PROGRAM_TEXTURE_GATHER_OFFSET;
        // pub const MAX_RECTANGLE_TEXTURE_SIZE: cInt = c.GL_MAX_RECTANGLE_TEXTURE_SIZE;
        // pub const MAX_RENDERBUFFER_SIZE: cInt = c.GL_MAX_RENDERBUFFER_SIZE;
        // pub const MAX_SAMPLES: cInt = c.GL_MAX_SAMPLES;
        // pub const MAX_SAMPLE_MASK_WORDS: cInt = c.GL_MAX_SAMPLE_MASK_WORDS;
        // pub const MAX_SERVER_WAIT_TIMEOUT: cInt = c.GL_MAX_SERVER_WAIT_TIMEOUT;
        // pub const MAX_SUBROUTINES: cInt = c.GL_MAX_SUBROUTINES;
        // pub const MAX_SUBROUTINE_UNIFORM_LOCATIONS: cInt = c.GL_MAX_SUBROUTINE_UNIFORM_LOCATIONS;
        // pub const MAX_TESS_CONTROL_INPUT_COMPONENTS: cInt = c.GL_MAX_TESS_CONTROL_INPUT_COMPONENTS;
        // pub const MAX_TESS_CONTROL_OUTPUT_COMPONENTS: cInt = c.GL_MAX_TESS_CONTROL_OUTPUT_COMPONENTS;
        // pub const MAX_TESS_CONTROL_TEXTURE_IMAGE_UNITS: cInt = c.GL_MAX_TESS_CONTROL_TEXTURE_IMAGE_UNITS;
        // pub const MAX_TESS_CONTROL_TOTAL_OUTPUT_COMPONENTS: cInt = c.GL_MAX_TESS_CONTROL_TOTAL_OUTPUT_COMPONENTS;
        // pub const MAX_TESS_CONTROL_UNIFORM_BLOCKS: cInt = c.GL_MAX_TESS_CONTROL_UNIFORM_BLOCKS;
        // pub const MAX_TESS_CONTROL_UNIFORM_COMPONENTS: cInt = c.GL_MAX_TESS_CONTROL_UNIFORM_COMPONENTS;
        // pub const MAX_TESS_EVALUATION_INPUT_COMPONENTS: cInt = c.GL_MAX_TESS_EVALUATION_INPUT_COMPONENTS;
        // pub const MAX_TESS_EVALUATION_OUTPUT_COMPONENTS: cInt = c.GL_MAX_TESS_EVALUATION_OUTPUT_COMPONENTS;
        // pub const MAX_TESS_EVALUATION_TEXTURE_IMAGE_UNITS: cInt = c.GL_MAX_TESS_EVALUATION_TEXTURE_IMAGE_UNITS;
        // pub const MAX_TESS_EVALUATION_UNIFORM_BLOCKS: cInt = c.GL_MAX_TESS_EVALUATION_UNIFORM_BLOCKS;
        // pub const MAX_TESS_EVALUATION_UNIFORM_COMPONENTS: cInt = c.GL_MAX_TESS_EVALUATION_UNIFORM_COMPONENTS;
        // pub const MAX_TESS_GEN_LEVEL: cInt = c.GL_MAX_TESS_GEN_LEVEL;
        // pub const MAX_TESS_PATCH_COMPONENTS: cInt = c.GL_MAX_TESS_PATCH_COMPONENTS;
        // pub const MAX_TEXTURE_BUFFER_SIZE: cInt = c.GL_MAX_TEXTURE_BUFFER_SIZE;
        // pub const MAX_TEXTURE_IMAGE_UNITS: cInt = c.GL_MAX_TEXTURE_IMAGE_UNITS;
        // pub const MAX_TEXTURE_LOD_BIAS: cInt = c.GL_MAX_TEXTURE_LOD_BIAS;
        // pub const MAX_TEXTURE_SIZE: cInt = c.GL_MAX_TEXTURE_SIZE;
        // pub const MAX_TRANSFORM_FEEDBACK_BUFFERS: cInt = c.GL_MAX_TRANSFORM_FEEDBACK_BUFFERS;
        // pub const MAX_TRANSFORM_FEEDBACK_INTERLEAVED_COMPONENTS: cInt = c.GL_MAX_TRANSFORM_FEEDBACK_INTERLEAVED_COMPONENTS;
        // pub const MAX_TRANSFORM_FEEDBACK_SEPARATE_ATTRIBS: cInt = c.GL_MAX_TRANSFORM_FEEDBACK_SEPARATE_ATTRIBS;
        // pub const MAX_TRANSFORM_FEEDBACK_SEPARATE_COMPONENTS: cInt = c.GL_MAX_TRANSFORM_FEEDBACK_SEPARATE_COMPONENTS;
        // pub const MAX_UNIFORM_BLOCK_SIZE: cInt = c.GL_MAX_UNIFORM_BLOCK_SIZE;
        // pub const MAX_UNIFORM_BUFFER_BINDINGS: cInt = c.GL_MAX_UNIFORM_BUFFER_BINDINGS;
        // pub const MAX_VARYING_COMPONENTS: cInt = c.GL_MAX_VARYING_COMPONENTS;
        // pub const MAX_VARYING_FLOATS: cInt = c.GL_MAX_VARYING_FLOATS;
        // pub const MAX_VARYING_VECTORS: cInt = c.GL_MAX_VARYING_VECTORS;
        // pub const MAX_VERTEX_ATTRIBS: cInt = c.GL_MAX_VERTEX_ATTRIBS;
        // pub const MAX_VERTEX_OUTPUT_COMPONENTS: cInt = c.GL_MAX_VERTEX_OUTPUT_COMPONENTS;
        // pub const MAX_VERTEX_STREAMS: cInt = c.GL_MAX_VERTEX_STREAMS;
        // pub const MAX_VERTEX_TEXTURE_IMAGE_UNITS: cInt = c.GL_MAX_VERTEX_TEXTURE_IMAGE_UNITS;
        // pub const MAX_VERTEX_UNIFORM_BLOCKS: cInt = c.GL_MAX_VERTEX_UNIFORM_BLOCKS;
        // pub const MAX_VERTEX_UNIFORM_COMPONENTS: cInt = c.GL_MAX_VERTEX_UNIFORM_COMPONENTS;
        // pub const MAX_VERTEX_UNIFORM_VECTORS: cInt = c.GL_MAX_VERTEX_UNIFORM_VECTORS;
        // pub const MAX_VIEWPORTS: cInt = c.GL_MAX_VIEWPORTS;
        // pub const MAX_VIEWPORT_DIMS: cInt = c.GL_MAX_VIEWPORT_DIMS;
        // pub const MEDIUM_FLOAT: cInt = c.GL_MEDIUM_FLOAT;
        // pub const MEDIUM_INT: cInt = c.GL_MEDIUM_INT;
        // pub const MIN: cInt = c.GL_MIN;
        pub const MINOR_VERSION: Int = c.GL_MINOR_VERSION;
        // pub const MIN_FRAGMENT_INTERPOLATION_OFFSET: cInt = c.GL_MIN_FRAGMENT_INTERPOLATION_OFFSET;
        // pub const MIN_PROGRAM_TEXEL_OFFSET: cInt = c.GL_MIN_PROGRAM_TEXEL_OFFSET;
        // pub const MIN_PROGRAM_TEXTURE_GATHER_OFFSET: cInt = c.GL_MIN_PROGRAM_TEXTURE_GATHER_OFFSET;
        // pub const MIN_SAMPLE_SHADING_VALUE: cInt = c.GL_MIN_SAMPLE_SHADING_VALUE;
        // pub const MIRRORED_REPEAT: cInt = c.GL_MIRRORED_REPEAT;
        // pub const MULTISAMPLE: cInt = c.GL_MULTISAMPLE;
        // pub const NAND: cInt = c.GL_NAND;
        // pub const NEAREST: cInt = c.GL_NEAREST;
        // pub const NEAREST_MIPMAP_LINEAR: cInt = c.GL_NEAREST_MIPMAP_LINEAR;
        // pub const NEAREST_MIPMAP_NEAREST: cInt = c.GL_NEAREST_MIPMAP_NEAREST;
        // pub const NEVER: cInt = c.GL_NEVER;
        // pub const NICEST: cInt = c.GL_NICEST;
        // pub const NONE: cInt = c.GL_NONE;
        // pub const NOOP: cInt = c.GL_NOOP;
        // pub const NOR: cInt = c.GL_NOR;
        // pub const NOTEQUAL: cInt = c.GL_NOTEQUAL;

        /// Part of possible Error Codes
        pub const NO_ERROR: Int = c.GL_NO_ERROR;

        // pub const NUM_COMPATIBLE_SUBROUTINES: cInt = c.GL_NUM_COMPATIBLE_SUBROUTINES;
        // pub const NUM_COMPRESSED_TEXTURE_FORMATS: cInt = c.GL_NUM_COMPRESSED_TEXTURE_FORMATS;
        // pub const NUM_EXTENSIONS: cInt = c.GL_NUM_EXTENSIONS;
        // pub const NUM_PROGRAM_BINARY_FORMATS: cInt = c.GL_NUM_PROGRAM_BINARY_FORMATS;
        // pub const NUM_SHADER_BINARY_FORMATS: cInt = c.GL_NUM_SHADER_BINARY_FORMATS;
        // pub const OBJECT_TYPE: cInt = c.GL_OBJECT_TYPE;
        // pub const ONE: cInt = c.GL_ONE;
        // pub const ONE_MINUS_CONSTANT_ALPHA: cInt = c.GL_ONE_MINUS_CONSTANT_ALPHA;
        // pub const ONE_MINUS_CONSTANT_COLOR: cInt = c.GL_ONE_MINUS_CONSTANT_COLOR;
        // pub const ONE_MINUS_DST_ALPHA: cInt = c.GL_ONE_MINUS_DST_ALPHA;
        // pub const ONE_MINUS_DST_COLOR: cInt = c.GL_ONE_MINUS_DST_COLOR;
        // pub const ONE_MINUS_SRC1_ALPHA: cInt = c.GL_ONE_MINUS_SRC1_ALPHA;
        // pub const ONE_MINUS_SRC1_COLOR: cInt = c.GL_ONE_MINUS_SRC1_COLOR;
        // pub const ONE_MINUS_SRC_ALPHA: cInt = c.GL_ONE_MINUS_SRC_ALPHA;
        // pub const ONE_MINUS_SRC_COLOR: cInt = c.GL_ONE_MINUS_SRC_COLOR;
        // pub const OR: cInt = c.GL_OR;
        // pub const OR_INVERTED: cInt = c.GL_OR_INVERTED;
        // pub const OR_REVERSE: cInt = c.GL_OR_REVERSE;

        /// Part of possible Error Codes
        pub const OUT_OF_MEMORY: Int = c.GL_OUT_OF_MEMORY;

        // pub const PACK_ALIGNMENT: cInt = c.GL_PACK_ALIGNMENT;
        // pub const PACK_IMAGE_HEIGHT: cInt = c.GL_PACK_IMAGE_HEIGHT;
        // pub const PACK_LSB_FIRST: cInt = c.GL_PACK_LSB_FIRST;
        // pub const PACK_ROW_LENGTH: cInt = c.GL_PACK_ROW_LENGTH;
        // pub const PACK_SKIP_IMAGES: cInt = c.GL_PACK_SKIP_IMAGES;
        // pub const PACK_SKIP_PIXELS: cInt = c.GL_PACK_SKIP_PIXELS;
        // pub const PACK_SKIP_ROWS: cInt = c.GL_PACK_SKIP_ROWS;
        // pub const PACK_SWAP_BYTES: cInt = c.GL_PACK_SWAP_BYTES;
        // pub const PATCHES: cInt = c.GL_PATCHES;
        // pub const PATCH_DEFAULT_INNER_LEVEL: cInt = c.GL_PATCH_DEFAULT_INNER_LEVEL;
        // pub const PATCH_DEFAULT_OUTER_LEVEL: cInt = c.GL_PATCH_DEFAULT_OUTER_LEVEL;
        // pub const PATCH_VERTICES: cInt = c.GL_PATCH_VERTICES;
        // pub const PIXEL_PACK_BUFFER: cInt = c.GL_PIXEL_PACK_BUFFER;
        // pub const PIXEL_PACK_BUFFER_BINDING: cInt = c.GL_PIXEL_PACK_BUFFER_BINDING;
        // pub const PIXEL_UNPACK_BUFFER: cInt = c.GL_PIXEL_UNPACK_BUFFER;
        // pub const PIXEL_UNPACK_BUFFER_BINDING: cInt = c.GL_PIXEL_UNPACK_BUFFER_BINDING;
        // pub const POINT: cInt = c.GL_POINT;
        // pub const POINTS: cInt = c.GL_POINTS;
        // pub const POINT_FADE_THRESHOLD_SIZE: cInt = c.GL_POINT_FADE_THRESHOLD_SIZE;
        // pub const POINT_SIZE: cInt = c.GL_POINT_SIZE;
        // pub const POINT_SIZE_GRANULARITY: cInt = c.GL_POINT_SIZE_GRANULARITY;
        // pub const POINT_SIZE_RANGE: cInt = c.GL_POINT_SIZE_RANGE;
        // pub const POINT_SPRITE_COORD_ORIGIN: cInt = c.GL_POINT_SPRITE_COORD_ORIGIN;
        // pub const POLYGON_MODE: cInt = c.GL_POLYGON_MODE;
        // pub const POLYGON_OFFSET_FACTOR: cInt = c.GL_POLYGON_OFFSET_FACTOR;
        // pub const POLYGON_OFFSET_FILL: cInt = c.GL_POLYGON_OFFSET_FILL;
        // pub const POLYGON_OFFSET_LINE: cInt = c.GL_POLYGON_OFFSET_LINE;
        // pub const POLYGON_OFFSET_POINT: cInt = c.GL_POLYGON_OFFSET_POINT;
        // pub const POLYGON_OFFSET_UNITS: cInt = c.GL_POLYGON_OFFSET_UNITS;
        // pub const POLYGON_SMOOTH: cInt = c.GL_POLYGON_SMOOTH;
        // pub const POLYGON_SMOOTH_HINT: cInt = c.GL_POLYGON_SMOOTH_HINT;
        // pub const PRIMITIVES_GENERATED: cInt = c.GL_PRIMITIVES_GENERATED;
        // pub const PRIMITIVE_RESTART: cInt = c.GL_PRIMITIVE_RESTART;
        // pub const PRIMITIVE_RESTART_INDEX: cInt = c.GL_PRIMITIVE_RESTART_INDEX;
        // pub const PROGRAM_BINARY_FORMATS: cInt = c.GL_PROGRAM_BINARY_FORMATS;
        // pub const PROGRAM_BINARY_LENGTH: cInt = c.GL_PROGRAM_BINARY_LENGTH;
        // pub const PROGRAM_BINARY_RETRIEVABLE_HINT: cInt = c.GL_PROGRAM_BINARY_RETRIEVABLE_HINT;
        // pub const PROGRAM_PIPELINE_BINDING: cInt = c.GL_PROGRAM_PIPELINE_BINDING;
        // pub const PROGRAM_POINT_SIZE: cInt = c.GL_PROGRAM_POINT_SIZE;
        // pub const PROGRAM_SEPARABLE: cInt = c.GL_PROGRAM_SEPARABLE;
        // pub const PROVOKING_VERTEX: cInt = c.GL_PROVOKING_VERTEX;
        // pub const PROXY_TEXTURE_1D: cInt = c.GL_PROXY_TEXTURE_1D;
        // pub const PROXY_TEXTURE_1D_ARRAY: cInt = c.GL_PROXY_TEXTURE_1D_ARRAY;
        // pub const PROXY_TEXTURE_2D: cInt = c.GL_PROXY_TEXTURE_2D;
        // pub const PROXY_TEXTURE_2D_ARRAY: cInt = c.GL_PROXY_TEXTURE_2D_ARRAY;
        // pub const PROXY_TEXTURE_2D_MULTISAMPLE: cInt = c.GL_PROXY_TEXTURE_2D_MULTISAMPLE;
        // pub const PROXY_TEXTURE_2D_MULTISAMPLE_ARRAY: cInt = c.GL_PROXY_TEXTURE_2D_MULTISAMPLE_ARRAY;
        // pub const PROXY_TEXTURE_3D: cInt = c.GL_PROXY_TEXTURE_3D;
        // pub const PROXY_TEXTURE_CUBE_MAP: cInt = c.GL_PROXY_TEXTURE_CUBE_MAP;
        // pub const PROXY_TEXTURE_CUBE_MAP_ARRAY: cInt = c.GL_PROXY_TEXTURE_CUBE_MAP_ARRAY;
        // pub const PROXY_TEXTURE_RECTANGLE: cInt = c.GL_PROXY_TEXTURE_RECTANGLE;
        // pub const QUADS: cInt = c.GL_QUADS;
        // pub const QUADS_FOLLOW_PROVOKING_VERTEX_CONVENTION: cInt = c.GL_QUADS_FOLLOW_PROVOKING_VERTEX_CONVENTION;
        // pub const QUERY_BY_REGION_NO_WAIT: cInt = c.GL_QUERY_BY_REGION_NO_WAIT;
        // pub const QUERY_BY_REGION_WAIT: cInt = c.GL_QUERY_BY_REGION_WAIT;
        // pub const QUERY_COUNTER_BITS: cInt = c.GL_QUERY_COUNTER_BITS;
        // pub const QUERY_NO_WAIT: cInt = c.GL_QUERY_NO_WAIT;
        // pub const QUERY_RESULT: cInt = c.GL_QUERY_RESULT;
        // pub const QUERY_RESULT_AVAILABLE: cInt = c.GL_QUERY_RESULT_AVAILABLE;
        // pub const QUERY_WAIT: cInt = c.GL_QUERY_WAIT;
        // pub const R11F_G11F_B10F: cInt = c.GL_R11F_G11F_B10F;
        // pub const R16: cInt = c.GL_R16;
        // pub const R16F: cInt = c.GL_R16F;
        // pub const R16I: cInt = c.GL_R16I;
        // pub const R16UI: cInt = c.GL_R16UI;
        // pub const R16_SNORM: cInt = c.GL_R16_SNORM;
        // pub const R32F: cInt = c.GL_R32F;
        // pub const R32I: cInt = c.GL_R32I;
        // pub const R32UI: cInt = c.GL_R32UI;
        // pub const R3_G3_B2: cInt = c.GL_R3_G3_B2;
        // pub const R8: cInt = c.GL_R8;
        // pub const R8I: cInt = c.GL_R8I;
        // pub const R8UI: cInt = c.GL_R8UI;
        // pub const R8_SNORM: cInt = c.GL_R8_SNORM;
        // pub const RASTERIZER_DISCARD: cInt = c.GL_RASTERIZER_DISCARD;
        // pub const READ_BUFFER: cInt = c.GL_READ_BUFFER;
        // pub const READ_FRAMEBUFFER: cInt = c.GL_READ_FRAMEBUFFER;
        // pub const READ_FRAMEBUFFER_BINDING: cInt = c.GL_READ_FRAMEBUFFER_BINDING;
        // pub const READ_ONLY: cInt = c.GL_READ_ONLY;
        // pub const READ_WRITE: cInt = c.GL_READ_WRITE;
        // pub const RED: cInt = c.GL_RED;
        // pub const RED_INTEGER: cInt = c.GL_RED_INTEGER;
        // pub const RENDERBUFFER: cInt = c.GL_RENDERBUFFER;
        // pub const RENDERBUFFER_ALPHA_SIZE: cInt = c.GL_RENDERBUFFER_ALPHA_SIZE;
        // pub const RENDERBUFFER_BINDING: cInt = c.GL_RENDERBUFFER_BINDING;
        // pub const RENDERBUFFER_BLUE_SIZE: cInt = c.GL_RENDERBUFFER_BLUE_SIZE;
        // pub const RENDERBUFFER_DEPTH_SIZE: cInt = c.GL_RENDERBUFFER_DEPTH_SIZE;
        // pub const RENDERBUFFER_GREEN_SIZE: cInt = c.GL_RENDERBUFFER_GREEN_SIZE;
        // pub const RENDERBUFFER_HEIGHT: cInt = c.GL_RENDERBUFFER_HEIGHT;
        // pub const RENDERBUFFER_INTERNAL_FORMAT: cInt = c.GL_RENDERBUFFER_INTERNAL_FORMAT;
        // pub const RENDERBUFFER_RED_SIZE: cInt = c.GL_RENDERBUFFER_RED_SIZE;
        // pub const RENDERBUFFER_SAMPLES: cInt = c.GL_RENDERBUFFER_SAMPLES;
        // pub const RENDERBUFFER_STENCIL_SIZE: cInt = c.GL_RENDERBUFFER_STENCIL_SIZE;
        // pub const RENDERBUFFER_WIDTH: cInt = c.GL_RENDERBUFFER_WIDTH;
        pub const RENDERER: Int = c.GL_RENDERER;
        // pub const REPEAT: cInt = c.GL_REPEAT;
        // pub const REPLACE: cInt = c.GL_REPLACE;
        // pub const RG: cInt = c.GL_RG;
        // pub const RG16: cInt = c.GL_RG16;
        // pub const RG16F: cInt = c.GL_RG16F;
        // pub const RG16I: cInt = c.GL_RG16I;
        // pub const RG16UI: cInt = c.GL_RG16UI;
        // pub const RG16_SNORM: cInt = c.GL_RG16_SNORM;
        // pub const RG32F: cInt = c.GL_RG32F;
        // pub const RG32I: cInt = c.GL_RG32I;
        // pub const RG32UI: cInt = c.GL_RG32UI;
        // pub const RG8: cInt = c.GL_RG8;
        // pub const RG8I: cInt = c.GL_RG8I;
        // pub const RG8UI: cInt = c.GL_RG8UI;
        // pub const RG8_SNORM: cInt = c.GL_RG8_SNORM;
        // pub const RGB: cInt = c.GL_RGB;
        // pub const RGB10: cInt = c.GL_RGB10;
        // pub const RGB10_A2: cInt = c.GL_RGB10_A2;
        // pub const RGB10_A2UI: cInt = c.GL_RGB10_A2UI;
        // pub const RGB12: cInt = c.GL_RGB12;
        // pub const RGB16: cInt = c.GL_RGB16;
        // pub const RGB16F: cInt = c.GL_RGB16F;
        // pub const RGB16I: cInt = c.GL_RGB16I;
        // pub const RGB16UI: cInt = c.GL_RGB16UI;
        // pub const RGB16_SNORM: cInt = c.GL_RGB16_SNORM;
        // pub const RGB32F: cInt = c.GL_RGB32F;
        // pub const RGB32I: cInt = c.GL_RGB32I;
        // pub const RGB32UI: cInt = c.GL_RGB32UI;
        // pub const RGB4: cInt = c.GL_RGB4;
        // pub const RGB5: cInt = c.GL_RGB5;
        // pub const RGB565: cInt = c.GL_RGB565;
        // pub const RGB5_A1: cInt = c.GL_RGB5_A1;
        // pub const RGB8: cInt = c.GL_RGB8;
        // pub const RGB8I: cInt = c.GL_RGB8I;
        // pub const RGB8UI: cInt = c.GL_RGB8UI;
        // pub const RGB8_SNORM: cInt = c.GL_RGB8_SNORM;
        // pub const RGB9_E5: cInt = c.GL_RGB9_E5;
        // pub const RGBA: cInt = c.GL_RGBA;
        // pub const RGBA12: cInt = c.GL_RGBA12;
        // pub const RGBA16: cInt = c.GL_RGBA16;
        // pub const RGBA16F: cInt = c.GL_RGBA16F;
        // pub const RGBA16I: cInt = c.GL_RGBA16I;
        // pub const RGBA16UI: cInt = c.GL_RGBA16UI;
        // pub const RGBA16_SNORM: cInt = c.GL_RGBA16_SNORM;
        // pub const RGBA2: cInt = c.GL_RGBA2;
        // pub const RGBA32F: cInt = c.GL_RGBA32F;
        // pub const RGBA32I: cInt = c.GL_RGBA32I;
        // pub const RGBA32UI: cInt = c.GL_RGBA32UI;
        // pub const RGBA4: cInt = c.GL_RGBA4;
        // pub const RGBA8: cInt = c.GL_RGBA8;
        // pub const RGBA8I: cInt = c.GL_RGBA8I;
        // pub const RGBA8UI: cInt = c.GL_RGBA8UI;
        // pub const RGBA8_SNORM: cInt = c.GL_RGBA8_SNORM;
        // pub const RGBA_INTEGER: cInt = c.GL_RGBA_INTEGER;
        // pub const RGB_INTEGER: cInt = c.GL_RGB_INTEGER;
        // pub const RG_INTEGER: cInt = c.GL_RG_INTEGER;
        // pub const RIGHT: cInt = c.GL_RIGHT;
        // pub const SAMPLER_1D: cInt = c.GL_SAMPLER_1D;
        // pub const SAMPLER_1D_ARRAY: cInt = c.GL_SAMPLER_1D_ARRAY;
        // pub const SAMPLER_1D_ARRAY_SHADOW: cInt = c.GL_SAMPLER_1D_ARRAY_SHADOW;
        // pub const SAMPLER_1D_SHADOW: cInt = c.GL_SAMPLER_1D_SHADOW;
        // pub const SAMPLER_2D: cInt = c.GL_SAMPLER_2D;
        // pub const SAMPLER_2D_ARRAY: cInt = c.GL_SAMPLER_2D_ARRAY;
        // pub const SAMPLER_2D_ARRAY_SHADOW: cInt = c.GL_SAMPLER_2D_ARRAY_SHADOW;
        // pub const SAMPLER_2D_MULTISAMPLE: cInt = c.GL_SAMPLER_2D_MULTISAMPLE;
        // pub const SAMPLER_2D_MULTISAMPLE_ARRAY: cInt = c.GL_SAMPLER_2D_MULTISAMPLE_ARRAY;
        // pub const SAMPLER_2D_RECT: cInt = c.GL_SAMPLER_2D_RECT;
        // pub const SAMPLER_2D_RECT_SHADOW: cInt = c.GL_SAMPLER_2D_RECT_SHADOW;
        // pub const SAMPLER_2D_SHADOW: cInt = c.GL_SAMPLER_2D_SHADOW;
        // pub const SAMPLER_3D: cInt = c.GL_SAMPLER_3D;
        // pub const SAMPLER_BINDING: cInt = c.GL_SAMPLER_BINDING;
        // pub const SAMPLER_BUFFER: cInt = c.GL_SAMPLER_BUFFER;
        // pub const SAMPLER_CUBE: cInt = c.GL_SAMPLER_CUBE;
        // pub const SAMPLER_CUBE_MAP_ARRAY: cInt = c.GL_SAMPLER_CUBE_MAP_ARRAY;
        // pub const SAMPLER_CUBE_MAP_ARRAY_SHADOW: cInt = c.GL_SAMPLER_CUBE_MAP_ARRAY_SHADOW;
        // pub const SAMPLER_CUBE_SHADOW: cInt = c.GL_SAMPLER_CUBE_SHADOW;
        // pub const SAMPLES: cInt = c.GL_SAMPLES;
        // pub const SAMPLES_PASSED: cInt = c.GL_SAMPLES_PASSED;
        // pub const SAMPLE_ALPHA_TO_COVERAGE: cInt = c.GL_SAMPLE_ALPHA_TO_COVERAGE;
        // pub const SAMPLE_ALPHA_TO_ONE: cInt = c.GL_SAMPLE_ALPHA_TO_ONE;
        // pub const SAMPLE_BUFFERS: cInt = c.GL_SAMPLE_BUFFERS;
        // pub const SAMPLE_COVERAGE: cInt = c.GL_SAMPLE_COVERAGE;
        // pub const SAMPLE_COVERAGE_INVERT: cInt = c.GL_SAMPLE_COVERAGE_INVERT;
        // pub const SAMPLE_COVERAGE_VALUE: cInt = c.GL_SAMPLE_COVERAGE_VALUE;
        // pub const SAMPLE_MASK: cInt = c.GL_SAMPLE_MASK;
        // pub const SAMPLE_MASK_VALUE: cInt = c.GL_SAMPLE_MASK_VALUE;
        // pub const SAMPLE_POSITION: cInt = c.GL_SAMPLE_POSITION;
        // pub const SAMPLE_SHADING: cInt = c.GL_SAMPLE_SHADING;
        // pub const SCISSOR_BOX: cInt = c.GL_SCISSOR_BOX;
        // pub const SCISSOR_TEST: cInt = c.GL_SCISSOR_TEST;
        // pub const SEPARATE_ATTRIBS: cInt = c.GL_SEPARATE_ATTRIBS;
        // pub const SET: cInt = c.GL_SET;
        // pub const SHADER_BINARY_FORMATS: cInt = c.GL_SHADER_BINARY_FORMATS;
        // pub const SHADER_COMPILER: cInt = c.GL_SHADER_COMPILER;
        // pub const SHADER_SOURCE_LENGTH: cInt = c.GL_SHADER_SOURCE_LENGTH;
        pub const SHADER_TYPE: Int = c.GL_SHADER_TYPE;
        // pub const SHADING_LANGUAGE_VERSION: cInt = c.GL_SHADING_LANGUAGE_VERSION;
        // pub const SHORT: cInt = c.GL_SHORT;
        // pub const SIGNALED: cInt = c.GL_SIGNALED;
        // pub const SIGNED_NORMALIZED: cInt = c.GL_SIGNED_NORMALIZED;
        // pub const SMOOTH_LINE_WIDTH_GRANULARITY: cInt = c.GL_SMOOTH_LINE_WIDTH_GRANULARITY;
        // pub const SMOOTH_LINE_WIDTH_RANGE: cInt = c.GL_SMOOTH_LINE_WIDTH_RANGE;
        // pub const SMOOTH_POINT_SIZE_GRANULARITY: cInt = c.GL_SMOOTH_POINT_SIZE_GRANULARITY;
        // pub const SMOOTH_POINT_SIZE_RANGE: cInt = c.GL_SMOOTH_POINT_SIZE_RANGE;
        // pub const SRC1_ALPHA: cInt = c.GL_SRC1_ALPHA;
        // pub const SRC1_COLOR: cInt = c.GL_SRC1_COLOR;
        // pub const SRC_ALPHA: cInt = c.GL_SRC_ALPHA;
        // pub const SRC_ALPHA_SATURATE: cInt = c.GL_SRC_ALPHA_SATURATE;
        // pub const SRC_COLOR: cInt = c.GL_SRC_COLOR;
        // pub const SRGB: cInt = c.GL_SRGB;
        // pub const SRGB8: cInt = c.GL_SRGB8;
        // pub const SRGB8_ALPHA8: cInt = c.GL_SRGB8_ALPHA8;
        // pub const SRGB_ALPHA: cInt = c.GL_SRGB_ALPHA;
        // pub const STATIC_COPY: cInt = c.GL_STATIC_COPY;
        pub const STATIC_DRAW: Int = c.GL_STATIC_DRAW;
        // pub const STATIC_READ: cInt = c.GL_STATIC_READ;
        // pub const STENCIL: cInt = c.GL_STENCIL;
        // pub const STENCIL_ATTACHMENT: cInt = c.GL_STENCIL_ATTACHMENT;
        // pub const STENCIL_BACK_FAIL: cInt = c.GL_STENCIL_BACK_FAIL;
        // pub const STENCIL_BACK_FUNC: cInt = c.GL_STENCIL_BACK_FUNC;
        // pub const STENCIL_BACK_PASS_DEPTH_FAIL: cInt = c.GL_STENCIL_BACK_PASS_DEPTH_FAIL;
        // pub const STENCIL_BACK_PASS_DEPTH_PASS: cInt = c.GL_STENCIL_BACK_PASS_DEPTH_PASS;
        // pub const STENCIL_BACK_REF: cInt = c.GL_STENCIL_BACK_REF;
        // pub const STENCIL_BACK_VALUE_MASK: cInt = c.GL_STENCIL_BACK_VALUE_MASK;
        // pub const STENCIL_BACK_WRITEMASK: cInt = c.GL_STENCIL_BACK_WRITEMASK;
        // pub const STENCIL_BUFFER_BIT: cInt = c.GL_STENCIL_BUFFER_BIT;
        // pub const STENCIL_CLEAR_VALUE: cInt = c.GL_STENCIL_CLEAR_VALUE;
        // pub const STENCIL_FAIL: cInt = c.GL_STENCIL_FAIL;
        // pub const STENCIL_FUNC: cInt = c.GL_STENCIL_FUNC;
        // pub const STENCIL_INDEX: cInt = c.GL_STENCIL_INDEX;
        // pub const STENCIL_INDEX1: cInt = c.GL_STENCIL_INDEX1;
        // pub const STENCIL_INDEX16: cInt = c.GL_STENCIL_INDEX16;
        // pub const STENCIL_INDEX4: cInt = c.GL_STENCIL_INDEX4;
        // pub const STENCIL_INDEX8: cInt = c.GL_STENCIL_INDEX8;
        // pub const STENCIL_PASS_DEPTH_FAIL: cInt = c.GL_STENCIL_PASS_DEPTH_FAIL;
        // pub const STENCIL_PASS_DEPTH_PASS: cInt = c.GL_STENCIL_PASS_DEPTH_PASS;
        // pub const STENCIL_REF: cInt = c.GL_STENCIL_REF;
        // pub const STENCIL_TEST: cInt = c.GL_STENCIL_TEST;
        // pub const STENCIL_VALUE_MASK: cInt = c.GL_STENCIL_VALUE_MASK;
        // pub const STENCIL_WRITEMASK: cInt = c.GL_STENCIL_WRITEMASK;
        // pub const STEREO: cInt = c.GL_STEREO;
        // pub const STREAM_COPY: cInt = c.GL_STREAM_COPY;
        // pub const STREAM_DRAW: cInt = c.GL_STREAM_DRAW;
        // pub const STREAM_READ: cInt = c.GL_STREAM_READ;
        // pub const SUBPIXEL_BITS: cInt = c.GL_SUBPIXEL_BITS;
        // pub const SYNC_CONDITION: cInt = c.GL_SYNC_CONDITION;
        // pub const SYNC_FENCE: cInt = c.GL_SYNC_FENCE;
        // pub const SYNC_FLAGS: cInt = c.GL_SYNC_FLAGS;
        // pub const SYNC_FLUSH_COMMANDS_BIT: cInt = c.GL_SYNC_FLUSH_COMMANDS_BIT;
        // pub const SYNC_GPU_COMMANDS_COMPLETE: cInt = c.GL_SYNC_GPU_COMMANDS_COMPLETE;
        // pub const SYNC_STATUS: cInt = c.GL_SYNC_STATUS;
        // pub const TESS_CONTROL_OUTPUT_VERTICES: cInt = c.GL_TESS_CONTROL_OUTPUT_VERTICES;
        // pub const TESS_CONTROL_SHADER: cInt = c.GL_TESS_CONTROL_SHADER;
        // pub const TESS_CONTROL_SHADER_BIT: cInt = c.GL_TESS_CONTROL_SHADER_BIT;
        // pub const TESS_EVALUATION_SHADER: cInt = c.GL_TESS_EVALUATION_SHADER;
        // pub const TESS_EVALUATION_SHADER_BIT: cInt = c.GL_TESS_EVALUATION_SHADER_BIT;
        // pub const TESS_GEN_MODE: cInt = c.GL_TESS_GEN_MODE;
        // pub const TESS_GEN_POINT_MODE: cInt = c.GL_TESS_GEN_POINT_MODE;
        // pub const TESS_GEN_SPACING: cInt = c.GL_TESS_GEN_SPACING;
        // pub const TESS_GEN_VERTEX_ORDER: cInt = c.GL_TESS_GEN_VERTEX_ORDER;
        // pub const TEXTURE: cInt = c.GL_TEXTURE;
        // pub const TEXTURE0: cInt = c.GL_TEXTURE0;
        // pub const TEXTURE1: cInt = c.GL_TEXTURE1;
        // pub const TEXTURE10: cInt = c.GL_TEXTURE10;
        // pub const TEXTURE11: cInt = c.GL_TEXTURE11;
        // pub const TEXTURE12: cInt = c.GL_TEXTURE12;
        // pub const TEXTURE13: cInt = c.GL_TEXTURE13;
        // pub const TEXTURE14: cInt = c.GL_TEXTURE14;
        // pub const TEXTURE15: cInt = c.GL_TEXTURE15;
        // pub const TEXTURE16: cInt = c.GL_TEXTURE16;
        // pub const TEXTURE17: cInt = c.GL_TEXTURE17;
        // pub const TEXTURE18: cInt = c.GL_TEXTURE18;
        // pub const TEXTURE19: cInt = c.GL_TEXTURE19;
        // pub const TEXTURE2: cInt = c.GL_TEXTURE2;
        // pub const TEXTURE20: cInt = c.GL_TEXTURE20;
        // pub const TEXTURE21: cInt = c.GL_TEXTURE21;
        // pub const TEXTURE22: cInt = c.GL_TEXTURE22;
        // pub const TEXTURE23: cInt = c.GL_TEXTURE23;
        // pub const TEXTURE24: cInt = c.GL_TEXTURE24;
        // pub const TEXTURE25: cInt = c.GL_TEXTURE25;
        // pub const TEXTURE26: cInt = c.GL_TEXTURE26;
        // pub const TEXTURE27: cInt = c.GL_TEXTURE27;
        // pub const TEXTURE28: cInt = c.GL_TEXTURE28;
        // pub const TEXTURE29: cInt = c.GL_TEXTURE29;
        // pub const TEXTURE3: cInt = c.GL_TEXTURE3;
        // pub const TEXTURE30: cInt = c.GL_TEXTURE30;
        // pub const TEXTURE31: cInt = c.GL_TEXTURE31;
        // pub const TEXTURE4: cInt = c.GL_TEXTURE4;
        // pub const TEXTURE5: cInt = c.GL_TEXTURE5;
        // pub const TEXTURE6: cInt = c.GL_TEXTURE6;
        // pub const TEXTURE7: cInt = c.GL_TEXTURE7;
        // pub const TEXTURE8: cInt = c.GL_TEXTURE8;
        // pub const TEXTURE9: cInt = c.GL_TEXTURE9;
        // pub const TEXTURE_1D: cInt = c.GL_TEXTURE_1D;
        // pub const TEXTURE_1D_ARRAY: cInt = c.GL_TEXTURE_1D_ARRAY;
        // pub const TEXTURE_2D: cInt = c.GL_TEXTURE_2D;
        // pub const TEXTURE_2D_ARRAY: cInt = c.GL_TEXTURE_2D_ARRAY;
        // pub const TEXTURE_2D_MULTISAMPLE: cInt = c.GL_TEXTURE_2D_MULTISAMPLE;
        // pub const TEXTURE_2D_MULTISAMPLE_ARRAY: cInt = c.GL_TEXTURE_2D_MULTISAMPLE_ARRAY;
        // pub const TEXTURE_3D: cInt = c.GL_TEXTURE_3D;
        // pub const TEXTURE_ALPHA_SIZE: cInt = c.GL_TEXTURE_ALPHA_SIZE;
        // pub const TEXTURE_ALPHA_TYPE: cInt = c.GL_TEXTURE_ALPHA_TYPE;
        // pub const TEXTURE_BASE_LEVEL: cInt = c.GL_TEXTURE_BASE_LEVEL;
        // pub const TEXTURE_BINDING_1D: cInt = c.GL_TEXTURE_BINDING_1D;
        // pub const TEXTURE_BINDING_1D_ARRAY: cInt = c.GL_TEXTURE_BINDING_1D_ARRAY;
        // pub const TEXTURE_BINDING_2D: cInt = c.GL_TEXTURE_BINDING_2D;
        // pub const TEXTURE_BINDING_2D_ARRAY: cInt = c.GL_TEXTURE_BINDING_2D_ARRAY;
        // pub const TEXTURE_BINDING_2D_MULTISAMPLE: cInt = c.GL_TEXTURE_BINDING_2D_MULTISAMPLE;
        // pub const TEXTURE_BINDING_2D_MULTISAMPLE_ARRAY: cInt = c.GL_TEXTURE_BINDING_2D_MULTISAMPLE_ARRAY;
        // pub const TEXTURE_BINDING_3D: cInt = c.GL_TEXTURE_BINDING_3D;
        // pub const TEXTURE_BINDING_BUFFER: cInt = c.GL_TEXTURE_BINDING_BUFFER;
        // pub const TEXTURE_BINDING_CUBE_MAP: cInt = c.GL_TEXTURE_BINDING_CUBE_MAP;
        // pub const TEXTURE_BINDING_CUBE_MAP_ARRAY: cInt = c.GL_TEXTURE_BINDING_CUBE_MAP_ARRAY;
        // pub const TEXTURE_BINDING_RECTANGLE: cInt = c.GL_TEXTURE_BINDING_RECTANGLE;
        // pub const TEXTURE_BLUE_SIZE: cInt = c.GL_TEXTURE_BLUE_SIZE;
        // pub const TEXTURE_BLUE_TYPE: cInt = c.GL_TEXTURE_BLUE_TYPE;
        // pub const TEXTURE_BORDER_COLOR: cInt = c.GL_TEXTURE_BORDER_COLOR;
        // pub const TEXTURE_BUFFER: cInt = c.GL_TEXTURE_BUFFER;
        // pub const TEXTURE_BUFFER_DATA_STORE_BINDING: cInt = c.GL_TEXTURE_BUFFER_DATA_STORE_BINDING;
        // pub const TEXTURE_COMPARE_FUNC: cInt = c.GL_TEXTURE_COMPARE_FUNC;
        // pub const TEXTURE_COMPARE_MODE: cInt = c.GL_TEXTURE_COMPARE_MODE;
        // pub const TEXTURE_COMPRESSED: cInt = c.GL_TEXTURE_COMPRESSED;
        // pub const TEXTURE_COMPRESSED_IMAGE_SIZE: cInt = c.GL_TEXTURE_COMPRESSED_IMAGE_SIZE;
        // pub const TEXTURE_COMPRESSION_HINT: cInt = c.GL_TEXTURE_COMPRESSION_HINT;
        // pub const TEXTURE_CUBE_MAP: cInt = c.GL_TEXTURE_CUBE_MAP;
        // pub const TEXTURE_CUBE_MAP_ARRAY: cInt = c.GL_TEXTURE_CUBE_MAP_ARRAY;
        // pub const TEXTURE_CUBE_MAP_NEGATIVE_X: cInt = c.GL_TEXTURE_CUBE_MAP_NEGATIVE_X;
        // pub const TEXTURE_CUBE_MAP_NEGATIVE_Y: cInt = c.GL_TEXTURE_CUBE_MAP_NEGATIVE_Y;
        // pub const TEXTURE_CUBE_MAP_NEGATIVE_Z: cInt = c.GL_TEXTURE_CUBE_MAP_NEGATIVE_Z;
        // pub const TEXTURE_CUBE_MAP_POSITIVE_X: cInt = c.GL_TEXTURE_CUBE_MAP_POSITIVE_X;
        // pub const TEXTURE_CUBE_MAP_POSITIVE_Y: cInt = c.GL_TEXTURE_CUBE_MAP_POSITIVE_Y;
        // pub const TEXTURE_CUBE_MAP_POSITIVE_Z: cInt = c.GL_TEXTURE_CUBE_MAP_POSITIVE_Z;
        // pub const TEXTURE_CUBE_MAP_SEAMLESS: cInt = c.GL_TEXTURE_CUBE_MAP_SEAMLESS;
        // pub const TEXTURE_DEPTH: cInt = c.GL_TEXTURE_DEPTH;
        // pub const TEXTURE_DEPTH_SIZE: cInt = c.GL_TEXTURE_DEPTH_SIZE;
        // pub const TEXTURE_DEPTH_TYPE: cInt = c.GL_TEXTURE_DEPTH_TYPE;
        // pub const TEXTURE_FIXED_SAMPLE_LOCATIONS: cInt = c.GL_TEXTURE_FIXED_SAMPLE_LOCATIONS;
        // pub const TEXTURE_GREEN_SIZE: cInt = c.GL_TEXTURE_GREEN_SIZE;
        // pub const TEXTURE_GREEN_TYPE: cInt = c.GL_TEXTURE_GREEN_TYPE;
        // pub const TEXTURE_HEIGHT: cInt = c.GL_TEXTURE_HEIGHT;
        // pub const TEXTURE_INTERNAL_FORMAT: cInt = c.GL_TEXTURE_INTERNAL_FORMAT;
        // pub const TEXTURE_LOD_BIAS: cInt = c.GL_TEXTURE_LOD_BIAS;
        // pub const TEXTURE_MAG_FILTER: cInt = c.GL_TEXTURE_MAG_FILTER;
        // pub const TEXTURE_MAX_LEVEL: cInt = c.GL_TEXTURE_MAX_LEVEL;
        // pub const TEXTURE_MAX_LOD: cInt = c.GL_TEXTURE_MAX_LOD;
        // pub const TEXTURE_MIN_FILTER: cInt = c.GL_TEXTURE_MIN_FILTER;
        // pub const TEXTURE_MIN_LOD: cInt = c.GL_TEXTURE_MIN_LOD;
        // pub const TEXTURE_RECTANGLE: cInt = c.GL_TEXTURE_RECTANGLE;
        // pub const TEXTURE_RED_SIZE: cInt = c.GL_TEXTURE_RED_SIZE;
        // pub const TEXTURE_RED_TYPE: cInt = c.GL_TEXTURE_RED_TYPE;
        // pub const TEXTURE_SAMPLES: cInt = c.GL_TEXTURE_SAMPLES;
        // pub const TEXTURE_SHARED_SIZE: cInt = c.GL_TEXTURE_SHARED_SIZE;
        // pub const TEXTURE_STENCIL_SIZE: cInt = c.GL_TEXTURE_STENCIL_SIZE;
        // pub const TEXTURE_SWIZZLE_A: cInt = c.GL_TEXTURE_SWIZZLE_A;
        // pub const TEXTURE_SWIZZLE_B: cInt = c.GL_TEXTURE_SWIZZLE_B;
        // pub const TEXTURE_SWIZZLE_G: cInt = c.GL_TEXTURE_SWIZZLE_G;
        // pub const TEXTURE_SWIZZLE_R: cInt = c.GL_TEXTURE_SWIZZLE_R;
        // pub const TEXTURE_SWIZZLE_RGBA: cInt = c.GL_TEXTURE_SWIZZLE_RGBA;
        // pub const TEXTURE_WIDTH: cInt = c.GL_TEXTURE_WIDTH;
        // pub const TEXTURE_WRAP_R: cInt = c.GL_TEXTURE_WRAP_R;
        // pub const TEXTURE_WRAP_S: cInt = c.GL_TEXTURE_WRAP_S;
        // pub const TEXTURE_WRAP_T: cInt = c.GL_TEXTURE_WRAP_T;
        // pub const TIMEOUT_EXPIRED: cInt = c.GL_TIMEOUT_EXPIRED;
        // pub const TIMEOUT_IGNORED: cInt = c.GL_TIMEOUT_IGNORED;
        // pub const TIMESTAMP: cInt = c.GL_TIMESTAMP;
        // pub const TIME_ELAPSED: cInt = c.GL_TIME_ELAPSED;
        // pub const TRANSFORM_FEEDBACK: cInt = c.GL_TRANSFORM_FEEDBACK;
        // pub const TRANSFORM_FEEDBACK_BINDING: cInt = c.GL_TRANSFORM_FEEDBACK_BINDING;
        // pub const TRANSFORM_FEEDBACK_BUFFER: cInt = c.GL_TRANSFORM_FEEDBACK_BUFFER;
        // pub const TRANSFORM_FEEDBACK_BUFFER_ACTIVE: cInt = c.GL_TRANSFORM_FEEDBACK_BUFFER_ACTIVE;
        // pub const TRANSFORM_FEEDBACK_BUFFER_BINDING: cInt = c.GL_TRANSFORM_FEEDBACK_BUFFER_BINDING;
        // pub const TRANSFORM_FEEDBACK_BUFFER_MODE: cInt = c.GL_TRANSFORM_FEEDBACK_BUFFER_MODE;
        // pub const TRANSFORM_FEEDBACK_BUFFER_PAUSED: cInt = c.GL_TRANSFORM_FEEDBACK_BUFFER_PAUSED;
        // pub const TRANSFORM_FEEDBACK_BUFFER_SIZE: cInt = c.GL_TRANSFORM_FEEDBACK_BUFFER_SIZE;
        // pub const TRANSFORM_FEEDBACK_BUFFER_START: cInt = c.GL_TRANSFORM_FEEDBACK_BUFFER_START;
        // pub const TRANSFORM_FEEDBACK_PRIMITIVES_WRITTEN: cInt = c.GL_TRANSFORM_FEEDBACK_PRIMITIVES_WRITTEN;
        // pub const TRANSFORM_FEEDBACK_VARYINGS: cInt = c.GL_TRANSFORM_FEEDBACK_VARYINGS;
        // pub const TRANSFORM_FEEDBACK_VARYING_MAX_LENGTH: cInt = c.GL_TRANSFORM_FEEDBACK_VARYING_MAX_LENGTH;
        pub const TRIANGLES: Int = c.GL_TRIANGLES;
        // pub const TRIANGLES_ADJACENCY: cInt = c.GL_TRIANGLES_ADJACENCY;
        // pub const TRIANGLE_FAN: cInt = c.GL_TRIANGLE_FAN;
        // pub const TRIANGLE_STRIP: cInt = c.GL_TRIANGLE_STRIP;
        // pub const TRIANGLE_STRIP_ADJACENCY: cInt = c.GL_TRIANGLE_STRIP_ADJACENCY;

        // pub const UNDEFINED_VERTEX: cInt = c.GL_UNDEFINED_VERTEX;
        // pub const UNIFORM_ARRAY_STRIDE: cInt = c.GL_UNIFORM_ARRAY_STRIDE;
        // pub const UNIFORM_BLOCK_ACTIVE_UNIFORMS: cInt = c.GL_UNIFORM_BLOCK_ACTIVE_UNIFORMS;
        // pub const UNIFORM_BLOCK_ACTIVE_UNIFORM_INDICES: cInt = c.GL_UNIFORM_BLOCK_ACTIVE_UNIFORM_INDICES;
        // pub const UNIFORM_BLOCK_BINDING: cInt = c.GL_UNIFORM_BLOCK_BINDING;
        // pub const UNIFORM_BLOCK_DATA_SIZE: cInt = c.GL_UNIFORM_BLOCK_DATA_SIZE;
        // pub const UNIFORM_BLOCK_INDEX: cInt = c.GL_UNIFORM_BLOCK_INDEX;
        // pub const UNIFORM_BLOCK_NAME_LENGTH: cInt = c.GL_UNIFORM_BLOCK_NAME_LENGTH;
        // pub const UNIFORM_BLOCK_REFERENCED_BY_FRAGMENT_SHADER: cInt = c.GL_UNIFORM_BLOCK_REFERENCED_BY_FRAGMENT_SHADER;
        // pub const UNIFORM_BLOCK_REFERENCED_BY_GEOMETRY_SHADER: cInt = c.GL_UNIFORM_BLOCK_REFERENCED_BY_GEOMETRY_SHADER;
        // pub const UNIFORM_BLOCK_REFERENCED_BY_TESS_CONTROL_SHADER: cInt = c.GL_UNIFORM_BLOCK_REFERENCED_BY_TESS_CONTROL_SHADER;
        // pub const UNIFORM_BLOCK_REFERENCED_BY_TESS_EVALUATION_SHADER: cInt = c.GL_UNIFORM_BLOCK_REFERENCED_BY_TESS_EVALUATION_SHADER;
        // pub const UNIFORM_BLOCK_REFERENCED_BY_VERTEX_SHADER: cInt = c.GL_UNIFORM_BLOCK_REFERENCED_BY_VERTEX_SHADER;
        // pub const UNIFORM_BUFFER: cInt = c.GL_UNIFORM_BUFFER;
        // pub const UNIFORM_BUFFER_BINDING: cInt = c.GL_UNIFORM_BUFFER_BINDING;
        // pub const UNIFORM_BUFFER_OFFSET_ALIGNMENT: cInt = c.GL_UNIFORM_BUFFER_OFFSET_ALIGNMENT;
        // pub const UNIFORM_BUFFER_SIZE: cInt = c.GL_UNIFORM_BUFFER_SIZE;
        // pub const UNIFORM_BUFFER_START: cInt = c.GL_UNIFORM_BUFFER_START;
        // pub const UNIFORM_IS_ROW_MAJOR: cInt = c.GL_UNIFORM_IS_ROW_MAJOR;
        // pub const UNIFORM_MATRIX_STRIDE: cInt = c.GL_UNIFORM_MATRIX_STRIDE;
        // pub const UNIFORM_NAME_LENGTH: cInt = c.GL_UNIFORM_NAME_LENGTH;
        // pub const UNIFORM_OFFSET: cInt = c.GL_UNIFORM_OFFSET;
        // pub const UNIFORM_SIZE: cInt = c.GL_UNIFORM_SIZE;
        // pub const UNIFORM_TYPE: cInt = c.GL_UNIFORM_TYPE;
        // pub const UNPACK_ALIGNMENT: cInt = c.GL_UNPACK_ALIGNMENT;
        // pub const UNPACK_IMAGE_HEIGHT: cInt = c.GL_UNPACK_IMAGE_HEIGHT;
        // pub const UNPACK_LSB_FIRST: cInt = c.GL_UNPACK_LSB_FIRST;
        // pub const UNPACK_ROW_LENGTH: cInt = c.GL_UNPACK_ROW_LENGTH;
        // pub const UNPACK_SKIP_IMAGES: cInt = c.GL_UNPACK_SKIP_IMAGES;
        // pub const UNPACK_SKIP_PIXELS: cInt = c.GL_UNPACK_SKIP_PIXELS;
        // pub const UNPACK_SKIP_ROWS: cInt = c.GL_UNPACK_SKIP_ROWS;
        // pub const UNPACK_SWAP_BYTES: cInt = c.GL_UNPACK_SWAP_BYTES;
        // pub const UNSIGNALED: cInt = c.GL_UNSIGNALED;
        // pub const UNSIGNED_BYTE: cInt = c.GL_UNSIGNED_BYTE;
        // pub const UNSIGNED_BYTE_2_3_3_REV: cInt = c.GL_UNSIGNED_BYTE_2_3_3_REV;
        // pub const UNSIGNED_BYTE_3_3_2: cInt = c.GL_UNSIGNED_BYTE_3_3_2;

        // pub const UNSIGNED_INT_10F_11F_11F_REV: cInt = c.GL_UNSIGNED_INT_10F_11F_11F_REV;
        // pub const UNSIGNED_INT_10_10_10_2: cInt = c.GL_UNSIGNED_INT_10_10_10_2;
        // pub const UNSIGNED_INT_24_8: cInt = c.GL_UNSIGNED_INT_24_8;
        // pub const UNSIGNED_INT_2_10_10_10_REV: cInt = c.GL_UNSIGNED_INT_2_10_10_10_REV;
        // pub const UNSIGNED_INT_5_9_9_9_REV: cInt = c.GL_UNSIGNED_INT_5_9_9_9_REV;
        // pub const UNSIGNED_INT_8_8_8_8: cInt = c.GL_UNSIGNED_INT_8_8_8_8;
        // pub const UNSIGNED_INT_8_8_8_8_REV: cInt = c.GL_UNSIGNED_INT_8_8_8_8_REV;
        // pub const UNSIGNED_INT_SAMPLER_1D: cInt = c.GL_UNSIGNED_INT_SAMPLER_1D;
        // pub const UNSIGNED_INT_SAMPLER_1D_ARRAY: cInt = c.GL_UNSIGNED_INT_SAMPLER_1D_ARRAY;
        // pub const UNSIGNED_INT_SAMPLER_2D: cInt = c.GL_UNSIGNED_INT_SAMPLER_2D;
        // pub const UNSIGNED_INT_SAMPLER_2D_ARRAY: cInt = c.GL_UNSIGNED_INT_SAMPLER_2D_ARRAY;
        // pub const UNSIGNED_INT_SAMPLER_2D_MULTISAMPLE: cInt = c.GL_UNSIGNED_INT_SAMPLER_2D_MULTISAMPLE;
        // pub const UNSIGNED_INT_SAMPLER_2D_MULTISAMPLE_ARRAY: cInt = c.GL_UNSIGNED_INT_SAMPLER_2D_MULTISAMPLE_ARRAY;
        // pub const UNSIGNED_INT_SAMPLER_2D_RECT: cInt = c.GL_UNSIGNED_INT_SAMPLER_2D_RECT;
        // pub const UNSIGNED_INT_SAMPLER_3D: cInt = c.GL_UNSIGNED_INT_SAMPLER_3D;
        // pub const UNSIGNED_INT_SAMPLER_BUFFER: cInt = c.GL_UNSIGNED_INT_SAMPLER_BUFFER;
        // pub const UNSIGNED_INT_SAMPLER_CUBE: cInt = c.GL_UNSIGNED_INT_SAMPLER_CUBE;
        // pub const UNSIGNED_INT_SAMPLER_CUBE_MAP_ARRAY: cInt = c.GL_UNSIGNED_INT_SAMPLER_CUBE_MAP_ARRAY;
        // pub const UNSIGNED_INT_VEC2: cInt = c.GL_UNSIGNED_INT_VEC2;
        // pub const UNSIGNED_INT_VEC3: cInt = c.GL_UNSIGNED_INT_VEC3;
        // pub const UNSIGNED_INT_VEC4: cInt = c.GL_UNSIGNED_INT_VEC4;
        // pub const UNSIGNED_NORMALIZED: cInt = c.GL_UNSIGNED_NORMALIZED;
        // pub const UNSIGNED_SHORT: cInt = c.GL_UNSIGNED_SHORT;
        // pub const UNSIGNED_SHORT_1_5_5_5_REV: cInt = c.GL_UNSIGNED_SHORT_1_5_5_5_REV;
        // pub const UNSIGNED_SHORT_4_4_4_4: cInt = c.GL_UNSIGNED_SHORT_4_4_4_4;
        // pub const UNSIGNED_SHORT_4_4_4_4_REV: cInt = c.GL_UNSIGNED_SHORT_4_4_4_4_REV;
        // pub const UNSIGNED_SHORT_5_5_5_1: cInt = c.GL_UNSIGNED_SHORT_5_5_5_1;
        // pub const UNSIGNED_SHORT_5_6_5: cInt = c.GL_UNSIGNED_SHORT_5_6_5;
        // pub const UNSIGNED_SHORT_5_6_5_REV: cInt = c.GL_UNSIGNED_SHORT_5_6_5_REV;
        // pub const UPPER_LEFT: cInt = c.GL_UPPER_LEFT;
        // pub const VALIDATE_STATUS: cInt = c.GL_VALIDATE_STATUS;
        // pub const VENDOR: cInt = c.GL_VENDOR;
        pub const VERSION: Int = c.GL_VERSION;
        // pub const VERTEX_ARRAY_BINDING: cInt = c.GL_VERTEX_ARRAY_BINDING;
        // pub const VERTEX_ATTRIB_ARRAY_BUFFER_BINDING: cInt = c.GL_VERTEX_ATTRIB_ARRAY_BUFFER_BINDING;
        // pub const VERTEX_ATTRIB_ARRAY_DIVISOR: cInt = c.GL_VERTEX_ATTRIB_ARRAY_DIVISOR;
        // pub const VERTEX_ATTRIB_ARRAY_ENABLED: cInt = c.GL_VERTEX_ATTRIB_ARRAY_ENABLED;
        // pub const VERTEX_ATTRIB_ARRAY_INTEGER: cInt = c.GL_VERTEX_ATTRIB_ARRAY_INTEGER;
        // pub const VERTEX_ATTRIB_ARRAY_NORMALIZED: cInt = c.GL_VERTEX_ATTRIB_ARRAY_NORMALIZED;
        // pub const VERTEX_ATTRIB_ARRAY_POINTER: cInt = c.GL_VERTEX_ATTRIB_ARRAY_POINTER;
        // pub const VERTEX_ATTRIB_ARRAY_SIZE: cInt = c.GL_VERTEX_ATTRIB_ARRAY_SIZE;
        // pub const VERTEX_ATTRIB_ARRAY_STRIDE: cInt = c.GL_VERTEX_ATTRIB_ARRAY_STRIDE;
        // pub const VERTEX_ATTRIB_ARRAY_TYPE: cInt = c.GL_VERTEX_ATTRIB_ARRAY_TYPE;
        // pub const VERTEX_PROGRAM_POINT_SIZE: cInt = c.GL_VERTEX_PROGRAM_POINT_SIZE;
        pub const VERTEX_SHADER: Int = c.GL_VERTEX_SHADER;
        // pub const VERTEX_SHADER_BIT: cInt = c.GL_VERTEX_SHADER_BIT;
        // pub const VIEWPORT: cInt = c.GL_VIEWPORT;
        // pub const VIEWPORT_BOUNDS_RANGE: cInt = c.GL_VIEWPORT_BOUNDS_RANGE;
        // pub const VIEWPORT_INDEX_PROVOKING_VERTEX: cInt = c.GL_VIEWPORT_INDEX_PROVOKING_VERTEX;
        // pub const VIEWPORT_SUBPIXEL_BITS: cInt = c.GL_VIEWPORT_SUBPIXEL_BITS;
        // pub const WAIT_FAILED: cInt = c.GL_WAIT_FAILED;
        // pub const WRITE_ONLY: cInt = c.GL_WRITE_ONLY;
        // pub const XOR: cInt = c.GL_XOR;

        // pub const VERSION_1_0: cInt = c.GL_VERSION_1_0;
        // pub const VERSION_1_1: cInt = c.GL_VERSION_1_1;
        // pub const VERSION_1_2: cInt = c.GL_VERSION_1_2;
        // pub const VERSION_1_3: cInt = c.GL_VERSION_1_3;
        // pub const VERSION_1_4: cInt = c.GL_VERSION_1_4;
        // pub const VERSION_1_5: cInt = c.GL_VERSION_1_5;
        // pub const VERSION_2_0: cInt = c.GL_VERSION_2_0;
        // pub const VERSION_2_1: cInt = c.GL_VERSION_2_1;
        // pub const VERSION_3_0: cInt = c.GL_VERSION_3_0;
        // pub const VERSION_3_1: cInt = c.GL_VERSION_3_1;
        // pub const VERSION_3_2: cInt = c.GL_VERSION_3_2;
        // pub const VERSION_3_3: cInt = c.GL_VERSION_3_3;
        // pub const VERSION_4_0: cInt = c.GL_VERSION_4_0;
        // pub const VERSION_4_1: cInt = c.GL_VERSION_4_1;

        // Straight-through functions

        /// Returns a parameter from a shader object
        /// #### Parameters
        /// - shader - Specifies the shader object to be queried.
        /// - pname  - Specifies the object parameter. Accepted symbolic names are `SHADER_TYPE`, `DELETE_STATUS`, `COMPILE_STATUS`, `INFO_LOG_LENGTH`, `SHADER_SOURCE_LENGTH`.
        /// - params - Returns the requested object parameter.
        /// - [See glGetShaderiv on docs.gl](https://docs.gl/gl4/glGetShader)
        pub fn getShaderiv(shader: Uint, pname: Enum, params: [*c]Int) void {
            c.glGetShaderiv(shader, pname, params);
        }

        /// Returns the information log for a shader object
        /// #### Parameters
        /// - shader    - Specifies the shader object whose information log is to be queried.
        /// - maxLength - Specifies the size of the character buffer for storing the returned information log.
        /// - length    - Returns the length of the string returned in infoLog (excluding the null terminator).
        /// - infoLog   - Specifies an array of characters that is used to return the information log.
        /// - [See glGetShaderInfoLog on docs.gl](https://docs.gl/gl4/glGetShaderInfoLog)
        pub fn getShaderInfoLog(shader: Uint, maxLength: Sizei, length: [*c]Sizei, infoLog: [*c]Char) void {
            c.glGetShaderInfoLog(shader, maxLength, length, infoLog);
        }

        /// Returns a parameter from a program object
        /// #### Parameters
        /// - program - specifies the program object to be queried.
        /// - pname - Specifies the object parameter. Accepted symbolic names are `DELETE_STATUS`, `LINK_STATUS`, `VALIDATE_STATUS`, `INFO_LOG_LENGTH`, `ATTACHED_SHADERS`, `ACTIVE_ATOMIC_COUNTER_BUFFERS`, `ACTIVE_ATTRIBUTES`, `ACTIVE_ATTRIBUTE_MAX_LENGTH`, `ACTIVE_UNIFORMS`, `ACTIVE_UNIFORM_BLOCKS`, `ACTIVE_UNIFORM_BLOCK_MAX_NAME_LENGTH`, `ACTIVE_UNIFORM_MAX_LENGTH`, `COMPUTE_WORK_GROUP_SIZE`, `PROGRAM_BINARY_LENGTH`, `TRANSFORM_FEEDBACK_BUFFER_MODE`, `TRANSFORM_FEEDBACK_VARYINGS`, `TRANSFORM_FEEDBACK_VARYING_MAX_LENGTH`, `GEOMETRY_VERTICES_OUT`, `GEOMETRY_INPUT_TYPE`, and `GEOMETRY_OUTPUT_TYPE`.
        /// - params - Returns the requested object parameter.
        /// - [See glGetProgramiv on docs.gl](https://docs.gl/gl4/glGetProgram)
        pub fn getProgramiv(program: Uint, pname: Enum, params: [*c]Int) void {
            c.glGetProgramiv(program, pname, params);
        }

        /// Creates a shader object
        /// #### Parameters
        /// - shaderType - Specifies the type of shader to be created. Must be one of `COMPUTE_SHADER`, `VERTEX_SHADER`, `TESS_CONTROL_SHADER`, `TESS_EVALUATION_SHADER`, `GEOMETRY_SHADER`, or `FRAGMENT_SHADER`.
        /// - [See glCreateShader on docs.gl](https://docs.gl/gl4/glCreateShader)
        pub fn createShader(shaderType: Enum) Uint {
            return c.glCreateShader(shaderType);
        }

        /// Replaces the source code in a shader object
        /// #### Parameters
        /// - shader - Specifies the handle of the shader object whose source code is to be replaced.
        /// - count - Specifies the number of elements in the `string` and `length` arrays.
        /// - string - Specifies an array of pointers to strings containing the source code to be loaded into the shader.
        /// - length - Specifies an array of string lengths.
        /// - [See glShaderSource on docs.gl](https://docs.gl/gl4/glShaderSource)
        pub fn shaderSource(shader: Uint, count: Sizei, string: [*c]const [*c]const Char, length: [*c]const Int) void {
            c.glShaderSource(shader, count, string, length);
        }

        /// Compiles a shader object
        /// #### Parameters
        /// - shader - Specifies the shader object to be compiled.
        /// - [See glCompileShader on docs.gl](https://docs.gl/gl4/glCompileShader)
        pub fn compileShader(shader: Uint) void {
            c.glCompileShader(shader);
        }

        /// select a polygon rasterization mode
        /// #### Parameters
        /// - face - Specifies the polygons that mode applies to. Must be GL_FRONT_AND_BACK for front- and back-facing polygons.
        /// - mode - Specifies how polygons will be rasterized. Accepted values are `POINT`, `LINE`, and `FILL`. The initial value is `FILL` for both front- and back-facing polygons.
        /// - [See glPolygonMode on docs.gl](https://docs.gl/gl4/glPolygonMode)
        pub fn polygonMode(face: Enum, mode: Enum) void {
            c.glPolygonMode(face, mode);
        }

        /// bind a vertex array object
        /// #### Parameters
        /// - array - Specifies the name of the vertex array to bind.
        /// - [See glBindVertexArray on docs.gl](https://docs.gl/gl4/glBindVertexArray)
        pub fn bindVertexArray(array: Uint) void {
            c.glBindVertexArray(array);
        }

        /// bind a named buffer object
        /// #### Parameters
        /// - target - Specifies the target to which the buffer object is bound, which must be one of the buffer binding targets. See table in docs.
        /// - buffer - Specifies the name of a buffer object.
        /// - [See glBindBuffer on docs.gl](https://docs.gl/gl4/glBindBuffer)
        pub fn bindBuffer(target: Enum, buffer: Uint) void {
            c.glBindBuffer(target, buffer);
        }

        /// creates and initializes a buffer object's data store
        /// #### Parameters
        /// - target - Specifies the target to which the buffer object is bound for glBufferData, which must be one of the buffer binding targets. See table in docs.
        /// - size - Specifies the size in bytes of the buffer object's new data store.
        /// - data - Specifies a pointer to data that will be copied into the data store for initialization, or NULL if no data is to be copied.
        /// - usage - Specifies the expected usage pattern of the data store. The symbolic constant must be `STREAM_DRAW`, `STREAM_READ`, `STREAM_COPY`, `STATIC_DRAW`, `STATIC_READ`, `STATIC_COPY`, `DYNAMIC_DRAW`, `DYNAMIC_READ`, or `DYNAMIC_COPY`.
        /// - [See glBufferData on docs.gl](https://docs.gl/gl4/glBufferData)
        pub fn bufferData(target: Enum, size: Sizeiptr, data: ?*const anyopaque, usage: Enum) void {
            c.glBufferData(target, size, data, usage);
        }

        /// ..
        /// #### Parameters
        /// - ..
        /// - [See glDrawElements on docs.gl](https://docs.gl/gl4/glDrawElements)
        pub fn drawElements(mode: Enum, count: Sizei, typeTag: Enum, indices: ?*const anyopaque) void {
            c.glDrawElements(mode, count, typeTag, indices);
        }

        /// ..
        /// #### Parameters
        /// - ..
        /// - [See glDrawArrays on docs.gl](https://docs.gl/gl4/glDrawArrays)
        pub fn drawArrays(mode: Enum, first: Int, count: Sizei) void {
            c.glDrawArrays(mode, first, count);
        }

        /// ..
        /// #### Parameters
        /// - ..
        /// - [See glCreateProgram on docs.gl](https://docs.gl/gl4/glCreateProgram)
        pub fn createProgram() Uint {
            return c.glCreateProgram();
        }

        /// ..
        /// #### Parameters
        /// - ..
        /// - [See glClear on docs.gl](https://docs.gl/gl4/glClear)
        pub fn clear(mask: Bitfield) void {
            c.glClear(mask);
        }

        /// ..
        /// #### Parameters
        /// - ..
        /// - [See glAttachShader on docs.gl](https://docs.gl/gl4/glAttachShader)
        pub fn attachShader(program: Uint, shader: Uint) void {
            c.glAttachShader(program, shader);
        }

        /// ..
        /// #### Parameters
        /// - ..
        /// - [See glDeleteShader on docs.gl](https://docs.gl/gl4/glDeleteShader)
        pub fn deleteShader(shader: Uint) void {
            c.glDeleteShader(shader);
        }

        /// ..
        /// #### Parameters
        /// - ..
        /// - [See glLinkProgram on docs.gl](https://docs.gl/gl4/glLinkProgram)
        pub fn linkProgram(shader: Uint) void {
            c.glLinkProgram(shader);
        }

        /// ..
        /// #### Parameters
        /// - ..
        /// - [See glUseProgram on docs.gl](https://docs.gl/gl4/glUseProgram)
        pub fn useProgram(program: Uint) void {
            c.glUseProgram(program);
        }

        /// ..
        /// #### Parameters
        /// - ..
        /// - [See glGetProgramInfoLog on docs.gl](https://docs.gl/gl4/glGetProgramInfoLog)
        pub fn getProgramInfoLog(program: Uint, maxLength: Sizei, length: [*c]Sizei, infoLog: [*c]Char) void {
            c.glGetProgramInfoLog(program, maxLength, length, infoLog);
        }

        /// define an array of generic vertex attribute data
        /// #### Parameters
        /// - ..
        /// - [See glVertexAttribPointer on docs.gl](https://docs.gl/gl4/glVertexAttribPointer)
        pub fn vertexAttribPointer(index: Uint, size: Int, typeTag: Enum, normalized: Boolean, stride: Sizei, pointer: ?*const anyopaque) void {
            c.glVertexAttribPointer(index, size, typeTag, normalized, stride, pointer);
        }

        /// Enable or disable a generic vertex attribute array
        /// #### Parameters
        /// - ..
        /// - [See glEnableVertexAttribArray on docs.gl](https://docs.gl/gl4/glEnableVertexAttribArray)
        pub fn enableVertexAttribArray(index: Uint) void {
            c.glEnableVertexAttribArray(index);
        }

        /// Returns the location of a uniform variable
        /// #### Parameters
        /// - ..
        /// - [See glGetUniformLocation on docs.gl](https://docs.gl/gl4/glGetUniformLocation)
        pub fn getUniformLocation(program: Uint, name: [*c]const Char) Int {
            return c.glGetUniformLocation(program, name);
        }

        /// Specify the value of a uniform variable for the current program object
        /// #### Parameters
        /// - ..
        /// - [See glUniformMatrix4fv on docs.gl](https://docs.gl/gl4/glUniform)
        pub fn uniformMatrix4fv(location: Int, count: Sizei, transpose: Boolean, value: [*c]const Float) void {
            c.glUniformMatrix4fv(location, count, transpose, value);
        }

        /// return error information
        /// #### Parameters
        /// - ..
        /// - [See glGetError on docs.gl](https://docs.gl/gl4/glGetError)
        pub fn getError() Enum {
            return c.glGetError();
        }

        /// generate buffer object names
        /// #### Parameters
        /// - ..
        /// - [See glGenBuffers on docs.gl](https://docs.gl/gl4/glGenBuffers)
        pub fn genBuffers(n: Sizei, buffers: [*c]Uint) void {
            c.glGenBuffers(n, buffers);
        }

        /// generate vertex array object names
        /// #### Parameters
        /// - ..
        /// - [See glGenVertexArrays on docs.gl](https://docs.gl/gl4/glGenVertexArrays)
        pub fn genVertexArrays(n: Sizei, arrays: [*c]Uint) void {
            c.glGenVertexArrays(n, arrays);
        }

        /// return a string describing the current GL connection
        /// #### Parameters
        /// - ..
        /// - [See glGetString on docs.gl](https://docs.gl/gl4/glGetString)
        pub fn getString(name: Enum) [*c]const Ubyte {
            return c.glGetString(name);
        }

        /// enable or disable server-side GL capabilities
        /// #### Parameters
        /// - ..
        /// - [See glEnable on docs.gl](https://docs.gl/gl4/glEnable)
        pub fn enable(cap: Enum) void {
            c.glEnable(cap);
        }

        /// specify the value used for depth buffer comparisons
        /// #### Parameters
        /// - ..
        /// - [See glDepthFunc on docs.gl](https://docs.gl/gl4/glDepthFunc)
        pub fn depthFunc(func: Enum) void {
            c.glDepthFunc(func);
        }

        /// Enable or disable a generic vertex attribute array
        /// #### Parameters
        /// - ..
        /// - [See glDisableVertexAttribArray on docs.gl](https://docs.gl/gl4/glDisableVertexAttribArray)
        pub fn disableVertexAttribArray(index: Uint) void {
            c.glDisableVertexAttribArray(index);
        }

        /// Detaches a shader object from a program object to which it is attached
        /// #### Parameters
        /// - ..
        /// - [See glDetachShader on docs.gl](https://docs.gl/gl4/glDetachShader)
        pub fn detachShader(program: Uint, shader: Uint) void {
            c.glDetachShader(program, shader);
        }

        /// specify clear values for the color buffers
        /// #### Parameters
        /// - ..
        /// - [See glClearColor on docs.gl](https://docs.gl/gl4/glClearColor)
        pub fn clearColor(red: Float, green: Float, blue: Float, alpha: Float) void {
            c.glClearColor(red, green, blue, alpha);
        }

        /// delete named buffer objects
        /// #### Parameters
        /// - ..
        /// - [See glDeleteBuffers on docs.gl](https://docs.gl/gl4/glDeleteBuffers)
        pub fn deleteBuffers(n: Sizei, buffers: [*c]const Uint) void {
            c.glDeleteBuffers(n, buffers);
        }

        /// delete vertex array objects
        /// #### Parameters
        /// - ..
        /// - [See glDeleteVertexArrays on docs.gl](https://docs.gl/gl4/glDeleteVertexArrays)
        pub fn deleteVertexArrays(n: Sizei, arrays: [*c]const Uint) void {
            c.glDeleteVertexArrays(n, arrays);
        }

        /// Deletes a program object
        /// #### Parameters
        /// - ..
        /// - [See glDeleteProgram on docs.gl](https://docs.gl/gl4/glDeleteProgram)
        pub fn deleteProgram(program: Uint) void {
            c.glDeleteProgram(program);
        }

        /// set the viewport
        /// #### Parameters
        /// - ..
        /// - [See glViewport on docs.gl](https://docs.gl/gl4/glViewport)
        pub fn viewport(x: Int, y: Int, width: Sizei, height: Sizei) void {
            c.glViewport(x, y, width, height);
        }
    };
}
