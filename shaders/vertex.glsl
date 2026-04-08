#version 330 core

layout (location = 0) in vec3 aPos;
layout (location = 1) in vec3 aColor;

out vec3 vertexColor;

uniform float time;

void main()
{
    // Add some animation
    vec3 pos = aPos;
    pos.y += sin(time + aPos.x * 2.0) * 0.1;
    
    gl_Position = vec4(pos, 1.0);
    vertexColor = aColor;
}
