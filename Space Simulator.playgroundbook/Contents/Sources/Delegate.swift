import PlaygroundSupport
import SceneKit

public var simulationSpeed: Time = 1.day
public var enlargePlanets: Bool = true
public var scale: Distance = 1.earthRadius
public var initialOrthographicScale: Double = 100
public var initialCameraRotation: SCNVector3 = SCNVector3(-Float.pi/16, Float.pi/2, 0)

var followedIndex: Int?
var anchorIndex: Int?

var planets: [ParticleNode] = []

public func add(_ particle: ParticleNode) {
    planets.append(particle)
}

public func anchor(to particle: ParticleNode) {
    anchorIndex = planets.index(where: { $0 === particle })
}

public func follow(_ particle: ParticleNode) {
    followedIndex = planets.index(where: { $0 === particle })
}

public class MyClassThatListens: PlaygroundRemoteLiveViewProxyDelegate {
    
    let proxy: PlaygroundRemoteLiveViewProxy
    
    public init(_ proxy: PlaygroundRemoteLiveViewProxy) {
        self.proxy = proxy
    }
    
    public func remoteLiveViewProxyConnectionClosed(_ remoteLiveViewProxy: PlaygroundRemoteLiveViewProxy) {
        
    }
    
    public func sendValues() {
        
        let planetArray = planets.map { node -> PlaygroundValue in
            
            let typeString: String = String(describing: type(of: node))
            
            var dict: [String: PlaygroundValue] =
                ["position": .array([
                    .floatingPoint(node.position.x.doubleValue),
                    .floatingPoint(node.position.y.doubleValue)]),
                 "velocity": .array([
                    .floatingPoint(node.velocity.x.doubleValue),
                    .floatingPoint(node.velocity.y.doubleValue)]),
                 "mass": .floatingPoint(node.mass.doubleValue),
                 "type": .string(typeString)
            ]
            
            if let node = node as? Planet, typeString == "Planet" {
                dict["radius"] = .floatingPoint(node.radius.doubleValue)
                
                var r: CGFloat = 0
                var g: CGFloat = 0
                var b: CGFloat = 0
                var a: CGFloat = 0
                node.color.getRed(&r, green: &g, blue: &b, alpha: &a)
                
                dict["color"] = .array([
                    .floatingPoint(Double(r)),
                    .floatingPoint(Double(g)),
                    .floatingPoint(Double(b)),
                    .floatingPoint(Double(a))])
            }
            
            return .dictionary(dict)
        }
        
        var dict: [String: PlaygroundValue] = (
            ["simulationSpeed": .floatingPoint(simulationSpeed.doubleValue),
             "enlargePlanets": .boolean(enlargePlanets),
             "scale": .floatingPoint(scale.doubleValue),
             "initialOrthographicScale": .floatingPoint(initialOrthographicScale),
             "initialCameraRotation": .array([
                .floatingPoint(Double(initialCameraRotation.x)),
                .floatingPoint(Double(initialCameraRotation.y)),
                .floatingPoint(Double(initialCameraRotation.z))]),
             "planets": .array(planetArray)
            ])
        
        if let followedIndex = followedIndex {
            dict["followedIndex"] = .integer(followedIndex)
        }
        if let anchorIndex = anchorIndex {
            dict["anchorIndex"] = .integer(anchorIndex)
        }
        
        proxy.send(PlaygroundValue.dictionary(dict))
    }
    
    public func remoteLiveViewProxy(_ remoteLiveViewProxy:
        PlaygroundRemoteLiveViewProxy,
                                    received message: PlaygroundValue) {
        print("received")
    }
}
