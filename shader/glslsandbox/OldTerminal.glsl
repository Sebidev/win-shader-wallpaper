{"code": "#ifdef GL_ES\nprecision mediump float;\n#endif\n\nuniform float time;\nuniform vec2 mouse;\nuniform vec2 resolution;\n\n \nfloat noise(vec2 p)\n{\n  return sin(p.x*10.) * sin(p.y*(3. + sin(time/11.))) + .2; \n}\n\nmat2 rotate(float angle)\n{\n  return mat2(cos(angle), -sin(angle), sin(angle), cos(angle));\n}\n\n\nfloat fbm(vec2 p)\n{\n  p *= 1.1;\n  float f = 0.;\n  float amp = .5;\n  for( int i = 0; i < 3; i++) {\n    mat2 modify = rotate(time/50. * float(i*i));\n    f += amp*noise(p);\n    p = modify * p;\n    p *= 2.;\n    amp /= 2.2;\n  }\n  return f;\n}\n\nfloat pattern(vec2 p, out vec2 q, out vec2 r) {\n  q = vec2( fbm(p + vec2(1.)), fbm(rotate(.1*time)*p + vec2(1.)));\n  r = vec2( fbm(rotate(.1)*q + vec2(0.)), fbm(q + vec2(0.)));\n  return fbm(p + 1.*r);\n\n}\n\nfloat sampleFont(vec2 p, float num) {\n    float glyph[2];\n    if (num < 1.)      { glyph[0] = 0.91333008; glyph[1] = 0.89746094; }\n    else if (num < 2.) { glyph[0] = 0.27368164; glyph[1] = 0.06933594; }\n    else if (num < 3.) { glyph[0] = 1.87768555; glyph[1] = 1.26513672; }\n    else if (num < 4.) { glyph[0] = 1.87719727; glyph[1] = 1.03027344; }\n    else if (num < 5.) { glyph[0] = 1.09643555; glyph[1] = 1.51611328; }\n    else if (num < 6.) { glyph[0] = 1.97045898; glyph[1] = 1.03027344; }\n    else if (num < 7.) { glyph[0] = 0.97045898; glyph[1] = 1.27246094; }\n    else if (num < 8.) { glyph[0] = 1.93945312; glyph[1] = 1.03222656; }\n    else if (num < 9.) { glyph[0] = 0.90893555; glyph[1] = 1.27246094; }\n    else               { glyph[0] = 0.90893555; glyph[1] = 1.52246094; }\n    \n    float pos = floor(p.x + p.y * 5.);\n    if (pos < 13.) {\n        return step(1., mod(pow(2., pos) * glyph[0], 2.));\n    } else {\n        return step(1., mod(pow(2., pos-13.) * glyph[1], 2.));\n    }\n}\n\nfloat digit(vec2 p){\n    p -= vec2(0.5, 0.5);\n    p *= (1.+0.15*pow(length(p),0.6));\n    p += vec2(0.5, 0.5);\n    \n    p.x += sin(time/7.)/5.;\n    p.y += sin(time/13.)/5.;\n        \n    vec2 grid = vec2(3.,1.) * 15.;\n    vec2 s = floor(p * grid) / grid;\n    p = p * grid;\n    vec2 q;\n    vec2 r;\n    float intensity = pattern(s/10., q, r)*1.3 - 0.03 ;\n    p = fract(p);\n    p *= vec2(1.2, 1.2);\n    float x = fract(p.x * 5.);\n    float y = fract((1. - p.y) * 5.);\n    vec2 fpos = vec2(floor(p.x * 5.), floor((1. - p.y) * 5.));\n    float isOn = sampleFont(fpos, floor(intensity*10.));\n    return p.x <= 1. && p.y <= 1. ? isOn * (0.2 + y*4./5.) * (0.75 + x/4.) : 0.;\n}\n\nfloat hash(float x){\n    return fract(sin(x*234.1)* 324.19 + sin(sin(x*3214.09) * 34.132 * x) + x * 234.12);\n}\n\nfloat onOff(float a, float b, float c)\n{\n\treturn step(c, sin(time + a*cos(time*b)));\n}\n\nfloat displace(vec2 look)\n{\n    float y = (look.y-mod(time/4.,1.));\n    float window = 1./(1.+50.*y*y);\n\treturn sin(look.y*20. + time)/80.*onOff(4.,2.,.8)*(1.+cos(time*60.))*window;\n}\n\nvec3 getColor(vec2 p){\n    \n    float bar = mod(p.y + time*20., 1.) < 0.2 ?  1.4  : 1.;\n    p.x += displace(p);\n    float middle = digit(p);\n    float off = 0.002;\n    float sum = 0.;\n    for (float i = -1.; i < 2.; i+=1.){\n        for (float j = -1.; j < 2.; j+=1.){\n            sum += digit(p+vec2(off*i, off*j));\n        }\n    }\n    return vec3(0.9)*middle + sum/10.*vec3(0.,1.,0.) * bar;\n}\n\nvoid main()\n{\n    \n    vec2 p = gl_FragCoord.xy / resolution.xy;\n    float off = 0.0001;\n    vec3 col = getColor(p);\n    gl_FragColor = vec4(col,1);\n}\n", "user": "1fc250e", "parent": null, "id": "26713.0"}