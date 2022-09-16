//
//  images + blank.swift
//  Swiftelbrot
//
//  Created by S🌟System on 2022-08-06.
//

import Foundation

import CrossKitTypes
import DrawingTools



public extension NativeImage {
    static var blank: NativeImage { .blank(size: .one) }
    
    
    static func blank(size: CGSize) -> NativeImage { .init(size: size) }
}
