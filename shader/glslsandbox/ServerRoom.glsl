{"code": "/*\n * Original shader from: https://www.shadertoy.com/view/MdySzc\n */\n\n#ifdef GL_ES\nprecision mediump float;\n#endif\n\n// glslsandbox uniforms\nuniform float time;\nuniform vec2 resolution;\n\n// shadertoy globals\nfloat iTime;\nvec3  iResolution;\n\n// --------[ Original ShaderToy begins here ]---------- //\nconst float tmax = 20.0;\n\nfloat hash(float n) {\n\treturn fract(sin(n)*43758.5453);\n}\n\nvec3 hash(vec3 p){ \n    \n    float n = sin(dot(p, vec3(7, 157, 113)));    \n    return fract(vec3(2097152, 262144, 32768)*n); \n}\n\nfloat noise(float g) {\n\tfloat p = floor(g);\n\tfloat f = fract(g);\n\n\treturn mix(hash(p), hash(p + 1.0), f);\n}\n\nfloat voronoi(vec3 x) {\n\tvec3 p = floor(x);\n\tvec3 f = fract(x);\n\n\tvec2 res = vec2(8.0);\n\n\tfor(int i = -1; i <= 1; i++)\n\tfor(int j = -1; j <= 1; j++)\n\tfor(int k = -1; k <= 1; k++) {\n\t\tvec3 g = vec3(float(i), float(j), float(k));\n\t\tvec3 r = g + hash(p + g) - f;\n\n\t\tfloat d = max(abs(r.x), max(abs(r.y), abs(r.z)));\n\n\t\tif(d < res.x) {\n\t\t\tres.y = res.x;\n\t\t\tres.x = d;\n\t\t} else if(d < res.y) {\n\t\t\tres.y = d;\n\t\t}\n\t}\n\n\treturn res.y - res.x;\n}\n\nvec2 path(float z) {\n\treturn vec2(cos(z/8.0)*sin(z/12.0)*12.0, 0.0);\n}\n\nfloat map(vec3 p) {\n\tvec4 q = vec4(p, 1.0);\n\tq.x += 1.0;\n\n\tfor(int i = 0; i < 6; i++) {\n\t\tq.xyz = -1.0 + 2.0*fract(0.5 + 0.5*q.xyz);\n\t\tq = 1.2*q/max(dot(q.xyz, q.xyz), 0.1);\n\t}\n\n\tvec2 tun = abs(p.xy - path(p.z))*vec2(0.6, 0.5);\n\n\treturn min(0.25*abs(q.y)/q.w, 1.0 - max(tun.x, tun.y));\n}\n\nfloat march(vec3 ro, vec3 rd, float mx) {\n\tfloat t = 0.0;\n\n\tfor(int i = 0; i < 200; i++) {\n\t\tfloat d = map(ro + rd*t);\n\t\tif(d < 0.001 || t >= mx) break;\n\t\tt += d*0.75;\n\t}\n\n\treturn t;\n}\n\nvec3 normal(vec3 p) {\n\tvec2 h = vec2(0.001, 0.0);\n\tvec3 n = vec3(\n\t\tmap(p + h.xyy) - map(p - h.xyy),\n\t\tmap(p + h.yxy) - map(p - h.yxy),\n\t\tmap(p + h.yyx) - map(p - h.yyx)\n\t);\n\treturn normalize(n);\n}\n\nfloat ao(vec3 p, vec3 n) {\n    float o = 0.0, s = 0.005;\n    for(int i = 0; i< 15; i++) {\n        float d = map(p + n*s);\n        o += (s - d);\n        s += s/float(i + 1);\n    }\n    \n    return 1.0 - clamp(o, 0.0, 1.0);\n}\n\nvec3 material(vec3 p) {\n\tfloat v = 0.0;\n\tfloat a = 0.7, f = 1.0;\n\n\tfor(int i = 0; i < 4; i++) {\n\t\tfloat v1 = voronoi(p*f + 5.0);\n\t\tfloat v2 = 0.0;\n\n\t\tif(i > 0) {\n\t\t\tv2 = voronoi(p*f*0.1 + 50.0 + 0.15*iTime);\n\n\t\t\tfloat va = 0.0, vb = 0.0;\n\t\t\tva = 1.0 - smoothstep(0.0, 0.1, v1);\n\t\t\tvb = 1.0 - smoothstep(0.0, 0.08, v2);\n\t\t\tv += a*pow(va*(0.5 + vb), 4.0);\n\t\t}\n\n\t\tv1 = 1.0 - smoothstep(0.0, 0.3, v1);\n\t\tv2 =  a*noise(v1*5.5 + 0.1);\n\n\t\tv += v2;\n\n\t\tf *= 3.0;\n\t\ta *= 0.5;\n\t}\n\n\treturn vec3(pow(v, 6.0), pow(v, 4.0), pow(v, 2.0))*2.0;\n}\n\nmat3 camera(vec3 eye, vec3 lat) {\n\tvec3 ww = normalize(lat - eye);\n\tvec3 uu = normalize(cross(vec3(0, 1, 0), ww));\n\tvec3 vv = normalize(cross(ww, uu));\n\n\treturn mat3(uu, vv, ww);\n}\n\nvoid mainImage( out vec4 fragColor, in vec2 fragCoord ) {\n\tvec2 uv = -1.0 + 2.0*(fragCoord.xy/iResolution.xy);\n\tuv.x *= iResolution.x/iResolution.y;\n\n\tvec3 col = vec3(0);\n\n\tvec3 ro = vec3(0.63*cos(iTime*0.1), 0.67, iTime*0.5);\n\tvec3 la = ro + vec3(0, 0, 0.3);\n\n\tro.xy += path(ro.z);\n\tla.xy += path(la.z);\n\tvec3 rd = normalize(camera(ro, la)*vec3(uv, 1.97));\n\n\tfloat i = march(ro, rd, tmax);\n\tif(i < tmax) {\n\t\tvec3 pos = ro + rd*i;\n\t\tvec3 nor = normal(pos);\n\t\tvec3 ref = normalize(reflect(rd, nor));\n        \n        float occ = ao(pos, nor);\n        \n\t\tcol = material(pos)*occ;\n        col += 2.0*pow(clamp(dot(-rd, ref), 0.0, 1.0), 16.0)*occ;\n\t}\n\n\tcol = mix(col, vec3(0), 1.0 - exp(-0.5*i));\n    \n    col = 1.0 - exp(-0.5*col);\n    col = pow(abs(col), vec3(1.0/2.2));\n\n\tfragColor = vec4(col, 1);\n}\n// --------[ Original ShaderToy ends here ]---------- //\n\nvoid main(void)\n{\n  iTime = time;\n  iResolution = vec3(resolution, 0.0);\n\n  mainImage(gl_FragColor, gl_FragCoord.xy);\n}\n", "user": "c15437", "parent": null, "id": "46562.0"}