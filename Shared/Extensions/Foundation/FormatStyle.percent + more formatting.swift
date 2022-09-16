//
//  FormatStyle.percent + more formatting.swift
//  Swiftelbrot
//
//  Created by S🌟System on 9/16/22.
//

import Foundation



public extension FloatingPointFormatStyle {
    struct RougeWarePercent: FormatStyle {
        
        let numberOfFractionDigits: ClosedRange<UInt>
        
        private let formatter: NumberFormatter
        
        
        init(numberOfFractionDigits: ClosedRange<UInt>) {
            self.numberOfFractionDigits = numberOfFractionDigits
            self.formatter = {
                let formatter = NumberFormatter()
                formatter.numberStyle = .percent
                formatter.minimumFractionDigits = Int(numberOfFractionDigits.lowerBound)
                formatter.maximumFractionDigits = Int(numberOfFractionDigits.upperBound)
                return formatter
            }()
        }
        
        
        // MARK: FormatStyle
        
        public func format(_ value: Value) -> String {
            guard let result = formatter.string(from: NSNumber.from(value: value)) else {
                assertionFailure("Somehow couldn't turn a number into a string?")
                return "\(value)%"
            }
            
            return result
        }
        
        
        // MARK: Decodable
        
        public init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            
            self.init(
                numberOfFractionDigits: try container.decode(ClosedRange<UInt>.self, forKey: .numberOfFractionDigits)
            )
        }
        
        
        // MARK: Encodable
        
        public func encode(to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)
            try container.encode(numberOfFractionDigits, forKey: .numberOfFractionDigits)
        }
        
        
        // MARK: both Codables
        
        private enum CodingKeys: Swift.CodingKey {
            case numberOfFractionDigits
        }
    }
}



@available(macOS 12.0, iOS 15.0, tvOS 15.0, watchOS 8.0, *)
public extension FormatStyle {

    static func percent<F: BinaryFloatingPoint>(fractionDigits: UInt) -> Self
    where Self == FloatingPointFormatStyle<F>.RougeWarePercent
    {
        Self.init(numberOfFractionDigits: fractionDigits...fractionDigits)
    }
    
    static func percent<F: BinaryFloatingPoint>(fractionDigits: ClosedRange<UInt>) -> Self
    where Self == FloatingPointFormatStyle<F>.RougeWarePercent
    {
        Self.init(numberOfFractionDigits: fractionDigits)
    }
}
