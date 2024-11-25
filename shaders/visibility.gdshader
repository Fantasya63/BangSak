// NOTE: Shader automatically converted from Godot Engine 4.3.stable's CanvasItemMaterial.

shader_type canvas_item;
render_mode blend_mix,light_only;




void light() {
	float alpha = smoothstep(0.0, 0.25, LIGHT_COLOR.a);
	LIGHT = vec4(LIGHT_COLOR. rgb * COLOR. rgb * LIGHT_ENERGY, alpha);
}