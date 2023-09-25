#version 300 es
// OpenGL ES 3.0 (GLSL v1.30)
precision mediump float;

// // just some example code
// // copied from: https://github.com/tiehuis/zstack/blob/3a2e41008abc7eedc77eeaf0e8d56db96d8926b8/src/window_gl.zig#L182
// // #version 150 core

// // Pixel output
// out vec4 outColor;

// // Input from vertex shader
// in vec3 normal;
// in vec3 fragPos;

// // Shared between pixels in frame, and shaders
// uniform vec3 viewPos;
// uniform vec3 surfaceColor;
// uniform vec3 lightColor;
// uniform vec3 lightPos;
// uniform bool enableLighting;

// void main()
// {
  //   if (!enableLighting) {
    //       outColor = vec4(surfaceColor, 1.0);
  //   } else {
    //       float ambientStrength = 0.7;
    //       vec3 ambient = ambientStrength * lightColor;
    
    //       vec3 norm = normalize(normal);
    //       vec3 lightDir = normalize(lightPos - fragPos);
    //       float diff = max(dot(norm, lightDir), 0.0);
    //       vec3 diffuse = diff * lightColor;
    
    //       // float specularStrength = 0.5;
    //       // vec3 viewDir = normalize(viewPos - fragPos);
    //       // vec3 reflectDir = reflect(-lightDir, norm);
    //       // float spec = pow(max(dot(viewDir, reflectDir), 0.0), 32);
    //       // vec3 specular = specularStrength * spec * lightColor;
    //       //
    //       // vec3 result = (ambient + diffuse + specular) * surfaceColor;
    //       vec3 result = (ambient + diffuse) * surfaceColor;
    //       outColor = vec4(result, 1.0);
  //   }
// }

// OCDP
// #version 330 core

// Interpolated values from the vertex shaders
// in vec3 fragmentColor;

// out vec4 FragColor;
out vec3 color;

// uniform vec3 color;

void main(){
  
// FragColor=vec4(color,1.);
color=vec3(1,0,0);
  
}
