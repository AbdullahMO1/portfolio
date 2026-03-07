#version 460 core

#include <flutter/runtime_effect.glsl>

uniform vec2 u_resolution;
uniform float u_time;
uniform vec2 u_mouse;
uniform float u_scroll;

out vec4 fragColor;

// ─── Desert Sunset Theme Colors ───────────────────────────────────

const vec3 SUNSET_RED = vec3(0.929, 0.176, 0.184);        // #ED2D2B
const vec3 SUNSET_ORANGE = vec3(0.969, 0.549, 0.298);      // #F78C4C
const vec3 SUNSET_PURPLE = vec3(0.576, 0.176, 0.576);     // #932D92
const vec3 DESERT_SAND = vec3(0.941, 0.847, 0.698);       // #F0D8B2
const vec3 PERSIAN_GOLD = vec3(0.831, 0.686, 0.216);      // #D4AF37
const vec3 NIGHT_BLUE = vec3(0.051, 0.051, 0.149);        // #0D0D26

// Sun position and glow
vec3 sunEffect(vec2 uv, float time) {
    // Sun moves across sky
    vec2 sunPos = vec2(0.5 + cos(time * 0.5) * 0.4, 0.3 + sin(time * 0.5) * 0.2);
    float sunDist = length(uv - sunPos);
    
    // Sun disc
    float sunDisc = 1.0 - smoothstep(0.05, 0.08, sunDist);
    
    // Sun glow
    float sunGlow = 1.0 - smoothstep(0.0, 0.3, sunDist);
    sunGlow = pow(sunGlow, 2.0);
    
    // Sun rays
    float sunRays = 0.0;
    for(int i = 0; i < 12; i++) {
        float angle = float(i) * 0.524; // 30 degrees
        vec2 rayDir = vec2(cos(angle), sin(angle));
        float ray = dot(normalize(uv - sunPos), rayDir);
        ray = max(0.0, ray);
        ray = pow(ray, 20.0);
        sunRays += ray;
    }
    
    vec3 sunColor = mix(SUNSET_ORANGE, SUNSET_RED, sin(time * 2.0) * 0.5 + 0.5);
    return sunColor * (sunDisc + sunGlow * 0.5 + sunRays * 0.3);
}

// Cloud formations
float clouds(vec2 uv, float time) {
    vec2 cloudUV = uv * 2.0;
    
    // Animated cloud movement
    cloudUV.x += time * 0.1;
    
    // Cloud noise using sine waves
    float cloud1 = sin(cloudUV.x * 2.0) * sin(cloudUV.y * 1.5) * 0.5 + 0.5;
    float cloud2 = sin(cloudUV.x * 3.0 + 1.0) * sin(cloudUV.y * 2.0 + 2.0) * 0.5 + 0.5;
    float cloud3 = sin(cloudUV.x * 1.5 + 3.0) * sin(cloudUV.y * 2.5 + 1.0) * 0.5 + 0.5;
    
    float clouds = (cloud1 + cloud2 + cloud3) / 3.0;
    
    // Shape clouds
    clouds = smoothstep(0.4, 0.8, clouds);
    
    // Only show clouds in upper part of sky
    clouds *= 1.0 - smoothstep(0.3, 0.7, uv.y);
    
    return clouds;
}

// Desert silhouette with dunes
float desertSilhouette(vec2 uv, float time) {
    float silhouette = 0.0;
    
    // Multiple dune layers for depth
    for(int i = 0; i < 5; i++) {
        float layer = float(i) / 5.0;
        vec2 duneUV = uv * vec2(3.0 + layer * 2.0, 1.0);
        
        // Dune shape using sine waves
        float dune = sin(duneUV.x + time * 0.1 * (1.0 - layer)) * 0.1;
        dune += sin(duneUV.x * 2.0 + time * 0.2) * 0.05;
        
        float duneY = 0.7 + layer * 0.1 + dune;
        
        float duneLayer = 1.0 - smoothstep(0.0, 0.02, uv.y - duneY);
        silhouette = max(silhouette, duneLayer * (1.0 - layer * 0.3));
    }
    
    return silhouette;
}

