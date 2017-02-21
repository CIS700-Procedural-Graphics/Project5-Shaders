const THREE = require('three');
const Random = require("random-js");
const Ease = require("ease-component")

import Framework from './framework'
import * as Building from './building.js'
import * as Rubik from './rubik.js'
import * as City from './city.js'
import * as Camera from './camera.js'

var Engine = 
{
  initialized : false,

  camera : null,
  cameraControllers : [],
  currentCameraIndex : 0,
  cameraTime : 0,

  time : 0.0,
  deltaTime : 0.0,
  clock : null,

  music : null,

  loadingBlocker : null,
  materials : [],

  rubik : null,
  rubikTime : 0,

}

function loadMusic()
{  
  // A more complex method needs state checking... 
  var listener = new THREE.AudioListener();
  Engine.camera.add(listener);

  var sound = new THREE.Audio(listener);
  var audioLoader = new THREE.AudioLoader();

  //Load a sound and set it as the Audio object's buffer
  audioLoader.load('./music/music.mp3', function( buffer ) {
      sound.setBuffer( buffer );
      sound.setLoop(true);
      sound.setVolume(1.0);
      sound.play();

      // Initialize the Engine ONLY when the sound is loaded
      Engine.initialized = true;
  });
}

function updateCamera()
{
    if(Engine.currentCameraIndex < Engine.cameraControllers.length)
    {
        var controller = Engine.cameraControllers[Engine.currentCameraIndex];
        var next = controller.update(Engine.cameraTime);

        if(next)
        {
            controller.onExit();
            setActiveCamera(Engine.currentCameraIndex + 1);
        }
    }

    Engine.camera.updateProjectionMatrix();
}

function setActiveCamera(index)
{
    Engine.currentCameraIndex = index;

    if(Engine.currentCameraIndex < Engine.cameraControllers.length)
        Engine.cameraControllers[Engine.currentCameraIndex].setActive(Engine.cameraTime);
}

function loadCameraControllers()
{
  Engine.cameraControllers.push(new Camera.CameraController(4, function(t) {
      Engine.camera.position.set(40, 40, 40);
      Engine.camera.zoom = 4 - t * .25;
      Engine.camera.lookAt(new THREE.Vector3(0, t + .2, 1));
  }));

  Engine.cameraControllers.push(new Camera.CameraController(3.5, function(t) {
      var direction = new THREE.Vector3(0, 0, 1);
      var p = new THREE.Vector3(40,-40,40).add(direction.multiplyScalar(t * .5));
      Engine.camera.position.copy(p);

      Engine.camera.zoom = 4 - t * .25;

      Engine.camera.lookAt(new THREE.Vector3(0, 0, 2 - t));
  }));

  Engine.cameraControllers.push(new Camera.CameraController(7.3, function(t) {
      var direction = new THREE.Vector3(0, 0, 1);
      var p = new THREE.Vector3(4, 4, 4);
      Engine.camera.position.set(40, 40, 40);
      // Engine.camera.position.copy(p);

      var smoothT = THREE.Math.smoothstep(Math.pow(t, 40) * .75 + t * .25, 0, 1);

      smoothT = Ease.outBack(smoothT);

      Engine.camera.zoom = 3.5 - smoothT * 2.5;

      Engine.camera.lookAt(new THREE.Vector3(0, 0, 0));
      Engine.camera.rotateZ(smoothT * Math.PI * 2);
  }));

  Engine.cameraControllers.push(new Camera.CameraController(15.0, function(t) {
      var direction = new THREE.Vector3(0, 0, 1);
      var p = new THREE.Vector3(4, 4, 4);

      Engine.camera.zoom = 1 + Math.pow(Math.abs(Math.sin(t * 15.5 * Math.PI * 2)), 15) * .2;

      Engine.camera.lookAt(new THREE.Vector3(0, 0, 0));
  }));

  setActiveCamera(0);
}

function onLoad(framework) 
{
  var scene = framework.scene;
  var camera = framework.camera;
  var renderer = framework.renderer;
  var gui = framework.gui;
  var stats = framework.stats;

  renderer.setClearColor(new THREE.Color(.4, .75, .95), 1);

  // initialize a simple box and material
  var directionalLight = new THREE.DirectionalLight( 0xffffff, 1 );
  directionalLight.color = new THREE.Color(.9, .9, 1 );
  directionalLight.position.set(-10, 10, 10);
  scene.add(directionalLight);

  // initialize a simple box and material
  var directionalLight2 = new THREE.DirectionalLight( 0xffffff, 1 );
  directionalLight2.color = new THREE.Color(.4, .4, .7);
  directionalLight2.position.set(-1, -3, 2);
  directionalLight2.position.multiplyScalar(10);
  scene.add(directionalLight2);

  // set camera position
  camera.position.set(40, 40, 40);
  camera.lookAt(new THREE.Vector3(0,0,0));
  camera.fov = 5;
  camera.updateProjectionMatrix();

  Engine.rubik = new Rubik.Rubik();
  var rubikMesh = Engine.rubik.build();
  scene.add(rubikMesh);

  // Init Engine stuff
  Engine.scene = scene;
  Engine.renderer = renderer;
  Engine.clock = new THREE.Clock();
  Engine.camera = camera;

  var random = new Random(Random.engines.mt19937().seed(2545));

  var speed = .45;

  var city = new City.Generator();
  var cityBlocks = city.build(scene);

  // Engine.rubik.attachShapesToFace(cityBlocks);

  var callback = function() {
    Engine.rubik.animate(random.integer(0, 2), random.integer(0, 2), speed, callback);
  };

  // Engine.rubik.animate(0, 0, speed, callback);

  loadMusic();

  loadCameraControllers();
}

// called on frame updates
function onUpdate(framework) 
{
  if(Engine.initialized)
  {
    var screenSize = new THREE.Vector2( framework.renderer.getSize().width, framework.renderer.getSize().height );
    var deltaTime = Engine.clock.getDelta();

    Engine.time += deltaTime;
    Engine.cameraTime += deltaTime;
    Engine.deltaTime = deltaTime;

    Engine.rubik.update(deltaTime);

    updateCamera();
  }
}

Framework.init(onLoad, onUpdate);
