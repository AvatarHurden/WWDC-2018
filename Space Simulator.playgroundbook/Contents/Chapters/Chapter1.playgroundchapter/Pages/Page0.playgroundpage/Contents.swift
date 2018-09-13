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
 # Welcome to Space Simulator
 
 This Playground allows creating anything from simple planet-moon systems to entire solar systems.
 
 * Note: You can move around the simulation by dragging and pinching. If you need to reset the camera position, just double tap.
 
 Below is a quick example and tutorial on what can be done in this simulator.
 
 # Tutorial
 
 The first important parameter of a simulation is its [speed](glossary://simulation%20speed).
 */
//#-code-completion(everything, hide)
//#-code-completion(identifier, show, second, hour, day, month, year)
simulationSpeed = /*#-editable-code speed*/1.day/*#-end-editable-code*/
//#-code-completion(identifier, hide, second, hour, day, month, year)

/*:
 Bodies in a simulation can be enlarged or shown in [scale](glossary://scale).
 */
//#-code-completion(everything, hide)
//#-code-completion(identifier, show, true, false)
enlargePlanets = /*#-editable-code*/true/*#-end-editable-code*/
//#-code-completion(identifier, hide, true, false)

/*:
 In this example, we [create](glossary://creating) and add Earth to the simulation, using it as the [anchor](glossary://anchor).
 */
let earth = Earth()
add(earth)
anchor(to: earth)

/*:
 Next, we add the Moon, specifying the [distance](glossary://distance), [orbit speed](glossary://speed) and (optionally) [mass](glossary://mass).
 */
let moon = Moon()
//#-code-completion(everything, hide)
//#-code-completion(identifier, show, kg, earthMass, moonMass)
moon.mass = /*#-editable-code*/1.moonMass/*#-end-editable-code*/
//#-code-completion(identifier, hide, kg, earthMass, moonMass)
//#-code-completion(everything, hide)
//#-code-completion(identifier, show, meter, km, moonDistance, astronomicalUnit)
moon.distance = /*#-editable-code speed*/1.moonDistance/*#-end-editable-code*/
//#-code-completion(identifier, hide, meter, km, moonDistance, astronomicalUnit)
//#-code-completion(everything, hide)
//#-code-completion(identifier, show, meterPerSecond, kmPerSecond, kmPerHour, moonOrbit)
moon.orbitSpeed = /*#-editable-code speed*/1.moonOrbit/*#-end-editable-code*/
//#-code-completion(identifier, hide, meterPerSecond, kmPerSecond, kmPerHour, moonOrbit)
add(moon)

/*:
 You can change what planet the camera is centered on by using the `follow(:)` function.
 */
//#-code-completion(everything, hide)
//#-code-completion(identifier, show, earth, moon)
follow(/*#-editable-code speed*/earth/*#-end-editable-code*/)
//#-code-completion(identifier, hide, earth, moon)

/*:
 # Sandboxes
 
 With the tutorial out of the way, there are 4 sandboxes for you to experiment and test your new skills!
 
 * [Earth and Moon](Earth%20and%20Moon)
 * [Solar System](Solar%20System)
 * [Binary Stars](Binary%20Stars)
 * [Unstable Binary Stars](Unstable%20Binary%20Stars)
 ----
 # Credits
 
 To make this playground possible, the following resources were used:
 
 * Planet textures from [Planet Pixel Emporium](http://planetpixelemporium.com/)
 * Space background from artist [StumpyStrust](https://opengameart.org/users/stumpystrust)
 * "The Cosmos" - song by [hjhkbn](https://www.newgrounds.com/audio/listen/715134)
 
 */
//#-hidden-code
listener.sendValues()
//#-end-hidden-code


