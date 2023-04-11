shader_type canvas_item;
uniform sampler2D GRADIENT;
uniform vec2 gradientScale = vec2(1.0, 1.0);
uniform float timeScale = 1.0;

vec2 scale(vec2 uv, float x, float y)
{
	mat2 scale = mat2(vec2(x, 0.0), vec2(0.0, y));
	
	uv -= 0.5;
	uv = uv * scale;
	uv += 0.5;
	return uv;
}

void fragment(){
	vec4 image = texture(TEXTURE, UV);
	vec4 gradient = texture(GRADIENT, scale(vec2(UV.x, UV.y + TIME * timeScale * 0.5), 1.0 / gradientScale.x, 1.0 / gradientScale.y));
	//vec4 gradient = texture(GRADIENT, vec2(UV.x, UV.y + TIME * timeScale * 0.5));
	image.rgb = (image.r > 0.1 && image.g > 0.1 && image.b > 0.1) ? image.rgb : vec3(0.0,0.0,0.0);
	gradient.a = (COLOR.r > 0.2 && COLOR.g > 0.2 && COLOR.b > 0.2) ? 1.0 : 0.0;
	COLOR.r = (image.r > 0.01 && image.g > 0.01 && image.b > 0.01) ? (gradient.r + image.r) * 0.5 : 0.0;
	COLOR.g = (image.r > 0.01 && image.g > 0.01 && image.b > 0.01) ? (gradient.g + image.g) * 0.5 : 0.0;
	COLOR.b = (image.r > 0.01 && image.g > 0.01 && image.b > 0.01) ? (gradient.b + image.b) * 0.5 : 0.0;
}
