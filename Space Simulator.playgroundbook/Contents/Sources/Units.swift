//
//  Units.swift
//  FourierTransform
//
//  Created by Arthur Vedana on 14/03/18.
//  Copyright © 2018 Arthur Vedana. All rights reserved.
//

import Foundation

public protocol Numerical {
    var doubleValue: Double { get }
}

extension Float: Numerical {
    public var doubleValue: Double { return Double(self) }
}

extension Int: Numerical {
    public var doubleValue: Double { return Double(self) }
}

extension Double: Numerical {
    public var doubleValue: Double { return self }
}

protocol Unit {
    var doubleValue: Double { get }
    
    init(_ value: Double)
}

extension Unit {
    public static prefix func -<T: Unit>(lhs: Self) -> T {
        return T(-lhs.doubleValue)
    }
    
    public static func -<T: Unit>(lhs: Self, rhs: Self) -> T {
        return T(lhs.doubleValue - rhs.doubleValue)
    }
}

// MARK: Mass

public struct Mass: Unit {
    
    public var doubleValue: Double
    
    init(_ value: Double) {
        self.doubleValue = value
    }
    
    static func +(lhs: Mass, rhs: Mass) -> Mass {
        return Mass(lhs.doubleValue + rhs.doubleValue)
    }
    
}

extension Numerical {
    public var kg: Mass {
        return Mass(self.doubleValue)
    }
    
    public var solarMass: Mass {
        return Mass(self.doubleValue * 1.989E30)
    }
}

// MARK: Distance

public struct Distance: Unit {
    public var doubleValue: Double
    
    init(_ value: Double) {
        self.doubleValue = value
    }
    
    public static func +(lhs: Distance, rhs: Distance) -> Distance {
        return Distance(lhs.doubleValue + rhs.doubleValue)
    }

    public static func -(lhs: Distance, rhs: Distance) -> Distance {
        return Distance(lhs.doubleValue - rhs.doubleValue)
    }

    public static func *(lhs: Distance, rhs: Distance) -> Distance {
        return Distance(lhs.doubleValue * rhs.doubleValue)
    }

    public static func *(lhs: Distance, rhs: Double) -> Distance {
        return Distance(lhs.doubleValue * rhs)
    }
    
    public static func /(lhs: Distance, rhs: Distance) -> Double {
        return lhs.doubleValue / rhs.doubleValue
    }
    
    public static func /(lhs: Distance, rhs: Int) -> Distance {
        return Distance(lhs.doubleValue / Double(rhs))
    }
    
    public static func /(lhs: Distance, rhs: Double) -> Distance {
        return Distance(lhs.doubleValue / rhs)
    }
    
    public static func sqrt(_ lhs: Distance) -> Distance {
        return Distance(Darwin.sqrt(lhs.doubleValue))
    }
    
    public static func +=(lhs: inout Distance, rhs: Distance) {
        lhs = Distance(rhs.doubleValue + lhs.doubleValue)
    }
    
    static func *(lhs: Double, rhs: Distance) -> Distance {
        return Distance(lhs * rhs.doubleValue)
    }
}

extension Distance: Comparable {
    public static func <(lhs: Distance, rhs: Distance) -> Bool {
        return lhs.doubleValue < rhs.doubleValue
    }
    
    public static func ==(lhs: Distance, rhs: Distance) -> Bool {
        return lhs.doubleValue == rhs.doubleValue
    }
    
    
}

extension Numerical {
    public var meter: Distance {
        return Distance(self.doubleValue)
    }
    
    public var km: Distance {
        return Distance(self.doubleValue * 1000)
    }
    
    public var solarRadius: Distance {
        return Distance(self.doubleValue * 695_700_000)
    }
    
    public var astronomicalUnit: Distance {
        return Distance(self.doubleValue * 149597871000)
    }
    
    public var lightYear: Distance {
        return Distance(self.doubleValue * 9.461E12)
    }
}

// MARK: Time

public struct Time: Unit {
    public var doubleValue: Double
    
    init(_ value: Double) {
        self.doubleValue = value
    }
    
