//
//  Simulation.swift
//  FourierTransform
//
//  Created by Arthur Vedana on 13/03/18.
//  Copyright © 2018 Arthur Vedana. All rights reserved.
//

import Foundation

public class Simulation {
    
    public var particles: [Particle]
    var originalParticles: [Particle]
    
    var anchorParticle: Particle?
    
    private var time: Time = 0.second
    public var stepTime: Time = 1.year
    
    var radius: Distance {
        var maxRadius: Double = 0
        for p in particles {
            let radius = max(abs(p.position.x.doubleValue), abs(p.position.y.doubleValue))
            maxRadius = max(radius, maxRadius)
        }
        return maxRadius.meter
    }
    
    public init() {
        originalParticles = []
        particles = []
    }
    
    func insert(_ particle: Particle) {
        self.particles.append(particle)
    }
    
    public func step() {
        if time == 0 {
            self.originalParticles = self.particles.map { Particle(from: $0) }
            
            if let anchor = anchorParticle {
                let total = self.particles.reduce(-anchor.momentum, { acc, x in acc + x.momentum })
                
                anchorParticle?.momentum = anchor.momentum + (-total)
            }
        }
        
        self.time += self.stepTime
        
        let quad = Quadrant(center: .zero, length: 2 * self.radius)
        let tree = BHTree(quadrant: quad)
        
        for p in particles {
            if quad.contains(p) {
                tree.insert(p)
            }
        }
        
        particles.forEach { p in
            p.resetForce()
            p.updateForce(from: tree)
            p.update(dt: self.stepTime)
        }
        
    }
    
    public func reset() {
        self.time = 0.second
        self.particles = self.originalParticles.map { Particle(from: $0) }
    }
    
}
