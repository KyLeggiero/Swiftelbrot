//
//  Rectangle + extensions.swift
//  Swiftelbrot (iOS)
//
//  Created by S🌟System on 2022-08-30.
//

import MultiplicativeArithmetic
import RectangleTools



public extension Rectangle
    where Length: AdditiveArithmetic,
          Length: MultiplicativeArithmetic,
          Length: ExpressibleByIntegerLiteral
{
    
    /// Creates a copy of this rectangle, but centered at the given point
    ///
    /// This ensures the center of the returned rectangle is at the given point. The size will remain the same
    ///
    /// - Parameter point: The new center of the rectangle
    func centered(at point: Point) -> Self {
        .init(center: point, size: size)
    }
    
    
    /// Creates a rectangle centered at the given point
    ///
    /// - Parameters:
    ///   - center: The center point of the new rectangle
    ///   - size:   The size of the new rectangle
    init(center: Point, size: Size) {
        self.init(
            origin: .init(
                x: (size.width / 2) + (center.x / 2),
                y: (size.height / 2) + (center.y / 2)),
            size: size
        )
    }
}



public extension Rectangle
    where Length: Comparable,
          Length: AdditiveArithmetic,
          Length: MultiplicativeArithmetic,
          Length: ExpressibleByIntegerLiteral
{
    @inline(__always)
    var center: Point {
        midXmidY
    }
}



public extension Rectangle
    where Length: Comparable,
          Length: AdditiveArithmetic
{
    var minToMaxDescription: String {
        return "\(minXminY) ~ \(maxXmaxY)"
    }
}



public extension Size2D
    where Length: Comparable,
          Length: AdditiveArithmetic
{
    var minToMaxDescription: String {
        return "(\(minX), \(minY)) ~ (\(maxX), \(maxY))"
    }
}
