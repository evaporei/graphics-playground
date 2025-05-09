#version 330 core

uniform vec2 resolution;

void main() {
    // gl_VertexID = 0 | 1 | 2 | 3
    // x = 0 | 1 | 0 | 1
    float x = float(gl_VertexID & 1);
    // y = 0 | 1 | 1 | 0
    float y = float((gl_VertexID >> 1) & 1);

    // {0, 0}, {1, 1}, {0, 1}, {1, 0}
    vec2 uv = vec2(x, y) - 0.5;
    float aspect = resolution.x / resolution.y;
    uv.xy *= aspect;

    gl_Position = vec4(uv, 0.0, 1.0);
}
