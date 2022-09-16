//
//  FractalColorPalette.swift
//  Swiftelbrot
//
//  Created by S🌟System on 2022-08-12.
//

import Foundation
import SwiftUI
import CrossKitTypes



protocol FractalColorPalette {
    func color(for iterations: MandelbrotIterations) -> Color
    var colorForMaxIterations: Color { get }
}



// MARK: - Default Types

// MARK: RepeatingGradientFractalColorPalette

struct RepeatingGradientFractalColorPalette: FractalColorPalette {
    let lowColor: Color
    let highColor: Color
    var maxIterationsBeforeWrapping: UInt? = nil
    var infiniteColor: Color? = nil
    
    
    func color(for iterations: MandelbrotIterations) -> Color {
        guard let rawIterations = iterations.rawValue,
              maxIterationsBeforeWrapping.map({ $0 > 0 }) ?? true
        else {
            return colorForMaxIterations
        }
        
        let wrappedIterations = UInt8(rawIterations.wrapped(within: range(iterationLimit: iterations.iterationLimit)))
        
        return color(for: wrappedIterations, iterationLimit: iterations.iterationLimit)
    }
    
    
    var colorForMaxIterations: Color {
        infiniteColor ?? highColor
    }
}



private extension RepeatingGradientFractalColorPalette {
    
    static let defaultMaxIterationsBeforeWrapping: UInt = 12
    
    
    func wrappingPoint(iterationLimit: UInt) -> UInt {
        min(iterationLimit, maxIterationsBeforeWrapping ?? Self.defaultMaxIterationsBeforeWrapping)
    }
    
    
    func range(iterationLimit: UInt) -> Range<UInt> {
        0..<UInt(wrappingPoint(iterationLimit: iterationLimit))
    }
    
    
    func color(for wrappedIteration: UInt8, iterationLimit: UInt) -> Color {
        color(at: CGFloat(wrappedIteration) / CGFloat(wrappingPoint(iterationLimit: iterationLimit)))
    }
    
    
    func color(at gradientProgress: CGFloat) -> Color {
        let low = lowColor.hsl
        let high = highColor.hsl
        
        let hue = low.hue > high.hue
            ?     value(atPercent: gradientProgress, between: low.hue, and: high.hue)
            : 1 - value(atPercent: gradientProgress, between: high.hue, and: low.hue + 1)
        
        return Color(
            hue: hue,
            saturation: value(atPercent: gradientProgress, between: low.saturation, and: high.saturation),
            brightness: value(atPercent: gradientProgress, between: low.brightness, and: high.brightness),
            opacity: value(atPercent: gradientProgress, between: low.alpha, and: high.alpha))
    }
    
    
    func value(atPercent gradientProgress: CGFloat, between low: CGFloat, and high: CGFloat) -> CGFloat {
        guard high >= low else {
            return value(atPercent: gradientProgress, between: high, and: low)
        }
        
        let relativeHigh = high - low
        let relativeValue = relativeHigh * gradientProgress
        return relativeValue + low
    }
}


// MARK: DebugGradientFractalColorPalette

struct DebugFractalColorPalette: FractalColorPalette {
    func color(for iterations: MandelbrotIterations) -> Color {
        switch iterations.rawValue {
        case .none:
            return .blue
            
        case .some(iterations.iterationLimit):
            return .orange
            
        case .some((iterations.iterationLimit+1)...):
            return .red
            
        case .some(let rawValue):
            return (0 == rawValue % 2)
                ? .black
                : .white
        }
    }
    
    var colorForMaxIterations: Color { .yellow }
    
    
}



// MARK: - Premade Palettes

extension RepeatingGradientFractalColorPalette {
    static let blackToOrange = Self(
        lowColor: Color(red: 1, green: 132/255, blue: 0),
        highColor: .black,
        maxIterationsBeforeWrapping: 10)
}



extension FractalColorPalette where Self == RepeatingGradientFractalColorPalette {
    static var blackToOrange: Self { RepeatingGradientFractalColorPalette.blackToOrange }
}



extension FractalColorPalette where Self == DebugFractalColorPalette {
    static var debug: Self { Self.init() }
}
