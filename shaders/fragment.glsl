#version 330 core

in vec3 vertexColor;
out vec4 FragColor;

uniform float time;

void main()
{
    // Animate colors slightly
    vec3 color = vertexColor;
    color.r *= (sin(time) * 0.5 + 0.5) * 0.5 + 0.5;
    color.g *= (cos(time * 0.7) * 0.5 + 0.5) * 0.5 + 0.5;
    color.b *= (sin(time * 1.3) * 0.5 + 0.5) * 0.5 + 0.5;
    
    FragColor = vec4(color, 1.0);
}
