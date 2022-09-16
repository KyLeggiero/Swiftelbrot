//
//  Progress.swift
//  Swiftelbrot
//
//  Created by S🌟System on 9/16/22.
//

import Foundation



public enum Progress {
    case indeterminate
    case discrete(totalUnitCount: UInt, completedUnitCount: UInt = 0)
}



public extension Progress {
    var isFinished: Bool {
        switch self {
        case .indeterminate:
            return false
            
        case .discrete(totalUnitCount: let totalUnitCount,
                       completedUnitCount: let completedUnitCount):
            return completedUnitCount >= totalUnitCount
        }
    }
    
    
    var isIndeterminate: Bool {
        switch self {
        case .indeterminate: return true
        case .discrete(totalUnitCount: _, completedUnitCount: _): return false
        }
    }
    
    
    mutating func finish() {
        switch self {
        case .indeterminate:
            self = .discrete(totalUnitCount: 1, completedUnitCount: 1)
            
        case .discrete(totalUnitCount: let totalUnitCount,
                       completedUnitCount: _):
            self = .discrete(totalUnitCount: totalUnitCount, completedUnitCount: totalUnitCount)
        }
    }
    
    
    var fractionCompleted: CGFloat {
        switch self {
        case .indeterminate:
            return .nan
            
        case .discrete(totalUnitCount: let totalUnitCount,
                       completedUnitCount: let completedUnitCount):
            return CGFloat(completedUnitCount) / CGFloat(totalUnitCount)
        }
    }
    
    
    var completedUnitCount: UInt {
        get {
            switch self {
            case .indeterminate:
                return 0
                
            case .discrete(totalUnitCount: _,
                           completedUnitCount: let completedUnitCount):
                return completedUnitCount
            }
        }
        set {
            switch self {
            case .indeterminate:
                break
                
            case .discrete(totalUnitCount: let totalUnitCount,
                           completedUnitCount: _):
                self = .discrete(totalUnitCount: totalUnitCount,
                                 completedUnitCount: newValue)
            }
        }
    }
}
