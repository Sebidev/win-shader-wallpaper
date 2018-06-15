{"code": "precision mediump float;\n\nuniform float time;\nuniform vec2 mouse;\nuniform vec2 resolution;\n\nconst int maxiter = 90;\nconst int maxiter_sqr = maxiter*maxiter;\n\nvoid main( void ) {\n\tvec3 dir = normalize(vec3((gl_FragCoord.xy-resolution*.5)/resolution.x,1.));\n\tfloat a = time * 0.4;\n\tvec3 pos = vec3(time*0.04,tan(time*0.5)*0.03,-20.0);\n\tvec3 color = vec3(0);\n\t\n\t\n\t\n\tfor (int i = 0; i < maxiter; i++) {\n\t\tvec3 p = pos;\t\t\n\t\tp = abs(fract(p) - 0.5);\n\t\tp *= p;\n\t\tvec3 field = sqrt(p+p.yzx*p.zzy)-0.015;\t\t\n\t\t\n\t\tvec3 f2 = field;\n\t\tvec3 rep = vec3(1.0);\n\t\tfloat f = min(min(min(f2.x,f2.y),f2.z), length(mod(pos-vec3(0.5,0.5,0.2),rep)-0.5*rep)-0.15);\n\t\tpos += dir*f;\n\t\tcolor += float(maxiter-i)/(f2+1e-5);\n\t}\n\tvec3 color3 = vec3(-1./(1.+color*(.5/float(maxiter_sqr))));\n\tcolor3 *= color3;\n\tgl_FragColor = vec4(vec3(color3.r+color3.g+color3.b),1.);\n}", "user": "69e642c", "parent": "/e#8390.0", "id": "8696.0"}