#version 460 core

#include <flutter/runtime_effect.glsl>

uniform vec2 u_resolution;
uniform float u_time;
uniform vec2 u_mouse;
uniform float u_scroll;
uniform float u_place;   // 0=camp/dawn, 1=oasis, 2=war/dunes, 3=palace/stars

out vec4 fragColor;

// ─── Persian Prince Desert Theme Colors ──────────────────────────────

const vec3 DESERT_SAND   = vec3(0.941, 0.847, 0.698); // #F0D8B2
const vec3 PERSIAN_GOLD  = vec3(0.831, 0.686, 0.216); // #D4AF37
const vec3 SUNSET_ORANGE = vec3(0.969, 0.549, 0.298); // #F78C4C
const vec3 DESERT_ROSE   = vec3(0.898, 0.361, 0.439); // #E55C70
const vec3 NIGHT_SKY     = vec3(0.051, 0.051, 0.149); // #0D0D26
const vec3 CAMEL_BROWN   = vec3(0.545, 0.271, 0.075); // #8B4513
const vec3 OASIS_BLUE    = vec3(0.188, 0.545, 0.678); // #308BAD
const vec3 PALM_GREEN    = vec3(0.133, 0.545, 0.133); // #228B22
const vec3 DEEP_PURPLE   = vec3(0.169, 0.071, 0.345); // #2B1258
const vec3 PALACE_GOLD   = vec3(1.000, 0.843, 0.000); // #FFD700
const vec3 STAR_WHITE    = vec3(0.937, 0.922, 0.863); // #EFE9DC

// ─── Noise Utilities ─────────────────────────────────────────────────

float noise(vec2 st) {
    return fract(sin(dot(st.xy, vec2(12.9898, 78.233))) * 43758.5453123);
}

float smoothNoise(vec2 st) {
    vec2 i = floor(st);
    vec2 f = fract(st);
    float a = noise(i);
    float b = noise(i + vec2(1.0, 0.0));
    float c = noise(i + vec2(0.0, 1.0));
    float d = noise(i + vec2(1.0, 1.0));
    vec2 u = f * f * (3.0 - 2.0 * f);
    return mix(a, b, u.x) + (c - a) * u.y * (1.0 - u.x) + (d - b) * u.x * u.y;
}

float fbm(vec2 p) {
    float val = 0.0;
    float amp = 0.5;
    float freq = 1.0;
    for (int i = 0; i < 4; i++) {
        val += smoothNoise(p * freq) * amp;
        freq *= 2.0;
        amp *= 0.5;
    }
    return val;
}

// ─── Place-specific sky gradients ────────────────────────────────────

// Place 0: Desert dawn camp — warm sand, golden horizon, moving dunes
vec3 campSky(vec2 uv, float t) {
    float dayCycle = sin(t * 0.07) * 0.5 + 0.5;
    vec3 topColor = mix(NIGHT_SKY, DESERT_ROSE * 0.6, dayCycle * 0.8);
    vec3 midColor = mix(SUNSET_ORANGE * 0.5, PERSIAN_GOLD * 0.4, dayCycle);
    vec3 botColor = mix(DESERT_SAND * 0.5, DESERT_SAND, dayCycle);
    vec3 col = mix(topColor, midColor, smoothstep(0.0, 0.5, uv.y));
    col = mix(col, botColor, smoothstep(0.4, 1.0, uv.y));
    return col;
}

// Place 1: Oasis — blue sky, water shimmer, greens
vec3 oasisSky(vec2 uv, float t) {
    vec3 sky = mix(vec3(0.2, 0.4, 0.7), vec3(0.6, 0.8, 1.0), uv.y);
    vec3 water = OASIS_BLUE + 0.1 * sin(uv.x * 20.0 + t * 2.0);
    vec3 sand = mix(DESERT_SAND, PALM_GREEN * 0.5, smoothstep(0.5, 0.7, uv.x));
    vec3 col = mix(sky, sand, smoothstep(0.3, 0.7, uv.y));
    // Water shimmer at horizon
    float waterMask = smoothstep(0.48, 0.52, uv.y) * (1.0 - smoothstep(0.52, 0.56, uv.y));
    col = mix(col, water, waterMask * 0.8);
    return col;
}

// Place 2: Desert war/storm — dramatic red dunes, sandstorm haze
vec3 warSky(vec2 uv, float t) {
    vec3 stormTop = mix(NIGHT_SKY, vec3(0.3, 0.08, 0.0), 0.6);
    vec3 stormMid = mix(DESERT_ROSE * 0.4, SUNSET_ORANGE * 0.6, 0.5);
    vec3 sandHaze = DESERT_SAND * 0.6 + CAMEL_BROWN * 0.3;
    vec3 col = mix(stormTop, stormMid, smoothstep(0.0, 0.6, uv.y));
    col = mix(col, sandHaze, smoothstep(0.5, 1.0, uv.y));
    // Storm streaks
    float streak = fbm(uv * 3.0 + vec2(t * 0.5, 0.0)) * 0.15;
    col += SUNSET_ORANGE * streak;
    return col;
}

