//
//  GameViewController.swift
//  FourierTransform
//
//  Created by Arthur Vedana on 13/03/18.
//  Copyright © 2018 Arthur Vedana. All rights reserved.
//

import SceneKit
import AVKit
import PlaygroundSupport

public class GameViewController: UIViewController {
    
    public var simulation: SimulationView!
    public var sceneView: SCNView!
    
    override public func loadView() {
        self.sceneView = SCNView()
        self.simulation.view = self.sceneView
        
        if let simulation = simulation {
            sceneView.scene = simulation.scene
            sceneView.delegate = simulation
            addMusic()
        }
        
        sceneView.backgroundColor = UIColor.black
        sceneView.play(nil)
        
        let pinch = UIPinchGestureRecognizer(target: self, action: #selector(pinched))
        sceneView.addGestureRecognizer(pinch)
        
        let pan = UIPanGestureRecognizer(target: self, action: #selector(panned))
        sceneView.addGestureRecognizer(pan)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapped))
        tap.numberOfTapsRequired = 2
        sceneView.addGestureRecognizer(tap)
        
        self.view = sceneView
        
    }
    
    func addMusic() {
//        self.sceneView.audioListener = self.simulation.cameraNode
//        
//        let source = SCNAudioSource(fileNamed: "music.m4a")!
//        source.isPositional = false
//        source.loops = true
//        source.volume = 1.0
//        source.shouldStream = true
//        
//        let player = SCNAudioPlayer(source: source)
//        self.simulation.cameraNode.addAudioPlayer(player)
    }
    
    public func insert(_ particle: ParticleNode) {
        self.simulation.add(particle: particle)
    }
    
    var oldScale: CGFloat = 1.0
    
    var oldY: CGFloat = 0
    var oldX: CGFloat = 0
}

extension GameViewController: PlaygroundLiveViewMessageHandler {
    
    public func liveViewMessageConnectionOpened() {
//        self.simulation.add(particle: particle)
    }
    
    public func receive(_ message: PlaygroundValue) {
        guard case let .dictionary(dict) = message else { return }
        if case let .boolean(enlarge)? = dict["enlargePlanets"] {
            self.simulation.toScale = !enlarge
        }
        if case let .floatingPoint(speed)? = dict["simulationSpeed"] {
            self.simulation.simulation.stepTime = speed.second / 60
        }
        if case let .floatingPoint(scale)? = dict["scale"] {
            self.simulation.scale = scale.meter
        }
        if case let .array(planets)? = dict["planets"] {
            simulation.deleteAll()
            planets.forEach { planet in
                guard case let .dictionary(dict) = planet else { return }
                guard case let .string(type)? = dict["type"] else { return }
                let planet: ParticleNode
                switch type {
                case "Sun": planet = Sun()
                case "Mercury": planet = Mercury()
                case "Venus": planet = Venus()
                case "Earth": planet = Earth()
                case "Moon": planet = Moon()
                case "Mars": planet = Mars()
                case "Jupiter": planet = Jupiter()
                case "Saturn": planet = Saturn()
                case "Uranus": planet = Uranus()
                case "Neptune": planet = Neptune()
                case "Pluto": planet = Pluto()
                default:
                    guard case let .floatingPoint(radius)? = dict["radius"],
                        case let .array(colors)? = dict["color"],
                        case let .floatingPoint(red) = colors[0],
                        case let .floatingPoint(green) = colors[1],
                        case let .floatingPoint(blue) = colors[2],
                        case let .floatingPoint(alpha) = colors[3] else { return }
                    planet = Planet(radius: radius.meter,
                                    color: UIColor(red: CGFloat(red), green: CGFloat(green), blue: CGFloat(blue), alpha: CGFloat(alpha)))
                }
                if case let .floatingPoint(mass)? = dict["mass"] {
                    planet.mass = mass.kg
                }
                if case let .array(positions)? = dict["position"] {
                    guard case let .floatingPoint(x) = positions[0],
                        case let .floatingPoint(y) = positions[1] else { return }
                    planet.position = Position(x: x.meter, y: y.meter)
                }
                if case let .array(velocities)? = dict["velocity"] {
                    guard case let .floatingPoint(x) = velocities[0],
                        case let .floatingPoint(y) = velocities[1] else { return }
                    planet.velocity = Velocity(x: x.meterPerSecond, y: y.meterPerSecond)
                }
                self.simulation.add(particle: planet)
            }
            simulation.running = true
        }
        if case let .integer(followed)? = dict["followedIndex"] {
            self.simulation.follow(self.simulation.particles[followed])
        }
        if case let .integer(anchored)? = dict["anchorIndex"] {
            self.simulation.simulation.anchorParticle = self.simulation.particles[anchored].particle
        }
        if case let .floatingPoint(orthoScale)? = dict["initialOrthographicScale"] {
            self.simulation.initialOrthographicScale = orthoScale
        }
        if case let .array(rotations)? = dict["initialCameraRotation"] {
            guard case let .floatingPoint(x) = rotations[0],
                case let .floatingPoint(y) = rotations[1],
                case let .floatingPoint(z) = rotations[2] else { return }
            self.simulation.initialCameraRotation = SCNVector3(x, y, z)
        }
        self.sceneView.prepare(sim.scene.rootNode, shouldAbortBlock: nil)
    }
    
}

