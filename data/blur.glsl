uniform float opacity;
uniform sampler2D myTexture;
uniform vec2 myTextureSize;

void main() 
{
    vec4 texColor = texture2D(myTexture, gl_FragCoord.xy / myTextureSize); // Sample the color from the texture
    gl_FragColor = vec4(texColor.rgb, opacity); // Use the sampled color and apply the opacity
}