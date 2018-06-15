{"code": "//from https://www.shadertoy.com/view/4tfGRr\n/////MAYRQ\n\n\n\n\n#ifdef GL_ES\nprecision highp float;\n#endif\n\nuniform float time;\nuniform vec2  mouse;\nuniform vec2  resolution;\n\n// License Creative Commons Attribution-NonCommercial-ShareAlike 3.0 Unported License.\n\n\n\n\nvec2 cmul( vec2 a, vec2 b )  { return vec2( a.x*b.x - a.y*b.y, a.x*b.y + a.y*b.x ); }\nvec2 csqr( vec2 a )  { return vec2( a.x*a.x - a.y*a.y, 2.*a.x*a.y  ); }\n\nvec3 dmul( vec3 a, vec3 b )  {\n    float r = length(a);\n    \n    b.xy=cmul(normalize(a.xy), b.xy);\n    b.yz=cmul(normalize(a.yz), b.yz);\n   // b.xz=cmul(normalize(a.xz), b.xz);\n\t\n    return r*b;\n}\n\n\nvec3 pow4( vec3 z){\n\tz=dmul(z,z);return dmul(z,z);\n}\n\nvec3 pow3( vec3 z){\n    float r2 = dot(z,z);\n    vec2 a = z.xy;a=csqr(a)/dot( a,a);\n    vec2 b = z.yz;b=csqr(b)/dot( b,b); \n    vec2 c = z.xz;c=csqr(c)/dot( c,c);\n    z.xy = cmul(a,z.xy);   \n    z.yz = cmul(b,z.yz);      \n    z.xz = cmul(c,z.xz);\n    return r2*z;\n}\n\nmat2 rot(float a) {\n\treturn mat2(cos(a),sin(a),-sin(a),cos(a));\t\n}\n\nfloat zoom=4.;\n\n\n\nfloat field(in vec3 p) {\n\t\n\tfloat res = 0.;\n\t\n    vec3 c = p;\n\tfor (int i = 0; i < 10; ++i) {\n\t\t\n        p = abs(p) / dot(p,p) -1.;\n        p = dmul(p,p)+.7;\n\t\tres += exp(-6. * abs(dot(p,c)-.15));\n\t\t\n\t}\n\treturn max(0., res/3.);\n}\n\n\n\nvec3 raycast( in vec3 ro, vec3 rd )\n{\n    float t = 6.0;\n    float dt = .05;\n    vec3 col= vec3(0.);\n    for( int i=0; i<64; i++ )\n\t{\n        \n        float c = field(ro+t*rd);               \n        t+=dt/(.35+c*c);\n        c = max(5.0 * c - .9, 0.0);\n        col = .97*col+ .08*vec3(0.5*c*c*c, .6*c*c, c);\n\t\t\n    }\n    \n    return col;\n}\n\n\nvoid main(void)\n{\n\tfloat time = time;\n    vec2 q = gl_FragCoord.xy / resolution.xy;\n    vec2 p = -1.0 + 2.0 * q;\n    p.x *= resolution.x/resolution.y;\n    vec2 m = vec2(0.);\n//\tif( mouse.y>0.0 )\n//    m = mouse.xy/resolution.xy*3.14;\n//    m-=.5;\n\n    // camera\n\n    vec3 ro = zoom*vec3(2.);\n    ro.yz*=rot(m.y+0.4*time);\n    ro.xz*=rot(m.x+ 0.4*time);\n//    vec3 ro = vec3(-0.5 + 3.2*cos(0.1*time + 6.0*mouse.x), 1.0 + 2.0*mouse.y, 0.5 + 3.2*sin(0.1*time + 6.0*mouse.x));\n    vec3 ta = vec3( 0.0 , 0.0, 0.0 );\n    vec3 ww = normalize( ta - ro );\n    vec3 uu = normalize( cross(ww,vec3(0.0,1.0,0.0) ) );\n    vec3 vv = normalize( cross(uu,ww));\n    vec3 rd = normalize( p.x*uu + p.y*vv + 4.0*ww );\n    \n\n\t// raymarch\n    vec3 col = raycast(ro,rd);\n    \n\t\n\t// shade\n    \n    col =  .5 *(log(1.+col));\n    col = clamp(col,0.,1.);\n    gl_FragColor = vec4( sqrt(col), 1.0 );\n\n}\n", "user": "3dca6a4", "parent": "/e#22294.0", "id": "22497.0"}