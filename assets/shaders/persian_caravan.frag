#version 460 core

#include <flutter/runtime_effect.glsl>

uniform vec2 u_resolution;
uniform float u_time;
uniform vec2 u_mouse;
uniform float u_scroll;

out vec4 fragColor;

// ─── Persian Caravan Theme Colors ─────────────────────────────────

const vec3 NIGHT_SKY = vec3(0.051, 0.051, 0.149);       // #0D0D26
const vec3 DESERT_SAND = vec3(0.941, 0.847, 0.698);     // #F0D8B2
const vec3 PERSIAN_GOLD = vec3(0.831, 0.686, 0.216);     // #D4AF37
const vec3 MOONLIGHT = vec3(0.929, 0.929, 0.941);       // #EDEDEF
const vec3 CAMEL_BROWN = vec3(0.545, 0.271, 0.075);      // #8B4513
const vec3 CAMPFIRE_ORANGE = vec3(1.0, 0.549, 0.0);      // #FF8C00

// Star field generation
float star(vec2 uv, float time) {
    vec2 pos = uv * 100.0;
    pos = floor(pos);
    
    float starValue = fract(sin(dot(pos, vec2(12.9898, 78.233))) * 43758.5453);
    
    // Twinkling effect
    float twinkle = sin(time * 3.0 + starValue * 10.0) * 0.5 + 0.5;
    
    return starValue * twinkle;
}

// Moon phase calculation
float moonPhase(float time) {
    return sin(time * 0.1) * 0.5 + 0.5;
}

// Caravan silhouette function
float caravan(vec2 uv, float time) {
    float caravan = 0.0;
    
    // Multiple camels in caravan
    for(int i = 0; i < 5; i++) {
        float camelX = 0.2 + float(i) * 0.15 + time * 0.05;
        camelX = mod(camelX, 1.2) - 0.1; // Wrap around
        
        float camelY = 0.6 + sin(time * 2.0 + float(i)) * 0.02;
        
        // Camel body (simplified silhouette)
        float camelBody = 1.0 - smoothstep(0.02, 0.04, length(uv - vec2(camelX, camelY)));
        
        // Camel humps
        float hump1 = 1.0 - smoothstep(0.015, 0.025, length(uv - vec2(camelX - 0.01, camelY - 0.02)));
        float hump2 = 1.0 - smoothstep(0.015, 0.025, length(uv - vec2(camelX + 0.01, camelY - 0.02)));
        
        caravan += max(camelBody, max(hump1, hump2));
    }
    
    return caravan;
}

// Desert horizon line
float horizon(vec2 uv) {
    return smoothstep(0.58, 0.62, uv.y);
}

// Campfire effect
float campfire(vec2 uv, float time) {
    vec2 firePos = vec2(0.8, 0.65);
    float fireDist = length(uv - firePos);
    
    // Flickering flame
    float flicker = sin(time * 10.0) * 0.1 + sin(time * 17.0) * 0.05;
    float flame = 1.0 - smoothstep(0.0, 0.05 + flicker, fireDist);
    
    // Glow effect
    float glow = 1.0 - smoothstep(0.0, 0.15, fireDist);
    
    return flame * 0.8 + glow * 0.2;
}

void main() {
    vec2 fragCoord = FlutterFragCoord().xy;
    vec2 uv = fragCoord / u_resolution;
    vec2 mouseNorm = u_mouse / u_resolution;
    
    float time = u_time * 0.5;
    
    // Night sky gradient
    vec3 skyColor = mix(NIGHT_SKY, vec3(0.102, 0.102, 0.204), uv.y * 0.5);
    
    // Add stars
    float stars = star(uv, time) * 0.8;
    skyColor += stars * MOONLIGHT;
    
    // Moon
    float moonPhase = moonPhase(time);
    vec2 moonPos = vec2(0.8, 0.2);
    float moonDist = length(uv - moonPos);
    float moon = 1.0 - smoothstep(0.05, 0.06, moonDist);
    
    // Crescent moon effect
    float moonShadow = 1.0 - smoothstep(0.03, 0.04, length(uv - vec2(moonPos.x - 0.02, moonPos.y)));
    moon = max(moon - moonShadow * moonPhase, 0.0);
    
    skyColor += moon * MOONLIGHT;
    
    // Desert floor
    float horizonLine = horizon(uv);
    vec3 desertColor = DESERT_SAND * (0.3 + uv.y * 0.2);
    
    // Combine sky and desert
    vec3 color = mix(skyColor, desertColor, horizonLine);
    
    // Add caravan silhouettes
    float caravanSilhouette = caravan(uv, time);
    color = mix(color, CAMEL_BROWN, caravanSilhouette);
    
    // Add campfire
    float fire = campfire(uv, time);
    vec3 fireColor = mix(CAMPFIRE_ORANGE, PERSIAN_GOLD, sin(time * 15.0) * 0.5 + 0.5);
    color = mix(color, fireColor, fire);
    
    // Mouse interaction - shooting star
    float mouseDist = length(uv - mouseNorm);
    float shootingStar = 1.0 - smoothstep(0.0, 0.02, mouseDist);
    vec2 starDir = normalize(uv - mouseNorm);
    float starTrail = smoothstep(0.1, 0.0, length(uv - mouseNorm - starDir * 0.2));
    
    color += (shootingStar + starTrail) * MOONLIGHT * 0.5;
    
    // Scroll-based time progression
    float timeProgress = u_scroll;
    color = mix(color, skyColor, timeProgress * 0.3);
    
    // Subtle vignette
    float vig = 1.0 - smoothstep(0.4, 1.8, length(uv - 0.5) * 2.0);
    color *= mix(0.8, 1.0, vig);
    
    // Tone mapping
    color = color / (1.0 + color);
    color = pow(color, vec3(0.9));
    
    fragColor = vec4(color, 1.0);
}
