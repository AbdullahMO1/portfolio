#version 460 core

#include <flutter/runtime_effect.glsl>

uniform vec2 u_resolution;
uniform float u_time;
uniform vec2 u_mouse;
uniform float u_scroll;

out vec4 fragColor;

// ─── Premium theme colors: Imperial Navy, Gold, Slate ─────────

const vec3 NAVY_BASE    = vec3(0.04, 0.067, 0.157);   // #0A1128
const vec3 NAVY_SURFACE = vec3(0.059, 0.106, 0.239); // #0F1B3D
const vec3 GOLD         = vec3(0.831, 0.686, 0.216);  // #D4AF37
const vec3 GOLD_LIGHT   = vec3(1.0, 0.843, 0.0);     // #FFD700
const vec3 SLATE        = vec3(0.557, 0.604, 0.686);  // #8E9AAF
const vec3 TERTIARY     = vec3(0.898, 0.722, 0.043);  // #E5B80B

void main() {
    vec2 fragCoord = FlutterFragCoord().xy;
    vec2 uv = fragCoord / u_resolution;
    vec2 mouseNorm = u_mouse / u_resolution;

    float slowTime = u_time * 0.4;

    // Base gradient: navy with subtle gold tint toward center
    float centerDist = length(uv - 0.5) * 2.0;
    vec3 color = mix(
        mix(NAVY_SURFACE, GOLD * 0.1, uv.y * 0.25),
        NAVY_BASE,
        smoothstep(0.25, 1.2, centerDist)
    );

    // One big sine wave: horizontal, centered, slow undulation
    float freq = 1.2;
    float amp = 0.28;
    float wave = sin(uv.x * freq - slowTime) * amp;
    float distToWave = uv.y - 0.5 - wave;

    // Thick glowing band — 30% screen height with soft glow
    float waveWidth = 0.3;
    float waveGlow = 1.0 - smoothstep(0.0, waveWidth, abs(distToWave));
    waveGlow = pow(waveGlow, 1.3);

    // Premium gold gradient along the wave
    vec3 waveColor = mix(GOLD, GOLD_LIGHT, 0.5 + 0.5 * wave);
    color += waveColor * waveGlow * 0.55;

    // Subtle slate edge highlight
    float edgeGlow = 1.0 - smoothstep(0.06, waveWidth * 0.5, abs(distToWave));
    color += mix(SLATE, TERTIARY, 0.4) * edgeGlow * 0.1;

    // Mouse glow — enlarged radius and stronger visibility
    float mouseDist = length(uv - mouseNorm);
    float mouseGlow = 1.0 - smoothstep(0.0, 0.5, mouseDist);
    mouseGlow *= 0.5 + 0.5 * sin(slowTime * 2.0);
    color += GOLD_LIGHT * mouseGlow * 0.18;

    // Vignette for softer edges
    float vig = 1.0 - smoothstep(0.5, 1.8, length(uv - 0.5) * 2.0);
    color *= mix(0.75, 1.0, vig);

    // Reinhard tone mapping + gamma
    color = color / (1.0 + color);
    color = pow(color, vec3(0.9));

    fragColor = vec4(color, 1.0);
}
