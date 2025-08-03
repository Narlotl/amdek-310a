#version 130

uniform sampler2D tex;
uniform float opacity;

void main( ){
    ivec2 size = textureSize(tex, 0);

    vec4 c = texture2D(tex, gl_TexCoord[0].xy);

    float gray = 0.2126 * c.r + 0.7152 * c.g + 0.0722 * c.b;
    float r = floor(gray + 2. / 3.); // Lower this number to require higher brightness forthe pixel to display and raise it to require lower brightness
    float b = floor(gray + 1. / 3.); // Lower this number to require higher brightness forthe pixel to be fully bright and raise it to require lower brightness
    gl_FragColor = vec4(
        r,
        0.,
        b,
        1.
    );
}