    static func ==(lhs: Time, rhs: Double) -> Bool {
        return lhs.doubleValue == rhs
    }
    static func ==(lhs: Double, rhs: Time) -> Bool {
        return rhs.doubleValue == lhs
    }
    
    public static func +=(lhs: inout Time, rhs: Time) {
        lhs = Time(rhs.doubleValue + lhs.doubleValue)
    }
    
    public static func /(lhs: Time, rhs: Int) -> Time {
        return Time(lhs.doubleValue / Double(rhs))
    }
    
    public static func /(lhs: Time, rhs: Time) -> Double {
        return lhs.doubleValue / rhs.doubleValue
    }
    
}

extension Numerical {
    public var second: Time {
        return Time(self.doubleValue)
    }
    
    public var hour: Time {
        return Time(self.doubleValue * 3600)
    }
    
    public var day: Time {
        return Time(self.doubleValue * 3600 * 24)
    }
    
    public var month: Time {
        return Time(self.doubleValue * 3600 * 24 * 30)
    }
    
    public var year: Time {
        return Time(self.doubleValue * 31557600)
    }
}

// MARK: Speed

public struct Speed: Unit {
    public var doubleValue: Double
    
    init(_ value: Double) {
        self.doubleValue = value
    }
    
    public static func +(lhs: Speed, rhs: Speed) -> Speed {
        return Speed(lhs.doubleValue + rhs.doubleValue)
    }
    
    static func *(lhs: Speed, rhs: Time) -> Distance {
        return Distance(lhs.doubleValue * rhs.doubleValue)
    }
    
    public static func *(lhs: Speed, rhs: Double) -> Speed {
        return Speed(lhs.doubleValue * rhs)
    }
    
    public static func +=(lhs: inout Speed, rhs: Speed) {
        lhs = Speed(rhs.doubleValue + lhs.doubleValue)
    }
    
    static func *(lhs: Mass, rhs: Speed) -> Momentum {
        return Momentum(lhs.doubleValue * rhs.doubleValue)
    }
}

extension Numerical {
    public var meterPerSecond: Speed {
        return Speed(self.doubleValue)
    }
    
    public var kmPerSecond: Speed {
        return Speed(self.doubleValue * 1000)
    }
    
    public var kmPerHour: Speed {
        return Speed(self.doubleValue * 1000 * 3600)
    }
}

// MARK: Acceleration

public struct Acceleration: Unit {
    public var doubleValue: Double
    
    init(_ value: Double) {
        self.doubleValue = value
    }
    
    static func *(lhs: Acceleration, rhs: Time) -> Speed {
        return Speed(lhs.doubleValue * rhs.doubleValue)
    }
    
    public static func +=(lhs: inout Acceleration, rhs: Acceleration) {
        lhs = Acceleration(rhs.doubleValue + lhs.doubleValue)
    }
}

extension Numerical {
    public var mps2: Acceleration {
        return Acceleration(self.doubleValue)
    }
    
}

// MARK: Force

public struct Force: Unit {
    public var doubleValue: Double
    
    init(_ value: Double) {
        self.doubleValue = value
    }
    
    static func /(lhs: Force, rhs: Mass) -> Acceleration {
        return Acceleration(lhs.doubleValue / rhs.doubleValue)
    }
    
    public static func +=(lhs: inout Force, rhs: Force) {
        lhs = Force(rhs.doubleValue + lhs.doubleValue)
    }
}

extension Numerical {
    public var newton: Force {
        return Force(self.doubleValue)
    }
}

// MARK: Momentum

public struct Momentum: Unit {
    public var doubleValue: Double
    
    init(_ value: Double) {
        self.doubleValue = value
    }
    
    static func +(lhs: Momentum, rhs: Momentum) -> Momentum {
        return Momentum(lhs.doubleValue + rhs.doubleValue)
    }
    
    static func /(lhs: Momentum, rhs: Mass) -> Speed {
        return Speed(lhs.doubleValue / rhs.doubleValue)
    }
    
}

extension Numerical {
    public var kgMeterPerSecond: Momentum {
        return Momentum(self.doubleValue)
    }
    
}
