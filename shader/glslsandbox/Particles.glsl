{"code": "\n    // This shader useds noise shaders by stegu -- http://webstaff.itn.liu.se/~stegu/\n    // This is supposed to look like snow falling, for example like http://24.media.tumblr.com/tumblr_mdhvqrK2EJ1rcru73o1_500.gif\n\t // for future starscroll/// Gtr\n#ifdef GL_ES\nprecision mediump float;\n#endif\n\nuniform float time;\nuniform vec2 mouse;\nuniform vec2 resolution;\n\n\n\t\tvec2 mod289(vec2 x) {\n\t\t  return x - floor(x * (1.0 / 289.0)) * 289.0;\n\t\t}\n\n\t\tvec3 mod289(vec3 x) {\n\t\t  \treturn x - floor(x * (1.0 / 289.0)) * 289.0;\n\t\t}\n\t\t\n\t\tvec4 mod289(vec4 x) {\n\t\t  \treturn x - floor(x * (1.0 / 289.0)) * 289.0;\n\t\t}\n\t\t\n\t\tvec3 permute(vec3 x) {\n\t\t  return mod289(((x*34.0)+1.0)*x);\n\t\t}\n\n\t\tvec4 permute(vec4 x) {\n\t\t  return mod((34.0 * x + 1.0) * x, 289.0);\n\t\t}\n\n\t\tvec4 taylorInvSqrt(vec4 r)\n\t\t{\n\t\t  \treturn 1.79284291400159 - 0.85373472095314 * r;\n\t\t}\n\t\t\n\t\tfloat snoise(vec2 v)\n\t\t{\n\t\t\t\tconst vec4 C = vec4(0.211324865405187,0.366025403784439,-0.577350269189626,0.024390243902439);\n\t\t\t\tvec2 i  = floor(v + dot(v, C.yy) );\n\t\t\t\tvec2 x0 = v -   i + dot(i, C.xx);\n\t\t\t\t\n\t\t\t\tvec2 i1;\n\t\t\t\ti1 = (x0.x > x0.y) ? vec2(1.0, 0.0) : vec2(0.0, 1.0);\n\t\t\t\tvec4 x12 = x0.xyxy + C.xxzz;\n\t\t\t\tx12.xy -= i1;\n\t\t\t\t\n\t\t\t\ti = mod289(i); // Avoid truncation effects in permutation\n\t\t\t\tvec3 p = permute( permute( i.y + vec3(0.0, i1.y, 1.0 ))\n\t\t\t\t\t+ i.x + vec3(0.0, i1.x, 1.0 ));\n\t\t\t\t\n\t\t\t\tvec3 m = max(0.5 - vec3(dot(x0,x0), dot(x12.xy,x12.xy), dot(x12.zw,x12.zw)), 0.0);\n\t\t\t\tm = m*m ;\n\t\t\t\tm = m*m ;\n\t\t\t\t\n\t\t\t\tvec3 x = 2.0 * fract(p * C.www) - 1.0;\n\t\t\t\tvec3 h = abs(x) - 0.5;\n\t\t\t\tvec3 ox = floor(x + 0.5);\n\t\t\t\tvec3 a0 = x - ox;\n\t\t\t\t\n\t\t\t\tm *= 1.79284291400159 - 0.85373472095314 * ( a0*a0 + h*h );\n\t\t\t\t\n\t\t\t\tvec3 g;\n\t\t\t\tg.x  = a0.x  * x0.x  + h.x  * x0.y;\n\t\t\t\tg.yz = a0.yz * x12.xz + h.yz * x12.yw;\n\n\t\t\t\treturn 130.0 * dot(m, g);\t\t\n\t\t}\n\t\t\n\t\tfloat cellular2x2(vec2 P)\n\t\t{\n\t\t\t\t#define K 0.142857142857 // 1/7\n\t\t\t\t#define K2 0.0714285714285 // K/2\n\t\t\t\t#define jitter 0.8 // jitter 1.0 makes F1 wrong more often\n\t\t\t\t\n\t\t\t\tvec2 Pi = mod(floor(P), 289.0);\n\t\t\t\tvec2 Pf = fract(P);\n\t\t\t\tvec4 Pfx = Pf.x + vec4(-0.5, -1.5, -0.5, -1.5);\n\t\t\t\tvec4 Pfy = Pf.y + vec4(-0.5, -0.5, -1.5, -1.5);\n\t\t\t\tvec4 p = permute(Pi.x + vec4(0.0, 1.0, 0.0, 1.0));\n\t\t\t\tp = permute(p + Pi.y + vec4(0.0, 0.0, 1.0, 1.0));\n\t\t\t\tvec4 ox = mod(p, 7.0)*K+K2;\n\t\t\t\tvec4 oy = mod(floor(p*K),7.0)*K+K2;\n\t\t\t\tvec4 dx = Pfx + jitter*ox;\n\t\t\t\tvec4 dy = Pfy + jitter*oy;\n\t\t\t\tvec4 d = dx * dx + dy * dy; // d11, d12, d21 and d22, squared\n\t\t\t\t// Sort out the two smallest distances\n\t\t\t\t\n\t\t\t\t// Cheat and pick only F1\n\t\t\t\td.xy = min(d.xy, d.zw);\n\t\t\t\td.x = min(d.x, d.y);\n\t\t\t\treturn d.x; // F1 duplicated, F2 not computed\n\t\t}\n\n\t\tfloat fbm(vec2 p) {\n \t\t   float f = 0.0;\n    \t\tfloat w = 0.5;\n    \t\tfor (int i = 0; i < 5; i ++) {\n\t\t\t\t\t\tf += w * snoise(p);\n\t\t\t\t\t\tp *= 2.;\n\t\t\t\t\t\tw *= 0.5;\n    \t\t}\n    \t\treturn f;\n\t\t}\n\n\t\tvoid main()\n\t\t{\n\t\t\t\tfloat speed=1.0;\n\t\t\t\t\n\t\t\t\tvec2 uv = gl_FragCoord.xy / resolution.xy;\n\t\t\t\t\n\t\t\t\tuv.x*=(resolution.x/resolution.y);\n\t\t\t\t\n\t\t\t\tvec2 suncent=vec2(0.3,0.9);\n\t\t\t\t\n\t\t\t\tfloat suns=(1.0-distance(uv,suncent));\n\t\t\t\tsuns=clamp(0.0+suns,0.0,1.0);\n\t\t\t\tfloat sunsh=smoothstep(0.85,0.95,suns);\n\n\t\t\t\tfloat slope;\n\t\t\t\tslope=0.8+uv.x-(uv.y*5.3);\n\t\t\t\tslope=1.0-smoothstep(0.55,0.0,slope);\t\t\t\t\t\t\t\t\n\t\t\t\t\n\t\t\t\tfloat noise=abs(fbm(uv));\n\t\t\t\tslope=(noise*0.4)+(slope-((1.0-noise)*slope*0.1))*0.6;\n\t\t\t\tslope=clamp(slope,0.0,1.0);\n\t\t\t\t\t\t\t\t\t\t\n\t\t\t\tvec2 GA = vec2(0.);\n\t\t\t\tGA.x-=time*1.0;\n\t\t\t\tGA.y+=time*0.0;\n\t\t\t\tGA*=speed;\n\t\t\t\n\t\t\t\tfloat F1=0.0,F2=0.0,F3=0.0,F4=0.0,F5=0.0,N1=0.0,N2=0.0,N3=0.0,N4=0.0,N5=0.0;\n\t\t\t\tfloat A=0.0,A1=0.0,A2=0.0,A3=0.0,A4=0.0,A5=0.0;\n\n\n\t\t\t\t// Attentuation\n\t\t\t\tA = (uv.x-(uv.y*2.0));\n\t\t\t\tA = clamp(A,0.0,1.0);\n\n\t\t\t\t// Snow layers, somewhat like an fbm with worley layers.\n\t\t\t\tF1 = 1.0-cellular2x2((uv+(GA*0.1))*8.0);\t\n\t\t\t\tA1 = 1.0-(A*1.0);\n\t\t\t\tN1 = smoothstep(0.998,1.0,F1)*1.0*A1;\t\n\n\t\t\t\tF2 = 1.0-cellular2x2((uv+(GA*0.2))*6.0);\t\n\t\t\t\tA2 = 1.0-(A*0.8);\n\t\t\t\tN2 = smoothstep(0.995,1.0,F2)*0.85*A2;\t\t\t\t\n\n\t\t\t\tF3 = 1.0-cellular2x2((uv+(GA*0.4))*4.0);\t\n\t\t\t\tA3 = 1.0-(A*0.6);\n\t\t\t\tN3 = smoothstep(0.99,1.0,F3)*0.65*A3;\t\t\t\t\n\n\t\t\t\tF4 = 1.0-cellular2x2((uv+(GA*0.6))*3.0);\t\n\t\t\t\tA4 = 1.0-(A*1.0);\n\t\t\t\tN4 = smoothstep(0.98,1.0,F4)*0.4*A4;\t\t\t\t\n\n\t\t\t\tF5 = 1.0-cellular2x2((uv+(GA))*1.2);\t\n\t\t\t\tA5 = 1.0-(A*1.0);\n\t\t\t\tN5 = smoothstep(0.98,1.0,F5)*0.25*A5;\t\t\t\t\n\t\t\t\t\t\t\t\t\n\t\t\t\tfloat Snowout=N5+N4+N3+N2+N1;\n\t\t\t\t\t\t\t\t\n\t\t\t\tSnowout = 0.01+(slope*(suns+0.0))+(sunsh*0.1)+N1+N2+N3+N4+N5;\n\t\t\t\t\n\t\t\t\tgl_FragColor = vec4(Snowout*0.9, Snowout, Snowout*1.1, 1.0);\n\n\t\t}", "user": "922a76c", "parent": null, "id": "25466.1"}