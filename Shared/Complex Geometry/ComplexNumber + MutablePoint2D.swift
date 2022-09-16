//
//  ComplexPoint.swift
//  Swiftelbrot
//
//  Created by S🌟System on 2022-08-15.
//

import Foundation

import RectangleTools



extension ComplexNumber: MutablePoint2D {
    public var x: Length {
        get { self.real }
        set { self.real = newValue }
    }
    
    public var y: Length {
        get { self.coefficient }
        set { self.coefficient = newValue }
    }
    
    
    public init(x: Length, y: Length) {
        self.init(real: x, coefficient: y)
    }
    
    
    public typealias Length = CGFloat
}
