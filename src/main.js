require('file-loader?name=[name].[ext]!../index.html');

const THREE = require('three');
const OrbitControls = require('three-orbit-controls')(THREE)

import Stats from 'stats-js'
import {objLoaded} from './mario'
import {setupGUI} from './setup'

window.addEventListener('load', function() {
    var stats = new Stats();
    stats.setMode(1);
    stats.domElement.style.position = 'absolute';
    stats.domElement.style.left = '0px';
    stats.domElement.style.top = '0px';
    document.body.appendChild(stats.domElement);

    var scene = new THREE.Scene();
    var camera = new THREE.PerspectiveCamera( 75, window.innerWidth/window.innerHeight, 0.1, 10000 );
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
        camera.position.set(500, 10, 1500);
        const center = geo.boundingSphere.center;
        camera.lookAt(center);
        controls.target.set(center.x, center.y, center.z);
    });

    (function tick() {
        controls.update();
        stats.begin();
        if (shader && shader.update) shader.update();   // perform any necessary updates
        if (post && post.update) post.update();         // perform any necessary updates
        if (post) post.render();                        // render the scene
        stats.end();
        requestAnimationFrame(tick);
    })();
});
