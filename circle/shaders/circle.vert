#version 330 core

uniform vec2 resolution;

out vec2 uv;

void main() {
    // gl_VertexID = 0 | 1 | 2 | 3
    // x = 0 | 1 | 0 | 1
    float x = float(gl_VertexID & 1);
    // y = 0 | 1 | 1 | 0
    float y = float((gl_VertexID >> 1) & 1);

    // { 0,  0}, {1, 1}, { 0, 1}, {1,  0}
    // {-1, -1}, {0, 0}, {-1, 0}, {0, -1}
    uv = vec2(x, y) * 2.0 - 1.0;

    gl_Position = vec4(uv, 0.0, 1.0);
}
