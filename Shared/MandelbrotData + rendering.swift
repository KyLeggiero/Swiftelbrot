//
//  MandelbrotData + rendering.swift
//  Swiftelbrot
//
//  Created by S🌟System on 2022-08-14.
//

import Foundation
import SwiftUI
import CrossKitTypes
import RectangleTools



extension MandelbrotData {
    func image(size imageSize: UIntSize, in palette: FractalColorPalette) async throws -> NativeImage {
        try Task.checkCancellation()
        
        return try await Task {
            let imageSize = CGSize(imageSize)
            
            return try NativeImage.drawNew(size: .init(imageSize)) { context in
                guard let context = context else {
                    fatalError("Out of context")
                }
                
                for pixel in self {
                    try Task.checkCancellation()
                    
                    context.setFillColor(NativeColor(palette.color(for: pixel.value)).cgColor)
                    context.fillPixel(at: .init(pixel.key.screenCoordinate))
                }
            }
        }
        .value
    }
    
    func image_sync(size imageSize: UIntSize, in palette: FractalColorPalette) -> NativeImage {
        let imageSize = CGSize(imageSize)
        
        return NativeImage.drawNew(size: .init(imageSize)) { context in
            guard let context = context else {
                fatalError("Out of context")
            }
            
            for pixel in self {
                context.setFillColor(NativeColor(palette.color(for: pixel.value)).cgColor)
                context.fillPixel(at: .init(pixel.key.screenCoordinate))
            }
        }
    }
}