// Persian architecture silhouettes
float persianArchitecture(vec2 uv, float time) {
    float arch = 0.0;
    
    // Simple Persian arch silhouette
    vec2 archPos = uv - vec2(0.3, 0.6);
    
    // Arch base
    float archBase = 1.0 - smoothstep(0.02, 0.04, abs(archPos.x));
    archBase *= 1.0 - smoothstep(0.0, 0.1, archPos.y);
    
    // Arch top (semi-circle)
    vec2 archTopVec = archPos - vec2(0.0, 0.1);
    float archTop = length(archTopVec);
    archTop = 1.0 - smoothstep(0.08, 0.1, archTop);
    archTop *= 1.0 - smoothstep(0.08, 0.12, archTopVec.y);
    
    arch = max(archBase, archTop);
    
    // Minaret
    vec2 minaretPos = uv - vec2(0.7, 0.5);
    float minaret = 1.0 - smoothstep(0.01, 0.02, abs(minaretPos.x));
    minaret *= 1.0 - smoothstep(0.0, 0.3, minaretPos.y);
    
    // Minaret top
    float minaretTop = length(minaretPos - vec2(0.0, 0.32));
    minaretTop = 1.0 - smoothstep(0.03, 0.05, minaretTop);
    
    minaret = max(minaret, minaretTop);
    
    return max(arch, minaret);
}

void main() {
    vec2 fragCoord = FlutterFragCoord().xy;
    vec2 uv = fragCoord / u_resolution;
    vec2 mouseNorm = u_mouse / u_resolution;
    
    float time = u_time * 0.3;
    
    // Sky gradient based on time (sunset progression)
    float sunsetProgress = sin(time * 0.5) * 0.5 + 0.5;
    
    vec3 skyColor;
    if (sunsetProgress < 0.3) {
        // Day to sunset
        skyColor = mix(vec3(0.529, 0.808, 0.922), SUNSET_ORANGE, sunsetProgress * 3.33);
    } else if (sunsetProgress < 0.7) {
        // Peak sunset
        skyColor = mix(SUNSET_ORANGE, SUNSET_PURPLE, (sunsetProgress - 0.3) * 2.5);
    } else {
        // Sunset to night
        skyColor = mix(SUNSET_PURPLE, NIGHT_BLUE, (sunsetProgress - 0.7) * 3.33);
    }
    
    // Add vertical gradient
    skyColor = mix(skyColor * 0.7, skyColor, uv.y);
    
    // Add sun effect
    vec3 sun = sunEffect(uv, time);
    skyColor += sun;
    
    // Add clouds
    float cloudLayer = clouds(uv, time);
    vec3 cloudColor = mix(SUNSET_PURPLE * 0.5, PERSIAN_GOLD * 0.3, sunsetProgress);
    skyColor = mix(skyColor, cloudColor, cloudLayer * 0.6);
    
    // Desert silhouette
    float desert = desertSilhouette(uv, time);
    vec3 desertColor = mix(DESERT_SAND, SUNSET_ORANGE, sunsetProgress);
    
    // Persian architecture
    float architecture = persianArchitecture(uv, time);
    vec3 archColor = mix(PERSIAN_GOLD, SUNSET_PURPLE, sunsetProgress);
    
    // Combine elements
    vec3 color = skyColor;
    color = mix(color, desertColor, desert);
    color = mix(color, archColor, architecture);
    
    // Mouse interaction - magical sparkle
    float mouseDist = length(uv - mouseNorm);
    float sparkle = 1.0 - smoothstep(0.0, 0.1, mouseDist);
    float twinkle = sin(time * 10.0 + mouseDist * 20.0) * 0.5 + 0.5;
    color += sparkle * PERSIAN_GOLD * twinkle * 0.5;
    
    // Scroll-based time acceleration
    float timeEffect = u_scroll;
    color = mix(color, NIGHT_BLUE, timeEffect * 0.3);
    
    // Vignette for cinematic effect
    float vig = 1.0 - smoothstep(0.5, 1.8, length(uv - 0.5) * 2.0);
    color *= mix(0.7, 1.0, vig);
    
    // Tone mapping
    color = color / (1.0 + color);
    color = pow(color, vec3(0.9));
    
    fragColor = vec4(color, 1.0);
}
