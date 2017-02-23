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
                featherMesh.position.set(curve1.getPointAt(i).x, y, curve1.getPointAt(i).z);

                featherMesh.rotateY(180.0 * Math.PI/180.0);
                featherMesh.rotateY(gain(0.5, i)*70.0*Math.PI/180.0);

                var scalar = scaleBase + gain(0.5, i)*scaleFactor;
                featherMesh.scale.set(scalar, scalar, scalar);

                //animation for wind turbulence
                featherMesh.rotateZ(Math.PI/180.0 * sin(2, featherMesh.position.x, (0.003)*(Date.now()-startTime)));

                scene.add(featherMesh);
            }
        }  

    });

    (function tick() {
        
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

        var layer = 0.0;
        var j = 0.0;
        for (var i = 0; i < scene.children.length; i++) {

            if (scene.children[i].name == "feather" && layer <= 1.0) {

                var featherDistribution = (0.05/1.5) * (1.0 - layer) + (0.025/1.5) * layer;

                var featherMesh = scene.children[i];

                var y = curveA.getPointAt(j).y * (1.0 - layer) + curveB.getPointAt(j).y * layer;
                featherMesh.position.set(curveA.getPointAt(j).x, y, curveA.getPointAt(j).z);
                
                j += featherDistribution;
                if (j > 1.0) {
                    j = 0.0;
                    layer += 0.5;
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