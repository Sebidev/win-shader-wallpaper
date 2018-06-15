{"code": "precision highp float;\nuniform vec2 resolution;\nuniform float time;\n\nfloat e(vec3 c, float r)\n{\n  c = cos(vec3(cos(c.r+r/6.)*c.r-cos(c.g+r/5.)*c.g,c.b/3.*c.r-cos(r/7.)*c.g,c.r+c.g+c. b+r));\n  return dot(c*c,vec3(1.))-1.0;\n}\n\nvoid main()\n{\n  vec2 c=-1.+2.0*gl_FragCoord.rg/resolution.xy;\n  vec3 o=vec3(0.),g=vec3(c.r,c.g,1)/64.;\n  vec4 v=vec4(0.);\n  float t=time/3.,i,ii;\n  for(float i=1.;i<666.;i+=1.0)\n    {\n      vec3 vct = o+g*i;\n      float scn = e(vct, t);\n      if(scn<.4)\n        {\n          vec3 r=vec3(.15,0.,0.),c=r;\n          c.r=scn-e(vec3(vct+r.rgg), t);\n          c.g=scn-e(vec3(vct+r.grg), t);\n          c.b=scn-e(vec3(vct+r.ggr), t);\n          v+=dot(vec3(0.,0.,-1.0),c)+dot(vec3(0.0,-0.5,0.5),c);\n          break;\n        }\n        ii=i;\n    }\n  gl_FragColor=v+vec4(.1+cos(t/14.)/9.,0.1,.1-cos(t/3.)/19.,1.)*(ii/44.);\n}", "user": "ad0e31e", "parent": null, "id": "26986.2"}