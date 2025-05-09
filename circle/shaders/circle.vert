#version 330 core

void main() {
    // gl_VertexID = 0 | 1 | 2 | 3
    // x = 0 | 1 | 0 | 1
    float x = float(gl_VertexID & 1);
    // y = 1 | 0 | 1 | 0
    float y = float((gl_VertexID >> 1) & 1);
    gl_Position = vec4(x - 0.5, y - 0.5, 0.0, 1.0);
}
