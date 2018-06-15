{"code": "// @lsdlive\n\n// This was my shader for the shader showdown at Outline demoparty 2018 in Nederland.\n// Shader showdown is a live-coding competition where two participants are\n// facing each other during 25 minutes.\n// (Round 1)\n\n// I don't have access to the code I typed at the event, so it might be\n// slightly different.\n\n// Original algorithm on shadertoy from fb39ca4: https://www.shadertoy.com/view/4dX3zl\n// I used the implementation from shane: https://www.shadertoy.com/view/MdVSDh\n\n// Thanks to shadertoy community & shader showdown paris.\n\n// This is under CC-BY-NC-SA (shadertoy default licence)\n\n#ifdef GL_ES\nprecision mediump float;\n#endif\n\nuniform float time;\nuniform vec2 mouse;\nuniform vec2 resolution;\n\n\n#define iTime time\n\nmat2 r2d(float a) {\n\tfloat c = cos(a), s = sin(a);\n\treturn mat2(c, s, -s, c);\n}\n\nvec2 path(float t) {\n\tfloat a = sin(t*.2 + 1.5), b = sin(t*.2);\n\treturn vec2(2.*a, a*b);\n}\n\nfloat g = 0.;\nfloat de(vec3 p) {\n\tp.xy -= path(p.z);\n\n\tfloat d = -length(p.xy) + 4.;// tunnel (inverted cylinder)\n\n\tp.xy += vec2(cos(p.z + iTime)*sin(iTime), cos(p.z + iTime));\n\tp.z -= 6. + iTime * 6.;\n\td = min(d, dot(p, normalize(sign(p))) - 1.); // octahedron (LJ's formula)\n\t// I added this in the last 1-2 minutes, but I'm not sure if I like it actually!\n\n\t// Trick inspired by balkhan's shadertoys.\n\t// Usually, in raymarch shaders it gives a glow effect,\n\t// here, it gives a colors patchwork & transparent voxels effects.\n\tg += .015 / (.01 + d * d);\n\treturn d;\n}\n\nvoid main()\n{\n\tvec2 uv = gl_FragCoord.xy / resolution.xy - .5;\n\tuv.x *= resolution.x / resolution.y;\n\n\tfloat dt = time * 6.;\n\tvec3 ro = vec3(0, 0, -5. + dt);\n\tvec3 ta = vec3(0, 0, dt);\n\n\tro.xy += path(ro.z);\n\tta.xy += path(ta.z);\n\n\tvec3 fwd = normalize(ta - ro);\n\tvec3 right = cross(fwd, vec3(0, 1, 0));\n\tvec3 up = cross(right, fwd);\n\tvec3 rd = normalize(fwd + uv.x*right + uv.y*up);\n\n\trd.xy *= r2d(sin(-ro.x / 3.14)*.3);\n\n\t// Raycast in 3d to get voxels.\n\t// Algorithm fully explained here in 2D (just look at dde algo):\n\t// http://lodev.org/cgtutor/raycasting.html\n\t// Basically, tracing a ray in a 3d grid space, and looking for \n\t// each voxel (think pixel with a third dimension) traversed by the ray.\n\tvec3 p = floor(ro) + .5;\n\tvec3 mask;\n\tvec3 drd = 1. / abs(rd);\n\trd = sign(rd);\n\tvec3 side = drd * (rd * (p - ro) + .5);\n\n\tfloat t = 0., ri = 0.;\n\tfor (float i = 0.; i < 1.; i += .01) {\n\t\tri = i;\n\n\t\t/*\n\t\t// sphere tracing algorithm (for comparison)\n\t\tp = ro + rd * t;\n\t\tfloat d = de(p);\n\t\tif(d<.001) break;\n\t\tt += d;\n\t\t*/\n\n\t\tif (de(p) < 0.) break;// distance field\n\t\t\t\t\t\t\t  // we test if we are inside the surface\n\n\t\tmask = step(side, side.yzx) * step(side, side.zxy);\n\t\t// minimum value between x,y,z, output 0 or 1\n\n\t\tside += drd * mask;\n\t\tp += rd * mask;\n\t}\n\tt = length(p - ro);\n\n\tvec3 c = vec3(1) * length(mask * vec3(1., .5, .75));\n\tc = mix(vec3(.2, .2, .7), vec3(.2, .1, .2), c);\n\tc += g * .4;\n\tc.r += sin(time)*.2 + sin(p.z*.5 - time * 6.);// red rings\n\tc = mix(c, vec3(.2, .1, .2), 1. - exp(-.001*t*t));// fog\n\n\tgl_FragColor = vec4(c, 1.0);\n\n}", "user": "8345255", "parent": null, "id": "47053.1"}