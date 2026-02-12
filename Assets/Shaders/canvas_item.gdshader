shader_type canvas_item;

uniform float noise_frequency : hint_range(0.1, 20.0) = 4.0;
uniform float noise_strength : hint_range(0.0, 1.0) = 1.0;

uniform sampler2D gradient_tex; // 1D horizontal gradient

// Simple hash
float hash(vec2 p) {
    return fract(sin(dot(p, vec2(127.1, 311.7))) * 43758.5453123);
}

// Value noise
float noise(vec2 p) {
    vec2 i = floor(p);
    vec2 f = fract(p);

    float a = hash(i);
    float b = hash(i + vec2(1.0, 0.0));
    float c = hash(i + vec2(0.0, 1.0));
    float d = hash(i + vec2(1.0, 1.0));

    vec2 u = f * f * (3.0 - 2.0 * f);

    return mix(a, b, u.x) +
           (c - a) * u.y * (1.0 - u.x) +
           (d - b) * u.x * u.y;
}

void fragment() {
    vec2 uv = UV * noise_frequency;

    float n = noise(uv) * noise_strength;

    // Sample gradient horizontally using noise value
    vec4 gradient_color = texture(gradient_tex, vec2(n, 0.5));

    COLOR = gradient_color;
}
