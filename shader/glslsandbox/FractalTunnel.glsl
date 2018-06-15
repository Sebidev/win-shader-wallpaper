{"code": "#ifdef GL_ES\nprecision mediump float;\n#endif\n\nuniform float time;\nuniform vec2 resolution;\nuniform sampler2D tx;\nvoid main( void ) {\n\tvec2 uv = gl_FragCoord.xy / resolution.xy;\n\tvec2 p = ( uv ) * 2.0 - 1.0;\n\tp.x *= resolution.x / resolution.y;\n\tfloat strobe = .95 + .05* sin(time*100.);\n\tfloat fade = sin(time) * 2. + 2.;\n\tconst float ITER = 100.0;\n\tfloat c = 0.0;\t\n\tfor(float i = 0.0; i < ITER; i++)\n\t{\n\t\tc += smoothstep(0.15, 0.0, length(p*vec2(sin(p.x*i+time*1.5), cos(p.y*i))));\t\n\t}\n\tc/= ITER;\n\tc*= strobe * clamp( fade, .25, 1. );\n\tgl_FragColor = vec4( pow(vec3( c ), vec3(1.35,1.05,0.8))*5.0, 1.0 );\n}", "user": "aefc2ec", "parent": "/e#26771.1", "id": "26776.0"}