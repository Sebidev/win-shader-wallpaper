{"code": "/*\n * Original shader from: https://www.shadertoy.com/view/Xsd3RH\n */\n\n#ifdef GL_ES\nprecision mediump float;\n#endif\n\n// glslsandbox uniforms\nuniform float time;\nuniform vec2 resolution;\n\n// shadertoy globals\nfloat iTime;\nvec3  iResolution;\n\n// Protect glslsandbox uniform names\n#define time        stemu_time\n#define resolution  stemu_resolution\n\n// --------[ Original ShaderToy begins here ]---------- //\n// Created by randy read - rcread/2015\n// License Creative Commons Attribution-NonCommercial-ShareAlike 3.0 Unported License.\n\n#define N normalize\n\nfloat min3( vec3 a ) { return min( a.x, min( a.y, a.z ) ); }\nfloat max3( vec3 a ) { return max( a.x, max( a.y, a.z ) ); }\n\nvec3 make_rd( vec2 p, vec3 c ) {\n    vec2 r = iResolution.xy;\n    vec3 b = vec3( 0, 1, 0 ), a = cross( b, c );\n    p = ( p - r / 2. ) / r;\n    b = cross( a, c );\n    return N( p.x * a + p.y * b + c );\n}\n\nvoid mainImage( out vec4 o, vec2 i )\n{\n\tfloat ti = iTime, c = .96;\n\tvec3 t, ip, \n        cl = vec3( 1 ), \n        ro = 11. * vec3( sin( ti * ( .1 + cos( ti / 1e6 ) / 4. ) ), sin( ti * .2 ), cos( ti * .5 ) ), \n        rd = make_rd( i, N( -ro ) );\n\n\tt = ( c - ro ) / rd;\n\tfor ( int i = 0 ; i < 3 ; i++ ) {\n\t\tif ( t[i] >= 0. ) {\n\t\t\tip = abs( ro + rd * t[i] );\n\t\t\tif ( max3( ip ) <= 4. * c ) {\n\t\t\t\tip[i] = 1.;\n\t\t\t\tcl[i] = 1. - min3( ip );\n\t\t\t}\n\t\t}\n\t}\n\to.rgb = smoothstep( .04, 0., cl );\n    //*\n    float d = max3( o.rgb );\n    o.rgb = vec3( o.r + o.g, o.r + o.b, o.g + o.b );\n    o.rgb = o.rgb * d / max3( o.rgb );\n\t//*/\n}\n// --------[ Original ShaderToy ends here ]---------- //\n\n#undef time\n#undef resolution\n\nvoid main(void)\n{\n  iTime = time;\n  iResolution = vec3(resolution, 0.0);\n\n  mainImage(gl_FragColor, gl_FragCoord.xy);\n  gl_FragColor.a = 1.0;\n}", "user": "9b3e4f8", "parent": null, "id": "45485.0"}