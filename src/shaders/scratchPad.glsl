#version 300 es // OpenGL ES 3.0 (GLSL v1.30)
precision mediump float;

//-----------------------------------------------------------------------------
// # On GLSL Versions
// 
// > No single GLSL version will guarantee complete cross-compatibility between
// > desktop OpenGL, WebGL, WebGPU, etc., due to the differences in features, 
// > specifications, and limitations across these platforms.
// > 
// > The closest approach might be to target a version like GLSL ES 3.00, which 
// > is widely supported and aligns with WebGL 2. But even then, adjustments
// > and considerations would likely be needed for each specific target
// > platform.
// > 
// > That's why utilizing tools, libraries, preprocessor directives, and 
// > consistent testing across platforms can be essential for maintaining 
// > cross-compatibility. It allows for more flexibility and adaptation to the 
// > unique requirements of each platform.
// > 
// > ChatGPT-4 2023-08-19
//
// ## Chosen Version - GLSL ES 3.00
// - vscode extention 'glsl-canvas' supports only upto ES 3.0
// - WebGL 2.0 is based on OpenGL ES 3.0
//
// ## Resources
// - [GL version/function compatibility guide](https://docs.gl/)
// - [Reserved built-in variables](https://www.khronos.org/opengl/wiki/Built-in_Variable_(GLSL))
// - [Learn shaders](https://thebookofshaders.com/)
// - [Try shareds online](http://editor.thebookofshaders.com/)
// 
//-----------------------------------------------------------------------------

// ============================================================================
// # FOR THIS FRAME, DO:

// default inputs - same for all pixels (uniform)
uniform vec2 u_resolution;  // Canvas size (width,height) with .x, .y
uniform vec2 u_mouse;       // mouse position in screen pixels
uniform float u_time;       // Time in seconds since load

// default input - changes per pixel (varying)
// holds the screen coordinates of the pixel or screen fragment that the active thread is working on.
// in vec4 gl_FragCoord; // reserved built-in variable

// default output
out vec4 fragColor;

vec4 red(){
    return vec4(1.0,0.0,0.0,1.0);
}

vec4 color = vec4(vec3(0.0,0.0,1.0),1.0);

// float r1() {
//     return 0.5 + 0.5 * sin(u_time);
// }

// // pi
// float pi = 3.14159265359;

// // 2pi
// float pi2 = 6.28318530718;

// float r2() {
//     return sin(u_time);
// }

// ============================================================================
// # FOR EACH PIXEL (of this frame), DO:
void main() {

  // The abbreviation "st" in the context of shaders often stands for "surface texture" or "shading texture" coordinates. It's a conventional way to refer to normalized coordinates, particularly in texture mapping.
  vec2 st = gl_FragCoord.xy/u_resolution;

  // mouse-to-screen coordinates (0,0 bottom left, 1,1 top right)
  vec2 mts = u_mouse.xy/u_resolution;

  // mouse-to-frame coordinates (-1,-1 bottom left, 1,1 top right)
  vec2 mtf = abs(u_mouse.xy/u_resolution * 2.0 - 1.0);

  // fragColor = vec4(st.x, st.y, 0.0, 1.0);
fragColor=vec4(st.x+mts.x,st.y+mts.y,0.,1.);
  // fragColor = vec4(st.x * sin(u_time), st.y * cos(u_time), 0.0, 1.0);
  // fragColor = vec4(mts.x, mts.y, 0.0, 1.0);
// fragColor=vec4(mtf.x,mtf.y,0.,1.);

	// fragColor = vec4(r2(),sin(u_time * 2.0),sin(u_time * 4.0),1.0);
}