// Place 3: Palace/Starfield night — deep indigo, stars, palace glow
vec3 palaceSky(vec2 uv, float t) {
    vec3 deep = mix(DEEP_PURPLE, NIGHT_SKY, uv.y * 0.7);
    // Stars
    vec2 starUV = uv * 50.0;
    float star = noise(floor(starUV));
    float starPulse = 0.5 + 0.5 * sin(t * 2.0 + star * 20.0);
    float starMask = step(0.94, star) * starPulse * (1.0 - smoothstep(0.5, 1.0, uv.y));
    deep += STAR_WHITE * starMask * 0.8;
    // Palace horizon glow
    float horizonGlow = 1.0 - smoothstep(0.55, 0.75, uv.y);
    deep += PALACE_GOLD * horizonGlow * 0.12;
    return deep;
}

// ─── Dune layer (shared) ─────────────────────────────────────────────

float getDune(vec2 uv, float t, float intensity) {
    float duneWave = sin(uv.x * 1.5 - t * 0.6) * 0.15 * intensity;
    duneWave += sin(uv.x * 3.2 - t * 1.0) * 0.06 * intensity;
    duneWave += fbm(uv * 2.0 + t * 0.1) * 0.05;
    return uv.y - 0.55 - duneWave;
}

// ─── Caravan silhouettes ─────────────────────────────────────────────

float caravan(vec2 uv, float t) {
    float c = 0.0;
    for (int i = 0; i < 5; i++) {
        float ox = float(i) * 0.18 + t * 0.04;
        ox = mod(ox, 1.3) - 0.15;
        float oy = 0.52 + sin(uv.x * 1.5 - t * 0.6) * 0.08;
        c = max(c, 1.0 - smoothstep(0.0, 0.014, length(uv - vec2(ox, oy))));
    }
    return c;
}

void main() {
    vec2 fragCoord = FlutterFragCoord().xy;
    vec2 uv = fragCoord / u_resolution;
    vec2 mouseNorm = u_mouse / u_resolution;

    float t = u_time * 0.35;

    // ── Place blending (0-1 = camp→oasis, 1-2 = oasis→war, 2-3 = war→palace) ──
    float p = clamp(u_place, 0.0, 3.0);
    float pFrac = fract(p);
    int pFloor = int(floor(p));

    vec3 color;

    if (pFloor == 0) {
        color = mix(campSky(uv, t), oasisSky(uv, t), pFrac);
    } else if (pFloor == 1) {
        color = mix(oasisSky(uv, t), warSky(uv, t), pFrac);
    } else {
        color = mix(warSky(uv, t), palaceSky(uv, t), pFrac);
    }

    // ── Desert dunes (fade out in palace) ─────────────────────────────
    float duneIntensity = 1.0 - smoothstep(2.0, 3.0, p);
    float distToDune = getDune(uv, t, duneIntensity);
    float sandRipples = smoothNoise(uv * 80.0 + t * 0.2) * 0.018;
    distToDune += sandRipples;
    float duneGlow = pow(1.0 - smoothstep(0.0, 0.22, abs(distToDune)), 1.3);
    vec3 duneColor = mix(PERSIAN_GOLD, DESERT_SAND, 0.4 + 0.3 * sin(uv.x * 2.0 - t));
    color += duneColor * duneGlow * 0.55 * duneIntensity;

    // Sand layer below dune
    if (distToDune > 0.0) {
        float sandBlend = smoothstep(0.0, 0.2, distToDune) * duneIntensity;
        color = mix(color, DESERT_SAND * 0.65, sandBlend * 0.5);
    }

    // ── Caravan silhouettes (camp + war) ──────────────────────────────
    float caravanVisibility = 1.0 - smoothstep(0.8, 1.5, p);
    caravanVisibility += clamp(smoothstep(1.5, 2.0, p) - smoothstep(2.5, 3.0, p), 0.0, 1.0) * 0.5;
    float caravanMask = caravan(uv, t) * caravanVisibility;
    color = mix(color, CAMEL_BROWN * 0.6, caravanMask * 0.85);

    // ── Sandstorm particles (war place) ───────────────────────────────
    float stormStr = smoothstep(1.5, 2.5, p) * (1.0 - smoothstep(2.5, 3.0, p));
    stormStr += smoothstep(0.7, 1.0, u_scroll) * 0.15;
    vec2 stormUV = uv + vec2(t * 2.5, t * 0.6);
    float storm = smoothNoise(stormUV * 55.0) * stormStr;
    color += DESERT_SAND * storm * 0.25;

    // ── Mouse glow — magic oil lamp ───────────────────────────────────
    float mouseDist = length(uv - mouseNorm);
    float glow = (1.0 - smoothstep(0.0, 0.38, mouseDist)) * (0.5 + 0.5 * sin(t * 3.2));
    color += PERSIAN_GOLD * glow * 0.22;
    color += SUNSET_ORANGE * glow * 0.12;

    // ── Subtle Persian geometric tile overlay ──────────────────────────
    vec2 tile = uv * 14.0;
    float pattern = sin(tile.x) * sin(tile.y) * sin(tile.x + tile.y);
    color += PERSIAN_GOLD * abs(pattern) * 0.025;

    // ── Vignette ──────────────────────────────────────────────────────
    float vig = 1.0 - smoothstep(0.5, 1.8, length((uv - 0.5) * 2.0));
    color *= mix(0.65, 1.0, vig);

    // ── Tone map + gamma ──────────────────────────────────────────────
    color = color / (1.0 + color);
    color = pow(max(color, vec3(0.0)), vec3(0.88));

    fragColor = vec4(color, 1.0);
}