extension GameViewController {
    
    @objc func tapped(_ sender: UITapGestureRecognizer) {
        self.simulation.reset()
    }
    
    @objc func panned(_ sender: UIPanGestureRecognizer) {
        
        if case .ended = sender.state {
            oldX = 0
            oldY = 0
            return
        }
        
        let translation = sender.translation(in: self.view)
        
        let diffY = oldY - translation.y
        oldY = translation.y
        
        let diffX = oldX - translation.x
        oldX = translation.x
        
        simulation.rotate(roll: Double(diffY) / 500, yaw: Double(diffX) / 500)
        
    }
    
    @objc func pinched(_ sender: UIPinchGestureRecognizer) {
        
        switch sender.state {
        case .ended:
            self.oldScale = 1.0
            return
        default:
            break
        }
        
        let diff = sender.scale
        
        simulation.zoom(by: Double(oldScale / diff))
        oldScale = diff
    }
    
}

public var game: GameViewController = GameViewController()
public var sim = SimulationView(scale: 1.km, timeStep: 30.day)

public func reset() {
    sim.reset()
    sim.particles.removeAll()
    sim.simulation.reset()
    sim.simulation.particles.removeAll()
}

public func setup() {
    game.simulation = sim
    PlaygroundPage.current.liveView = game
    PlaygroundPage.current.needsIndefiniteExecution = true
}

public func endSetup() {
    game.sceneView.prepare(sim.scene.rootNode, shouldAbortBlock: nil)
}

public func addLive(_ particle: ParticleNode) {
    game.insert(particle)
}

public func anchorLive(to particle: ParticleNode) {
    game.simulation.simulation.anchorParticle = particle.particle
}

public func followLive(_ particle: ParticleNode) {
    game.simulation.follow(particle)
}

public var initialOrthographicScaleLive: Double? {
    get {
        return game.simulation.initialOrthographicScale
    }
    set {
        game.simulation.initialOrthographicScale = newValue
    }
}

public var initialCameraRotationLive: SCNVector3? {
    get {
        return game.simulation.initialCameraRotation
    }
    set {
        game.simulation.initialCameraRotation = newValue
    }
}

public var enlargePlanetsLive: Bool {
    get {
        return !game.simulation.toScale
    }
    set {
        game.simulation.toScale = !newValue
    }
}


public var scaleLive: Distance {
    get {
        return game.simulation.scale
    }
    set {
        game.simulation.scale = newValue
    }
}

public var simulationSpeedLive: Time {
    get {
        return game.simulation.timeStep
    }
    set {
        game.simulation.simulation.stepTime = newValue / 60
    }
}


