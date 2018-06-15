{"code": "\n//----------------------------------------------\n// MultipleCircleInversions.glsl by THolzer \n// original by BeondTheStatic 2015-07-27 \n//   https://www.shadertoy.com/view/MlXXR2\n// Show how multiple conformal transformations can be added together,\n// producing a result that maintains conformality.\n// Tags: 2d, conformal, circle, inversion, checkerboard\n//----------------------------------------------\n\n#ifdef GL_ES\nprecision mediump float;\n#endif\n\nuniform float time;\nuniform vec2 mouse;\nuniform vec2 resolution;\n\n//----------------------------------------------\nconst float periodTime = 15.0;\n\nconst vec3 patternColor0 = vec3(1.0);\nconst vec3 patternColor1 = vec3(0.2,0.4,0.5);\nconst vec3 patternColor2 = vec3(0.2,0.5,0.2);\nconst vec3 patternColor3 = vec3(0.5,0.4,0.2);\n\nconst int circles = 4;  // number of circle inversions\n\n//----------------------------------------------\n// return rotated position p\n//----------------------------------------------\nvec2 rotate(vec2 p, float a)\n{\n\tfloat s = sin(radians(a));\n\tfloat c = cos(radians(a));\n\treturn vec2(p.y*c + p.x*s, -p.y*s + p.x*c);\n}\n//----------------------------------------------\n// p = position; o = circle center, r = radius\n//----------------------------------------------\nvec2 cInvert(vec2 p, vec2 o, float r)\n{\n\tvec2 po = p-o;\n\treturn po / dot(po, po)*pow(r, 2.);\n}\n//----------------------------------------------\n// return checkerboard pattern color\n//----------------------------------------------\nvec3 CheckerboardColor (in vec2 pos)\n{\n    return (mod(floor(pos.x * 10.0) \n               +floor(pos.y * 10.0), 2.0) \n                < 1.0 ? patternColor0 : patternColor1);\n}\n//----------------------------------------------\n// return rounded square pattern color\n//----------------------------------------------\nvec3 RoundedSquaresColor (in vec2 pos)\n{\n  float k = smoothstep(0.0, 0.5, sin(pos.x * 10.0) +sin(pos.y * 10.0) );\n  return mix(patternColor0, patternColor2, k);\n}\n//----------------------------------------------\n// return hexagonal grid color\n// http://glslsandbox.com/e#23933\n//----------------------------------------------\nvec3 HexagonalGridColor (in vec2 position         \n\t                ,in float gridSize\n\t                ,in float gridThickness) \n{\n  vec2 pos = position / gridSize; \n  pos.x *= 0.57735 * 2.0;\n  pos.y += mod(floor(pos.x), 2.0)*0.5;\n  pos = abs((mod(pos, 1.0) - 0.5));\n  float d = abs(max(pos.x*1.5 + pos.y, pos.y*2.0) - 1.0);\n  float k = smoothstep(0.0, gridThickness, d);\n  return mix(patternColor0, patternColor3, k);\n}\n//----------------------------------------------\n// return color of circle inversions\n//----------------------------------------------\nvec3 CircleInversions (in vec2 pos)\n{\n\t// adding up circle inversions\n    vec2 invertSum = vec2(0.0);\n    for(int i=0; i<circles; i++)\n    {\n        float rn = float(i) / float(circles);  \n        invertSum += cInvert(pos, rotate(vec2(0.0, rn)\n                            ,time * 13.0*rn), 0.5);\n    }\n   \tpos = fract(invertSum);\n    \n    float border = clamp(8.*(.5-max(abs(pos.x-0.5), abs(pos.y-0.5))), 0.1, 1.0);\n    vec3 col;\n//  col = 2. * border * texture2D(iChannel0, uv).rgb;\n    float sceneTime = periodTime / 3.0;\n    int selection = int(mod(time, periodTime) / periodTime * 3.0);\n    if      (selection < 1)  col = border * CheckerboardColor(pos);\n    else if (selection < 2)  col = border * RoundedSquaresColor(pos);\n    else                     col = border * HexagonalGridColor(pos, 0.1, 0.2);\n    return col;\n}\n//----------------------------------------------\nvoid main( void ) \n{\n    vec2 uv = gl_FragCoord.xy / resolution.xy -0.5;\n    uv.x *= resolution.x / resolution.y;\n    gl_FragColor = vec4(CircleInversions(uv), 11.01);\n}", "user": "fa0712a", "parent": null, "id": "26853.10"}