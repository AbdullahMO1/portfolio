#version 460 core
#include <flutter/runtime_effect.glsl>

uniform vec2 u_resolution;
uniform float u_time;
uniform float u_scroll;
uniform vec2 u_mouse;

out vec4 fragColor;

//////////////////////////////////////////////////////
// GLOBALS
//////////////////////////////////////////////////////

#define MAX_STEPS 120
#define MAX_DIST 200.
#define SURF_DIST .001

//////////////////////////////////////////////////////
// HASH + NOISE
//////////////////////////////////////////////////////

float hash(vec2 p){
    p = fract(p * vec2(234.34,435.345));
    p += dot(p,p+34.23);
    return fract(p.x*p.y);
}

float noise(vec2 p){
    vec2 i=floor(p);
    vec2 f=fract(p);

    float a=hash(i);
    float b=hash(i+vec2(1,0));
    float c=hash(i+vec2(0,1));
    float d=hash(i+vec2(1,1));

    vec2 u=f*f*(3.-2.*f);

    return mix(a,b,u.x)+(c-a)*u.y*(1.-u.x)+(d-b)*u.x*u.y;
}

float fbm(vec2 p){

    float v=0.;
    float a=.5;

    for(int i=0;i<6;i++){
        v+=noise(p)*a;
        p*=2.;
        a*=.5;
    }

    return v;
}

//////////////////////////////////////////////////////
// DUNE HEIGHT FIELD
//////////////////////////////////////////////////////

float duneHeight(vec2 p){

    float dunes = fbm(p*0.6);

    dunes += sin(p.x*0.8)*0.4;
    dunes += sin(p.x*0.25+p.y*0.2)*0.7;

    return dunes*3.0;
}

//////////////////////////////////////////////////////
// SIGNED DISTANCE FIELD
//////////////////////////////////////////////////////

float map(vec3 p){

    float terrain = p.y - duneHeight(p.xz);

    return terrain;
}

//////////////////////////////////////////////////////
// RAYMARCHER
//////////////////////////////////////////////////////

float raymarch(vec3 ro, vec3 rd){

    float dO=0.;

    for(int i=0;i<MAX_STEPS;i++){

        vec3 p = ro + rd*dO;

        float dS = map(p);

        dO += dS;

        if(dO>MAX_DIST || abs(dS)<SURF_DIST) break;
    }

    return dO;
}

//////////////////////////////////////////////////////
// NORMAL
//////////////////////////////////////////////////////

vec3 getNormal(vec3 p){

    float e=.002;

    vec2 h=vec2(e,0);

    float d=map(p);

    vec3 n = d - vec3(
        map(p-h.xyy),
        map(p-h.yxy),
        map(p-h.yyx)
    );

    return normalize(n);
}

//////////////////////////////////////////////////////
// SUN LIGHT
//////////////////////////////////////////////////////

vec3 sunDir = normalize(vec3(0.7,0.5,0.3));

float lighting(vec3 p){

    vec3 n=getNormal(p);

    float diff=max(dot(n,sunDir),0.);

    return diff;
}

//////////////////////////////////////////////////////
// VOLUMETRIC SAND DUST
//////////////////////////////////////////////////////

float sandDust(vec3 p){

    float d = fbm(p.xz*0.4 + u_time*0.05);

    float height = smoothstep(1.,4.,p.y);

    return d*height*0.3;
}

//////////////////////////////////////////////////////
// OASIS WATER
//////////////////////////////////////////////////////

float oasis(vec2 p){

    vec2 center=vec2(10.,5.);

    float d=length(p-center);

    return smoothstep(2.0,1.8,d);
}

vec3 oasisColor(vec2 uv){

    vec3 shallow = vec3(.25,.7,.8);
    vec3 deep    = vec3(.05,.25,.35);

    float wave = sin(uv.x*10.+u_time*2.)*.05;

    return mix(shallow,deep,uv.y+wave);
}

//////////////////////////////////////////////////////
// CARAVAN SILHOUETTE
//////////////////////////////////////////////////////

float camel(vec2 p){

    p.x -= u_time*0.5;

    float body = smoothstep(.2,.19,length(p-vec2(0,0)));

    float hump = smoothstep(.15,.14,length(p-vec2(.1,.05)));

    return max(body,hump);
}

//////////////////////////////////////////////////////
// STARFIELD
//////////////////////////////////////////////////////

float star(vec2 uv){

    vec2 gv=fract(uv*150.);
    vec2 id=floor(uv*150.);

    float n=hash(id);

    float d=length(gv-.5);

    return smoothstep(.02,.0,d)*step(.996,n);
}

//////////////////////////////////////////////////////
// MILKY WAY
//////////////////////////////////////////////////////

float milkyWay(vec2 uv){

    float band = smoothstep(.4,.5,abs(uv.y-.5));

    float n = fbm(uv*8.);

    return (1.-band)*n;
}

//////////////////////////////////////////////////////
// SKY
//////////////////////////////////////////////////////

vec3 sky(vec2 uv){

    vec3 sunsetTop = vec3(.2,.1,.4);
    vec3 horizon   = vec3(.95,.65,.45);

    vec3 col = mix(horizon,sunsetTop,uv.y);

    float s = star(uv);

    float mw = milkyWay(uv);

    col += vec3(1.)*s;

    col += vec3(.4,.4,.7)*mw*0.3;

    return col;
}

//////////////////////////////////////////////////////
// CAMERA
//////////////////////////////////////////////////////

vec3 getRay(vec2 uv, vec3 ro, vec3 look){

    vec3 f = normalize(look-ro);
    vec3 r = normalize(cross(vec3(0,1,0),f));
    vec3 u = cross(f,r);

    vec3 c = ro + f;

    vec3 i = c + uv.x*r + uv.y*u;

    return normalize(i-ro);
}

//////////////////////////////////////////////////////
// SCROLL TIMELINE
//////////////////////////////////////////////////////

float timeline(){

    return u_scroll;
}

//////////////////////////////////////////////////////
// MAIN
//////////////////////////////////////////////////////

void main(){

    vec2 uv = FlutterFragCoord().xy/u_resolution.xy;

    uv = uv*2.-1.;

    uv.x *= u_resolution.x/u_resolution.y;

    float t = timeline();

    vec3 ro = vec3(0.,3.,-8. + t*10.);
    vec3 look = vec3(0.,0.,t*20.);

    vec3 rd = getRay(uv,ro,look);

    float d = raymarch(ro,rd);

    vec3 col;

    if(d<MAX_DIST){

        vec3 p = ro + rd*d;

        float light = lighting(p);

        vec3 sandLight = vec3(.95,.85,.7);
        vec3 sandDark  = vec3(.8,.68,.5);

        float h = duneHeight(p.xz);

        vec3 sand = mix(sandLight,sandDark,h*.1);

        float dust = sandDust(p);

        col = sand*(.3+light);

        col += dust;

        float water = oasis(p.xz);

        col = mix(col,oasisColor(p.xz),water);

    }
    else{

        col = sky(uv*.5+.5);
    }

    fragColor = vec4(col,1.);
}