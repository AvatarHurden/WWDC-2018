//
//  EarthAndMoon.swift
//  FourierTransform
//
//  Created by Arthur Vedana on 14/03/18.
//  Copyright © 2018 Arthur Vedana. All rights reserved.
//

import SceneKit

public class SimulationView: NSObject {
    
    public let scene: SCNScene
    public let simulation: Simulation
    var particles: [ParticleNode] = []
    
    var view: SCNView!
    
    public let cameraNode: SCNNode
    private let cameraOrbit: SCNNode
    
    private var followedNode: ParticleNode? {
        didSet {
            let t = initialOrthographicScale ?? 10
            self.cameraNode.camera?.orthographicScale = t
            updateRadiusScale()
        }
    }
    private var lookedAtNode: SCNNode?
    
    var timeStep: Time {
        get {
            return simulation.stepTime
        }
        set {
            simulation.stepTime = timeStep / 60
        }
    }
    
    var toScale: Bool = false {
        didSet {
            if toScale {
                self.radiusScale = scale
            } else {
                self.radiusScale = scale / 10
            }
        }
    }
    
    var scale: Distance {
        didSet {
            if toScale {
                self.radiusScale = scale
            } else {
                self.radiusScale = scale / 10
            }
        }
    }
    
    var initialCameraRotation: SCNVector3? {
        didSet {
            self.cameraOrbit.eulerAngles = initialCameraRotation ?? SCNVector3(0, 0, 0)
        }
    }
    var initialOrthographicScale: Double? {
        didSet {
            let t = initialOrthographicScale ?? 10
            self.cameraNode.camera?.orthographicScale = t
            updateRadiusScale()
        }
    }
    
    public var running = true
    
    var radiusScale: Distance
    var smallestRadius: Distance?
    
