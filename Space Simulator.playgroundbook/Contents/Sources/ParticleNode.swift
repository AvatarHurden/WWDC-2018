//
//  ParticleNode.swift
//  FourierTransform
//
//  Created by Arthur Vedana on 14/03/18.
//  Copyright © 2018 Arthur Vedana. All rights reserved.
//

import Foundation
import SpriteKit
import SceneKit

public enum Direction {
    case clockwise, counterclockwise
    
    var multiplier: Double {
        switch self {
        case .clockwise: return -1
        case .counterclockwise: return 1
        }
    }
    
}

public class ParticleNode {
    
    var particle: Particle
    var node: SCNNode
    
    public var radius: Distance
    public var rotationTime: Time
    public var rotationDirection: Direction
    
   public var mass: Mass {
        get {
            return particle.mass
        }
        set {
            particle.mass = newValue
        }
    }
    
    public var position: Position {
        get {
            return particle.position
        }
        set {
            particle.position = newValue
        }
    }
    public var distance: Distance {
        get {
            return position.x
        }
        set {
            position = Position(x: newValue, y: 0.meter)
        }
    }
    
    public var velocity: Velocity {
        get {
            return particle.velocity
        }
        set {
            particle.velocity = newValue
        }
    }
    public var orbitSpeed: Speed {
        get {
            return velocity.y
        }
        set {
            velocity = Velocity(x: 0.meterPerSecond, y: newValue)
        }
    }
    
    var geometry: SCNSphere
    let particles: SCNParticleSystem
    
    init(with particle: Particle, radius: Distance = 1.earthRadius, rotation: Time = 86400.second, rotationDirection: Direction = .clockwise) {
        self.particle = particle
        self.radius = radius
        self.rotationTime = rotation
        self.rotationDirection = rotationDirection
        self.geometry = SCNSphere(radius: CGFloat(radius.doubleValue))
        self.node = SCNNode(geometry: geometry)
        self.particles = SCNParticleSystem()
        
        self.node.categoryBitMask = 0x1
    }
    
}

public class Planet: ParticleNode {
    
    init(texture: UIImage, radius: Distance) {
        self.color = .white
        let pos = Position(x: 0.km, y: 0.km)
        let vel = Velocity(x: 0.meterPerSecond, y: 0.meterPerSecond)
        let p = Particle(mass: 0.kg, position: pos, velocity: vel)
        
        super.init(with: p, radius: radius, rotation: 1.day, rotationDirection: .clockwise)
        
        let a = SCNMaterial()
        a.diffuse.contents = texture
        self.node.geometry?.materials = [a]
        
        self.particles.emittingDirection = SCNVector3(0, 0, 0)
        self.particles.birthRate = 200
        self.particles.particleLifeSpan = 100
        self.particles.particleSize = CGFloat(0.2 * radius.doubleValue)
        
        self.particles.particleColor = UIColor(white: 1, alpha: 0.1)
        
        self.particles.birthDirection = .constant
        self.particles.birthLocation = .vertex
        
        self.node.addParticleSystem(self.particles)
        
    }
    
    public var color: UIColor
    
    public init(radius: Distance, color: UIColor = .white) {
        let pos = Position(x: 0.km, y: 0.km)
        let vel = Velocity(x: 0.meterPerSecond, y: 0.meterPerSecond)
        let p = Particle(mass: 0.kg, position: pos, velocity: vel)
        self.color = color
        
        super.init(with: p, radius: radius, rotation: 1.day, rotationDirection: .clockwise)
        
        let material = SCNMaterial()
        material.diffuse.contents = color
        self.node.geometry?.materials = [material]
        
        self.particles.emittingDirection = SCNVector3(0, 0, 0)
        self.particles.birthRate = 50
        self.particles.particleLifeSpan = 30
        self.particles.particleSize = CGFloat(0.2 * radius.doubleValue)
        
        self.particles.particleColor = UIColor(white: 1, alpha: 0.1)
        
        self.particles.birthDirection = .constant
        self.particles.birthLocation = .vertex
        
        self.node.addParticleSystem(self.particles)
    }
    
}

public class Sun: Planet {
    
