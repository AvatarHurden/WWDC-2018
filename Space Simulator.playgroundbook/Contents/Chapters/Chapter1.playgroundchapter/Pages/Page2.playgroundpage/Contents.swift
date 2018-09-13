//#-hidden-code
import SceneKit
import PlaygroundSupport
let proxy = PlaygroundPage.current.liveView as! PlaygroundRemoteLiveViewProxy

let listener = MyClassThatListens(proxy)
proxy.delegate = listener

scale = 1.solarRadius
initialOrthographicScale = 8000
initialCameraRotation = SCNVector3(-Float.pi/16, Float.pi/2, 0)
//#-end-hidden-code
/*:
 # The Sun and its Planets
 We can also simulate the whole solar system, with all of the 8 planets (plus Pluto, of course).
 
 * Experiment: Try doubling the sun's mass (`2.solarMass`).
 
    What happens to the orbits of the planets?
 */
//#-editable-code
simulationSpeed = 10.day
enlargePlanets = true

let sun = Sun()
sun.mass = 1.solarMass
add(sun)
anchor(to: sun)

let mercury = Mercury()
mercury.distance = 1.mercuryDistance
mercury.orbitSpeed = 1.mercuryOrbit
add(mercury)

let venus = Venus()
venus.distance = 1.venusDistance
venus.orbitSpeed = -1.venusOrbit
add(venus)

let earth = Earth()
earth.distance = 1.earthDistance
earth.orbitSpeed = 1.earthOrbit
add(earth)

let mars = Mars()
mars.distance = 1.marsDistance
mars.orbitSpeed = 1.marsOrbit
add(mars)

let jupiter = Jupiter()
jupiter.distance = 1.jupiterDistance
jupiter.orbitSpeed = 1.jupiterOrbit
add(jupiter)

let saturn = Saturn()
saturn.distance = 1.saturnDistance
saturn.orbitSpeed = 1.saturnOrbit
add(saturn)

let uranus = Uranus()
uranus.distance = 1.uranusDistance
uranus.orbitSpeed = -1.uranusOrbit
add(uranus)

let neptune = Neptune()
neptune.distance = 1.neptuneDistance
neptune.orbitSpeed = 1.neptuneOrbit
add(neptune)

let pluto = Pluto()
pluto.distance = 1.plutoDistance
pluto.orbitSpeed = 1.plutoOrbit
add(pluto)

follow(sun)

//#-end-editable-code
//#-hidden-code
listener.sendValues()
//#-end-hidden-code



