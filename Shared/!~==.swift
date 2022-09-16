//
//  !~==.swift
//  Swiftelbrot
//
//  Created by S🌟System on 2022-08-05.
//

import Foundation

import BasicMathTools



public extension TolerablyEqual {
    static func !~== (lhs: Self, rhs: Self) -> Bool {
        !(lhs ~== rhs)
    }
}



infix operator !~==