    public init() {
        super.init(texture: #imageLiteral(resourceName: "sunmap.jpg"), radius: 1.solarRadius)
        
        self.mass = 1.solarMass
        self.rotationTime = 24.47.day
        self.rotationDirection = .counterclockwise
        
        self.node.removeParticleSystem(self.particles)
        
        //        let light = SCNLight()
        //        light.type = .omni
        //        light.intensity = 1000
        //        light.castsShadow = true
        //        light.zFar = 1000000
        //        light.categoryBitMask = 0x1
        //
        //        self.node.light = light
        //        self.node.categoryBitMask = 0x2
        //        light.zNear = CGFloat(30.solarRadius.doubleValue)
        //        //light.categoryBitMask = 0
        //
        //        let sunLightNode = SCNNode()
        ////        sunLightNode.position = self.node.position
        //        self.node.addChildNode(sunLightNode)
        //        sunLightNode.light = light
        //        self.node.castsShadow = true
        //
        //        self.node.categoryBitMask = 0x10
        
        //        let sunLight = SCNLight()
        //        sunLight.type = .ambient
        //        sunLight.categoryBitMask = 0x0
        
        //        let sunLightNode = SCNNode()
        //        sunLightNode.light = sunLight
        
        //        self.node.addChildNode(sunLightNode)
        //        self.node.categoryBitMask = 2
        //        self.node.castsShadow = false
    }
    
}

extension Numerical {
    
    public var mercuryRadius: Distance {
        return Distance(self.doubleValue * 2_439_700)
    }
    
    public var mercuryMass: Mass {
        return Mass(self.doubleValue * 0.33011E24)
    }
    
    public var mercuryDistance: Distance {
        return Distance(self.doubleValue * 46E9)
    }
    
    public var mercuryOrbit: Speed {
        return Speed(self.doubleValue * 58_980)
    }
}

public class Mercury: Planet {
    
    public init() {
        super.init(texture: #imageLiteral(resourceName: "mercurymap.jpg"), radius: 1.mercuryRadius)
        
        self.mass = 1.mercuryMass
        self.rotationTime = 1407.6.hour
        self.rotationDirection = .counterclockwise
        
    }
    
}

extension Numerical {
    
    public var earthRadius: Distance {
        return Distance(self.doubleValue * 6_371_000)
    }
    
    public var earthMass: Mass {
        return Mass(self.doubleValue * 5.97249E24)
    }
    
    public var earthDistance: Distance {
        return Distance(self.doubleValue * 147.09E9)
    }
    
    public var earthOrbit: Speed {
        return Speed(self.doubleValue * 30_290)
    }
}

public class Earth: Planet {
    
    public init() {
        super.init(texture: #imageLiteral(resourceName: "earthmap1k.jpg"), radius: 1.earthRadius)
        
        self.mass = 1.earthMass
        self.rotationTime = 86400.second
        self.rotationDirection = .counterclockwise
    }
    
}

extension Numerical {
    
    public var moonRadius: Distance {
        return Distance(self.doubleValue * 1_737_400)
    }
    
    public var moonMass: Mass {
        return Mass(self.doubleValue * 7.346E22)
    }
    
    public var moonDistance: Distance {
        return Distance(self.doubleValue * 0.3633E9)
    }
    
    public var moonOrbit: Speed {
        return Speed(self.doubleValue * 1082)
    }
}

public class Moon: Planet {
    
    public init() {
        super.init(texture: #imageLiteral(resourceName: "2k_moon.jpg"), radius: 1.moonRadius)
        
        self.mass = 1.moonMass
        self.rotationTime = 27.3217.day
        self.rotationDirection = .clockwise
    }
    
}

extension Numerical {
    
    public var venusRadius: Distance {
        return Distance(self.doubleValue * 6051.8E3)
    }
    
    public var venusMass: Mass {
        return Mass(self.doubleValue * 4.8675E24)
    }
    
    public var venusDistance: Distance {
        return Distance(self.doubleValue * 107.48E9)
    }
    
    public var venusOrbit: Speed {
        return Speed(self.doubleValue * 35_260)
    }
}

public class Venus: Planet {
    
    public init() {
        super.init(texture: #imageLiteral(resourceName: "venusmap.jpg"), radius: 1.venusRadius)
        
        self.mass = 1.venusMass
        self.rotationTime = 2802.0.hour
        self.rotationDirection = .counterclockwise
    }
    
}

extension Numerical {
    
    public var marsRadius: Distance {
        return Distance(self.doubleValue * 3396.2E3)
    }
    
    public var marsMass: Mass {
        return Mass(self.doubleValue * 0.64171E24)
    }
    
