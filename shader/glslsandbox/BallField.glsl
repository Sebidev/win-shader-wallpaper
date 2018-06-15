{"code": "#define Iterations 64\n\n#ifdef GL_ES\nprecision mediump float;\n#endif\n\n// Tried to unbreak wahas shader, probably broke various other things in the process\n\nuniform float time;\nuniform vec2 mouse;\nuniform vec2 resolution;\n\nvec3 cellmask[8];\n\nfloat rand(vec3 r) { return fract(sin(dot(r.xy,vec2(1.38984*sin(r.z),1.13233*cos(r.z))))*653758.5453); }\n\nvec3 camera;\n\nfloat celldist(vec3 ipos,vec3 pos)\n{\n\tvec3 c=ipos+vec3(rand(ipos),rand(ipos+0.1),rand(ipos+0.2));\n\tfloat dist=length(c-pos);\n\tfloat radius=(rand(ipos+0.3)*0.3+0.2);\n\tfloat shrink=1.0-(1.0+cos(c.x))*(1.0+cos(c.y))*(1.0+cos(c.z))/8.0;\n\tfloat avoid=max(0.0,0.5-length(c-camera));\n\treturn dist-radius*shrink+avoid;\n}\n\nfloat distfunc(vec3 pos)\n{\n\tvec3 ipos=floor(pos)-0.5;\n\t\n\tfloat d = 50.0;\n\t\n\tfor(int i=0; i < 8; i++) {\n\t\td = min(d, celldist(ipos+cellmask[i],pos));\n\t}\n\n\treturn min (0.5,d);\n}\n\nvec3 gradient(vec3 pos)\n{\n\tconst float eps=0.001;\n\tfloat mid=distfunc(pos);\n\tfloat dx = distfunc(pos+vec3(eps,0.0,0.0))-mid;\n\tfloat dy = distfunc(pos+vec3(0.0,eps,0.0))-mid;\n\tfloat dz = distfunc(pos+vec3(0.0,0.0,eps))-mid;\n\treturn vec3(dx,dy,dz);\n}\n\n\nvoid main()\n{\n\tcellmask[0] = vec3( 0.0, 0.0, 0.0 );\n  \tcellmask[1] = vec3( 0.0, 0.0, 1.0 );\n  \tcellmask[2] = vec3( 0.0, 1.0, 0.0 );\n\tcellmask[3] = vec3( 0.0, 1.0, 1.0 );\n\tcellmask[4] = vec3( 1.0, 0.0, 0.0 );\n\tcellmask[5] = vec3( 1.0, 0.0, 1.0 );\n\tcellmask[6] = vec3( 1.0, 1.0, 0.0 );\n\tcellmask[7] = vec3( 1.0, 1.0, 1.0 );\n\t\n\tconst float pi=3.141592;\n\tvec2 coords=(2.0*gl_FragCoord.xy-resolution.xy)/max(resolution.x,resolution.y);\n\tvec3 ray_dir=normalize(vec3(coords,1.0));\n\tvec3 ray_pos=vec3(0.0,-3.0*time*0.1,0.0);\n\tcamera=ray_pos;\n\n\tfloat a=time/20.0;\n\tray_dir=ray_dir*mat3(\n\t\tcos(a),0.0,sin(a),\n\t\t0.0,1.0,0.0,\n\t\t-sin(a),0.0,cos(a)\n\t);\n\n\tfloat i=float(Iterations);\n\tfor(int j=0;j<Iterations;j++)\n\t{\n\t\tfloat dist=distfunc(ray_pos);\n\t\tray_pos+=dist*ray_dir;\n\n\t\tif(abs(dist)<0.001) { i=float(j); break; }\n\t}\n\n\tvec3 normal=normalize(gradient(ray_pos));\n\n\tfloat ao=1.0-i/float(Iterations);\n\tfloat what=pow(max(0.0,dot(normal,-ray_dir)),0.5);\n\t//float vignette=pow(1.0-length(coords),0.3);\n\tfloat light=ao*what*1.0;\n\n\tfloat z=length(ray_pos.xz);\n//\tvec3 col=(sin(vec3(z,z+pi/3.0,z+pi*2.0/3.0))+2.0)/3.0;\n\tvec3 col=exp(-vec3(z/5.0+0.1,z/30.0,z/10.0+0.1));\n\n\tvec3 reflected=reflect(ray_dir,normal);\n\tvec3 env=vec3(clamp(reflected.y*4.0,0.0,1.0));\n\n\tgl_FragColor=vec4(col*light+0.1*env*ao,1.0);\n}\n", "user": "a970956", "parent": "/e#8399.0", "id": "8400.0"}