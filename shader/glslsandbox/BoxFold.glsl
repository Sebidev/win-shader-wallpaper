{"code": "#ifdef GL_ES\nprecision highp float;\n#endif\n\nuniform float time;\nuniform vec2 mouse;\nuniform vec2 resolution;\n\n\n// License Creative Commons Attribution-NonCommercial-ShareAlike 3.0 Unported License.\n\n\n\n//Triplex inversion\nvec3 tinv(vec3 p) \n{\nreturn vec3(p.x,-p.yz)/dot(p,p);\n}\n\n\n\n\nvec4 ot; \nfloat g=.60;\nvec3 CSize = vec3(1.28);\nvec3 C1 = vec3(1.0);\nvec3 C =  vec3(1.0);\nconst int MaxIter = 10;\nfloat zoom=1.0;\n\nfloat map( vec3 p )\n{\n\tfloat dr = 1.0;\n\tp=p.yxz;\n\tot = vec4(1000.0); \n    C=p*.45;\n\n\tfor( int i=0; i<MaxIter;i++ )\n\t{\n        \n        //BoxFold\n       \n        p = clamp(p,-CSize,  CSize) * 2.0 - p;\n       \n        float r2 = dot(p,p);\n        if(r2>100.)continue;\n\t\t\n        ot = min( ot, vec4(abs(p),r2) );\n\n\t\t//Scaling, triplex inversion and translation \n          \n            \n\t\tdr= dr/r2/g;            \n\t\tp = tinv(g*(p))+C;\n\t}\t\n\treturn .16*abs(p.x)/dr;  //Try this\n\treturn .2*length(p)/dr*log(length(p));\n\t\n}\n\nfloat trace( in vec3 ro, in vec3 rd )\n{\n\tfloat maxd = 4.;\n\tfloat precis = 0.001;\n      \n    float h=precis*2.0;\n    float t = 0.0;\n    for( int i=0; i<200; i++ )\n    {\n\tif( t>maxd ||  h<precis*(.1+t)) continue;//break;//        \n        \n        t += h;\n\t\th = map( ro+rd*t );\n    }\n\n   \tif( t>maxd ) t=-1.0;\n    return t;\n}\n\nvec3 calcNormal( in vec3 pos )\n{\n\tvec3  eps = vec3(.0001,0.0,0.0);\n\tvec3 nor;\n\tnor.x = map(pos+eps.xyy) - map(pos-eps.xyy);\n\tnor.y = map(pos+eps.yxy) - map(pos-eps.yxy);\n\tnor.z = map(pos+eps.yyx) - map(pos-eps.yyx);\n\treturn normalize(nor);\n}\n\nvoid main(void)\n{\n\tfloat igt = 1.2425*time;\n\tvec4   iMouse = vec4(mouse, 0.0, 1.0);\n\tvec2 p = -1.0 + 2.0*gl_FragCoord.xy / resolution;\n        p.x *= resolution.x/resolution.y;\n\n\t\n\tvec2 m = vec2(-.5)*6.28;\n\tif( iMouse.z>0.0 )m = (iMouse.xy/resolution-.5)*6.28;\n\tm+=.5*vec2(cos(0.15*igt),cos(0.09*igt))+.3;      \n\t\n    // camera\n\n\n\tvec3 ta = vec3(0.,.5+.2*sin(0.12*igt),0.);\n\tvec3 ro = ta- .9*zoom*vec3( cos(m.x)*cos(m.y), sin(m.y), sin(m.x)*cos(m.y));\n\t\n\t\n\tvec3 cw = normalize(ta-ro);\n\tvec3 cp = vec3(0.,1.,0.0);\n\tvec3 cu = normalize(cross(cw,cp));\n\tvec3 cv = normalize(cross(cu,cw));\n\tvec3 rd = normalize( p.x*cu + p.y*cv + 2.0*cw );\n\n\n    // trace\t\n\tvec3 col = vec3(0.8,0.8,1.);\n\tfloat t = trace( ro, rd );\n\tif( t>0.0 )\n\t{\n\t\t\n\t\tvec3 pos = ro + t*rd;\n\t\tvec3 nor = calcNormal( pos );\n\t\t\n\t\t// lighting\n        vec3  light1 = vec3(  0.577, 0.577, -0.577 );\n        vec3  light2 = vec3( -0.707, 0.707,0.0  );\n\t\tfloat key = clamp( dot( light1, nor ), 0.0, 1.0 );\n\t\tfloat bac = clamp( 0.2 + 0.8*dot( light2, nor ), 0.0, 1.0 );\n\t\tfloat amb = (0.7+0.3*nor.y);\n\t\tfloat ao = pow( clamp(ot.w*2.0,0.2,1.0), 1.2 );\t\t\n        vec3 brdf = vec3(ao)*(.4*amb+key+.2*bac);\n\n        // material\t\t\n\t\tvec3 rgb = vec3(1.0);\n\t\t\n\t\trgb =(0.4*abs(sin(2.5+(vec3(.5*ot.w,ot.y*ot.y,2.-5.*ot.w))))+0.6*sin(vec3(-0.2,-0.6,0.8)+2.3+ot.x*22.5))*.85 + .15;\n\t\trgb.gbr=mix(rgb,rgb.bgr+vec3(0.3,0.1,-.2),0.5+.5*sin(15.*ot.w));\n\n\n\t\t// color\n\t\tcol = mix(vec3(0.8,0.8,1.),rgb*brdf,exp(-0.28*t));\n\t}\n\n\t\n\tgl_FragColor=vec4(col,1.0);\n}", "user": "61e70d1", "parent": null, "id": "17506.2"}