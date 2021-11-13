varying vec3 FragPos;
varying vec3 Normal;

#ifdef VERTEX
    attribute vec3 VertexNormal;

    uniform mat4 projection;
    uniform mat4 view;
    uniform vec3 viewPosition;
    uniform mat4 model;
    uniform mat4 modelInverse;

    vec4 position(mat4 _, vec4 vertex) {
        FragPos = vec3(model * vec4(vertex.xyz, 1.0));
        Normal = normalize(mat3(modelInverse) * VertexNormal);

        return projection * view * model * vertex;
    }
#endif

#ifdef PIXEL
    uniform Image iAlbedo;
    uniform Image iMettalic;
    uniform Image iRoughness;
    uniform Image iEmission;
    uniform Image iNormal;

    void effect() {
        vec2 _UV = VaryingTexCoord.xy;
        _UV.y = 1.0 - _UV.y;

        vec3 Colour = Texel(iAlbedo, _UV).rgb * VaryingColor.rgb;

        vec4 PBR;
        PBR.r = Texel(iMettalic, _UV).r;
        PBR.g = Texel(iRoughness, _UV).r;
        PBR.b = Texel(iEmission, _UV).r;
        PBR.a = 1.0f;

        love_Canvases[0] = vec4(FragPos, 1.0);
        love_Canvases[1] = vec4(Normal, 1.0);
        love_Canvases[2] = vec4(Colour, 1.0);
        love_Canvases[3] = PBR;
    }
#endif