//
//  MandelbrotIterations.swift
//  Swiftelbrot (iOS)
//
//  Created by S🌟System on 2022-08-30.
//

import Foundation



/// A partially-opaque type which is used for computing and storing the number of iterations it takes to compute one coordinate of the Mandelbrot set
public enum MandelbrotIterations {
    
    /// The iterations stopped before hitting the limit
    ///
    /// - Parameters:
    ///   - iterations: The number of times the Mandelbrot equation iterated before settling on a value for some coordinate
    ///   - iterationLimit: The maximum allowed number of iterations, used during the computation
    case finite(iterations: UInt, iterationLimit: UInt)
    
    /// The iterations did not stop before hitting the limit
    ///
    /// - Parameter iterationLimit: The maximum allowed number of iterations, which the computation exceeded
    case indefinite(iterationLimit: UInt)
    
    
    /// Computes the number of iterations at the given Mandelbrot coordinates, within the given limit
    ///
    /// - Parameters:
    ///   - mandelCoords:   The coordinates at which to compute the number of iterations of the Mandelbrot equation
    ///   - iterationLimit: The maximum allowed number of iterations, used during the computation
    init(at mandelCoords: ComplexNumber, iterationLimit: UInt) async {
//        let real = (CGFloat(trueLocationX) + offset.x + CGFloat(position.x)) * scale
//        let coefficient = (CGFloat(trueLocationY) + offset.y - CGFloat(position.y)) * scale
        
//        switch await Self.iterationsOrNil(at: mandelCoords, maxIterations: iterationLimit) {
//        case .none:
//            self = .indefinite(iterationLimit: iterationLimit)
//
//        case .some(let iterations):
//            self = .finite(iterations: iterations, iterationLimit: iterationLimit)
//        }
        
        self = await Task(priority: Task.currentPriority) {
            .computeSync(at: mandelCoords, iterationLimit: iterationLimit)
        }
        .value
    }
    
    
    static func computeSync(at mandelCoords: ComplexNumber, iterationLimit: UInt) -> Self {
        switch Self.__sync__iterationsOrNil(at: mandelCoords, maxIterations: iterationLimit) {
        case .none:
            return .indefinite(iterationLimit: iterationLimit)
            
        case .some(let iterations):
            return .finite(iterations: iterations, iterationLimit: iterationLimit)
        }
    }
}



public extension MandelbrotIterations {
    
    /// The raw number of iterations that it took to settle the Mandelbrot equation at a given point, or `nil` if the equation never settled
    var rawValue: UInt? {
        switch self {
        case .finite(iterations: let iterations, iterationLimit: _):
            return iterations
            
        case .indefinite(iterationLimit: _):
            return nil
        }
    }
    
    
    /// The maximum number of iterations which were allowed while computing this number
    var iterationLimit: UInt {
        switch self {
        case .finite(iterations: _, iterationLimit: let iterationLimit),
                .indefinite(iterationLimit: let iterationLimit):
            return iterationLimit
        }
    }
}



// MARK: - Calculations

/*private*/internal extension MandelbrotIterations {
    /// Asyncrhonously computes the number of iterations it takes for the given point in the Mandelbrot Set to diverge
    ///
    /// - Parameters:
    ///   - mandelCoords: Coordinates within the Mandelbrot set
    ///   - maxIterations: The maximum number of iterationst to attempt before declaring that the given point never diverges
    ///
    /// - Returns: The number of iterations it took before diverging, or `nil` if it did not diverge before `maxIterations`
    static func iterationsOrNil(at mandelCoords: ComplexNumber, maxIterations: UInt) async -> UInt? {
        await Task(priority: Task.currentPriority) {
            __sync__iterationsOrNil(at: mandelCoords, maxIterations: maxIterations)
        }
        .value
    }
    
    /// The synchronous form of ``iterationsOrNil(at:maxIterations:)``. Do not use this unless you need to
    static func __sync__iterationsOrNil(at mandelCoords: ComplexNumber, maxIterations: UInt) -> UInt? {
        guard maxIterations > 0 else {
            return nil
        }
//        return fromCxx(at: mandelCoords, maxIterations: maxIterations)
        return fromRosettaCode(at: mandelCoords, maxIterations: maxIterations)
        
        guard abs(mandelCoords.real) <= 2,
              abs(mandelCoords.coefficient) <= 2
        else {
            return 0
        }
        
        var tr: CGFloat = 0
        var second = ComplexNumber.zero
        
        tr = pow(second.real, 2) - pow(second.coefficient, 2)
        second.coefficient = (2 * second.real * second.coefficient) + mandelCoords.coefficient
        second.real = mandelCoords.real + tr
        
        for iterations in 0 ... maxIterations {
            tr = pow(second.real, 2) - pow(second.coefficient, 2) + mandelCoords.real
            second.coefficient = 2 * second.real * second.coefficient
            second.real = tr

            if abs(second.real) > 2,
               abs(second.coefficient) > 2
            {
                return iterations
            }
        }
        
        return nil
    }
    
    
    static func fromCxx(at mandelCoords: ComplexNumber, maxIterations: UInt) -> UInt? {
        var tr: CGFloat
        var second = ComplexNumber.zero
        
        var isDone: Bool {
            (pow(second.real, 2) + pow(second.coefficient, 2)) < 4
        }

        // Calculate whether c(c_real + c_imaginary) belongs
        // to the Mandelbrot set or not and draw a pixel
        // at coordinates (x, y) accordingly
        // If you reach the Maximum number of iterations
        // and If the distance from the origin is
        // greater than 2 exit the loop
        for iteration in 0..<maxIterations {
            
            if isDone {
                return iteration
            }
            
            // Calculate Mandelbrot function
            // z = z*z + c where z is a complex number

            // tempx = z_real*_real - z_imaginary*z_imaginary + c_real
            tr = pow(second.real, 2) - pow(second.coefficient, 2) + mandelCoords.real

            // 2*z_real*z_imaginary + c_imaginary
            second.coefficient = 2 * second.real * second.coefficient + mandelCoords.coefficient

            // Updating z_real = tempx
            second.real = tr
        }

        // To display the created fractal
        return isDone ? maxIterations : nil
    }
    
    
    // https://rosettacode.org/wiki/Mandelbrot_set#Swift
    static func fromRosettaCode(at mandelCoord: ComplexNumber, maxIterations: UInt) -> UInt? {
        var second = ComplexNumber.zero
        
        for iterations in 0..<maxIterations {
            if second.magnitude > 2 {
                return iterations
            }
            
            second = second.squared + mandelCoord
        }
        
        return nil
    }
}



// MARK: - Equatable

extension MandelbrotIterations: Equatable {}
