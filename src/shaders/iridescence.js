
const THREE = require('three');
import {textureLoaded} from '../mario'

// options for iridecence shader
var options = {
    lightColor: '#ffffff',
    lightIntensity: 2,
    albedo: '#dddddd',
    ambient: '#111111',
    useTexture: true,
    irrStartCol: '#f0c5c5',
    irrEndCol: '#8e54f7',
    irrThreshold: 0.5,
    irrRampExp: 1.2,
    irrWhiteOnly: true,
    /*
    RGBamp: new THREE.Vector3(1,1,1),
    RGBfrq: new THREE.Vector3(1,1,1),
    RGBphz: new THREE.Vector3(0,0,0),
    */
}

export default function(renderer, scene, camera) {
    
    const Shader = {
        initGUI: function(gui) {
            gui.addColor(options, 'lightColor').onChange(function(val) {
                Shader.material.uniforms.u_lightCol.value = new THREE.Color(val);
            });
            gui.add(options, 'lightIntensity').onChange(function(val) {
                Shader.material.uniforms.u_lightIntensity.value = val;
            });
            gui.addColor(options, 'albedo').onChange(function(val) {
                Shader.material.uniforms.u_albedo.value = new THREE.Color(val);
            });
            gui.addColor(options, 'ambient').onChange(function(val) {
                Shader.material.uniforms.u_ambient.value = new THREE.Color(val);
            });
            gui.add(options, 'useTexture').onChange(function(val) {
                Shader.material.uniforms.u_useTexture.value = val;
            });
            var irr = gui.addFolder('Irridescence');
            irr.addColor(options, 'irrStartCol').onChange(function(val) {
                Shader.material.uniforms.u_irrStartCol.value = new THREE.Color(val);
            });
            irr.addColor(options, 'irrEndCol').onChange(function(val) {
                Shader.material.uniforms.u_irrEndCol.value = new THREE.Color(val);
            });
            irr.add(options, 'irrThreshold').onChange(function(val) {
                Shader.material.uniforms.u_irrThreshold.value = val;
            });
            // needs work to get the effect I want.
            irr.add(options, 'irrRampExp').onChange(function(val) {
                Shader.material.uniforms.u_irrRampExp.value = val;
            });
            irr.add(options, 'irrWhiteOnly').onChange(function(val) {
                Shader.material.uniforms.u_irrWhiteOnly.value = val;
            });
			irr.open();
            /* This fails when reload the shader, saying folder already exists. Why
               for this but not other gui elements?
               Also, values don't seem to be geting into frag shader. */
            /*
            var cf = gui.addFolder('RGB Cos Curves');
            //for( var i=0; i < 3; i++){
            //var com = ['x','y','z'][i]; //couldn't get it going with loop. why not? cuz of function?
				cf.add(options.RGBamp, 'x', 0, 1 ).name('amp.R').onChange(function(val) {
               	 Shader.material.uniforms.u_RGBamp.value['x'] = val;
            	});
				cf.add(options.RGBamp, 'y', 0, 1 ).name('amp.G').onChange(function(val) {
               	 Shader.material.uniforms.u_RGBamp.value['y'] = val;
               	});
				cf.add(options.RGBamp, 'z', 0 ,1 ).name('amp.B').onChange(function(val) {
               	 Shader.material.uniforms.u_RGBamp.value['z'] = val;
               	});
				cf.add(options.RGBfrq, 'x', 0, 10 ).name('frq.R').onChange(function(val) {
               	 Shader.material.uniforms.u_RGBfrq.value['x'] = val;
            	});
				cf.add(options.RGBfrq, 'y', 0, 10 ).name('frq.G').onChange(function(val) {
               	 Shader.material.uniforms.u_RGBfrq.value['y'] = val;
               	});
				cf.add(options.RGBfrq, 'z', 0 , 10 ).name('frq.B').onChange(function(val) {
               	 Shader.material.uniforms.u_RGBfrq.value['z'] = val;
               	});
				cf.add(options.RGBphz, 'x', 0, 1 ).name('phz.R').onChange(function(val) {
               	 Shader.material.uniforms.u_RGBphz.value['x'] = val;
            	});
				cf.add(options.RGBphz, 'y', 0, 1 ).name('phz.G').onChange(function(val) {
               	 Shader.material.uniforms.u_RGBphz.value['y'] = val;
               	});
				cf.add(options.RGBphz, 'z', 0 ,1 ).name('phz.B').onChange(function(val) {
               	 Shader.material.uniforms.u_RGBphz.value['z'] = val;
               	});
               	*/
			//}
        },
        
        material: new THREE.ShaderMaterial({
            uniforms: {
                texture: {
                    type: "t", 
                    value: null
                },
                u_useTexture: {
                    type: 'i',
                    value: options.useTexture
                },
                u_albedo: {
                    type: 'v3',
                    value: new THREE.Color(options.albedo)
                },
                u_ambient: {
                    type: 'v3',
                    value: new THREE.Color(options.ambient)
                },
                u_lightPos: {
                    type: 'v3',
                    value: new THREE.Vector3(30, 50, 40)
                },
                u_lightCol: {
                    type: 'v3',
                    value: new THREE.Color(options.lightColor)
                },
                u_lightIntensity: {
                    type: 'f',
                    value: options.lightIntensity
                },
                u_irrStartCol: {
                    type: 'v3',
                    value: new THREE.Color(options.irrStartCol)
                },
                u_irrEndCol: {
                    type: 'v3',
                    value: new THREE.Color(options.irrEndCol)
                },
                u_irrThreshold: {
                    type: 'f',
                    value: options.irrThreshold
                },
                u_irrRampExp: {
                    type: 'f',
                    value: options.irrRampExp
                },
                u_irrWhiteOnly: {
                	type: 'i',
                	value: options.irrWhiteOnly
                }
                
                /*
                u_RGBamp: {
                    type: 'v3',
                    value: new THREE.Vector3(1, 1, 1)
                },
                u_RGBfrq: {
                    type: 'v3',
                    value: new THREE.Vector3(1, 1, 1)
                },
                u_RGBphz: {
                    type: 'v3',
                    value: new THREE.Vector3(1, 1, 1)
                },*/
            },
            vertexShader: require('../glsl/iridescence-vert.glsl'),
            fragmentShader: require('../glsl/iridescence-frag.glsl')
        })
    }

    // once the Mario texture loads, bind it to the material
    textureLoaded.then(function(texture) {
        Shader.material.uniforms.texture.value = texture;
    });

    return Shader;
}