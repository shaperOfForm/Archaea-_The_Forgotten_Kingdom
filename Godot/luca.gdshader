shader_type canvas_item;
uniform sampler2D overlay_texture;
uniform sampler2D noise_texture;
uniform float alpha = 1.0;

void vertex() {
	
}

void fragment() {	
	
	//Create wave
	vec2 wave = vec2(1, 1) * sin(3.3 * TIME) * 0.12;
	
	vec2 center = vec2(0.5, 0.5);
	// For current fragment
	float distToCenter = distance(UV, center);
	
	float distortionScaled = distToCenter * 0.16;
	
	// Sample noise texture adding wave pattern to current fragment; amount of noise based on noise texture
	float noise = texture(noise_texture, UV + wave ).r;
	
	// 0.7 is and offset of the color layers
	vec2 distortedUV = UV + distortionScaled * (noise - 0.7);
	
	// Sample overlay texture using the distorted and original UVs
	vec4 distortedColor = texture(overlay_texture, distortedUV);
	vec4 overlayColor = texture(overlay_texture, UV);
	
	// Apply color to current fragment
	COLOR = mix(distortedColor, overlayColor, 0.1);
	
	// The further a fragment is from the center, the more red it will appear
	COLOR[0] = distToCenter; // red border
	
	//COLOR[3] = COLOR[3] * alpha;
}


//void light() {
	// Called for every pixel for every light affecting the CanvasItem.
	// Uncomment to replace the default light processing function with this one.
//}