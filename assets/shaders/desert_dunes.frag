#version 460 core

#include <flutter/runtime_effect.glsl>

uniform vec2 u_resolution;
uniform float u_time;
uniform vec2 u_mouse;
uniform float u_scroll;

out vec4 fragColor;

// ─── Persian Prince Desert Theme Colors ──────────────────────────────

const vec3 DESERT_SAND = vec3(0.941, 0.847, 0.698);     // #F0D8B2
const vec3 DESERT_SAND_DARK = vec3(0.824, 0.706, 0.549); // #D2B48C
const vec3 PERSIAN_GOLD = vec3(0.831, 0.686, 0.216);     // #D4AF37
const vec3 SUNSET_ORANGE = vec3(0.969, 0.549, 0.298);   // #F78C4C
const vec3 NIGHT_SKY = vec3(0.051, 0.051, 0.149);       // #0D0D26
const vec3 CAMEL_BROWN = vec3(0.545, 0.271, 0.075);      // #8B4513

// Noise function for natural sand texture
float noise(vec2 st) {
    return fract(sin(dot(st.xy, vec2(12.9898,78.233))) * 43758.5453123);
}

// Smooth noise interpolation
float smoothNoise(vec2 st) {
    vec2 i = floor(st);
    vec2 f = fract(st);
    
    float a = noise(i);
    float b = noise(i + vec2(1.0, 0.0));
    float c = noise(i + vec2(0.0, 1.0));
    float d = noise(i + vec2(1.0, 1.0));
    
    vec2 u = f * f * (3.0 - 2.0 * f);
    
    return mix(a, b, u.x) + (c - a)* u.y * (1.0 - u.x) + (d - b) * u.x * u.y;
}

// Fractal Brownian Motion for realistic dunes
float fbm(vec2 st) {
    float value = 0.0;
    float amplitude = 0.5;
    float frequency = 0.0;
    
    for (int i = 0; i < 4; i++) {
        value += amplitude * smoothNoise(st);
        st *= 2.0;
        amplitude *= 0.5;
    }
    return value;
}

void main() {
    vec2 fragCoord = FlutterFragCoord().xy;
    vec2 uv = fragCoord / u_resolution;
    vec2 mouseNorm = u_mouse / u_resolution;
    
    float time = u_time * 0.3;
    
    // Create layered sand dunes with parallax
    vec2 st = uv * 3.0;
    
    // Background dunes (slowest movement)
    float dunes1 = fbm(st + time * 0.1) * 0.3;
    
    // Middle dunes (medium movement)
    vec2 st2 = uv * 5.0;
    float dunes2 = fbm(st2 + time * 0.2) * 0.2;
    
    // Foreground dunes (fastest movement)
    vec2 st3 = uv * 8.0;
    float dunes3 = fbm(st3 + time * 0.4) * 0.1;
    
    // Combine dune layers
    float dunes = dunes1 + dunes2 + dunes3;
    
    // Create sand ripples
    float ripples = sin(uv.x * 50.0 + time * 2.0) * 0.01;
    ripples += sin(uv.y * 30.0 + time * 1.5) * 0.008;
    
    // Wind effect based on mouse position
    vec2 windDir = mouseNorm - 0.5;
    float windStrength = length(windDir) * 0.1;
    float windEffect = sin(uv.x * 20.0 + time * 3.0 + windDir.x * 5.0) * windStrength;
    
    // Combine all terrain effects
    float terrain = dunes + ripples + windEffect;
    
    // Color based on terrain height and time of day
    float dayCycle = sin(time * 0.1) * 0.5 + 0.5;
    
    vec3 color;
    if (dayCycle > 0.7) {
        // Bright daylight
        color = mix(DESERT_SAND_DARK, DESERT_SAND, terrain + 0.5);
    } else if (dayCycle > 0.3) {
        // Sunset
        color = mix(DESERT_SAND, SUNSET_ORANGE, terrain + 0.3);
        color = mix(color, PERSIAN_GOLD, (1.0 - dayCycle) * 2.0);
    } else {
        // Night
        color = mix(NIGHT_SKY, DESERT_SAND_DARK, terrain + 0.2);
    }
    
    // Add sand texture
    float sandTexture = smoothNoise(uv * 100.0) * 0.05;
    color += sandTexture;
    
    // Mouse interaction - footprints in sand
    float mouseDist = length(uv - mouseNorm);
    float footprint = 1.0 - smoothstep(0.0, 0.1, mouseDist);
    color -= footprint * 0.2;
    
    // Scroll-based sand storm effect
    float sandStorm = smoothstep(0.8, 1.0, u_scroll) * 0.3;
    color = mix(color, DESERT_SAND, sandStorm);
    
    // Vignette for depth
    float vig = 1.0 - smoothstep(0.3, 1.5, length(uv - 0.5) * 2.0);
    color *= mix(0.7, 1.0, vig);
    
    // Tone mapping
    color = color / (1.0 + color);
    color = pow(color, vec3(0.8));
    
    fragColor = vec4(color, 1.0);
}
