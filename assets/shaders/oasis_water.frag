#version 460 core

#include <flutter/runtime_effect.glsl>

uniform vec2 u_resolution;
uniform float u_time;
uniform vec2 u_mouse;
uniform float u_scroll;

out vec4 fragColor;

// ─── Oasis Water Theme Colors ────────────────────────────────────

const vec3 OASIS_WATER = vec3(0.188, 0.545, 0.729);       // #308BAD
const vec3 OASIS_WATER_DEEP = vec3(0.098, 0.322, 0.529);  // #195287
const vec3 TURQUOISE = vec3(0.251, 0.878, 0.816);          // #40E0D0
const vec3 PALM_GREEN = vec3(0.133, 0.545, 0.133);         // #228B22
const vec3 SAND_BEACH = vec3(0.941, 0.847, 0.698);        // #F0D8B2
const vec3 PERSIAN_BLUE = vec3(0.176, 0.196, 0.667);       // #2D32AA

// Water ripple function
float waterRipple(vec2 uv, float time, vec2 center) {
    float dist = length(uv - center);
    float ripple = sin(dist * 20.0 - time * 4.0) * 0.5 + 0.5;
    ripple *= 1.0 - smoothstep(0.0, 0.5, dist);
    return ripple;
}

// Animated water waves
float waterWaves(vec2 uv, float time) {
    float wave1 = sin(uv.x * 10.0 + time * 2.0) * 0.05;
    float wave2 = sin(uv.y * 8.0 + time * 1.5) * 0.03;
    float wave3 = sin((uv.x + uv.y) * 6.0 + time * 3.0) * 0.02;
    
    return wave1 + wave2 + wave3;
}

// Palm tree silhouette
float palmTree(vec2 uv, float time) {
    float tree = 0.0;
    
    // Tree trunk
    float trunk = 1.0 - smoothstep(0.02, 0.04, length(uv - vec2(0.5, 0.3)));
    
    // Palm leaves (simplified)
    for(int i = 0; i < 6; i++) {
        float angle = float(i) * 1.047; // 60 degrees
        vec2 leafDir = vec2(cos(angle), sin(angle)) * 0.15;
        vec2 leafPos = vec2(0.5, 0.3) + leafDir;
        
        // Sway animation
        leafPos.x += sin(time + float(i)) * 0.02;
        
        float leaf = 1.0 - smoothstep(0.01, 0.03, length(uv - leafPos));
        tree = max(tree, leaf);
    }
    
    return max(trunk, tree);
}

// Bioluminescent particles
float bioluminescence(vec2 uv, float time) {
    float particles = 0.0;
    
    for(int i = 0; i < 20; i++) {
        vec2 particlePos = vec2(
            sin(time * 0.3 + float(i) * 0.5) * 0.4 + 0.5,
            cos(time * 0.2 + float(i) * 0.7) * 0.2 + 0.6
        );
        
        float particle = 1.0 - smoothstep(0.0, 0.01, length(uv - particlePos));
        float glow = 1.0 - smoothstep(0.0, 0.03, length(uv - particlePos));
        
        particles += particle * 0.8 + glow * 0.2;
    }
    
    return particles * 0.5;
}

void main() {
    vec2 fragCoord = FlutterFragCoord().xy;
    vec2 uv = fragCoord / u_resolution;
    vec2 mouseNorm = u_mouse / u_resolution;
    
    float time = u_time * 0.8;
    
    // Create oasis pool shape (circular)
    vec2 oasisCenter = vec2(0.5, 0.6);
    float oasisDist = length(uv - oasisCenter);
    float oasisPool = 1.0 - smoothstep(0.25, 0.35, oasisDist);
    
    // Water depth based on distance from center
    float waterDepth = 1.0 - smoothstep(0.0, 0.3, oasisDist);
    
    // Base water color with depth variation
    vec3 waterColor = mix(OASIS_WATER_DEEP, OASIS_WATER, waterDepth);
    
    // Add water waves
    float waves = waterWaves(uv, time);
    waterColor += waves * 0.1;
    
    // Mouse interaction - ripples
    float mouseRipple = waterRipple(uv, time, mouseNorm);
    waterColor += mouseRipple * TURQUOISE * 0.3;
    
    // Multiple ripples for realism
    vec2 ripple1 = vec2(0.4, 0.5);
    vec2 ripple2 = vec2(0.6, 0.7);
    float ripples = waterRipple(uv, time, ripple1) * 0.5;
    ripples += waterRipple(uv, time * 1.2, ripple2) * 0.3;
    waterColor += ripples * TURQUOISE * 0.2;
    
    // Add bioluminescent particles
    float bioParticles = bioluminescence(uv, time);
    waterColor += bioParticles * TURQUOISE;
    
    // Sand beach around oasis
    float sandBeach = 1.0 - smoothstep(0.35, 0.45, oasisDist);
    sandBeach = max(0.0, sandBeach - oasisPool);
    vec3 sandColor = SAND_BEACH * (0.8 + sin(time * 0.5) * 0.1);
    
    // Palm trees around oasis
    vec3 treeColor = PALM_GREEN;
    float tree1 = palmTree((uv - vec2(0.2, 0.4)) * 2.0, time);
    float tree2 = palmTree((uv - vec2(0.8, 0.5)) * 2.0, time * 1.1);
    float tree3 = palmTree((uv - vec2(0.5, 0.2)) * 2.0, time * 0.9);
    
    // Background desert
    vec3 backgroundColor = mix(SAND_BEACH * 0.7, PERSIAN_BLUE * 0.3, uv.y);
    
    // Combine all elements
    vec3 color = backgroundColor;
    color = mix(color, sandColor, sandBeach);
    color = mix(color, waterColor, oasisPool);
    color = mix(color, treeColor, max(tree1, max(tree2, tree3)));
    
    // Shimmer effect on water surface
    float shimmer = sin(uv.x * 50.0 + uv.y * 30.0 + time * 5.0) * 0.5 + 0.5;
    shimmer *= oasisPool;
    color += shimmer * TURQUOISE * 0.2;
    
    // Scroll-based oasis growth
    float oasisGrowth = smoothstep(0.0, 1.0, u_scroll);
    color = mix(backgroundColor, color, oasisGrowth);
    
    // Subtle vignette
    float vig = 1.0 - smoothstep(0.4, 1.8, length(uv - 0.5) * 2.0);
    color *= mix(0.8, 1.0, vig);
    
    // Tone mapping
    color = color / (1.0 + color);
    color = pow(color, vec3(0.85));
    
    fragColor = vec4(color, 1.0);
}
