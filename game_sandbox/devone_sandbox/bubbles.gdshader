shader_type spatial;

group_uniforms color;
uniform vec4 base_color : source_color = vec4(0.0, .35, .5, 1.0);
uniform sampler2D base_color_texture : source_color, hint_default_white;

uniform float speed: hint_range(0.02, 1.0, 0.01);

uniform sampler2D noiseTex;
uniform float smootheness : hint_range(0.0, 1.0, 0.01);

group_uniforms roughness;
uniform float roughness : hint_range(0.0, 1.0) = 0.15;
uniform sampler2D roughness_texture : hint_roughness_r;

group_uniforms normal;
uniform float normal_strength : hint_range(-16.0, 16.0) = 1.0;
uniform sampler2D normal_map : hint_normal;

uniform vec4 edge_color : source_color = vec4(0.0, 0.0, 0.0, 1.0);

varying vec3 world_position;

void vertex(){
	world_position = (MODEL_MATRIX * vec4(VERTEX, 1.0)).xyz;
	float height = texture(noiseTex, VERTEX.xy * smootheness + vec2(TIME * speed)).r;
	VERTEX += NORMAL * height;
}

float SchlickFresnel(float u) {
	float m = 1.0 - u;
	float m2 = m * m;
	return m2 * m2 * m;
}

vec3 fresnel_glow(float amount, float intensity, vec3 color, vec3 normal, vec3 view)
{
	return pow((1.0 - dot(normalize(normal), normalize(view))), amount) * color * intensity;
}

void fragment()
{
	// calculate fresnel values
	float VdotN = dot(VIEW, NORMAL);
	float fresnel = clamp(SchlickFresnel(VdotN), 0.0, 1.0);

	// sample and mix textures
	vec4 _albedo = texture(base_color_texture, UV) * base_color;
	float _roughness = texture(roughness_texture, UV).r * roughness;

	// apply glass look
	float a = mix(0.001, 1.0, _albedo.a);
	ALPHA = mix(fresnel * edge_color.a, 1.0, a);
	ALBEDO = mix(edge_color.rgb * edge_color.a, _albedo.rgb, a);

	ROUGHNESS = _roughness;
	NORMAL_MAP = texture(normal_map, UV).xyz;
	NORMAL_MAP_DEPTH = normal_strength;

	// function to compensate specular for alpha blend
	// 0.5 * ALPHA^-0.5
	SPECULAR = 0.5 * inversesqrt(ALPHA);
}
