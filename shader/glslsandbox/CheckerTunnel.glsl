{"code": "/**\n\n###Anaglyph 3d tunnel###\nby Ralph Hauwert / @UnitZeroOne / UnitZeroOne.com\nPut on your red / magenta anaglyph glasses and enjoy the trip.\n**/\n\n#ifdef GL_ES\nprecision mediump float;\n#endif\n\nuniform float time;\nuniform vec2 mouse;\nuniform vec2 resolution;\n\n//There is a nasty bug on chrome (at leat mine), that breaks on any usage of cos, workaround with the mycos define below.\n#define mycos(x) sin(1.57079633-x) \n\nvec3 roy(vec3 v, float x)\n{\n    return vec3(mycos(x)*v.x - sin(x)*v.z,v.y,sin(x)*v.x + mycos(x)*v.z);\n}\n\nvec3 rox(vec3 v, float x)\n{\n    return vec3(v.x,v.y*mycos(x) - v.z*sin(x),v.y*sin(x) + v.z*mycos(x));\n}\n\nfloat fdtun(vec3 rd, vec3 ro, float r)\n{\n\t\n\t//float a = dot(rd.xy,rd.xy);\n\tfloat a = rd.x*rd.x + rd.y*rd.y;\n\tfloat b = ro.x*rd.x + ro.y*rd.y;\n\tfloat c = dot(ro.xy,ro.xy) + r*r;\n\t//b = dot(ro.xy,rd.xy);\n\t//return sqrt(c);\n  \treturn c;\n\tfloat d = (b*b)-(4.0*a*(dot(ro.xy,ro.xy)+(r*r)));\n\treturn d;\n\tfloat t1 = (-b + sqrt(d))/(2.0*a);\n  \tfloat t2 = (-b - sqrt(d))/(2.0*a);\n  \tfloat t = min(t1, t2); \n  \treturn t;\n}\n\nvec2 tunuv(vec3 pos){\n\treturn vec2(pos.z,(atan(pos.y, pos.x))/0.31830988618379);\n}\n\nvec3 checkerCol(vec2 loc, vec3 col)\n{\n\treturn mix(col, vec3(0.0), mod(step(fract(loc.x), 0.5) + step(fract(loc.y), 0.5), 2.0));\n}\n\nvec3 lcheckcol(vec2 loc, vec3 col)\n{\n\treturn checkerCol(loc*2.0,col)*checkerCol(loc*0.8,col);\t\n}\n\nvoid main( void ) {\n\tvec3 dif = vec3(0.15,0.0,0.0);\n\tvec3 scoll = vec3(0.0,1.0,1.0);\n\tvec3 scolr = vec3(1.0,0.0,0.0);\n\tvec2 uv = (gl_FragCoord.xy/resolution.xy);\n\tvec3 ro = vec3(0.0,0.0,time*2.0);\n\tvec3 dir = normalize( vec3( -1.0 + 2.0*vec2(uv.x - .2, uv.y)* vec2(resolution.x/resolution.y, 1.0), -1.33 ) );\n\n\tfloat ry = time*0.3;\n\t\n\tdir = roy(rox(dir,time*0.4),time*0.2);\n\tvec3 lro = ro-dif;\n\tvec3 rro = ro+dif;\n\n\tconst float r = 3.0;\n\tfloat ld = fdtun(dir,lro,r);\n\tfloat rd = fdtun(dir,rro,r);\n\tvec2 luv = tunuv(ro + ld*dir);\n\tvec2 ruv = tunuv(ro + rd*dir);\n\tvec3 coll = lcheckcol(luv*.3,scoll)*(10.0/exp(sqrt(ld)));\n\tvec3 colr = lcheckcol(ruv*.3,scolr)*(10.0/exp(sqrt(rd)));\n\tgl_FragColor = vec4(sqrt(coll+colr),1.0);\n}", "user": "ad55346", "parent": "/e#1431.3", "id": "1437.0"}