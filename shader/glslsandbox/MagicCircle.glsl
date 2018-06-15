{"code": "\n//Ark's Magic Circle ported to GLSL Sandbox\n\n\n#ifdef GL_ES\nprecision mediump float;\n#endif\n\n\nuniform float time;\nuniform vec2 mouse;\nuniform vec2 resolution;\n#define iResolution resolution.xyxy\n#define iMouse mouse*resolution\n#define iGlobalTime time\n#define iDate.w time\n#define PI 3.14159265359\n\nvec2 rotate(vec2 p, float rad) {\n    mat2 m = mat2(cos(rad), sin(rad), -sin(rad), cos(rad));\n    return m * p;\n}\n\nvec2 translate(vec2 p, vec2 diff) {\n    return p - diff;\n}\n\nvec2 scale(vec2 p, float r) {\n    return p*r;\n}\n\nfloat circle(float pre, vec2 p, float r1, float r2, float power) {\n    float leng = length(p);\n    if (r1<leng && leng<r2) pre = 0.0;\n    float d = min(abs(leng-r1), abs(leng-r2));\n    float res = power / d;\n    return clamp(pre + res, 0.0, 1.0);\n}\n\nfloat rectangle(float pre, vec2 p, vec2 half1, vec2 half2, float power) {\n    p = abs(p);\n    if ((half1.x<p.x || half1.y<p.y) && (p.x<half2.x && p.y<half2.y)) {\n        pre = max(0.01, pre);\n    }\n    float dx1 = (p.y < half1.y) ? abs(half1.x-p.x) : length(p-half1);\n    float dx2 = (p.y < half2.y) ? abs(half2.x-p.x) : length(p-half2);\n    float dy1 = (p.x < half1.x) ? abs(half1.y-p.y) : length(p-half1);\n    float dy2 = (p.x < half2.x) ? abs(half2.y-p.y) : length(p-half2);\n    float d = min(min(dx1, dx2), min(dy1, dy2));\n    float res = power / d;\n\t\n    return clamp(pre + res, 0.0, 1.0);\n}\n\nfloat radiation(float pre, vec2 p, float r1, float r2, int num, float power) {\n    float angle = 2.0*PI/float(num);\n    float d = 1e10;\n    for(int i=0; i<360; i++) {\n        if (i>=num) break;\n        float _d = (r1<p.y && p.y<r2) ? \n            abs(p.x) : \n        \tmin(length(p-vec2(0.0, r1)), length(p-vec2(0.0, r2)));\n        d = min(d, _d);\n        p = rotate(p, angle);\n    }\n    float res = power / d;\n    return clamp(pre + res, 0.0, 1.0);\n}\n\nvec3 calc(vec2 p) {\n    float dest = 0.0;\n    p = scale(p, sin(PI*iGlobalTime/1.0)*0.02+1.1);\n    {\n        vec2 q = p;\n        q = rotate(q, iGlobalTime * PI / 6.0);\n        dest = circle(dest, q, 0.85, 0.9, 0.006);\n        dest = radiation(dest, q, 0.87, 0.88, 36, 0.0008);\n    }\n    {\n        vec2 q = p;\n        q = rotate(q, iGlobalTime * PI / 6.0);\n        float n = 12.0 * abs(sin(time*.1));\n        float angle = PI / float(n);\n        q = rotate(q, floor(atan(q.x, q.y)/angle + 0.5) * angle);\n        for(int i=0; i>-1; i++) {\n            dest = rectangle(dest, q, vec2(0.85/sqrt(2.0)), vec2(0.85/sqrt(2.0)), 0.0015);\n            q = rotate(q, angle);\n\t    if(i == int(n)){break;};\t\t\n        }\n    }\n    {\n        vec2 q = p;\n        q = rotate(q, iGlobalTime * PI / 6.0);\n        float n = 4.0 * abs(sin(time*.1));\n        q = rotate(q, 2.0*PI/float(n)/2.0);\n        float angle = 2.0*PI / float(n);\n        for(int i=0; i>-1; i++) {\n            dest = circle(dest, q-vec2(0.0, 0.875), 0.001, 0.05, 0.004);\n            dest = circle(dest, q-vec2(0.0, 0.875), 0.001, 0.001, 0.008);\n            q = rotate(q, angle);\n\t    if(i == int(n)){break;};\n        }\n    }\n    {\n        vec2 q = p;\n        dest = circle(dest, q, 0.5, 0.55, 0.002);\n    }\n    {\n        vec2 q = p;\n        q = rotate(q, -iGlobalTime * PI / 6.0);\n        const int n = 3;\n        float angle = PI / float(n);\n        q = rotate(q, floor(atan(q.x, q.y)/angle + 0.5) * angle);\n        for(int i=0; i<n; i++) {\n            dest = rectangle(dest, q, vec2(0.36, 0.36), vec2(0.36, 0.36), 0.0015);\n            q = rotate(q, angle);\n        }\n    }\n    {\n        vec2 q = p;\n        q = rotate(q, -iGlobalTime * PI / 6.0);\n        const int n = 12;\n        q = rotate(q, 2.0*PI/float(n)/2.0);\n        float angle = 2.0*PI / float(n);\n        for(int i=0; i<n; i++) {\n            dest = circle(dest, q-vec2(0.0, 0.53), 0.001, 0.035, 0.004);\n            dest = circle(dest, q-vec2(0.0, 0.53), 0.001, 0.001, 0.001);\n            q = rotate(q, angle);\n        }\n    }\n    {\n        vec2 q = p;\n        q = rotate(q, iGlobalTime * PI / 6.0);\n        dest = radiation(dest, q, 0.25, 0.3, 12, 0.005);\n    }\n    {\n        vec2 q = p;\n    \tq = scale(q, sin(PI*iGlobalTime/1.0)*0.04+1.1);\n        q = rotate(q, -iGlobalTime * PI / 6.0);\n        for(float i=0.0; i<6.0; i++) {\n            float r = 0.13-i*0.01;\n            q = translate(q, vec2(0.1, 0.0));\n        \tdest = circle(dest, q, r, r, 0.002);\n        \tq = translate(q, -vec2(0.1, 0.0));\n        \tq = rotate(q, -iGlobalTime * PI / 12.0);\n        }\n        dest = circle(dest, q, 0.04, 0.04, 0.004);\n    }\n    return pow(dest, 2.5) * vec3(1.0, 0.95, 0.8);\n}\n\nvoid mainImage( out vec4 fragColor, in vec2 fragCoord ) {\n\tvec2 uv = (iResolution.xy - fragCoord.xy*2.0) / min(iResolution.x, iResolution.y);\n\tfragColor = vec4(calc(uv),1.0);\n}\nvoid main( void ) {\n\n\tmainImage( gl_FragColor, gl_FragCoord.xy );\n\n}\n", "user": "77a5382", "parent": "/e#36354.1", "id": "36398.2"}