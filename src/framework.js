
const THREE = require('three');
const OrbitControls = require('three-orbit-controls')(THREE)
import Stats from 'stats-js'
import DAT from 'dat-gui'

// when the scene is done initializing, the function passed as `callback` will be executed
// then, every frame, the function passed as `update` will be executed
function init(callback, update, resizeFunction) {

  var hasUserGesture = false;
  
  //var stats = new Stats();
  //stats.setMode(1);
  //stats.domElement.style.position = 'absolute';
  //stats.domElement.style.left = '0px';
  //stats.domElement.style.top = '0px';
  //document.body.appendChild(stats.domElement);

  //var gui = new DAT.GUI();

  var framework = {
    //gui: gui,
    //stats: stats
  };

  // run this function after the window loads
  window.addEventListener('load', function() {
    document.body.style.cursor = 'pointer';
    var scene = new THREE.Scene();
    var camera = new THREE.PerspectiveCamera( 75, window.innerWidth/window.innerHeight, 0.1, 1000 );
    var renderer = new THREE.WebGLRenderer( { antialias: true } );
    renderer.setPixelRatio(window.devicePixelRatio);
    renderer.setSize(window.innerWidth, window.innerHeight);
    renderer.setClearColor(0x020202, 0);
    renderer.antialias = true;

    var controls = new OrbitControls(camera, renderer.domElement);
    controls.enableDamping = true;
    controls.enableZoom = true;
    controls.target.set(0, 0, 0);
    controls.rotateSpeed = 0.3;
    controls.zoomSpeed = 1.0;
    controls.panSpeed = 2.0;

    const e = document.getElementById('startMsg');
    document.body.insertBefore(renderer.domElement, e);

    // resize the canvas when the window changes
    window.addEventListener('resize', function() {
      camera.aspect = window.innerWidth / window.innerHeight;
      camera.updateProjectionMatrix();
      renderer.setSize(window.innerWidth, window.innerHeight);

      resizeFunction(framework);
    }, false);

    // assign THREE.js objects to the object we will return
    framework.scene = scene;
    framework.camera = camera;
    framework.renderer = renderer;

    // begin the animation loop
    (function tick() {
      //stats.begin();
      update(framework); // perform any requested updates
      // renderer.render(scene, camera); // render the scene
      //stats.end();
      requestAnimationFrame(tick); // register to call this again when the browser renders a new frame
    })();

    return;
  });


  // Need to do this in the click event listener because AudioContexts can no longer play without a user gesture
  window.addEventListener('click', function() {
    if (hasUserGesture) {
      return;
    } else {
      hasUserGesture = true;
      document.body.style.cursor = 'auto';

      // Hide the overlays
      [].forEach.call(document.querySelectorAll('.overlay'), function (el) {
        el.style.visibility = 'hidden';
      });

      // we will pass the scene, gui, renderer, camera, etc... to the callback function
      return callback(framework);
    }
  });
}

export default {
  init: init
}