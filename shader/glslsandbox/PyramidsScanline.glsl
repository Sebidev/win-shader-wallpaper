{"code": "//frorked by T_S / RTX1911\n#ifdef GL_ES\nprecision mediump float;\n#endif\n\nuniform float time;\nuniform vec2 mouse;\nuniform vec2 resolution;\n\n#define EPSM  0.9999\n\n//iq's tools.\nfloat hash( float n )\n{\n    return fract(sin(n)*43758.5453123);\n}\n\nvec4 tv(vec4 col, vec2 pos)\n{\t\n\tfloat speed = 0.0;\n\t\n\tvec4 tmp;\n\t\n\t// vibrating rgb-separated scanlines\n\ttmp.r = sin(( pos.y + 0.0002 + sin(time * 64.0) * 0.0002 ) * resolution.y * 2.0 + time * speed);\n\ttmp.g = sin(( pos.y + 0.0004 - sin(time * 70.0) * 0.0002 ) * resolution.y * 2.0 + time * speed);\n\ttmp.b = sin(( pos.y + 0.0006 + sin(time * 90.0) * 0.0002 ) * resolution.y * 2.0 + time * speed);\n\n\t// normalize tmp\n\ttmp = clamp(tmp, 0.75, 1.0);\n\t\n\t// accumulate\n\tcol *= tmp;\n\t\n\t// grain\n\tfloat grain = hash( ( pos.x + hash(pos.y) ) * time ) * 0.15;\n\tcol += grain;\n\t\n\t// flicker\n\tfloat flicker = ( sin(hash(time)) + 0.5 ) * 0.075;\n\tcol += flicker;\n\t\n\t// vignette\n\tvec2 t = 1.0 * ( pos);\n\t\n\tt *= t;\n\t\n\tfloat d = 1.0 - clamp( length( t ), 0.0, 1.0 );\n\t\n\tcol *= d;\n\t\n\treturn col;\n}\n\n\nfloat hexp( vec2 p, vec2 h )\n{\n    vec2 q = abs(p);\n    return max(q.x-h.y,max(q.x+q.y*0.57735,q.y*1.1547)-h.x);\n}\n\nfloat plane(vec3 p, float D) {\n\treturn D - dot(abs(p), normalize(vec3(0.0, 1.0, 0.0)));\n}\n\nvec2 rot(vec2 p, float a) {\n\treturn vec2(\n\t\tcos(a) * p.x - sin(a) * p.y,\n\t\tsin(a) * p.x + cos(a) * p.y);\n}\n\nvec3 map(vec3 p) {\n\tvec3 pp = p;\n\t\n\t//ground\n\tfloat k = plane(pp, 0.7);\n\t\n\t//PYRAMID\n\tpp = mod(-abs(p), 1.0) - 0.5;\n\t\n\tfloat tim = time * 2.0 + sin(time * 1.14) * 4.0;\n\tfor(int e = 0 ; e < 6; e++) {\n\t\t//rotate\n\t\tif( floor(float(e) / 2.0) > 0.0 ) tim = -tim;\n\t\tvec3 ppp = pp;\n\t\t\n\t\t//get fake unique angle.\n\t\tppp.xz = rot(ppp.xz, tim * 0.3 + ceil(p.z) / (1.5));\n\t\tk = min(k, max(ppp.y - 0.08 * float(e), hexp(ppp.xz, vec2(0.48 - 0.08 * float(e)))) );\n\t}\n\treturn vec3(pp.xz, k);\n}\n\t\nvoid main( void ) {\n\tvec2 uv    = -1.0 + 2.0 * ( gl_FragCoord.xy / resolution.xy );\n\t\n\t//ray\n\tvec3 dir   = normalize(vec3(uv * vec2(resolution.x / resolution.y, 1.0), 1.0)).xyz;\n\t\n\t//rotate\n\tdir.xz = rot(dir.xz, cos(time * 0.25) * 0.5);\n\tdir.yz = rot(dir.yz, sin(time * 0.25) * 0.25);\n\t//dir.xy = rot(dir.xy, time * 0.005);\n\t\n\t//camera \n\tvec3 pos   = vec3(0.0);\n\tpos.x\t   = mouse.x -0.5;\n\tpos.y\t   = mouse.y * 0.25 - 0.125;\n\tpos.z     += time * 0.5;\n\tpos.x     += sin(time * 0.5) * 0.125;\n\t\n\t//col\n\tvec3  col  = vec3(0.0);\n\tfloat t    = 0.01;\n\n\t//raymarching\n\tvec3  gm   = vec3(0.0);\n\tfor(int i  = 0 ; i < 64; i++) {\n\t\tgm = map(pos + dir * t * EPSM);\n\t\tt += gm.z;\n\t}\n\tvec3  IP   = pos + dir * t;\n\t\n\t//fake shadow and fake ao : http://pouet.net/topic.php?which=7535&page=1\n\tvec3  L    = vec3(-0.5, 1.2, -0.7); //norm...\n\tfloat Sef  = 0.05;\n\tfloat S1   = max(map(IP + Sef * L).z, 0.005);\n\tcol        = max(vec3(S1), 0.0);\n\t\n\t//sun\n\tvec3 sun   = mix(vec3(1, 2, 3), vec3(1, 2, 3).zyx, t * 0.5) * 0.04;\n\tcol        = sqrt(col) + dir.zxy * 0.005+ t * 0.05 + sun;\n\tvec4 fcol  = vec4(col.gbr, 1.0);\n\tfcol = tv(fcol, uv);\n\tgl_FragColor = fcol;\n\tgl_FragColor *= mod(gl_FragCoord.y, 2.0);\n}", "user": "d0929c6", "parent": null, "id": "9483.3"}