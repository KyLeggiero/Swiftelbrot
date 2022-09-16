//
//  Color + HSL.swift
//  Swiftelbrot
//
//  Created by S🌟System on 2022-08-14.
//

import SwiftUI

import CrossKitTypes



extension Color {
    var hsl: HSL {
        var hsl = HSL(hue: 0.5, saturation: 0.5, brightness: 0.5, alpha: 0.5)
        NativeColor(self)
            .usingColorSpace(.deviceRGB)?
            .getHue(&hsl.hue, saturation: &hsl.saturation, brightness: &hsl.brightness, alpha: &hsl.alpha)
        return hsl
    }
    
    
    
    typealias HSL = (hue: CGFloat, saturation: CGFloat, brightness: CGFloat, alpha: CGFloat)
}
