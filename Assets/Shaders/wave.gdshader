shader_type spatial;

uniform float amplitude : hint_range(0.0, 5.0) = 0.5;
uniform float frequency : hint_range(0.0, 10.0) = 0.25;
uniform float speed : hint_range(0.0, 10.0) = 1.0;
uniform bool is_sin = true;
uniform bool is_neg = true;

void vertex() {
    float offset = VERTEX.y * frequency + TIME * speed;
	float function_sign = 1.0;
	if (is_neg) {
		function_sign = -1.0;
	}

    // Shift entire ring sideways
	if (is_sin) {
		VERTEX.x += function_sign * sin(offset) * amplitude;
	} else {
		VERTEX.x += function_sign * cos(offset) * amplitude;
	}
}
