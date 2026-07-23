shader_type spatial;
render_mode cull_front, unshaded;

uniform vec3 color : source_color = vec3(0,0,0);
uniform float thickness : hint_range(0.0, 1.0, 0.01) = 0.05;


uniform bool use_billboard;
void vertex() {
	if (use_billboard){
        MODELVIEW_MATRIX = VIEW_MATRIX * mat4(INV_VIEW_MATRIX[0], INV_VIEW_MATRIX[1], INV_VIEW_MATRIX[2], MODEL_MATRIX[3]);
	}
}

void fragment() {
	ALBEDO = color;
}