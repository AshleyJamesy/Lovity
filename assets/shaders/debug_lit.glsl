#define NR_POINT_LIGHTS 5

varying vec3 FragPos;
varying vec3 Normal;

struct Light {
    float strength;
    vec3 position;
    vec4 colour;
};

uniform mat4 projection;
uniform mat4 view;
uniform vec3 viewPosition;
uniform mat4 model;
uniform mat4 modelInverse;

uniform Light lights[NR_POINT_LIGHTS];

#ifdef VERTEX
    attribute vec3 VertexNormal;

    vec4 position(mat4 t, vec4 vertex) {
        FragPos = vec3(model * vec4(vertex.xyz, 1.0));
        Normal = normalize(mat3(modelInverse) * VertexNormal);

        return projection * view * model * vertex;
    }
#endif

#ifdef PIXEL
    void effect() {
        vec2 UV = VaryingTexCoord.xy;
        UV.y = 1.0 - UV.y;

        vec3 lightColour = vec3(0.1f, 0.1f, 0.1f);
        for(int i = 0; i < NR_POINT_LIGHTS; ++i) {
            lightColour += max(dot(Normal, normalize(lights[i].position - FragPos)), 0.0) * lights[i].colour.rgb * (1.0 / length(lights[i].position - FragPos) * lights[i].strength);
        }

        vec3 Colour = VaryingColor.rgb * lightColour;

        love_Canvases[0] = vec4(Colour, 1.0);
    	love_Canvases[1] = vec4(Colour, 1.0);
        love_Canvases[2] = vec4(Colour, 1.0);
    	love_Canvases[3] = vec4(Colour, 1.0);
    }
#endif