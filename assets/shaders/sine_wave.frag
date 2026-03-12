#version 460 core
#include <flutter/runtime_effect.glsl>

uniform vec2 u_resolution;
uniform float u_time;
uniform vec2 u_mouse;
uniform float u_scroll;
uniform float u_place;

out vec4 fragColor;

const vec3 DEEP_NAVY = vec3(0.039, 0.067, 0.157);
const vec3 GOLD      = vec3(0.45, 0.35, 0.15);
const vec3 GOLD_LT   = vec3(0.55, 0.45, 0.25);
const vec3 GOLD_DK   = vec3(0.25, 0.18, 0.06);

float waveShape(float x, float t) {
    float w  = sin(x * 1.8 - t * 0.4) * 0.10;
    w += sin(x * 0.9 + t * 0.25) * 0.06;
    w += sin(x * 3.0 - t * 0.6) * 0.02;
    return w;
}

float waveSlope(float x, float t) {
    float d  = cos(x * 1.8 - t * 0.4) * 0.10 * 1.8;
    d += cos(x * 0.9 + t * 0.25) * 0.06 * 0.9;
    d += cos(x * 3.0 - t * 0.6) * 0.02 * 3.0;
    return d;
}

void main() {
    vec2 fragCoord = FlutterFragCoord().xy;
    vec2 uv = fragCoord / u_resolution;
    float aspect = u_resolution.x / u_resolution.y;

    float t = u_time;

    float x = uv.x * aspect * 2.0;
    float wave = waveShape(x, t);

    float breathe = sin(t * 0.1) * 0.04 + sin(t * 0.06) * 0.025;

    float center = 0.5 + wave + breathe + u_scroll * 0.1 + u_place * 0.05;

    float halfSpan = 0.5;
    float dist = uv.y - center;
    float absDist = abs(dist);

    float core = 1.0 - smoothstep(0.0, halfSpan * 0.15, absDist);
    float body = 1.0 - smoothstep(0.0, halfSpan * 0.5, absDist);
    float fade = 1.0 - smoothstep(0.0, halfSpan, absDist);

    float s = waveSlope(x, t) * aspect * 2.0;
    float invLen = 1.0 / sqrt(1.0 + s * s);
    vec2 normal = vec2(-s * invLen, invLen);

    float diffuse = max(dot(normal, normalize(vec2(0.5, 1.0))), 0.0);
    float spec = pow(max(dot(normal, normalize(vec2(0.3, 1.0))), 0.0), 20.0);

    float topSide = smoothstep(halfSpan * 0.2, 0.0, dist);

    vec3 col = DEEP_NAVY;

    vec3 waveColor = mix(GOLD_DK, GOLD, diffuse * 0.7 + 0.3);
    waveColor = mix(waveColor, GOLD_LT, topSide * core * 0.5);
    waveColor += spec * vec3(0.7, 0.65, 0.55) * 0.15;

    float opacity = fade * fade * 0.2 + body * 0.2 + core * 0.15;

    col = mix(col, waveColor, opacity);

    vec2 mouseNorm = u_mouse / u_resolution;
    float mouseGlow = 1.0 - smoothstep(0.0, 0.35, length(uv - mouseNorm));
    col += mouseGlow * GOLD * 0.02;

    fragColor = vec4(col, 1.0);
}
