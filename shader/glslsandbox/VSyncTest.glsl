{"code": "/* https://www.shadertoy.com/view/Xd3BWr */\n\n#ifdef GL_ES\nprecision mediump float;\n#endif\n\nuniform float time;\nuniform vec2 resolution;\n\nvoid main( void ) {\n    vec2 uv = gl_FragCoord.xy / resolution.xy;\n\n    float c = uv.x * 2.0 + time*2.0;\n    c = mod(c, 1.0);\n    float d = 0.01;\n    c = smoothstep(0.5 - d, 0.5 + d, c);\n\n    gl_FragColor = vec4(c);\n}", "user": "ac536ac", "parent": null, "id": "46639.0"}