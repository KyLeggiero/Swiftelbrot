//
//  ComputeMandelbrot.swift
//  Swiftelbrot
//
//  Created by S🌟System on 2022-08-08.
//

import Foundation

import RectangleTools
import SimpleLogging
import CrossKitTypes



final class ComputeMandelbrot: Operation {
    
    private let locationInWindow: UIntRect
    private let maxIterations: UInt
    private let zoom: CGFloat
    private let center: ComplexNumber
    
    public var result: Result?
    
    
    init(locationInWindow: UIntRect,
         zoom: CGFloat,
         maxIterations: UInt,
         center: ComplexNumber)
    {
        logEntry(); defer { logExit() }
        self.locationInWindow = locationInWindow
        self.zoom = zoom
        self.maxIterations = maxIterations
        self.center = center
    }
    
    
    @inline(__always)
    private var size: UIntSize { locationInWindow.size }
    
    
    @inline(__always)
    private var position: UIntPoint { locationInWindow.origin }
    
    
    override func main() {
//        logEntry(); defer { logExit() }
        let result = Result(data: .init(crop: crop), locationInWindow: .init(locationInWindow))
        
        var currentPixel = UIntPoint.zero
        
        var colorR: UInt8 = .max
        var colorG: UInt8 = .min
        var colorB: UInt8 = .min
        
        for screenY in (Int(ceil(CGFloat(size.height) * -0.5) - 1) ... Int(ceil(CGFloat(size.height) * 0.5))).reversed() {
            defer {
                currentPixel.x += 1
            }
            
            for screenX in Int(ceil(CGFloat(size.width) * -0.5)) ..< Int(ceil(CGFloat(size.width) * 0.5)) {
                log(verbose: "\tEntry: (\(screenX), \(screenY))")
                defer {
                    log(verbose: "\tExit: (\(screenX), \(screenY))")
                }
                defer {
                    currentPixel.y += 1
                    currentPixel.x = 0
                }
                
                let real = (CGFloat(screenX) + center.x + CGFloat(position.x)) * zoom
                let coefficient = (CGFloat(screenY) + center.y - CGFloat(position.y)) * zoom
                var tr: CGFloat = 0
                var secondCoefficient = coefficient
                var secondReal = real
                
                for z in 0 ..< maxIterations {
                    tr = pow(secondReal, 2) - pow(secondCoefficient, 2)
                    secondCoefficient = 2 * secondReal * secondCoefficient
                    secondReal = real + tr
                    secondCoefficient = secondCoefficient + coefficient
                    
                    if abs(secondReal) > 2,
                       abs(secondCoefficient) > 2
                    {
                        color = palette.color(at: z)
                        
                        var colorIndex: UInt8
                        if z > maxIterations / 2 {
                            colorIndex = color(
                                for: UInt(z),
                                previousRangeLowerBound: 500,
                                previousRangeMax: maxIterations,
                                newRangeLowerBound: 50,
                                newRangeUpperBound: 80)
                        }
                        else if z <= maxIterations / 2,
                                z > maxIterations / 3 {
                            colorIndex = color(
                                for: UInt(z),
                                previousRangeLowerBound: maxIterations / 3,
                                previousRangeMax: maxIterations / 2,
                                newRangeLowerBound: 80,
                                newRangeUpperBound: 110)
                        }
                        else if z <= maxIterations / 3,
                                z > maxIterations / 4 {
                            colorIndex = color(
                                for: UInt(z),
                                previousRangeLowerBound: maxIterations / 4,
                                previousRangeMax: maxIterations / 3,
                                newRangeLowerBound: 110,
                                newRangeUpperBound: 140)
                        }
                        else if z <= maxIterations / 4,
                                z > maxIterations / 5 {
                            colorIndex = color(
                                for: UInt(z) * 4,
                                previousRangeLowerBound: maxIterations / 5,
                                previousRangeMax: maxIterations / 4,
                                newRangeLowerBound: 140,
                                newRangeUpperBound: 170)
                        }
                        else if z <= maxIterations / 5,
                                z > maxIterations / 6 {
                            colorIndex = color(
                                for: UInt(z) * 5,
                                previousRangeLowerBound: maxIterations / 6,
                                previousRangeMax: maxIterations / 5,
                                newRangeLowerBound: 170,
                                newRangeUpperBound: 200)
                        }
                        else if z <= maxIterations / 6,
                                z >= 20 {
                            colorIndex = color(
                                for: UInt(z) * 6,
                                previousRangeLowerBound: 50,
                                previousRangeMax: maxIterations / 6,
                                newRangeLowerBound: 200,
                                newRangeUpperBound: 230)
                        }
                        else if z <= 50 {
                            colorIndex = color(
                                for: UInt(z) * 6,
                                previousRangeLowerBound: 0,
                                previousRangeMax: 125,
                                newRangeLowerBound: 180,
                                newRangeUpperBound: 255)
                        }
                        else {
                            colorIndex = .max
                        }
                        
                        colorR = colorIndex
                        colorG = .init(CGFloat(colorIndex) * 0.55)
                        colorB = 0
                        
                        break
                    }
                }
                
                if abs(secondReal) < 2,
                   abs(secondCoefficient) < 2 {
                    colorR = 0
                    colorG = 0
                    colorB = 0
                }
                
//                result.image.inCurrentGraphicsContext { context in
//                    guard let context = context else { fatalError("No graphics context while drawing") }
//                    context.setFillColor(red: colorR, green: colorG, blue: colorB, alpha: 1)
//                    context.fillPixel(at: CGPoint(currentPixel))
//                }
                result.data.setValue(at: currentPixel, to: z)
            }
        }
        
        self.result = result
    }
    
    
    
    var crop: ComplexRect {
        ComplexRect(center: center, size: complexSize)
    }
    
    
    var complexSize: CGSize {
        MandelbrotData.defaultSize.scaled(by: 1 / zoom)
    }
    
    
    
    struct Result {
        let data: MandelbrotData
        var locationInWindow: CGRect
    }
}



internal func color(for z: UInt, previousRangeLowerBound: UInt, previousRangeMax: UInt, newRangeLowerBound: UInt, newRangeUpperBound: UInt) -> UInt8 {
    let ratio = CGFloat(previousRangeMax - (z + previousRangeLowerBound)) / CGFloat(previousRangeMax)
    return UInt8((CGFloat(newRangeUpperBound - newRangeLowerBound) * ratio) + CGFloat(newRangeLowerBound))
}
