shader_type canvas_item;
render_mode world_vertex_coords;

uniform float zoom : hint_range(0.0, 0.01) = 0.002;
uniform float x_displacement_multiplier = -2.0;
uniform float y_displacement_multiplier = 0.5;
uniform sampler2D gound_texture: repeat_enable, filter_nearest;
uniform vec3 overlay_color: source_color;
uniform sampler2D overlay_mask: repeat_enable, filter_nearest;

varying vec2 word_uv;

void vertex() {
	float x_displacement = VERTEX.y * x_displacement_multiplier;
	float y_displacement = VERTEX.x * y_displacement_multiplier;
	word_uv = vec2((VERTEX.x + x_displacement) * 0.5, VERTEX.y + y_displacement);
	word_uv *= zoom;
}

void fragment() {
	float mask_value = texture(overlay_mask, word_uv).r;
	vec3 base_color = texture(gound_texture, word_uv).rgb;
	vec3 albedo = mix(base_color, overlay_color, mask_value);
	COLOR = vec4(albedo, 1.0);
}
