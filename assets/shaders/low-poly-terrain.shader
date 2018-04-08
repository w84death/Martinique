shader_type spatial;

// heightmap texture
uniform sampler2D hightmap_tex;
uniform sampler2D grass_tex;
uniform sampler2D rocks_tex;
uniform sampler2D sand_tex;
uniform sampler2D splatmap_tex;
uniform float tex_scale = 2.0;
uniform int height_range = 5;

void vertex() {
	VERTEX = vec3(VERTEX.x, texture(hightmap_tex, UV).r * float(height_range), VERTEX.z);
}

void fragment() {
	// same normal vector for every face
	NORMAL = normalize(cross(dFdx(VERTEX), dFdy(VERTEX)));

	// textures
	float rocks_vis = texture(splatmap_tex, UV).r;
	float grass_vis = texture(splatmap_tex, UV).g;
	float sand_vis = texture(splatmap_tex, UV).b;
	
	vec3 grass_color = texture(grass_tex, UV * tex_scale).rgb * grass_vis;
	vec3 rocks_color = texture(rocks_tex, UV * tex_scale).rgb * rocks_vis;
	vec3 sand_color = texture(sand_tex, UV * tex_scale).rgb * sand_vis;
	
	ALBEDO = grass_color + rocks_color + sand_color;
	
}
