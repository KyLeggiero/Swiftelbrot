//
//  ComplexRect.swift
//  Swiftelbrot
//
//  Created by S🌟System on 2022-08-15.
//

import Foundation

import RectangleTools



public struct ComplexRect {
    public var origin: Point
    public var size: Size
    
    
    public init(origin: Point, size: Size) {
        self.origin = origin
        self.size = size
    }
}



// MARK: - MutableRectangle

extension ComplexRect: MutableRectangle {
    
    public typealias Length = CGFloat
    
    public typealias Point = ComplexNumber
    
    public typealias Size = CGSize
}



// MARK: - Equatable

extension ComplexRect: Equatable {}



// MARK: - CustomStringConvertible

extension ComplexRect: CustomStringConvertible {
    public var description: String {
        minToMaxDescription
    }
}
