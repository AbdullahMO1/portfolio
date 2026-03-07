#version 460 core

#include <flutter/runtime_effect.glsl>

uniform vec2 u_resolution;
uniform float u_time;
uniform vec2 u_mouse;
uniform float u_scroll;

out vec4 fragColor;

// ─── Starlight Desert Theme Colors ────────────────────────────────

const vec3 NIGHT_SKY = vec3(0.051, 0.051, 0.149);        // #0D0D26
const vec3 DEEP_SPACE = vec3(0.020, 0.020, 0.078);        // #050514
const vec3 STAR_WHITE = vec3(0.929, 0.929, 0.941);        // #EDEDEF
const vec3 STAR_BLUE = vec3(0.576, 0.737, 0.929);         // #93BCE5
const vec3 DESERT_SILVER = vec3(0.663, 0.663, 0.678);      // #A9A9AD
const vec3 MOONLIGHT = vec3(0.929, 0.929, 0.941);          // #EDEDEF
const vec3 AURORA_GREEN = vec3(0.251, 0.878, 0.518);       // #40E084

// Star field with different star types
vec3 starField(vec2 uv, float time) {
    vec3 stars = vec3(0.0);
    
    // Multiple layers of stars for depth
    for(int layer = 0; layer < 3; layer++) {
        float layerDepth = float(layer) * 0.3;
        vec2 starUV = uv * (50.0 + layerDepth * 20.0);
        
        // Star positions
        vec2 starPos = floor(starUV);
        
        // Random star brightness using hash function
        float starHash = fract(sin(dot(starPos, vec2(12.9898, 78.233))) * 43758.5453);
        
        // Different star types
        float starSize = 0.0;
        vec3 starColor = STAR_WHITE;
        
        if (starHash < 0.6) {
            // Regular white stars
            starSize = 0.002;
            starColor = STAR_WHITE;
        } else if (starHash < 0.8) {
            // Blue giants
            starSize = 0.003;
            starColor = STAR_BLUE;
        } else {
            // Bright stars
            starSize = 0.004;
            starColor = mix(STAR_WHITE, STAR_BLUE, 0.3);
        }
        
        // Twinkling effect
        float twinkle = sin(time * 5.0 + starHash * 10.0) * 0.3 + 0.7;
        twinkle *= sin(time * 3.0 + starHash * 7.0) * 0.2 + 0.8;
        
        // Draw star
        vec2 starCenter = starPos + vec2(0.5);
        float star = 1.0 - smoothstep(0.0, starSize, length(uv - starCenter / (50.0 + layerDepth * 20.0)));
        
        stars += star * starColor * twinkle * (1.0 - layerDepth * 0.3);
    }
    
    return stars;
}

// Shooting star effect
vec3 shootingStar(vec2 uv, float time, vec2 mousePos) {
    vec3 shootingStar = vec3(0.0);
    
    // Create shooting star path
    float shootingTime = mod(time * 0.3, 3.0);
    vec2 shootingStart = vec2(0.2, 0.1);
    vec2 shootingEnd = vec2(0.8, 0.4);
    
    vec2 shootingPos = mix(shootingStart, shootingEnd, shootingTime / 3.0);
    
    // Shooting star trail
    float trailLength = 0.2;
    vec2 trailDir = normalize(shootingEnd - shootingStart);
    
    float trail = 0.0;
    for(float i = 0.0; i < trailLength; i += 0.01) {
        vec2 trailPos = shootingPos - trailDir * i;
        float trailDist = length(uv - trailPos);
        float trailIntensity = 1.0 - (i / trailLength);
        trail += (1.0 - smoothstep(0.0, 0.01, trailDist)) * trailIntensity;
    }
    
    // Shooting star head
    float head = 1.0 - smoothstep(0.0, 0.005, length(uv - shootingPos));
    
    shootingStar = (trail * 0.5 + head) * STAR_WHITE;
    
    // Mouse-activated shooting star
    float mouseDist = length(mousePos - shootingPos);
    if (mouseDist < 0.3) {
        shootingStar *= 2.0;
    }
    
    return shootingStar;
}

// Aurora borealis effect
vec3 aurora(vec2 uv, float time) {
    vec3 aurora = vec3(0.0);
    
    // Aurora waves
    float wave1 = sin(uv.x * 3.0 + time * 0.5) * 0.1 + 0.3;
    float wave2 = sin(uv.x * 5.0 + time * 0.7 + 1.0) * 0.1 + 0.5;
    float wave3 = sin(uv.x * 7.0 + time * 0.3 + 2.0) * 0.1 + 0.7;
    
    // Combine waves
    float auroraHeight = (wave1 + wave2 + wave3) / 3.0;
    
    // Aurora shape
    float auroraShape = 1.0 - smoothstep(auroraHeight - 0.05, auroraHeight + 0.05, uv.y);
    auroraShape *= 1.0 - smoothstep(0.0, 0.8, uv.y); // Only in upper sky
    
    // Aurora color animation
    vec3 auroraColor = mix(AURORA_GREEN, STAR_BLUE, sin(time * 0.4) * 0.5 + 0.5);
    
    aurora = auroraShape * auroraColor * 0.3;
    
    return aurora;
}

