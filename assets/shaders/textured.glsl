#ifdef VERTEX
    uniform mat4 projection;
    uniform mat4 view;
    uniform mat4 model;

    vec4 position(mat4 t, vec4 position) {
        return projection * view * model * position;
    }
#endif

uniform sampler2D iAlbedo;

#ifdef PIXEL
    void effect() {
        vec2 UV = VaryingTexCoord.xy;
        UV.y = 1.0 - UV.y;

        vec4 Colour = vec4(VaryingColor.rgb, 1.0);

        vec4 albedo = vec4(Texel(iAlbedo, UV).rgb, 1.0);

        love_Canvases[0] = albedo * Colour;
    	love_Canvases[1] = albedo * Colour;
        love_Canvases[2] = albedo * Colour;
        love_Canvases[3] = albedo * Colour;
    }
#endif