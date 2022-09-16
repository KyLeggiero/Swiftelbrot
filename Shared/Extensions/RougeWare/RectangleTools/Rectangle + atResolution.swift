//
//  Rectangle + atResolution.swift
//  Swiftelbrot (iOS)
//
//  Created by S🌟System on 2022-08-30.
//

import Foundation

import MultiplicativeArithmetic
import RectangleTools



public extension Rectangle
where Length: BinaryFloatingPoint,
      Length: MultiplicativeArithmetic
{
    
    func rasterize<ScreenLength>(
        at resolution: BinaryIntegerSize<ScreenLength>,
        scaleMethod: ScaleMethod = .stretch
    )
    -> LazyMapSequence<BinaryIntegerSize<ScreenLength>, ResolvedPoint<ScreenLength>>
    where ScreenLength: BinaryInteger
    {
        return BinaryIntegerSize(self.scaled(
            within: Self(origin: .zero, size: Size(resolution)),
            method: scaleMethod,
            direction: .upOrDown)
            .size
        )
        .lazy
        .map { screenCoordinate in
            (
                screenCoordinate: .init(screenCoordinate),
                actualCoordinate: self.relativePoint(xPercent: Length(screenCoordinate.x) / Length(resolution.width),
                                                     yPercent: Length(screenCoordinate.y) / Length(resolution.height))
            )
        }
    }
    
    
    
    typealias ResolvedPoint<ScreenLength: BinaryInteger> = (screenCoordinate: BinaryIntegerPoint<ScreenLength>,
                                                            actualCoordinate: Self.Point)
}
