//#-hidden-code
import SceneKit

setup()

scaleLive = 1.earthRadius

//#-end-hidden-code
//#-editable-code
simulationSpeedLive = 1.day
enlargePlanetsLive = true

let earth = Earth()
addLive(earth)
anchorLive(to: earth)

let moon = Moon()
moon.distance = 1.moonDistance
moon.orbitSpeed = 1.moonOrbit

addLive(moon)

followLive(earth)
//#-end-editable-code
//#-hidden-code
initialOrthographicScaleLive = 100
initialCameraRotationLive = SCNVector3(-Float.pi/16, Float.pi/2, 0)
endSetup()
//#-end-hidden-code