    public init(scale: Distance, timeStep: Time) {
        self.scale = scale
        self.radiusScale = scale / (self.toScale ? 1 : 10)
        self.simulation = Simulation()
        simulation.stepTime = timeStep / 60
        self.scene = SCNScene(named: "EarthAndMoon.scn")!
        
        self.scene.background.contents = [#imageLiteral(resourceName: "bkg1_right.png"), #imageLiteral(resourceName: "bkg1_left.png"), #imageLiteral(resourceName: "bkg1_top.png"), #imageLiteral(resourceName: "bkg1_bot.png"), #imageLiteral(resourceName: "bkg1_front.png"), #imageLiteral(resourceName: "bkg1_back.png")]
        
        self.cameraNode = self.scene.rootNode.childNode(withName: "camera", recursively: true)!
        cameraNode.position = SCNVector3(x: 0, y: 0, z: 15000)
        cameraNode.eulerAngles = SCNVector3(0, 0, 0)
        
        let audioPlayer = SCNAudioSource(fileNamed: "music.m4a")!
        audioPlayer.loops = true
        audioPlayer.isPositional = false
        
        self.scene.rootNode.runAction(SCNAction.playAudio(audioPlayer, waitForCompletion: false))
        
        let camera = self.cameraNode.camera!
        camera.zNear = 0
        camera.zFar = 12403062
        camera.vignettingPower = 0.5
        camera.vignettingIntensity = 1
        
        cameraOrbit = SCNNode()
        cameraOrbit.position = SCNVector3(0, 0, 0)
        cameraNode.removeFromParentNode()
        cameraOrbit.addChildNode(cameraNode)
        self.scene.rootNode.addChildNode(cameraOrbit)
        
        super.init()
    }
    
    func updateRadiusScale() {
        let (smallestRadius, smallestRadius2) = self.particles.map { (screenRadius(for: $0), $0.radius) }.min(by: { $0.0 < $1.0 }) ?? (1, 1.meter)
        
        self.smallestRadius = smallestRadius2
        
        let desiredRadius = 0.003
        
        let multiplier = smallestRadius / desiredRadius
        
        if smallestRadius < desiredRadius || self.radiusScale < self.scale / (self.toScale ? 1 : 10) {
            self.radiusScale = multiplier * self.radiusScale
        }
    }
    
    func screenRadius(for particle: ParticleNode) -> Double {
        let transform = self.cameraNode.camera!.projectionTransform
        let center = SCNMatrix4MultV(pM: transform, pV: particle.node.position.vector4).vector3
        
        var surface3D = particle.node.position
        surface3D.x += Float(particle.radius / self.radiusScale)
        let surface = SCNMatrix4MultV(pM: transform, pV: surface3D.vector4).vector3
        
        let dist = distance(float3(surface), float3(center))
        return Double(dist)
    }
    
    func zoom(by: Double) {
        self.cameraNode.camera?.orthographicScale *= by
        
        updateRadiusScale()
    }
    
    func rotate(roll: Double, yaw: Double) {
        self.cameraOrbit.eulerAngles.x += Float(roll)
        self.cameraOrbit.eulerAngles.y += Float(yaw)
    }
    
    public func reset() {
        
        if self.toScale {
            self.radiusScale = self.scale
        } else {
            self.radiusScale = self.scale / 10
        }
        
        SCNTransaction.begin()
        SCNTransaction.animationDuration = 1
        if let followed = self.followedNode {
            self.cameraNode.camera?.orthographicScale = self.initialOrthographicScale ?? 10
        }
        updateRadiusScale()
        SCNTransaction.commit()
        
        let x = self.initialCameraRotation?.x ?? 0
        let y = self.initialCameraRotation?.y ?? 0
        let z = self.initialCameraRotation?.z ?? 0
        
        let unRotate = SCNAction.rotateTo(x: CGFloat(x), y: CGFloat(y), z: CGFloat(z), duration: 1)
        
        self.cameraOrbit.runAction(unRotate)
    }
    
    public func deleteAll() {
        self.running = false
        self.followedNode = nil
        self.reset()
        self.particles.forEach { $0.node.removeFromParentNode() }
        self.particles.forEach { $0.particles.reset() }
        self.simulation.reset()
        self.simulation.particles = []
        self.particles = []
    }
    
    func follow(_ particle: ParticleNode, lookingAt: ParticleNode? = nil) {
        self.followedNode = particle
        self.lookedAtNode = lookingAt?.node
        
        //        if let lookingTarget = lookingAt {
        //            let t = SCNLookAtConstraint(target: lookingTarget.node)
        //            t.isGimbalLockEnabled = false
        //            self.cameraNode.constraints = [t]
        //        }
        
        self.cameraNode.camera?.orthographicScale = 10 * (particle.radius / self.radiusScale)
        cameraOrbit.position = particle.node.position
    }
    
    func add(particle: ParticleNode, simulated: Bool = true) {
        
        if simulated {
            self.simulation.insert(particle.particle)
        }
        
        self.updatePosition(of: particle)
        
        self.scene.rootNode.addChildNode(particle.node)
        self.particles.append(particle)
        
        let rotationDuration = particle.rotationTime / simulation.stepTime / 60
        
        let rotation = SCNAction.rotate(by: CGFloat(particle.rotationDirection.multiplier)*2*CGFloat.pi, around: SCNVector3(0, 1, 0), duration: rotationDuration)
        let forever = SCNAction.repeatForever(rotation)
        particle.node.runAction(forever)
    }
    
    func updatePosition(of particle: ParticleNode) {
        let position = particle.particle.position
        
        let positionX = position.x / self.scale
        let positionY = position.y / self.scale
        
        particle.node.position = SCNVector3(positionX, 0, positionY)
        
        let visibleRadius: CGFloat
        if let smallest = self.smallestRadius {
            let radiusProportion = particle.radius / smallest
            
            let multiplier = min(4.0, log2(radiusProportion) + 1)
            
            visibleRadius = CGFloat(multiplier * smallest / self.radiusScale)
        } else {
            visibleRadius = CGFloat(particle.radius / self.radiusScale)
        }
        
        if self.toScale {
            particle.geometry.radius = CGFloat(particle.radius / self.scale)
        } else {
            particle.geometry.radius = visibleRadius
        }
        particle.particles.particleSize = 0.2 * visibleRadius
    }
    
}

extension SimulationView: SCNSceneRendererDelegate {
    
    public func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {
        if !running { return }
        simulation.step()
        particles.forEach { self.updatePosition(of: $0) }
        
        if let followed = self.followedNode?.node {
            self.cameraOrbit.position = followed.position
        }
//        if let lookedAt = self.lookedAtNode {
            //            let diffX1 = self.cameraNode.worldPosition.x - lookedAt.worldPosition.x
            //            let diffX2 = self.cameraNode.worldPosition.x - self.cameraOrbit.worldPosition.x
            //
            //            let roll = acos(diffX2/diffX1) - Float.pi/2
            //
            //            let diffY1 = self.cameraNode.worldPosition.y - lookedAt.worldPosition.y
            //            let diffY2 = self.cameraNode.worldPosition.y - self.cameraOrbit.worldPosition.y
            //            let Y = acos(diffY2/diffY1)
            //
            //            let diffZ1 = self.cameraNode.worldPosition.z - lookedAt.worldPosition.z
            //            let diffZ2 = self.cameraNode.worldPosition.z - self.cameraOrbit.worldPosition.z
            //            let Z = acos(diffZ2/diffZ1)
            //
            //            self.cameraNode.eulerAngles = SCNVector3(roll, Y, Z)
//        }
        //
        //print(particles[0].particle.force)
        //        print(self.view.pointOfView)
        //        print(self.view.pointOfView?.camera)
    }
    
}

