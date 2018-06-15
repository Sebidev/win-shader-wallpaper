{"code": "//TODO: Add hgPhase funtion\n//Add sunlight, skylight, and indirect light colors\n//Modifiy noise\n//Modify \"occlusion\"\n\n#ifdef GL_ES\nprecision mediump float;\n#endif\n\nuniform float time;\nuniform vec2 mouse;\nuniform vec2 resolution;\n\n// hash\n\nfloat hash( float n )\n{\n    return fract(sin(n)*43758.5453);\n}\n\n// noise\n\nfloat noise( in vec3 x )\n{\n    vec3 p = floor(x);\n    vec3 f = fract(x);\n\n    f = f*f*(3.0-2.0*f);\n    float n = p.x + p.y*57.0 + 113.0*p.z;\n    return mix(mix(mix( hash(n+  0.0), hash(n+  1.0),f.x),\n                   mix( hash(n+ 57.0), hash(n+ 58.0),f.x),f.y),\n               mix(mix( hash(n+113.0), hash(n+114.0),f.x),\n                   mix( hash(n+170.0), hash(n+171.0),f.x),f.y),f.z);\n}\n\n// map\n\n\nvec4 map( in vec3 p )\n{\n\t//altitude\n\tfloat d = -0.005 - p.y +sin(time);\n\n\t//wind\n\tvec3 q = p - vec3(-1.0,0.0,0.9) * time;\n\tfloat f;\n    f  = 0.5000*noise( q ); q = q*2.02;\n    f += 0.2500*noise( q ); q = q*2.03;\n    f += 0.1250*noise( q ); q = q*2.01;\n    f += 0.0625*noise( q );\n\n\t//density\n\td += 3.0 * f;\n\n\td = clamp( d, 0.0, 1.0 );\n\t\n\tvec4 res = vec4( d );\n\n\t// diffuse is here actually\n\tres.xyz = mix( 1.15*vec3(1.0,0.95,0.8), vec3(0.7,0.7,0.7), res.x );\n\t\n\treturn res;\n}\n\n// sundir\n\nvec3 sundir = vec3(-1.0,-1.0,0.0);\n\n// raymarch\n\nvec4 raymarch( in vec3 ro, in vec3 rd )\n{\n\tvec4 sum = vec4(0, 0, 0, 0);\n\n\tfloat t = 0.0;\n\tfor(int i=0; i<64; i++)\n\t{\n\t\tif( sum.a > 0.99 ) continue;\n\n\t\tvec3 pos = ro + t*rd;\n\t\tvec4 col = map( pos );\n\t\t\n\t\t#if 1\n\t\tfloat dif =  clamp((col.w - map(pos+0.3*sundir).w)/0.6, 0.0, 1.0 );\n\t\tfloat constrast = 0.5;\n\t\t//fake for now, but will change soon\n\t\tvec3 skylighting = vec3(0.4,0.48,0.9)*0.2 + 0.15 ;\n\t\tvec3 sunlighting = vec3(1.0,1.0,1.0)*0.2 + 0.5;\n        \tvec3 lin = sunlighting + skylighting;\n\t\tcol.xyz *= lin;\n\t\tcol.xyz *= pow(col.xyz, vec3(constrast));\n\t\t#endif\n\t\t\n\t\tcol.a *= 0.25;\n\t\tcol.rgb *= col.a;\n\n\t\tsum = sum + col*(1.0 - sum.a);\t\n\n        #if 0\n\t\tt += 0.1;\n\t\t#else\n\t\tt += max(0.1,0.02*t);\n\t\t#endif\n\t}\n\n\tsum.xyz /= (0.001+sum.w);\n\n\treturn clamp( sum, 0.0, 1.0 );\n}\n\n\nvoid main( void ) {\n\t\n\tvec2 q = gl_FragCoord.xy / resolution.xy;\n\tvec2 p = -1.0 + 2.0*q;\n\tp.x *= resolution.x/ resolution.y;\n\tvec2 mo = -1.0 + 2.0 / resolution.xy;\n\t\n\t    // camera\n    \tvec3 ro = 4.0*normalize(vec3(cos(2.75-3.0*mo.x), 0.7+(mo.y+1.0), sin(2.75-3.0*mo.x)));\n\tvec3 ta = vec3(0.0, 1.0, 0.0);\n    \tvec3 ww = normalize( ta - ro);\n    \tvec3 uu = normalize(cross( vec3(0.0,1.0,0.0), ww ));\n    \tvec3 vv = normalize(cross(ww,uu));\n    \tvec3 rd = normalize( p.x*uu*1.0 + p.y*vv*1.0 + 1.0*ww );\n\t\n\tvec4 res = raymarch( ro, rd );\n\n\tfloat sun = clamp( dot(sundir,rd), 0.0, 1.0 );\n\tvec3 col = vec3(0.6,0.63,0.7) - rd.y*0.2*vec3(0.5,0.5,1.0) + 0.1 * 0.8;\n\tcol += vec3(1.3,1.22,0.65)*sun * 0.2;\n\tcol *= 0.95;\n\t\n\tcol = mix( col, res.xyz, res.w );\n\tcol += 0.2*vec3(0.645,0.4,0.2)*pow( sun, 0.0 );\n\tcol *= col;\n\tcol = col;\n\t\n\tgl_FragColor = vec4( col, 1.0 );\n}", "user": "bf7a9c5", "parent": "/e#21843.24", "id": "21871.0"}