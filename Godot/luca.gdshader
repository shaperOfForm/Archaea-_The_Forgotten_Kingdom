shader_type canvas_item;
uniform sampler2D overlay_texture;
uniform sampler2D noise_texture;
void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {	
	/* NOISE on overlay */
	// Sample the noise texture
    vec2 direction = vec2(1, 1) * sin(2.2 * TIME) * 0.05;
	
	float noiseValue = texture(noise_texture, UV + direction).r;

	vec2 distortedUV = UV + vec2(0.1, 0.1) * (noiseValue - 0.5);
    
    // Sample the original texture using the distorted UVs
    vec4 distortedColor = texture(overlay_texture, distortedUV);
	vec4 overlayColor = texture(overlay_texture, UV);
	
    
    // Apply the color to the fragment
     COLOR = mix(distortedColor, overlayColor, 0.1);
	
	
	
	/* CUTE ROTATING SPIKES */
	
    // Calculate distance and angle for the current fragment
    vec2 toCenter = UV - vec2(0.5, 0.5);
    float dist = length(toCenter);
    float angle = atan(toCenter.y, toCenter.x);

    // Time-based oscillation factor
    float timeOsc = sin(TIME) * 0.032;

    // Angle-based oscillation, with peaks every 45 degrees as it rotates
    float angleOsc = sin(angle * 4.0 + TIME * 2.0) * 0.01; // 4.0 adjusts the frequency to have peaks every π/4

    // Combine the two oscillations
    float oscillation = timeOsc + angleOsc;

    // Adjust the edge values in smoothstep with the combined oscillation
    float innerEdge = 0.35 + oscillation;
    float outerEdge = 0.45 + oscillation; // Control the thickness of the oscillating border

    // Smoothstep for smooth interpolation between the circle border and background
    float alpha = 1.0 - smoothstep(innerEdge, outerEdge, dist);

	COLOR[0] = dist; // red border
    COLOR[3] = alpha;
	/* END CUTE ROTATING SPIKES */
	
}


//void light() {
	// Called for every pixel for every light affecting the CanvasItem.
	// Uncomment to replace the default light processing function with this one.
//}
