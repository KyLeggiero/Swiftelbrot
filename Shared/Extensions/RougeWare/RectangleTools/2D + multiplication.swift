//
//  Size + multiplication.swift
//  Swiftelbrot
//
//  Created by S🌟System on 9/16/22.
//

import Foundation

import MultiplicativeArithmetic
import RectangleTools



public extension TwoDimensional where Length: MultiplicativeArithmetic {
    static func * (lhs: Self, rhs: Length) -> Self {
        Self.init(measurementX: lhs.measurementX * rhs,
                  measurementY: lhs.measurementY * rhs)
    }
}
