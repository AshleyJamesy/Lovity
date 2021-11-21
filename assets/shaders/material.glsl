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

        vec3 viewDir = normalize(viewPosition - FragPos);

        vec3 Colour = vec3(0.0, 0.0, 0.0);

        for(int i = 0; i < NR_POINT_LIGHTS; ++i) {
            //diffuse
            vec3 lightDir = normalize(lights[i].position - FragPos);
            vec3 diffuse = max(dot(Normal, lightDir), 0.0) * lights[i].colour.rgb;

            //specular
            vec3 specular = pow(max(dot(viewDir, reflect(-lightDir, Normal)), 0.0), 32) * lights[i].colour.rgb * 0.5f;

            Colour += diffuse + specular * VaryingColor.rgb;
        }

        love_Canvases[0] = vec4(Colour, 1.0);
    	love_Canvases[1] = vec4(Colour, 1.0);
        love_Canvases[2] = vec4(Colour, 1.0);
        love_Canvases[3] = vec4(Colour, 1.0);
    }
#endif