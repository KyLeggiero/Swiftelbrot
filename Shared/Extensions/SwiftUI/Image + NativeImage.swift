//
//  Image + NativeImage.swift
//  Swiftelbrot
//
//  Created by S🌟System on 2022-08-06.
//

import SwiftUI
import CrossKitTypes



public extension Image {
    init(nativeImage: NativeImage) {
        #if canImport(UIKit)
        self.init(uiImage: nativeImage)
        #elseif canImport(AppKit)
        self.init(nsImage: nativeImage)
        #endif
    }
}
