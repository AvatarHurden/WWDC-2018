//
//  BHTree.swift
//  FourierTransform
//
//  Created by Arthur Vedana on 13/03/18.
//  Copyright © 2018 Arthur Vedana. All rights reserved.
//

import Foundation
import UIKit

public class BHTree {
 
    public static let Theta = 5.0
    
    public var particle: Particle?
    public let quadrant: Quadrant
    
    public var NW, NE, SW, SE: BHTree?
    
    var isExternal: Bool {
        return NW == nil && NE == nil && SW == nil && SE == nil
    }
    
    public init(quadrant: Quadrant) {
        self.quadrant = quadrant
    }
    
    public func insert(_ particle: Particle) {
        guard let own = self.particle else {
            self.particle = particle
            return
        }
        
        if !self.isExternal {
            self.particle = own.adding(particle)
            self.allocate(particle)
        } else {
            self.NW = BHTree(quadrant: self.quadrant.NW)
            self.NE = BHTree(quadrant: self.quadrant.NE)
            self.SW = BHTree(quadrant: self.quadrant.SW)
            self.SE = BHTree(quadrant: self.quadrant.SE)
            
            self.allocate(own)
            self.allocate(particle)
            self.particle = own.adding(particle)
        }
        
    }
    
    private func allocate(_ particle: Particle) {
        if self.quadrant.NW.contains(particle) {
            self.NW?.insert(particle)
        } else if self.quadrant.NE.contains(particle) {
            self.NE?.insert(particle)
        } else if self.quadrant.SW.contains(particle) {
            self.SW?.insert(particle)
        } else if self.quadrant.SE.contains(particle) {
            self.SE?.insert(particle)
        }
    }
    
}


public class Quadrant {
    
    private var center: Position
    public var length: Distance
    
    var minX: Distance {
        return center.x - length / 2
    }
    
    var maxX: Distance {
        return center.x + length / 2
    }
    
    var minY: Distance {
        return center.y - length / 2
    }
    
    var maxY: Distance {
        return center.y + length / 2
    }
    
    public init(center: Position, length: Distance) {
        self.center = center
        self.length = length
    }
    
    public func contains(_ point: Position) -> Bool {
        return
            point.x >= self.minX && point.x <= self.maxX &&
            point.y >= self.minY && point.y <= self.maxY
    }
    
    public func contains(_ particle: Particle) -> Bool {
        return self.contains(particle.position)
    }
    
    var NW: Quadrant {
        return Quadrant(center: Position(x: self.center.x - self.length / 4, y: self.center.y + self.length / 4), length: self.length / 2)
    }
    
    var NE: Quadrant {
        return Quadrant(center: Position(x: self.center.x + self.length / 4, y: self.center.y + self.length / 4), length: self.length / 2)
    }
    
    var SW: Quadrant {
        return Quadrant(center: Position(x: self.center.x - self.length / 4, y: self.center.y - self.length / 4), length: self.length / 2)
    }
    
    var SE: Quadrant {
        return Quadrant(center: Position(x: self.center.x + self.length / 4, y: self.center.y - self.length / 4), length: self.length / 2)
    }
    
}
