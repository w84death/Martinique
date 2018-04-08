shader_type canvas_item; 

uniform sampler2D grass_tex;
uniform sampler2D rock_tex;
uniform sampler2D dirt_tex;
uniform sampler2D splatmap_tex;


void fragment() {
	vec3 c = textureLod(grass_tex, UV, 0.0).rgb;
	COLOR.rgb = vec3(1,0,0);
}