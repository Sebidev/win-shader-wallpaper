{"code": "/*\n * Original shader from: https://www.shadertoy.com/view/MsGczV\n */\n\n#ifdef GL_ES\nprecision mediump float;\n#endif\n\n// glslsandbox uniforms\nuniform float time;\nuniform vec2 resolution;\n\n// shadertoy globals\nfloat iTime;\nvec3  iResolution;\n\n// --------[ Original ShaderToy begins here ]---------- //\n\n// Inspired by:\n//  http://cmdrkitten.tumblr.com/post/172173936860\n\n\n#define Pi 3.14159265359\n\nstruct Gear\n{\n    float t;\t\t\t// Time\n    float gearR;\t\t// Gear radius\n    float teethH;\t\t// Teeth height\n    float teethR;\t\t// Teeth \"roundness\"\n    float teethCount;\t// Teeth count\n    float diskR;\t\t// Inner or outer border radius\n    vec3 color;\t\t\t// Color\n};\n\n    \n    \nfloat GearFunction(vec2 uv, Gear g)\n{\n    float r = length(uv);\n    float a = atan(uv.y, uv.x);\n    \n    // Gear polar function:\n    //  A sine squashed by a logistic function gives a convincing\n    //  gear shape!\n    float p = g.gearR-0.5*g.teethH + \n              g.teethH/(1.0+exp(g.teethR*sin(g.t + g.teethCount*a)));\n\n    float gear = r - p;\n    float disk = r - g.diskR;\n    \n    return g.gearR > g.diskR ? max(-disk, gear) : max(disk, -gear);\n}\n\n\nfloat GearDe(vec2 uv, Gear g)\n{\n    // IQ's f/|Grad(f)| distance estimator:\n    float f = GearFunction(uv, g);\n    vec2 eps = vec2(0.0001, 0);\n    vec2 grad = vec2(\n        GearFunction(uv + eps.xy, g) - GearFunction(uv - eps.xy, g),\n        GearFunction(uv + eps.yx, g) - GearFunction(uv - eps.yx, g)) / (2.0*eps.x);\n    \n    return (f)/length(grad);\n}\n\n\n\nfloat GearShadow(vec2 uv, Gear g)\n{\n    float r = length(uv+vec2(0.1));\n    float de = r - g.diskR + 0.0*(g.diskR - g.gearR);\n    float eps = 0.4*g.diskR;\n    return smoothstep(eps, 0., abs(de));\n}\n\n\nvoid DrawGear(inout vec3 color, vec2 uv, Gear g, float eps)\n{\n\tfloat d = smoothstep(eps, -eps, GearDe(uv, g));\n    float s = 1.0 - 0.7*GearShadow(uv, g);\n    color = mix(s*color, g.color, d);\n}\n\n\n\n\n\nvoid mainImage( out vec4 fragColor, in vec2 fragCoord )\n{\n    float t = 0.5*iTime;\n    vec2 uv = 2.0*(fragCoord - 0.5*iResolution.xy)/iResolution.y;\n    float eps = 2.0/iResolution.y;\n\n    // Scene parameters;\n\tvec3 base = vec3(0.95, 0.7, 0.2);\n    const float count = 8.0;\n\n    Gear outer = Gear(0.0, 0.8, 0.08, 4.0, 32.0, 0.9, base);\n    Gear inner = Gear(0.0, 0.4, 0.08, 4.0, 16.0, 0.3, base);\n    \n    \n    // Draw inner gears back to front:\n    vec3 color = vec3(0.0);\n    for(float i=0.0; i<count; i++)\n    {\n        t += 2.0*Pi/count;\n \t    inner.t = 16.0*t;\n        inner.color = base*(0.35 + 0.6*i/(count-1.0));\n        DrawGear(color, uv+0.4*vec2(cos(t),sin(t)), inner, eps);\n    }\n    \n    // Draw outer gear:\n    DrawGear(color, uv, outer, eps);\n    \n    \n    fragColor = vec4(color,1.0);\n}\n// --------[ Original ShaderToy ends here ]---------- //\n\nvoid main(void)\n{\n    iTime = time;\n    iResolution = vec3(resolution, 0.0);\n\n    mainImage(gl_FragColor, gl_FragCoord.xy);\n}", "user": "aa44711", "parent": null, "id": "46200.0"}