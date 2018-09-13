//#-hidden-code
import SceneKit

setup()

scaleLive = 1.solarRadius

//#-end-hidden-code
//#-editable-code
simulationSpeedLive = 20.day
enlargePlanetsLive = true

let sun = Sun()
addLive(sun)
anchorLive(to: sun)

let mercury = Mercury()
mercury.distance = 1.mercuryDistance
mercury.orbitSpeed = 1.mercuryOrbit
addLive(mercury)

let venus = Venus()
venus.distance = 1.venusDistance
venus.orbitSpeed = -1.venusOrbit
addLive(venus)

let earth = Earth()
earth.distance = 1.earthDistance
earth.orbitSpeed = 1.earthOrbit
addLive(earth)

let mars = Mars()
mars.distance = 1.marsDistance
mars.orbitSpeed = 1.marsOrbit
addLive(mars)

let jupiter = Jupiter()
jupiter.distance = 1.jupiterDistance
jupiter.orbitSpeed = 1.jupiterOrbit
addLive(jupiter)

let saturn = Saturn()
saturn.distance = 1.saturnDistance
saturn.orbitSpeed = 1.saturnOrbit
addLive(saturn)

let uranus = Uranus()
uranus.distance = 1.uranusDistance
uranus.orbitSpeed = -1.uranusOrbit
addLive(uranus)

let neptune = Neptune()
neptune.distance = 1.neptuneDistance
neptune.orbitSpeed = 1.neptuneOrbit
addLive(neptune)

let pluto = Pluto()
pluto.distance = 1.plutoDistance
pluto.orbitSpeed = 1.plutoOrbit
addLive(pluto)

followLive(sun)
//#-end-editable-code
//#-hidden-code
initialOrthographicScaleLive = 8000
initialCameraRotationLive = SCNVector3(-Float.pi/16, Float.pi/2, 0)
endSetup()
//#-end-hidden-code