    public var marsDistance: Distance {
        return Distance(self.doubleValue * 206.62E9)
    }
    
    public var marsOrbit: Speed {
        return Speed(self.doubleValue * 26_500)
    }
}

public class Mars: Planet {
    public init() {
        super.init(texture: #imageLiteral(resourceName: "mars_1k_color.jpg"), radius: 1.marsRadius)
        
        self.mass = 1.marsMass
        self.rotationTime = 24.6229.hour
        self.rotationDirection = .counterclockwise
    }
}

extension Numerical {
    
    public var jupiterRadius: Distance {
        return Distance(self.doubleValue * 66854E3)
    }
    
    public var jupiterMass: Mass {
        return Mass(self.doubleValue * 1898.19E24)
    }
    
    public var jupiterDistance: Distance {
        return Distance(self.doubleValue * 740.52E9)
    }
    
    public var jupiterOrbit: Speed {
        return Speed(self.doubleValue * 13_720)
    }
}

public class Jupiter: Planet {
    public init() {
        super.init(texture: #imageLiteral(resourceName: "jupitermap.jpg"), radius: 1.jupiterRadius)
        
        self.mass = 1.jupiterMass
        self.rotationTime = 9.9259.hour
        self.rotationDirection = .counterclockwise
    }
}

extension Numerical {
    
    public var saturnRadius: Distance {
        return Distance(self.doubleValue * 54_364E3)
    }
    
    public var saturnMass: Mass {
        return Mass(self.doubleValue * 568.34E24)
    }
    
    public var saturnDistance: Distance {
        return Distance(self.doubleValue * 1_352.55E9)
    }
    
    public var saturnOrbit: Speed {
        return Speed(self.doubleValue * 10_180)
    }
}

public class Saturn: Planet {
    public init() {
        super.init(texture: #imageLiteral(resourceName: "saturnmap.jpg"), radius: 1.saturnRadius)
        
        self.mass = 1.saturnMass
        self.rotationTime = 10.656.hour
        self.rotationDirection = .counterclockwise
    }
}

extension Numerical {
    
    public var uranusRadius: Distance {
        return Distance(self.doubleValue * 24_973E3)
    }
    
    public var uranusMass: Mass {
        return Mass(self.doubleValue * 86.813E24)
    }
    
    public var uranusDistance: Distance {
        return Distance(self.doubleValue * 2_741.30E9)
    }
    
    public var uranusOrbit: Speed {
        return Speed(self.doubleValue * 7_110)
    }
}

public class Uranus: Planet {
    public init() {
        super.init(texture: #imageLiteral(resourceName: "uranusmap.jpg"), radius: 1.uranusRadius)
        
        self.mass = 1.uranusMass
        self.rotationTime = 17.24.hour
        self.rotationDirection = .clockwise
    }
}

extension Numerical {
    
    public var neptuneRadius: Distance {
        return Distance(self.doubleValue * 24_764E3)
    }
    
    public var neptuneMass: Mass {
        return Mass(self.doubleValue * 102.413E24)
    }
    
    public var neptuneDistance: Distance {
        return Distance(self.doubleValue * 4_444.45E9)
    }
    
    public var neptuneOrbit: Speed {
        return Speed(self.doubleValue * 5_500)
    }
}

public class Neptune: Planet {
    public init() {
        super.init(texture: #imageLiteral(resourceName: "neptunemap.jpg"), radius: 1.neptuneRadius)
        
        self.mass = 1.neptuneMass
        self.rotationTime = 16.11.hour
        self.rotationDirection = .counterclockwise
    }
}

extension Numerical {
    
    public var plutoRadius: Distance {
        return Distance(self.doubleValue * 1187E3)
    }
    
    public var plutoMass: Mass {
        return Mass(self.doubleValue * 0.01303E24)
    }
    
    public var plutoDistance: Distance {
        return Distance(self.doubleValue * 7375.93E9)
    }
    
    public var plutoOrbit: Speed {
        return Speed(self.doubleValue * 3_710)
    }
}

public class Pluto: Planet {
    public init() {
        super.init(texture: #imageLiteral(resourceName: "plutomap1k.jpg"), radius: 1.plutoRadius)
        
        self.mass = 1.plutoMass
        self.rotationTime = 153.2820.hour
        self.rotationDirection = .counterclockwise
    }
}

