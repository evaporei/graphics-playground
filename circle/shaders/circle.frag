#version 330

uniform vec2 resolution;

in vec2 uv;

layout(location = 0) out vec4 outColor;

void main() {
    float scale = 2.0; // inverse because of length
    float distance = 1.0 - length(uv * scale);
    distance = smoothstep(0.0, 0.01, distance);
    outColor.rgb = vec3(distance);
}
