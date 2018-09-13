import Foundation

public struct Position  {
    public var x: Distance
    public var y: Distance
    
    static public var zero = Position(x: 0.km, y: 0.km)
    
    public init(x: Distance, y: Distance) {
        self.x = x
        self.y = y
    }
}

extension Position {
    public func distance(to point: Position) -> Distance {
        let dx = self.x - point.x
        let dy = self.y - point.y
        return Distance.sqrt(dx*dx + dy*dy)
    }
}

public struct Velocity  {
    public var x: Speed
    public var y: Speed
    
    static var zero = Velocity(x: 0.meterPerSecond, y: 0.meterPerSecond)
    
    public init(x: Speed, y: Speed) {
        self.x = x
        self.y = y
    }
    
    func momentum(given mass: Mass) -> MomentumVector {
        return MomentumVector(x: mass * x, y: mass * y)
    }
}

public struct ForceVector  {
    var x: Force
    var y: Force
    
    static var zero = ForceVector(x: 0.newton, y: 0.newton)
}

public struct MomentumVector  {
    var x: Momentum
    var y: Momentum
    
    static var zero = MomentumVector(x: 0.kgMeterPerSecond, y: 0.kgMeterPerSecond)
    
    static func +(lhs: MomentumVector, rhs: MomentumVector) -> MomentumVector {
        return MomentumVector(x: lhs.x + rhs.x, y: lhs.y + rhs.y)
    }
    
    static prefix func -(lhs: MomentumVector) -> MomentumVector {
        return MomentumVector(x: -lhs.x , y: -lhs.y)
    }
}

public class Particle {
    
    public static let G = 6.67408E-11
    
    public var mass: Mass
    public var position: Position
    public var velocity: Velocity
    public var force: ForceVector
    
    public var radius: Double {
        return pow(mass.doubleValue / (4 * Double.pi / 3.0), 1.0/3)
    }
    
    public var momentum: MomentumVector {
        get {
            return self.velocity.momentum(given: self.mass)
        }
        set {
            self.velocity.x = newValue.x / self.mass
            self.velocity.y = newValue.y / self.mass
        }
    }
    
    public init(mass: Mass, position: Position, velocity: Velocity) {
        self.mass = mass
        self.position = position
        self.velocity = velocity
        self.force = .zero
    }
    
    public init(from other: Particle) {
        self.mass = other.mass
        self.position = other.position
        self.velocity = other.velocity
        self.force = other.force
    }
    
    public func distance(to particle: Particle) -> Distance {
        return self.position.distance(to: particle.position)
    }
    
    public func update(dt: Time) {
        self.velocity.y += force.y / self.mass * dt
        self.velocity.x += force.x / self.mass * dt
        
        self.position.y += self.velocity.y * dt
        self.position.x += self.velocity.x * dt
    }
    
    public func resetForce() {
        self.force = .zero
    }
    
    public func updateForce(from tree: BHTree) {
        guard let own = tree.particle, self !== own else {
            return
        }
        
        if tree.isExternal {
            self.addForce(from: own)
        } else {
            
            let s = tree.quadrant.length
            let d = self.distance(to: own)
            
            if s / d < BHTree.Theta {
                self.addForce(from: own)
            } else {
                self.updateForce(from: tree.NW!)
                self.updateForce(from: tree.NE!)
                self.updateForce(from: tree.SW!)
                self.updateForce(from: tree.SE!)
            }
            
        }
    }
    
    
    public func addForce(from particle: Particle) {
        let EPS: Double = 3E4
        
        let dx = particle.position.x - self.position.x
        let dy = particle.position.y - self.position.y
        let dist = self.distance(to: particle).doubleValue
        
        let F = (Particle.G * self.mass.doubleValue * particle.mass.doubleValue) / (dist * dist + EPS * EPS)
        
        self.force.y += (F * dy.doubleValue / dist).newton
        self.force.x += (F * dx.doubleValue / dist).newton
    }
    
    public func adding(_ particle: Particle) -> Particle {
        
        let mass = self.mass + particle.mass
        
        let positionX = (self.position.x.doubleValue * self.mass.doubleValue + particle.position.x.doubleValue * particle.mass.doubleValue) / mass.doubleValue
        let positionY = (self.position.y.doubleValue * self.mass.doubleValue + particle.position.y.doubleValue * particle.mass.doubleValue) / mass.doubleValue
        
        let velocityX = (self.velocity.x.doubleValue * self.mass.doubleValue + particle.velocity.x.doubleValue * particle.mass.doubleValue) / mass.doubleValue
        let velocityY = (self.velocity.y.doubleValue * self.mass.doubleValue + particle.velocity.y.doubleValue * particle.mass.doubleValue) / mass.doubleValue
        
        let result = Particle(mass: mass, position: Position(x: positionX.meter, y: positionY.meter), velocity: Velocity(x: velocityX.meterPerSecond, y: velocityY.meterPerSecond))
        
        return result
    }
    
}
