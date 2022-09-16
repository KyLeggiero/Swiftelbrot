//
//  ComplexNumber.swift
//  Swiftelbrot
//
//  Created by S🌟System on 2022-08-05.
//

import Foundation

import BasicMathTools
import MultiplicativeArithmetic



public struct ComplexNumber {
    public var real: CGFloat
    public var coefficient: CGFloat
}



public extension ComplexNumber {
    
    var squared: Self {
        Self(real: pow(real, 2) - pow(coefficient, 2),
             coefficient: 2 * real * coefficient)
    }
    
    var magnitude: CGFloat {
        sqrt(pow(real, 2) + pow(coefficient, 2))
    }
    
}



extension ComplexNumber: AdditiveArithmetic {
    
    public static var zero: Self {
        Self(real: 0, coefficient: 0)
    }
    
    public static func + (lhs: Self, rhs: Self) -> Self {
        Self(real: lhs.real + rhs.real,
             coefficient: lhs.coefficient + rhs.coefficient)
    }
    
    
    public static func - (lhs: Self, rhs: Self) -> Self {
        Self(real: lhs.real - rhs.real,
             coefficient: lhs.coefficient - rhs.coefficient)
    }
}



extension ComplexNumber: SimpleMultiplicativeArithmetic {
    public static func / (lhs: Self, rhs: Self) -> Self {
        Self(
            real:
                ((lhs.real * rhs.real) + (lhs.coefficient * rhs.coefficient))
                / (pow(rhs.real,2) + pow(rhs.coefficient,2)),
            
            coefficient:
                ((lhs.coefficient * rhs.real) - (lhs.real * rhs.coefficient))
                / (pow(rhs.real,2) + pow(rhs.coefficient,2))
        )
    }
    
    
    public static func * (lhs: Self, rhs: Self) -> Self {
        Self(real: (lhs.real * rhs.real) - (lhs.coefficient * rhs.coefficient),
             coefficient: (lhs.real * rhs.coefficient) + (rhs.real * lhs.coefficient))
    }
}



extension ComplexNumber: CustomStringConvertible {
    
    public var description: String {
        if real ~== 0 {
            return "\(coefficient)i"
        }
        else if coefficient ~== 0 {
            return real.description
        }
        else {
            return "\(real) + \(coefficient)i"
        }
    }
    
    
    
    public var oldDescription: String {
        var x = ""
        if real !~== 0 {
            x += real.description
        }
        if real !~== 0,
           coefficient !~== 0 {
            x += " + "
        }
        if coefficient !~== 0 {
            x += "\(coefficient)i"
        }
        return x
    }
}



extension ComplexNumber: Hashable {
}



extension ComplexNumber: Equatable {
}



func + (lhs: CGFloat, rhs: CGFloat) -> ComplexNumber {
    .init(real: lhs, coefficient: rhs)
}
