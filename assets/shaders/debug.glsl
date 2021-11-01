#ifdef VERTEX
    uniform mat4 projection;
    uniform mat4 view;
    uniform mat4 model;
    
    vec4 position(mat4 t, vec4 position) {
        return projection * view * model * position;
    }
#endif

#ifdef PIXEL
    void effect() {
    	vec3 Colour = VaryingColor.rgb;
    	
        love_Canvases[0] = vec4(Colour, 1.0);
		love_Canvases[1] = vec4(Colour, 1.0);
		love_Canvases[2] = vec4(Colour, 1.0);
		love_Canvases[3] = vec4(Colour, 1.0);
    }
#endif