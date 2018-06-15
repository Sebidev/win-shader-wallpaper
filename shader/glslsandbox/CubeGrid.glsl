{"code": "#ifdef GL_ES\nprecision mediump float;\n#endif\n\nuniform float time;\nuniform vec2 mouse;\nuniform vec2 resolution;\n\nconst float pi = 3.14159;\n\nvec3 rotate(vec3 v,vec2 r) \n{\n\tmat3 rxmat = mat3(1,   0    ,    0    ,\n\t\t\t  0,cos(r.y),-sin(r.y),\n\t\t\t  0,sin(r.y), cos(r.y));\n\tmat3 rymat = mat3(cos(r.x), 0,-sin(r.x),\n\t\t\t     0    , 1,    0    ,\n\t\t\t  sin(r.x), 0,cos(r.x));\n\t\n\t\n\treturn (v*rxmat)*rymat;\n\t\n}\n\nvec3 norm(vec3 v)\n{\n\t//box made of 6 planes\n\tfloat tp = dot(v,vec3(0,-1,0))*3.;\n\tfloat bt = dot(v,vec3(0,1,0))*3.;\n\tfloat lf = dot(v,vec3(1,0,0))*3.;\n\tfloat rt = dot(v,vec3(-1,0,0))*3.;\n\tfloat fr = dot(v,vec3(0,0,1))*3.;\n\tfloat bk = dot(v,vec3(0,0,-1))*3.;\n\t\n\treturn v/min(min(min(min(min(tp,bt),lf),rt),fr),bk);\n}\n\nfloat grid(vec3 v)\n{\n\tfloat g;\n\tg = abs((mod(v.x*4.,0.25)*4.)-0.5);\n\tg = max(g,abs((mod(v.y*4.,0.25)*4.)-0.5));\n\tg = max(g,abs((mod(v.z*4.,0.25)*4.)-0.5));\n\t\n\tg = smoothstep(0.5+length(v)*0.25,0.5,1.-g);\n\treturn g;\n}\n\nvoid main( void ) {\n\n\tvec2 res = vec2(resolution.x/resolution.y,1.0);\n\tvec2 p = ( gl_FragCoord.xy / resolution.y ) -(res/2.0);\n\t\n\tp = p / (1.0-dot(p,p)*1.5);\n\t\n\tvec2 m = (mouse-0.5)*pi*vec2(2.,1.);\n\t\n\tvec3 color = vec3(0.0);\n\t\n\tvec3 pos = norm(rotate(vec3(p,0.5),vec2(m)));\n\t\n\tcolor = vec3((.5+.5*pos)*(grid(pos)));\n\t\t\n\tgl_FragColor = vec4(  color , 3.0 );\n\n}\n\n\n", "user": "142aed0", "parent": "/e#34024.0", "id": "34167.0"}