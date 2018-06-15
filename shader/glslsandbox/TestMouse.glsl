{"code": "#ifdef GL_ES\nprecision mediump float;\n#endif\n\nuniform vec2 mouse;\nuniform vec2 resolution;\n\nvoid main( void ) {\n    vec2 mouse_coord = mouse.xy * resolution.xy;\n    vec2 m = mouse_coord - gl_FragCoord.xy;\n    if (m.x >= -0.5 && m.x < 0.5 && m.y >=-0.5 && m.y < 0.5)\n        gl_FragColor = vec4(1.);\n    else\n        gl_FragColor = vec4(vec3(0.), 1.);\n}", "user": "44e4354", "parent": null, "id": "46876.1"}