// Desert landscape at night
float desertLandscape(vec2 uv, float time) {
    float landscape = 0.0;
    
    // Multiple dune layers
    for(int i = 0; i < 4; i++) {
        float layer = float(i) / 4.0;
        vec2 duneUV = uv * vec2(2.0 + layer, 1.0);
        
        // Dune shape
        float dune = sin(duneUV.x + time * 0.05 * (1.0 - layer)) * 0.1;
        dune += sin(duneUV.x * 2.5 + time * 0.1) * 0.05;
        
        float duneY = 0.6 + layer * 0.1 + dune;
        
        float duneLayer = 1.0 - smoothstep(0.0, 0.02, uv.y - duneY);
        landscape = max(landscape, duneLayer * (1.0 - layer * 0.4));
    }
    
    return landscape;
}

// Moon with craters
vec3 moon(vec2 uv, float time) {
    vec2 moonPos = vec2(0.8, 0.15);
    float moonDist = length(uv - moonPos);
    
    // Moon disc
    float moonDisc = 1.0 - smoothstep(0.08, 0.1, moonDist);
    
    // Moon craters
    float craters = 0.0;
    for(int i = 0; i < 5; i++) {
        vec2 craterPos = moonPos + vec2(
            sin(float(i) * 1.2) * 0.04,
            cos(float(i) * 1.5) * 0.04
        );
        float craterDist = length(uv - craterPos);
        craters += 1.0 - smoothstep(0.01, 0.02, craterDist);
    }
    
    // Moon glow
    float moonGlow = 1.0 - smoothstep(0.0, 0.2, moonDist);
    moonGlow = pow(moonGlow, 3.0);
    
    vec3 moonColor = MOONLIGHT * (moonDisc - craters * 0.3);
    moonColor += moonGlow * MOONLIGHT * 0.3;
    
    return moonColor;
}

void main() {
    vec2 fragCoord = FlutterFragCoord().xy;
    vec2 uv = fragCoord / u_resolution;
    vec2 mouseNorm = u_mouse / u_resolution;
    
    float time = u_time * 0.4;
    
    // Night sky gradient
    vec3 skyColor = mix(DEEP_SPACE, NIGHT_SKY, uv.y * 0.5);
    
    // Add stars
    vec3 stars = starField(uv, time);
    skyColor += stars;
    
    // Add moon
    vec3 moon = moon(uv, time);
    skyColor += moon;
    
    // Add aurora
    vec3 auroraEffect = aurora(uv, time);
    skyColor += auroraEffect;
    
    // Desert landscape
    float landscape = desertLandscape(uv, time);
    vec3 desertColor = DESERT_SILVER * (0.2 + uv.y * 0.1);
    
    // Combine sky and landscape
    vec3 color = mix(skyColor, desertColor, landscape);
    
    // Add shooting stars
    vec3 shootingStars = shootingStar(uv, time, mouseNorm);
    color += shootingStars;
    
    // Mouse interaction - constellation drawing
    float mouseDist = length(uv - mouseNorm);
    float constellation = 1.0 - smoothstep(0.0, 0.02, mouseDist);
    color += constellation * STAR_WHITE * 0.5;
    
    // Connect nearby stars to mouse (constellation effect)
    if (constellation > 0.1) {
        for(float i = 0.0; i < 10.0; i++) {
            vec2 starPos = vec2(
                sin(i * 1.7) * 0.4 + 0.5,
                cos(i * 2.3) * 0.3 + 0.3
            );
            float starDist = length(uv - starPos);
            if (starDist < 0.01) {
                float connection = 1.0 - smoothstep(0.0, length(mouseNorm - starPos), length(uv - mouseNorm));
                color += connection * STAR_WHITE * 0.2;
            }
        }
    }
    
    // Scroll-based time progression
    float nightProgress = u_scroll;
    color = mix(color, DEEP_SPACE, nightProgress * 0.2);
    
    // Subtle vignette
    float vig = 1.0 - smoothstep(0.4, 1.8, length(uv - 0.5) * 2.0);
    color *= mix(0.8, 1.0, vig);
    
    // Tone mapping
    color = color / (1.0 + color);
    color = pow(color, vec3(0.85));
    
    fragColor = vec4(color, 1.0);
}
