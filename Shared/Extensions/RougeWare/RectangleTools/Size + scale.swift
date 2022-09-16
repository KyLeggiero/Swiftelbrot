//
//  Size + scale.swift
//  Swiftelbrot (iOS)
//
//  Created by S🌟System on 2022-08-30.
//

import MultiplicativeArithmetic
import RectangleTools



public extension Size2D where Length: MultiplicativeArithmetic {
    func scaled(by multiplier: Length) -> Self {
        .init(width: width * multiplier,
              height: width * multiplier)
    }
}
