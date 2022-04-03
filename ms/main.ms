init = function()
  scene = new BABYLON.Scene()

  dsm = new BABYLON.DeviceSourceManager(scene.getEngine())
  
  camera = new BABYLON.UniversalCamera("UniversalCamera", 
              new BABYLON.Vector3(0, 0, -10), scene)
  camera.setTarget(BABYLON.Vector3.Zero())
  camera.attachControl()
  
  dlight = new BABYLON.DirectionalLight("light", 
              new BABYLON.Vector3(0, -1, 0), scene)
  dlight.shadowMinZ = 50
  dlight.shadowMaxZ = 1000
  shadows = new BABYLON.ShadowGenerator(2048, dlight)
  shadows.usePercentageCloserFiltering = true
  
  hlight = new BABYLON.HemisphericLight("light", 
              new BABYLON.Vector3(0, 1, 0), scene)
  
  local opt = object width=0.2 depth=1 height=0.25 end
  player = BABYLON.MeshBuilder.CreateBox("player", opt, scene)
  player.setParent(camera)
  player.position.set(0.5,-0.65,2)
  
  stage = BABYLON.Mesh.CreateBox("room", 100, scene, false, BABYLON.Mesh.BACKSIDE)
  local mat = new BABYLON.StandardMaterial("roomMat", scene)
  mat.diffuseColor.set(0.5,0.6,0.7)
  stage.material = mat
  stage.scaling.set(32,8,32)
  stage.checkCollisions = true
  stage.receiveShadows = true
  
  targets = []
  for i = 1 to 64
      local option = object diameter = 0.5 + random.next() end
      local sphere = BABYLON.MeshBuilder.CreateSphere("sphere"+i, option, scene)
      sphere.position.set(
            random.next()*64-32, 
            random.next()*16-8, 
            random.next()*64-32)
      local mat = new BABYLON.StandardMaterial("sphereMat", scene)
      mat.diffuseColor.set(random.next(), random.next(), random.next())
      sphere.material = mat
      shadows.getShadowMap().renderList.push(sphere)
      targets.push(sphere)
  end
  
  frameCount = 0
  lightFactor = 1
end

update = function()
  frameCount += 1
  lightFactor -= 0.001 * log(frameCount)
  lightFactor = BABYLON.Scalar.Clamp(lightFactor, 0, 1)
  dlight.intensity = hlight.intensity = lightFactor
  
  // No need to use babylon input system, microstudio api has input objects
  // local kb = dsm.getDeviceSource(BABYLON.DeviceType.Keyboard)
  // if (kb != 0) (kb.getInput(32) == 1) then
  
  if keyboard.release.SPACE then
    lightFactor += 0.1
  end
 
end

draw = function()
  screen.render(scene)
end