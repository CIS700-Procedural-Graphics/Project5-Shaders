const THREE = require('three');
const Random = require("random-js");
const Ease = require("ease-component")

import Framework from './framework'
import * as Building from './building.js'
import * as Rubik from './rubik.js'
import * as City from './city.js'
import * as Camera from './camera.js'

import * as Glare from './post/glare.js'
import * as Sobel from './post/sobel.js'
import * as Glitch from './post/glitch.js'

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
  passes : [],

  rubik : null,
  rubikTime : 0,

  // Important meshes
  initialCube : null,

  // Important materials
  buildingMaterial : null,

  audio : null,
  volume : 1.0,

  glarePass : null,
  sobelPass : null,
  currentPass : null
}

function startAnimation()
{
    // Initialize the Engine ONLY when the sound is loaded
    Engine.initialized = true;
    Engine.rubik.container.scale.set(.1, .1, .1);
}

function loadMusic()
{  
  // A more complex method needs state checking... 
  var listener = new THREE.AudioListener();
  Engine.camera.add(listener);

  var sound = new THREE.Audio(listener);
  var audioLoader = new THREE.AudioLoader();

  Engine.audio = sound;

  //Load a sound and set it as the Audio object's buffer
  audioLoader.load('./music/music.mp3', function( buffer ) {
      sound.setBuffer( buffer );
      sound.setLoop(false);
      sound.setVolume(Engine.volume);
      sound.play();

      startAnimation();
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

  // BUILDUP CAMERA
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

  // DROP CAMERA
  Engine.cameraControllers.push(new Camera.CameraController(14.5, function(t) {
      var direction = new THREE.Vector3(0, 0, 1);
      var p = new THREE.Vector3(4, 4, 4);

      Engine.camera.zoom = 1 + Math.pow(Math.abs(Math.sin(t * 15.5 * Math.PI * 2)), 15) * .05;

      Engine.rubik.container.rotateY(.01);

      Engine.camera.lookAt(new THREE.Vector3(0, 0, 0));
  }, 
  function(){
    Engine.fakeBox.visible = false;  
    Engine.rubik.container.scale.set(1,1,1);
    Engine.buildingMaterial.uniforms.animateHeight.value = 1;
  }));

  // ENVIRO 1
  Engine.cameraControllers.push(new Camera.CameraController(3.5, function(t) {
      var direction = new THREE.Vector3(0, 0, 1);
      var p = new THREE.Vector3(7,7,0).add(direction.multiplyScalar(t * -.2));
      Engine.camera.position.copy(p);

      Engine.camera.zoom = 1;
      Engine.buildingMaterial.uniforms.animateHeight.value = 0;

      Engine.camera.lookAt(new THREE.Vector3(0, 1, 1 - t * .3));
  }));

  // ENVIRO 2
  Engine.cameraControllers.push(new Camera.CameraController(3.5, function(t) {
      var direction = new THREE.Vector3(0, 0, 1);
      var p = new THREE.Vector3(7,-7,0).add(direction.multiplyScalar(t * -.2));
      Engine.camera.position.copy(p);

      Engine.camera.zoom = 1;
      Engine.buildingMaterial.uniforms.animateHeight.value = 0;

      Engine.camera.lookAt(new THREE.Vector3(0, 1, 1 - t * .3));
  }));

  // ENVIRO 3
  Engine.cameraControllers.push(new Camera.CameraController(3.75, function(t) {
      var direction = new THREE.Vector3(0, 0, 1);
      var p = new THREE.Vector3(7,4,-4).add(direction.multiplyScalar(t * -.2));
      Engine.camera.position.copy(p);

      Engine.camera.zoom = 1;
      Engine.buildingMaterial.uniforms.animateHeight.value = 0;

      Engine.camera.lookAt(new THREE.Vector3(0, 1, 1 - t * .3));
  }));

  // BUILDUP CAMERA 2
  Engine.cameraControllers.push(new Camera.CameraController(4, function(t) {
      var direction = new THREE.Vector3(0, 0, 1);
      var p = new THREE.Vector3(4, 4, 4);
      Engine.camera.position.set(40, 40, 40);
      // Engine.camera.position.copy(p);

      var smoothT = THREE.Math.smoothstep(Math.pow(t, 25) * .75 + t * .25, 0, 1);

      smoothT = Ease.outBack(smoothT);

      Engine.camera.zoom = 3.5 - smoothT * 2.5;

      Engine.camera.lookAt(new THREE.Vector3(0, 0, 0));
      Engine.camera.rotateZ(smoothT * Math.PI * 2);
  }));

  // DROP 2 CAMERA
  Engine.cameraControllers.push(new Camera.CameraController(29.65, function(t) {
      var direction = new THREE.Vector3(0, 0, 1);
      var p = new THREE.Vector3(4, 4, 4);

      Engine.camera.zoom = 1 + Math.pow(Math.abs(Math.sin(t * 31.5 * Math.PI * 2)), 15) * .05;

      Engine.rubik.container.rotateY(.01);
      Engine.rubik.container.rotateX(.01);

      Engine.camera.lookAt(new THREE.Vector3(0, 0, 0));
  }, 
  function(){
    Engine.buildingMaterial.uniforms.animateHeight.value = 1;
  }));

  // SLOW DOWN CAMERA 1
  Engine.cameraControllers.push(new Camera.CameraController(3.5, function(t) {
      var direction = new THREE.Vector3(0, 0, 1);
      var p = new THREE.Vector3(7,7,0).add(direction.multiplyScalar(t * -.2));
      Engine.camera.position.copy(p);

      Engine.camera.zoom = 1;
      Engine.buildingMaterial.uniforms.animateHeight.value = 0;

      Engine.camera.lookAt(new THREE.Vector3(0, 1, 1 - t * .3));
  }));

  // SLOW DOWN CAMERA 2
  Engine.cameraControllers.push(new Camera.CameraController(3.5, function(t) {
      var direction = new THREE.Vector3(0, 0, 1);
      var p = new THREE.Vector3(7,-7,0).add(direction.multiplyScalar(t * -.2));
      Engine.camera.position.copy(p);

      Engine.camera.zoom = 1;
      Engine.buildingMaterial.uniforms.animateHeight.value = 0;

      Engine.camera.lookAt(new THREE.Vector3(0, 1, 1 - t * .3));
  }));

  // SLOW DOWN CAMERA 3
  Engine.cameraControllers.push(new Camera.CameraController(4.75, function(t) {
      var direction = new THREE.Vector3(0, 0, 1);
      var p = new THREE.Vector3(7,4,-4).add(direction.multiplyScalar(t * -.2));
      Engine.camera.position.copy(p);

      Engine.camera.zoom = 1;
      Engine.buildingMaterial.uniforms.animateHeight.value = 0;

      Engine.camera.lookAt(new THREE.Vector3(0, 1, 1 - t * .3));
  }));

  // PRE BUILDUP 3 CAMERA
  Engine.cameraControllers.push(new Camera.CameraController(2, function(t) {
      var direction = new THREE.Vector3(0, 0, 1);
      var p = new THREE.Vector3(40, 40, 40);
      Engine.camera.position.copy(p);

      Engine.camera.zoom = 1;

      Engine.rubik.container.rotateY(.01);
      Engine.rubik.container.rotateX(-.01);

      Engine.camera.lookAt(new THREE.Vector3(0, 0, 0));

  }));

  // BUILDUP 3 CAMERA (START OF MOVEMENT)
  Engine.cameraControllers.push(new Camera.CameraController(15, function(t) {
      var direction = new THREE.Vector3(0, 0, 1);
      var p = new THREE.Vector3(40, 40, 40);
      Engine.camera.position.copy(p);

      Engine.camera.zoom = 1 - t * .5;

      Engine.rubik.container.rotateY(.01);
      Engine.rubik.container.rotateX(.01);

      Engine.camera.lookAt(new THREE.Vector3(0, 0, 0));

  }, 
  function(){
    Engine.buildingMaterial.uniforms.animateHeight.value = 1;

    var speed = .5;

    var callback = function() {
      setTimeout(function(){
        Engine.rubik.animate(Engine.random.integer(0, 2), Engine.random.integer(0, 2), speed, callback, false);
      }, 1200);
    };

    Engine.rubik.animate(0, 0, speed, callback, true);
  }));

  // BIG DROP
  Engine.cameraControllers.push(new Camera.CameraController(1.4, function(t) {
      var direction = new THREE.Vector3(0, 0, 1);
      var p = new THREE.Vector3(40, 40, 40);
      Engine.camera.position.copy(p);

      Engine.camera.zoom = 1 + Math.floor(t * 4.0) * .25;

      Engine.rubik.container.rotateY(.01);
      Engine.rubik.container.rotateX(.01);

      Engine.camera.lookAt(new THREE.Vector3(0, 0, 0));

      var sobel = Math.sin(t * Math.PI * 2 * 8.0);

      if(sobel > 0)
        Engine.currentPass = Engine.sobelPass;
      else
        Engine.currentPass = null;
  }, 
  function(){
    Engine.buildingMaterial.uniforms.animateHeight.value = 1;

    var speed = .2;

    var callback = function() {
      Engine.rubik.animate(Engine.random.integer(0, 2), Engine.random.integer(0, 2), speed, callback, false);
    };

    Engine.rubik.animate(0, 0, speed, callback, true);
  }));

  // MAIN SECTION, INTRODUCTION OF RUBIK+PASS CHANGE
  Engine.cameraControllers.push(new Camera.CameraController(28.7, function(t) {
      var direction = new THREE.Vector3(0, 0, 1);
      var p = new THREE.Vector3(40, 40, 40);
      Engine.camera.position.copy(p);

      Engine.camera.zoom = 1 + Math.pow(Math.abs(Math.sin(t * 31.5 * Math.PI * 2)), 15) * .05;;

      Engine.rubik.container.rotateY(-.01);
      Engine.rubik.container.rotateX(-.01);

      Engine.camera.lookAt(new THREE.Vector3(0, 0, 0));
  }, 
  function(){
    Engine.buildingMaterial.uniforms.animateHeight.value = 1;

    var speed = .25;
    var pass = 0;

    var callback = function() {
      setTimeout(function(){

        pass = (pass == 3 ? 0 : pass + 1);

        if(pass == 0)
          Engine.currentPass = null;
        else if(pass == 1)
          Engine.currentPass = Engine.sobelPass;        
        else if(pass == 2)
          Engine.currentPass = Engine.glitchPass;
        else
          Engine.currentPass = Engine.glarePass;

        Engine.rubik.animate(Engine.random.integer(0, 2), Engine.random.integer(0, 2), speed, callback, false);
      }, 400);
    };

    Engine.rubik.animate(0, 0, speed, callback, true);
  }));

  // SLOW DOWN CAMERA 1
  Engine.cameraControllers.push(new Camera.CameraController(8, function(t) {
      var direction = new THREE.Vector3(0, 0, 1);
      var p = new THREE.Vector3(7,7,0).add(direction.multiplyScalar(t * -.2));
      Engine.camera.position.copy(p);

      Engine.camera.zoom = 1;
      Engine.buildingMaterial.uniforms.animateHeight.value = 0;

      Engine.camera.lookAt(new THREE.Vector3(2, 1, 1 - t * .3));
  }, 
  function(){
    Engine.rubik.reset();
    Engine.rubik.forceDisable = true;
  }));

  // // SLOW DOWN CAMERA 2
  // Engine.cameraControllers.push(new Camera.CameraController(8, function(t) {
  //     var direction = new THREE.Vector3(0, 0, 1);
  //     var p = new THREE.Vector3(7,-7,0).add(direction.multiplyScalar(t * -.2));
  //     Engine.camera.position.copy(p);

  //     Engine.camera.zoom = 1;
  //     Engine.buildingMaterial.uniforms.animateHeight.value = 0;

  //     Engine.camera.lookAt(new THREE.Vector3(0, 2, 1 - t * .3));
  // }));

  // SLOW DOWN CAMERA 3
  Engine.cameraControllers.push(new Camera.CameraController(8, function(t) {
      var direction = new THREE.Vector3(0, 0, 1);
      var p = new THREE.Vector3(7,4,-4).add(direction.multiplyScalar(t * -.2));
      Engine.camera.position.copy(p);

      Engine.camera.zoom = 1;
      Engine.buildingMaterial.uniforms.animateHeight.value = 0;

      Engine.camera.lookAt(new THREE.Vector3(0, 1, 2 - t * .3));
  }));

  // SLOW DOWN CAMERA 2
  Engine.cameraControllers.push(new Camera.CameraController(6, function(t) {
      var direction = new THREE.Vector3(0, 0, 1);
      var p = new THREE.Vector3(7,-4,0).add(direction.multiplyScalar(t * -.2));
      Engine.camera.position.copy(p);

      Engine.camera.zoom = 1;
      Engine.buildingMaterial.uniforms.animateHeight.value = 0;

      Engine.camera.lookAt(new THREE.Vector3(0, -2, 1 - t * .3));
  }));


   // SLOW DOWN CAMERA 1
  Engine.cameraControllers.push(new Camera.CameraController(9.75, function(t) {
      var direction = new THREE.Vector3(0, 0, 1);
      var p = new THREE.Vector3(-4,7,0).add(direction.multiplyScalar(t * -.2));
      Engine.camera.position.copy(p);

      Engine.camera.zoom = 1;
      Engine.buildingMaterial.uniforms.animateHeight.value = 0;

      Engine.camera.lookAt(new THREE.Vector3(-2, 1, 1 - t * .3));
  }, 
  function(){
  }));

  // MAIN SECTION, INTRODUCTION OF RUBIK+PASS CHANGE
  Engine.cameraControllers.push(new Camera.CameraController(58.0, function(t) {
      var direction = new THREE.Vector3(0, 0, 1);
      var p = new THREE.Vector3(40, 40, 40);
      Engine.camera.position.copy(p);

      Engine.camera.zoom = 1 + Math.pow(Math.abs(Math.sin(t * 60.5 * Math.PI * 2)), 15) * .05;;

      Engine.rubik.container.rotateY(-.01);
      Engine.rubik.container.rotateX(-.01);

      Engine.camera.lookAt(new THREE.Vector3(0, 0, 0));
  }, 
  function(){
    Engine.buildingMaterial.uniforms.animateHeight.value = 1;

    Engine.rubik.forceDisable = false;
    var speed = .25;
    var pass = 0;

    var callback = function() {
      setTimeout(function(){

        pass = (pass == 3 ? 0 : pass + 1);

        if(pass == 0)
          Engine.currentPass = null;
        else if(pass == 1)
          Engine.currentPass = Engine.sobelPass;        
        else if(pass == 2)
          Engine.currentPass = Engine.glitchPass;
        else
          Engine.currentPass = Engine.glarePass;

        Engine.rubik.animate(Engine.random.integer(0, 2), Engine.random.integer(0, 2), speed, callback, false);
      }, 400);
    };

    Engine.rubik.animate(0, 0, speed, callback, true);
  }));

   // END CAMERA
  Engine.cameraControllers.push(new Camera.CameraController(.75, function(t) {      
      var scale = THREE.Math.smoothstep(1.0 - t, 0.0, 1.0);
      Engine.rubik.container.scale.set(scale, scale, scale);
  }, 
  function(){
  }));

  setActiveCamera(0);
}

function loadShaderMaterial(shaderName, uniforms)
{
  var mat = new THREE.ShaderMaterial({
        uniforms: uniforms,
        vertexShader: require("./shaders/" + shaderName + ".vert.glsl"),
        fragmentShader: require("./shaders/" + shaderName + ".frag.glsl")
  });

  Engine.materials.push(mat);

  return mat;
}

function makeBackgroundMaterial(mat)
{
    mat.depthWrite = false;
    mat.depthTest = false;
}

function makeMaterialAdditive(material)
{
    material.transparent = true;

    material.blending = THREE.CustomBlending;
    material.blendEquation = THREE.AddEquation;
    material.blendSrc = THREE.OneFactor;
    material.blendDst = THREE.OneFactor;

    material.depthTest = false;
    material.depthWrite = false;
}

function loadBackgrounds()
{   
  var bgGeo = new THREE.PlaneGeometry(1,1,1,1);

  var initialMaterial = loadShaderMaterial("backgrounds/initial", {
    time: { type: "f", value : 0.0 }
  });
  makeBackgroundMaterial(initialMaterial);

  var polkaMaterial = loadShaderMaterial("backgrounds/polka", {
    time: { type: "f", value : 0.0 },
    ASPECT_RATIO: { type: "f", value : 1.0 }
  });
  makeBackgroundMaterial(polkaMaterial)

  var initialMesh = new THREE.Mesh(bgGeo, initialMaterial);
  initialMesh.renderOrder = -10;

  initialMesh.onBeforeRender = function() {
    if(Engine.time > 40)
    {
      initialMesh.material = polkaMaterial;
    }
  }

  Engine.scene.add(initialMesh);

  var introOverlayMaterial = loadShaderMaterial("overlays/opening_overlay", {
    time: { type: "f", value : 0.0 }
  });

  // Multiply
  introOverlayMaterial.blending = THREE.CustomBlending;
  introOverlayMaterial.blendEquation = THREE.AddEquation;
  introOverlayMaterial.blendSrc = THREE.DstColorFactor;
  introOverlayMaterial.blendDst = THREE.SrcColorFactor;

  introOverlayMaterial.depthFunc = THREE.AlwaysDepth;
  introOverlayMaterial.depthWrite = false;
  introOverlayMaterial.depthTest = false;
  introOverlayMaterial.side = THREE.DoubleSide;
  introOverlayMaterial.transparent = true;
  introOverlayMaterial.renderOrder = 15;

  var openingMesh = new THREE.Mesh(bgGeo, introOverlayMaterial);

  openingMesh.onBeforeRender = function(){
    if(Engine.time > 8.0)
      openingMesh.visible = false;
  };
  Engine.scene.add(openingMesh);

  // Vignette
  var vignetteMaterial = loadShaderMaterial("overlays/vignette", {
    time: { type: "f", value : 0.0 },
    SCREEN_SIZE: { type: "2fv", value : new THREE.Vector2( 1, 1 ) },
    vignette: { type: "t", value: THREE.ImageUtils.loadTexture("./images/vignette.png")}
  });

  // Multiply
  vignetteMaterial.blending = THREE.CustomBlending;
  vignetteMaterial.blendEquation = THREE.AddEquation;
  vignetteMaterial.blendSrc = THREE.DstColorFactor;
  vignetteMaterial.blendDst = THREE.SrcColorFactor;

  vignetteMaterial.depthFunc = THREE.AlwaysDepth;
  vignetteMaterial.depthWrite = false;
  vignetteMaterial.depthTest = false;
  vignetteMaterial.side = THREE.DoubleSide;
  vignetteMaterial.transparent = true;
  vignetteMaterial.renderOrder = 15;

  var vignetteMesh = new THREE.Mesh(bgGeo, vignetteMaterial);
  vignetteMesh.frustumCulled = false;

  vignetteMesh.onBeforeRender = function(){
    if(Engine.currentPass === Engine.sobelPass)
      vignetteMesh.visible = false;
    else
      vignetteMesh.visible = true;
  };
  Engine.scene.add(vignetteMesh);
}

function loadFakeBox()
{
  var boxGeo = new THREE.BoxGeometry( 3, 3, 3 );
  var material = loadShaderMaterial("fakeBox",{
    time: { type: "f", value : 0.0 }
  });
  var mesh = new THREE.Mesh(boxGeo, material);

  Engine.fakeBox = mesh;

  Engine.scene.add(mesh);
}

function loadBuildings()
{
  Engine.buildingMaterial = loadShaderMaterial("building", {
    time: { type: "f", value : 0.0 },
    animateHeight: { type: "f", value : 1.0 }
  });

  // Engine.buildingMaterial.side = THREE.DoubleSide;
  Engine.buildingMaterial.vertexColors = THREE.VertexColors;

  var city = new City.Generator();
  var cityBlocks = city.build(Engine.scene, Engine.buildingMaterial);
  Engine.rubik.attachShapesToFace(cityBlocks);
}

function onLoad(framework) 
{
  var scene = framework.scene;
  var camera = framework.camera;
  var renderer = framework.renderer;
  var gui = framework.gui;
  var stats = framework.stats;

  // Init Engine stuff
  Engine.scene = scene;
  Engine.renderer = renderer;
  Engine.clock = new THREE.Clock();
  Engine.camera = camera;
  Engine.currentPass = null;

  Engine.glarePass = Glare.GlarePass(renderer, scene, camera);
  Engine.sobelPass = Sobel.MainPass(renderer, scene, camera);
  Engine.glitchPass = Glitch.MainPass(renderer, scene, camera);
  Engine.passes.push(Engine.glarePass);
  Engine.passes.push(Engine.sobelPass);
  Engine.passes.push(Engine.glitchPass);

  // Very important to set clear color alpha to 0, 
  // so that effects can use that vaue as an additional parameter!
  renderer.setClearColor(new THREE.Color(.4, .75, .95), 0);

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
  camera.far = 200;
  camera.updateProjectionMatrix();

  loadBackgrounds();
  loadFakeBox();

  Engine.rubik = new Rubik.Rubik();
  var rubikMesh = Engine.rubik.build();

  loadBuildings();
  scene.add(rubikMesh);

  Engine.random = new Random(Random.engines.mt19937().seed(14041956));


  loadMusic();

  loadCameraControllers();
}

function onResize(framework)
{
  console.log("resize")
  for (var i = 0; i < Engine.passes.length; i++)
    Engine.passes[i].resize();
}

// called on frame updates
function onUpdate(framework) 
{
  if(Engine.initialized)
  {
    var screenSize = new THREE.Vector2( framework.renderer.getSize().width, framework.renderer.getSize().height );
    var aspectRatio = screenSize.y / screenSize.x;
    var deltaTime = Engine.clock.getDelta();

    Engine.time += deltaTime;
    Engine.cameraTime += deltaTime;
    Engine.deltaTime = deltaTime;

    Engine.rubik.update(deltaTime);

    // Update materials code
    for (var i = 0; i < Engine.materials.length; i++)
    {
      var material = Engine.materials[i];

      material.uniforms.time.value = Engine.time;

      if(material.uniforms["SCREEN_SIZE"] != null)
        material.uniforms.SCREEN_SIZE.value = screenSize;

      if(material.uniforms["ASPECT_RATIO"] != null)
        material.uniforms.ASPECT_RATIO.value = aspectRatio;
    }

    // Update passes code
    for (var i = 0; i < Engine.passes.length; i++)
    {
      var pass = Engine.passes[i];

      if(pass.uniforms["time"] != null)
        pass.uniforms.time.value = Engine.time;

      if(pass.uniforms["SCREEN_SIZE"] != null)
        pass.uniforms.SCREEN_SIZE.value = screenSize;

      if(pass.uniforms["ASPECT_RATIO"] != null)
        pass.uniforms.ASPECT_RATIO.value = aspectRatio;
    }

    updateCamera();

    if(Engine.currentPass != null)
      Engine.currentPass.render();
    else
      Engine.renderer.render(Engine.scene, Engine.camera);
  }
}

Framework.init(onLoad, onUpdate, onResize);
