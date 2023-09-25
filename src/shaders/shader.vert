#version 300 es
// OpenGL ES 3.0 (GLSL v1.30)
precision mediump float;

// // just some example code
// // copied from: https://github.com/tiehuis/zstack/blob/3a2e41008abc7eedc77eeaf0e8d56db96d8926b8/src/window_gl.zig#L182
// // #version 150 core

// // Input from main program
// in vec3 position;
// in vec3 faceNormal;

// // Output to fragment shader
// out vec3 normal;
// out vec3 fragPos;

// // Shared between pixels in frame, and shaders
// uniform vec2 offset;
// uniform mat3 scale;
// uniform mat4 viewport;

// void main()
// {
  //   //fragPos = vec3(viewport * vec4(position, 1.0));
  //   //normal = mat3(transpose(inverse(viewport))) * faceNormal;
  
  //   // gl_Position — contains the position of the current vertex
  
  //   gl_Position=vec4(position,1.)*mat4(scale);
  //   gl_Position.x+=offset.x;
  //   gl_Position.y+=offset.y;
  //   gl_Position=gl_Position*viewport;
  
  //   fragPos=vec3(gl_Position);
  //   normal=faceNormal;
// }

// OCDP
// #version 330 core

layout(location=0)in vec3 vertexPosition_modelspace;

// Notice that the "1" here equals the "1" in glVertexAttribPointer
// layout(location=1)in vec3 vertexColor;

// uniform mat4 model;
// uniform mat4 view;
// uniform mat4 projection;

// Output data ; will be interpolated for each fragment.
// out vec3 fragmentColor;

void main(){
  
// gl_Position=projection*view*model*vec4(vertexPosition_modelspace,1.);
gl_Position.xyz=vertexPosition_modelspace;
gl_Position.w=1.;

// The color of each vertex will be interpolated
// to produce the color of each fragment
// fragmentColor=vertexColor;
  
}
