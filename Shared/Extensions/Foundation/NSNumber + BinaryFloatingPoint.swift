//
//  NSNumber + BinaryFloatingPoint.swift
//  Swiftelbrot
//
//  Created by S🌟System on 9/16/22.
//

import Foundation



public extension NSNumber {
    static func from<F: BinaryFloatingPoint>(value: F) -> NSNumber {
        if let value = value as? _NSNumberBridgeable {
            return value.nsNumberValue
        }
        else {
            fatalError("I don't think NSNumber supports values of type `\(F.self)`")
        }
    }
}



private protocol _NSNumberBridgeable {
    var nsNumberValue: NSNumber { get }
}
extension _NSNumberBridgeable {
    var nsNumberValue
    : NSNumber {
        // just force cast b/c we only conform this to known NSNumber convertible Numeric types
        self as! NSNumber
    }
}
extension Decimal: _NSNumberBridgeable { }
extension Float64: _NSNumberBridgeable { }
extension Float32: _NSNumberBridgeable { }
extension CGFloat: _NSNumberBridgeable { }
extension Int8:    _NSNumberBridgeable { }
extension Int32:   _NSNumberBridgeable { }
extension Int:     _NSNumberBridgeable { }
extension Int64:   _NSNumberBridgeable { }
extension UInt8:   _NSNumberBridgeable { }
extension Int16:   _NSNumberBridgeable { }
extension UInt:    _NSNumberBridgeable { }
extension UInt64:  _NSNumberBridgeable { }
extension UInt16:  _NSNumberBridgeable { }
extension Bool:    _NSNumberBridgeable { }
