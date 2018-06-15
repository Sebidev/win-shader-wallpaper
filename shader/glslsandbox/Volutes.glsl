{"code": "\n\n#ifdef GL_ES\n//precision highp float;\nprecision mediump float;\n#endif \n\nuniform float time;\nvarying vec2 surfacePosition;\n   \n#define ptpi 1385.4557313670110891409199368797 //powten(pi)\n#define pipi  36.462159607207911770990826022692 //pi pied, pi^pi\n#define picu  31.006276680299820175476315067101 //pi cubed, pi^3\n#define pepi  23.140692632779269005729086367949 //powe(pi);\n#define chpi  11.59195327552152062775175205256  //cosh(pi)\n#define shpi  11.548739357257748377977334315388 //sinh(pi)\n#define pisq  9.8696044010893586188344909998762 //pi squared, pi^2\n#define twpi  6.283185307179586476925286766559  //two pi, 2*pi \n#define pi    3.1415926535897932384626433832795 //pi\n#define sqpi  1.7724538509055160272981674833411 //square root of pi \n#define hfpi  1.5707963267948966192313216916398 //half pi, 1/pi\n#define cupi  1.4645918875615232630201425272638 //cube root of pi\n#define prpi  1.4396194958475906883364908049738 //pi root of pi\n#define lnpi  1.1447298858494001741434273513531 //logn(pi); \n#define trpi  1.0471975511965977461542144610932 //one third of pi, pi/3\n#define thpi  0.99627207622074994426469058001254//tanh(pi)\n#define lgpi  0.4971498726941338543512682882909 //log(pi)       \n#define rcpi  0.31830988618379067153776752674503// reciprocal of pi  , 1/pi  \n#define rcpipi  0.0274256931232981061195562708591 // reciprocal of pipi  , 1/pipi \n\nvec3 rotate(vec3 vect, vec3 axis, float angle)\n{\n    //axis = normalize(axis);\n    float s = sin(angle);\n    float c = cos(angle);\n    float oc = 1.0 - c;\n    float azs = axis.z * s; \n    float axs = axis.x * s;\n    float ays = axis.y * s;\n    float ocxy = oc * axis.x * axis.y; \n    float oczx = oc * axis.z * axis.x;\n    float ocyz = oc * axis.y * axis.z;   \n\t    \n    \n    mat4 rm = mat4(oc * axis.x * axis.x + c, ocxy - azs, oczx + ays, 0.0,\n                   ocxy + azs, oc * axis.y * axis.y + c, ocyz - axs, 0.0,\t\t   \n                   oczx -ays, ocyz + axs, oc * axis.z * axis.z + c,  0.0,\n                   0.0, 0.0, 0.0, 1.0);\n\t\n\treturn (vec4(vect, 1.0)*rm).xyz;\n}\n\n\nvoid main( void )\n{\n\n\tfloat t = (rcpi*(time/pisq))+pi;\n\tvec2 pos = surfacePosition*pi;\n\tvec3 qAxis = normalize(vec3(sin(t*(prpi)), cos(t*(cupi)), cos(t*(hfpi)) ));\n\tvec3 wAxis = normalize(vec3(cos(t*(-trpi)), sin(t*(rcpi)), sin(t*(lgpi)) ));\n\tvec3 camPos = normalize(vec3(0.0, 0.0, 1.0))/(twpi+sin(t)*pi);\n\tcamPos = rotate(camPos, qAxis, sin(t*lnpi)*pi)/pi;\n\tvec3 camTarget = vec3(0.0);\n\tvec3 camDir = normalize(camTarget-camPos);\n\tvec3 camUp  =normalize(vec3(0.0,1.0,0.0));\n\tcamUp = rotate(camUp, camDir, sin(t*prpi)*pi);\n    \tvec3 camSide = cross(camDir, camUp);\n\tvec3 sideNorm=normalize(cross(camUp, camDir));\n\tvec3 upNorm=cross(camDir, sideNorm);\n\tvec3 worldFacing=(camPos + camDir);\n\t\n    \tfloat focus =pi+sin(t)*sqpi;\n    \tvec3 rayDir = normalize((worldFacing+sideNorm*pos.x + upNorm*pos.y - camDir*((focus))));\n\n\tfloat f=0.0;\n\tvec3 tv=vec3(0.0);\n\tvec3 acCol = sin(worldFacing);\n\tfloat len =0.0;\n\tfor(float i=0.2; i<pi; i+=0.08)\n\t{\n        \ttv = rotate(worldFacing + (rayDir*(i)),normalize(reflect(wAxis*camDir,normalize(vec3(pos/pi,sin(t*rcpi)*pi)))),i*sin(i+time/pi));\n\t\t//tv = worldFacing + (rayDir*i);\n\t\tvec3 tvl =( cos(length(tv*hfpi))*sin(t+tv*pi));\n\t\tif((abs(tvl.x)<0.02 || abs(tvl.y)<0.02 || abs(tvl.z)<0.02))\n\t\t{\n\t\t\ttv=tv+(tvl/pi);\n\t\t\ttvl =( cos(length(tv*hfpi))*sin(t+tv*pi));\n\t\t\tlen +=1.2+i;\n\t\t\tacCol += ((camPos + (rayDir*i)))/len;\n\t\t\tif((abs(tvl.x)<0.012 || abs(tvl.y)<0.012 || abs(tvl.z)<0.012))\n\t\t\t{\n\t\t\t\t\n\t\t\t\tacCol += ((worldFacing + (rayDir*i)))/len;\n\t\t\t\tbreak;\n\t\t\t}\n\t\t\t//break;\n\t\t\t\n\t\t}\n\t\tacCol += ((worldFacing - (rayDir*i)))/pipi;\n\t\t\n\t}\n\t\n\tacCol = ((acCol)- acCol/len)/2.;\n\t\n\tacCol*=acCol;\n\t\n\tgl_FragColor = vec4(acCol,1.0);\n}\n", "user": "3a520b2", "parent": "/e#18125.33", "id": "18248.1"}