#version 130

uniform sampler2D tex;
uniform float opacity;

float nthBit(float num, float n) {
    return (mod(num, pow(2., n + 1.)) - mod(num, pow(2., n))) / pow(2., n);
}

float xor(float a, float b) {
    return (a - b) * (a - b);
}

float M(float i, float j) {
    float i0 = nthBit(i, 0.);
    float i1 = nthBit(i, 1.);
    float i2 = nthBit(i, 2.);
    float xor0 = xor(i0, nthBit(j, 0.));
    float xor1 = xor(i1, nthBit(j, 1.));
    float xor2 = xor(i2, nthBit(j, 2.));

    return (
        xor0 * 32. +
        i0 * 16. +
        xor1 * 8. +
        i1 * 4. +
        xor2 * 2. +
        i2
    ) / 64.;
}

void main( ){
    ivec2 size = textureSize(tex, 0);

    vec4 c = texture2D(tex, gl_TexCoord[0].xy);
    float gray = 0.2126 * c.r + 0.7152 * c.g + 0.0722 * c.b;
    float black = ceil(gray); // If the pixel is #000000, don't dither

    float n = 8.;
    float i = mod(gl_TexCoord[0].x * size.x, n);
    float j = mod(gl_TexCoord[0].y * size.y, n);
    float offset = 0.5283 * (M(i, j));
    gray += offset;

    gray *= black;

    float r = floor(gray + 2. / 3.);
    float b = floor(gray + 1. / 3.);

    gl_FragColor = vec4(
        r,
        0.,
        b,
        1.
    );
}

