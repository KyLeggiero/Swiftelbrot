//
//  CGContext extensions.swift
//  Swiftelbrot
//
//  Created by S🌟System on 2022-08-06.
//

import Foundation
import CoreGraphics

import RectangleTools



public extension CGContext {
    /// Sets the pixel at the given location to the current **fill** color
    /// - Parameter location: The location of the pixel which you want to set to the current fill color
    func fillPixel(at location: CGPoint) {
        fill(CGRect(origin: location, size: .one))
    }
    
    
    /// Sets the current fill color to a value in the DeviceRGB color space.
    ///
    /// When you call this function, two things happen:
    /// - Core Graphics sets the current fill color space to DeviceRGB.
    /// - Core Graphics sets the current fill color to the value specified by the red, green, blue, and alpha parameters.
    ///
    /// - Parameters:
    ///   - red: The red intensity value for the color to set. The DeviceRGB color space permits the specification of a value ranging from 0.0 (zero intensity) to 1.0 (full intensity).
    ///   - green: The green intensity value for the color to set. The DeviceRGB color space permits the specification of a value ranging from 0.0 (zero intensity) to 1.0 (full intensity).
    ///   - blue: The blue intensity value for the color to set. The DeviceRGB color space permits the specification of a value ranging from 0.0 (zero intensity) to 1.0 (full intensity).
    ///   - alpha: A value that specifies the opacity level. Values can range from 0.0 (transparent) to 1.0 (opaque). Values outside this range are clipped to 0.0 or 1.0.
    func setFillColor(red: UInt8, green: UInt8, blue: UInt8, alpha: UInt8 = .max) {
        
        /// Converts the given 8-bit unsigned integer (0...255) to a CGFloat (0...1) for use in representing a component of a pixel
        /// - Parameter byte: The value to convert from a 0...255 integer to a 0...1 float
        func toFloat(_ byte: UInt8) -> CGFloat {
            CGFloat(byte) / CGFloat(UInt8.max)
        }
        
        setFillColor(red: toFloat(red),
                     green: toFloat(green),
                     blue: toFloat(blue),
                     alpha: toFloat(alpha))
    }
}
