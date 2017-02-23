require('file-loader?name=[name].[ext]!../index.html');

const THREE = require('three');
const OrbitControls = require('three-orbit-controls')(THREE)

import Stats from 'stats-js'
import {objLoaded} from './mario'
import {featherLoaded} from './mario'
import {setupGUI} from './setup'

/////////////////////////TOOLBOX FUNCTIONS////////////////////////////

function bias(b, t) {
    return Math.pow(t, Math.log(b) / Math.log(0.5));
}

function gain(g, t) {
    if (t < 0.5) {
        return bias(1.0 - g, 2.0*t) / 2; 
    }
    else {
        return 1 - bias(1.0 - g, 2.0 - 2.0*t) / 2;
    }
}

function sin(freq, x, t) {
    return Math.sin(freq * (x+t));
}

/////////////////////////////////////////////////////////////////////

var featherMat = [];

window.addEventListener('load', function() {
    var stats = new Stats();
    stats.setMode(1);
    stats.domElement.style.position = 'absolute';
    stats.domElement.style.left = '0px';
    stats.domElement.style.top = '0px';
    document.body.appendChild(stats.domElement);

    var scene = new THREE.Scene();
    var camera = new THREE.PerspectiveCamera( 75, window.innerWidth/window.innerHeight, 0.1, 1000 );
    var renderer = new THREE.WebGLRenderer( { antialias: true } );
    renderer.setPixelRatio(window.devicePixelRatio);
    renderer.setSize(window.innerWidth, window.innerHeight);
    renderer.setClearColor(0x999999, 1.0);

    var controls = new OrbitControls(camera, renderer.domElement);
    controls.enableDamping = true;
    controls.enableZoom = true;
    controls.rotateSpeed = 0.3;
    controls.zoomSpeed = 1.0;
    controls.panSpeed = 2.0;

    document.body.appendChild(renderer.domElement);

    window.addEventListener('resize', function() {
        camera.aspect = window.innerWidth / window.innerHeight;
        camera.updateProjectionMatrix();
        renderer.setSize(window.innerWidth, window.innerHeight);
    });
    
    var mesh, shader, post;
    // this gets called when we set the shader
    function shaderSet(Shader, gui) {
        // create the shader and initialize its gui
        shader = new Shader(renderer, scene, camera);
        shader.initGUI(gui);

        // recreate the mesh with a new material
        if (mesh) scene.remove(mesh);
        objLoaded.then(function(geo) {
            mesh = new THREE.Mesh(geo, shader.material);
            scene.add(mesh);
        });

        var layer = 0.0;
        var j = 0.0;
        var layer2 = 0.0;
        var k = 0.0;
        for (var i = 0; i < scene.children.length; i++) {

            if (scene.children[i].name == "feather" && layer <= 1.0) {

                scene.children[i].material = shader.material;

                var featherDistribution = (0.05/1.5) * (1.0 - layer) + (0.025/1.5) * layer;
                j += featherDistribution;
                if (j > 1.0) {
                    j = 0.0;
                    layer += 0.5;
                }
            }
            else if (scene.children[i].name == "feather" && layer2 <= 1.0) {

                scene.children[i].material = shader.material;

                var featherDistribution = (0.05/1.5) * (1.0 - layer2) + (0.025/1.5) * layer2;
                k += featherDistribution;
                if (k > 1.0) {
                    k = 0.0;
                    layer2 += 0.5;
                }
            }
        }

    }

    // this gets called when we set the postprocess shader
    function postProcessSet(Post, gui) {
        // create the shader and initialize its gui
        post = new Post(renderer, scene, camera);
        post.initGUI(gui);
    }

    setupGUI(shaderSet, postProcessSet);

    objLoaded.then(function(geo) {
        // point the camera to Mario on load
        camera.position.set(5, 10, 15);
        const center = geo.boundingSphere.center;
        camera.lookAt(center);
        controls.target.set(center.x, center.y, center.z);
    });

    var startTime = Date.now();
    var featherGeo;
    featherLoaded.then(function(geo2) {

        //initialize global variable featherGeo to geo2
        featherGeo = geo2;

        //bottom curve
        var curve1 = new THREE.CubicBezierCurve3(
            new THREE.Vector3( 0, 0, -5 ),
            new THREE.Vector3( -2 - 2.0 * 0.5, 0, 0 ),
            new THREE.Vector3( 2 + 2.0 * 0.5, sin(2, 0, 0.003 * (Date.now()-startTime)) , 0 ),
            new THREE.Vector3( 0, 2.0 * sin(2, 0, 0.003 * (Date.now()-startTime)) - 0.20*2.0, 5 )
        );
        //top curve
        var curve2 = new THREE.CubicBezierCurve3(
            new THREE.Vector3( 0, 0.1, -5 ),
            new THREE.Vector3( -2 - 2.0 * 0.5, 1, 0 ),
            new THREE.Vector3( 2 + 2.0 * 0.5, sin(2, 0, 0.003 * (Date.now()-startTime)) + 0.2, 0 ),
            new THREE.Vector3( 0, 2.0 * sin(2, 0, 0.003 * (Date.now()-startTime)), 5 )
        );
        for (var layer = 0.0; layer <= 1.0; layer += 0.5) {

            //interpolate feather scaling base for each layer, numbers chosen myself
            var scaleBase = 1.0 * (1.0 - layer) + 0.5 * layer;
            //interpolate feather scaling factor (max scaling), numbers chosen myself
            var scaleFactor = (2.0) * (1.0 - layer) + (0.5) * layer;
            //interpolate feather distribution, numbers chosen myself
            var featherDistribution = (0.05/1.5) * (1.0 - layer) + (0.025/1.5) * layer;
            //interpolate feather color darkness
            var darkness = 0.8 * (1.0 - layer) + 0.2 * layer;

            for (var i = 0.0; i <= 1.0; i += featherDistribution) {

                var featherMesh = new THREE.Mesh(featherGeo);
                featherMesh.name = "feather";

                featherMesh.material.color.setRGB(darkness*0.9, darkness*0.9, darkness*1.0);

                var y = curve1.getPointAt(i).y * (1.0 - layer) + curve2.getPointAt(i).y * layer;


                var mat4 = new THREE.Matrix4().makeRotationFromQuaternion(
                                    new THREE.Quaternion().setFromAxisAngle(new THREE.Vector3(0, 1, 0), Math.PI+gain(0.5, i)*70.0*Math.PI/180.0)
                                    ) ;
                mat4.premultiply(new THREE.Matrix4().makeTranslation(curve1.getPointAt(i).x, y, curve1.getPointAt(i).z));

                mat4.premultiply(new THREE.Matrix4().makeRotationFromQuaternion(
                                    new THREE.Quaternion().setFromAxisAngle(new THREE.Vector3(0, 0, 1), Math.PI/2.0)
                                    )) ;
                mat4.premultiply(new THREE.Matrix4().makeRotationFromQuaternion(
                                    new THREE.Quaternion().setFromAxisAngle(new THREE.Vector3(1, 0, 0), -Math.PI/4.0)
                                    )) ;
                mat4.premultiply(new THREE.Matrix4().makeRotationFromQuaternion(
                                    new THREE.Quaternion().setFromAxisAngle(new THREE.Vector3(0, 1, 0), Math.PI-Math.PI/6.0)
                                    )) ;

                mat4.premultiply(new THREE.Matrix4().makeTranslation(3.6, 5.4, -3.5)) ;

                featherMesh.applyMatrix(mat4);
                featherMat[layer*10.0+i] = mat4;

                var scalar = scaleBase + gain(0.5, i)*scaleFactor;
                featherMesh.scale.set(scalar, scalar, scalar);

                scene.add(featherMesh);
            }
        }  

        //bottom curve
        var curve3 = new THREE.CubicBezierCurve3(
            new THREE.Vector3( 0, 0, -5 ),
            new THREE.Vector3( 2.0 + 2.0 * 0.5, 0, 0 ),
            new THREE.Vector3( -2.0 - 2.0 * 0.5, sin(2, 0, 0.003 * (Date.now()-startTime)) , 0 ),
            new THREE.Vector3( 0, 2.0 * sin(2, 0, 0.003 * (Date.now()-startTime)) - 0.20*2.0, 5 )
        );
        //top curve
        var curve4 = new THREE.CubicBezierCurve3(
            new THREE.Vector3( 0, 0.1, -5 ),
            new THREE.Vector3( 2.0 + 2.0 * 0.5, 1, 0 ),
            new THREE.Vector3( -2.0 - 2.0 * 0.5, sin(2, 0, 0.003 * (Date.now()-startTime)) + 0.2, 0 ),
            new THREE.Vector3( 0, 2.0 * sin(2, 0, 0.003 * (Date.now()-startTime)), 5 )
        );
        for (var layer = 0.0; layer <= 1.0; layer += 0.5) {

            //interpolate feather scaling base for each layer, numbers chosen myself
            var scaleBase = 1.0 * (1.0 - layer) + 0.5 * layer;
            //interpolate feather scaling factor (max scaling), numbers chosen myself
            var scaleFactor = (2.0) * (1.0 - layer) + (0.5) * layer;
            //interpolate feather distribution, numbers chosen myself
            var featherDistribution = (0.05/1.5) * (1.0 - layer) + (0.025/1.5) * layer;
            //interpolate feather color darkness
            var darkness = 0.8 * (1.0 - layer) + 0.2 * layer;

            for (var i = 0.0; i <= 1.0; i += featherDistribution) {

                var featherMesh = new THREE.Mesh(featherGeo);
                featherMesh.name = "feather";

                featherMesh.material.color.setRGB(darkness*0.9, darkness*0.9, darkness*1.0);

                var y = curve3.getPointAt(i).y * (1.0 - layer) + curve4.getPointAt(i).y * layer;


                var mat4 = new THREE.Matrix4().makeRotationFromQuaternion(
                                    new THREE.Quaternion().setFromAxisAngle(new THREE.Vector3(0, 1, 0), -gain(0.5, i)*70.0*Math.PI/180.0)
                                    ) ;
                mat4.premultiply(new THREE.Matrix4().makeTranslation(curve3.getPointAt(i).x, y, curve3.getPointAt(i).z));


                mat4.premultiply(new THREE.Matrix4().makeRotationFromQuaternion(
                                    new THREE.Quaternion().setFromAxisAngle(new THREE.Vector3(0, 0, 1), Math.PI/2.0)
                                    )) ;
                mat4.premultiply(new THREE.Matrix4().makeRotationFromQuaternion(
                                    new THREE.Quaternion().setFromAxisAngle(new THREE.Vector3(1, 0, 0), Math.PI+Math.PI/4.0)
                                    )) ;
                mat4.premultiply(new THREE.Matrix4().makeRotationFromQuaternion(
                                    new THREE.Quaternion().setFromAxisAngle(new THREE.Vector3(0, 1, 0), Math.PI/6.0)
                                    )) ;

                mat4.premultiply(new THREE.Matrix4().makeTranslation(-3.6, 5.4, -3.5)) ;
                
                featherMesh.applyMatrix(mat4);
                featherMat[(layer+1.1)*10.0+i] = mat4;

                var scalar = scaleBase + gain(0.5, i)*scaleFactor;
                featherMesh.scale.set(scalar, scalar, scalar);

                scene.add(featherMesh);
            }
        }  

    });

    (function tick() {

        //LEFT WING
        //bottom curve
        var curveA = new THREE.CubicBezierCurve3(
            new THREE.Vector3( 0, 0, -5 ),
            new THREE.Vector3( -2 - 2.0 * 0.5, 0, 0 ),
            new THREE.Vector3( 2 + 2.0 * 0.5, sin(2, 0, 0.003 * (Date.now()-startTime)) , 0 ),
            new THREE.Vector3( 0, 2.0 * sin(2, 0, 0.003 * (Date.now()-startTime)) - 0.20*2.0, 5 )
        );
        //top curve
        var curveB = new THREE.CubicBezierCurve3(
            new THREE.Vector3( 0, 0.1, -5 ),
            new THREE.Vector3( -2 - 2.0 * 0.5, 1, 0 ),
            new THREE.Vector3( 2 + 2.0 * 0.5, sin(2, 0, 0.003 * (Date.now()-startTime)) + 0.2, 0 ),
            new THREE.Vector3( 0, 2.0 * sin(2, 0, 0.003 * (Date.now()-startTime)), 5 )
        );

        //RIGHT WING
        //bottom curve
        var curveC = new THREE.CubicBezierCurve3(
            new THREE.Vector3( 0, 0, -5 ),
            new THREE.Vector3( 2.0 + 2.0 * 0.5, 0, 0 ),
            new THREE.Vector3( -2.0 - 2.0 * 0.5, sin(2, 0, 0.003 * (Date.now()-startTime)) , 0 ),
            new THREE.Vector3( 0, 2.0 * sin(2, 0, 0.003 * (Date.now()-startTime)) - 0.20*2.0, 5 )
        );
        //top curve
        var curveD = new THREE.CubicBezierCurve3(
            new THREE.Vector3( 0, 0.1, -5 ),
            new THREE.Vector3( 2.0 + 2.0 * 0.5, 1, 0 ),
            new THREE.Vector3( -2.0 - 2.0 * 0.5, sin(2, 0, 0.003 * (Date.now()-startTime)) + 0.2, 0 ),
            new THREE.Vector3( 0, 2.0 * sin(2, 0, 0.003 * (Date.now()-startTime)), 5 )
        );

        var layer = 0.0;
        var j = 0.0;
        var layer2 = 0.0;
        var k = 0.0;
        for (var i = 0; i < scene.children.length; i++) {

            if (scene.children[i].name === "feather" && layer <= 1.0) {

                var featherDistribution = (0.05/1.5) * (1.0 - layer) + (0.025/1.5) * layer;
                //interpolate feather scaling base for each layer, numbers chosen myself
                var scaleBase = 1.0 * (1.0 - layer) + 0.5 * layer;
                //interpolate feather scaling factor (max scaling), numbers chosen myself
                var scaleFactor = (2.0) * (1.0 - layer) + (0.5) * layer;

                var featherMesh = scene.children[i];

                var y = curveA.getPointAt(j).y * (1.0 - layer) + curveB.getPointAt(j).y * layer;


                featherMesh.applyMatrix(new THREE.Matrix4().getInverse(featherMat[layer*10.0+j]));

                var mat4 = new THREE.Matrix4().makeRotationFromQuaternion(
                                    new THREE.Quaternion().setFromAxisAngle(new THREE.Vector3(0, 1, 0), Math.PI+gain(0.5, j)*70.0*Math.PI/180.0)
                                    ) ;
                mat4.premultiply(new THREE.Matrix4().makeTranslation(curveA.getPointAt(j).x, y, curveA.getPointAt(j).z));


                mat4.premultiply(new THREE.Matrix4().makeRotationFromQuaternion(
                                    new THREE.Quaternion().setFromAxisAngle(new THREE.Vector3(0, 0, 1), Math.PI/2.0)
                                    )) ;
                mat4.premultiply(new THREE.Matrix4().makeRotationFromQuaternion(
                                    new THREE.Quaternion().setFromAxisAngle(new THREE.Vector3(1, 0, 0), -Math.PI/4.0)
                                    )) ;
                mat4.premultiply(new THREE.Matrix4().makeRotationFromQuaternion(
                                    new THREE.Quaternion().setFromAxisAngle(new THREE.Vector3(0, 1, 0), Math.PI-Math.PI/6.0)
                                    )) ;

                mat4.premultiply(new THREE.Matrix4().makeTranslation(3.6, 5.4, -3.5)) ;

                featherMesh.applyMatrix(mat4);
                featherMat[layer*10.0+j] = mat4;

                var scalar = scaleBase + gain(0.5, j)*scaleFactor;
                featherMesh.scale.set(scalar, scalar, scalar);

                
                j += featherDistribution;
                if (j > 1.0) {
                    j = 0.0;
                    layer += 0.5;
                }
            }
            else if (scene.children[i].name === "feather" && layer2 <= 1.0) {
                
                var featherDistribution = (0.05/1.5) * (1.0 - layer2) + (0.025/1.5) * layer2;
                //interpolate feather scaling base for each layer, numbers chosen myself
                var scaleBase = 1.0 * (1.0 - layer2) + 0.5 * layer2;
                //interpolate feather scaling factor (max scaling), numbers chosen myself
                var scaleFactor = (2.0) * (1.0 - layer2) + (0.5) * layer2;

                var featherMesh = scene.children[i];

                var y = curveC.getPointAt(k).y * (1.0 - layer2) + curveD.getPointAt(k).y * layer2;


                featherMesh.applyMatrix(new THREE.Matrix4().getInverse(featherMat[(layer2+1.1)*10.0+k]));

                var mat4 = new THREE.Matrix4().makeRotationFromQuaternion(
                                    new THREE.Quaternion().setFromAxisAngle(new THREE.Vector3(0, 1, 0), -gain(0.5, k)*70.0*Math.PI/180.0)
                                    ) ;
                mat4.premultiply(new THREE.Matrix4().makeTranslation(curveC.getPointAt(k).x, y, curveC.getPointAt(k).z));


                mat4.premultiply(new THREE.Matrix4().makeRotationFromQuaternion(
                                    new THREE.Quaternion().setFromAxisAngle(new THREE.Vector3(0, 0, 1), Math.PI/2.0)
                                    )) ;
                mat4.premultiply(new THREE.Matrix4().makeRotationFromQuaternion(
                                    new THREE.Quaternion().setFromAxisAngle(new THREE.Vector3(1, 0, 0), Math.PI+Math.PI/4.0)
                                    )) ;
                mat4.premultiply(new THREE.Matrix4().makeRotationFromQuaternion(
                                    new THREE.Quaternion().setFromAxisAngle(new THREE.Vector3(0, 1, 0), Math.PI/6.0)
                                    )) ;

                mat4.premultiply(new THREE.Matrix4().makeTranslation(-3.6, 5.4, -3.5)) ;

                featherMesh.applyMatrix(mat4);
                featherMat[(layer2+1.1)*10.0+k] = mat4;

                var scalar = scaleBase + gain(0.5, k)*scaleFactor;
                featherMesh.scale.set(scalar, scalar, scalar);
                
                k += featherDistribution;
                if (k > 1.0) {
                    k = 0.0;
                    layer2 += 0.5;
                }
            }
        }
        

        controls.update();
        stats.begin();
        if (shader && shader.update) shader.update();   // perform any necessary updates
        if (post && post.update) post.update();         // perform any necessary updates
        if (post) post.render();                        // render the scene
        stats.end();
        requestAnimationFrame(tick);
    })();
});