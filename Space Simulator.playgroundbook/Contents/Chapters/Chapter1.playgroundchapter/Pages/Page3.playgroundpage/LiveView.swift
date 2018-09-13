//#-hidden-code
import SceneKit

setup()

scaleLive = 1.solarRadius

//#-end-hidden-code
//#-editable-code
simulationSpeedLive = 10.day
enlargePlanetsLive = true

let star1 = Planet(radius: 1.solarRadius, color: #colorLiteral(red: 0.968627452850342, green: 0.780392169952393, blue: 0.345098048448563, alpha: 1.0))
star1.mass = 1.solarMass
star1.distance = -1.astronomicalUnit
star1.orbitSpeed = -25.kmPerSecond
addLive(star1)

let star2 = Planet(radius: 1.solarRadius, color: #colorLiteral(red: 0.7450980544, green: 0.1568627506, blue: 0.07450980693, alpha: 1))
star2.mass = 1.solarMass
star2.distance = 1.astronomicalUnit
star2.orbitSpeed = 25.kmPerSecond
addLive(star2)

//#-end-editable-code
//#-hidden-code
initialOrthographicScaleLive = 1000
initialCameraRotationLive = SCNVector3(-Float.pi/16, 0, 0)
endSetup()
//#-end-hidden-code


