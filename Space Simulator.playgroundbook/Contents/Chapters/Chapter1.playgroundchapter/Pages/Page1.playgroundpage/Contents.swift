//#-hidden-code
import SceneKit
import PlaygroundSupport
let proxy = PlaygroundPage.current.liveView as! PlaygroundRemoteLiveViewProxy

let listener = MyClassThatListens(proxy)
proxy.delegate = listener

scale = 1.earthRadius
initialOrthographicScale = 100
initialCameraRotation = SCNVector3(-Float.pi/16, Float.pi/2, 0)
//#-end-hidden-code
/*:
# Our Home and its Satellite
This is the same simulation as in the tutorial, but now you are free to edit anything you'd like!
 * Experiment: Move the moon a little further from the earth (e.g `1.2.moonDistance`).
 
    What happens to its orbit?
 */
//#-editable-code
simulationSpeed = 1.day
enlargePlanets = true

let earth = Earth()
earth.mass = 1.earthMass
add(earth)
anchor(to: earth)

let moon = Moon()
moon.distance = 1.moonDistance
moon.orbitSpeed = 1.moonOrbit

add(moon)

follow(earth)
//#-end-editable-code
//#-hidden-code
listener.sendValues()
//#-end-hidden-code


