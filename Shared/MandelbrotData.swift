//
//  MandelbrotData.swift
//  Swiftelbrot
//
//  Created by S🌟System on 2022-08-14.
//

import Combine
import Foundation

import RectangleTools
import CollectionTools



/// The raw data of a rendering of the Mandelbrot Set
public struct MandelbrotData {
    
    public private(set) var crop: ComplexRect
    private var rawValue = RawValue()
    
    
    fileprivate init(crop: ComplexRect = defaultCrop,
                     rawValue: RawValue = .init()) {
        self.crop = crop
        self.rawValue = rawValue
    }
    
    
    
    public typealias RawValue = [MandelbrotCoordinate : MandelbrotIterations]
}



public extension MandelbrotData {
    
    mutating func compute(
        crop newCrop: ComplexRect? = nil,
        resolution: UIntSize,
        iterationLimit: UInt,
        updateFeed: AnySubscriber<Progress, Never>? = nil)
    async {
        if let newCrop {
            self.crop = newCrop
        }
        
        do {
            try Task.checkCancellation()
            
            self.rawValue = try await Self.computeRawValue(
                crop: crop,
                at: resolution,
                iterationLimit: iterationLimit,
                updateFeed: updateFeed)
        }
        catch {
            updateFeed?.receive(completion: .finished)
        }
    }
    
    
//    mutating func computeSync(
//        crop newCrop: ComplexRect? = nil,
//        resolution: UIntSize,
//        iterationLimit: UInt,
//        updateFeed: AnySubscriber<Progress, Never>? = nil)
//    {
//        if let newCrop {
//            self.crop = newCrop
//        }
//
//        do {
//            try Task.checkCancellation()
//
//            self.rawValue = try Self.computeRawValue_sync(
//                startingRawValue: rawValue,
//                crop: crop,
//                at: resolution,
//                iterationLimit: iterationLimit,
//                updateFeed: updateFeed)
//        }
//        catch {
//            updateFeed?.receive(completion: .finished)
//        }
//    }
}



public struct MandelbrotCoordinate: Hashable {
    let complexNumber: ComplexNumber
    let screenCoordinate: UIntPoint
}



private extension MandelbrotData {
    
    private static var __jobNumber: UInt = 0
    
    static func newJobNumber() -> UInt {
        defer { __jobNumber += 1 }
        return __jobNumber
    }
    
    
    static func computeRawValue(
        crop: ComplexRect,
        at resolution: UIntSize,
        iterationLimit: UInt,
        updateFeed: AnySubscriber<Progress, Never>? = nil)
    async throws -> RawValue {
        let jobNumber = Self.newJobNumber()
        do {
            try Task.checkCancellation()
            let complexPlane = crop.rasterize(at: resolution, scaleMethod: .fill)
                .map { MandelbrotCoordinate(complexNumber: .init($0.actualCoordinate),
                                            screenCoordinate: $0.screenCoordinate) }
            
            actor ExclusiveAccessRawValue {
                var rawValue: RawValue
                
                @Published
                var progress: Progress
                
                let jobNumber: UInt
                
                let updateFeed: AnySubscriber<Progress, Never>?
                
                init(capacity: UInt, jobNumber: UInt, updateFeed: AnySubscriber<Progress, Never>?) async {
                    let capacity = Int(capacity)
                    self.rawValue = RawValue()
                    self.rawValue.reserveCapacity(capacity)
                    
                    self.progress = .discrete(totalUnitCount: .init(clamping: capacity))
                    self.jobNumber = jobNumber
                    self.updateFeed = updateFeed
                }
                
                
                func save(_ iterations: MandelbrotIterations, at coordinate: MandelbrotCoordinate) {
                    rawValue[coordinate] = iterations
                    progress.completedUnitCount = .init(rawValue.count)
                    _ = updateFeed?.receive(progress)
//                    print("Job #\(jobNumber):\t \(progress.fractionCompleted * 100)%")
                }
            }
            
            try Task.checkCancellation()
            
            let exclusiveAccess = await ExclusiveAccessRawValue(capacity: UInt(complexPlane.count),
                                                                jobNumber: jobNumber,
                                                                updateFeed: updateFeed)
            
            try Task.checkCancellation()
            
            await complexPlane.forEachAsync { coordinate in
                async let iterations = MandelbrotIterations(at: coordinate.complexNumber,
                                                            iterationLimit: iterationLimit)
                
                await exclusiveAccess.save(await iterations, at: coordinate)
            }
            
            updateFeed?.receive(completion: .finished)
            return await exclusiveAccess.rawValue
        }
        catch {
            updateFeed?.receive(completion: .finished)
            throw error
        }
    }
    
    
//    static func computeRawValue_sync(
//        startingRawValue: RawValue,
//        crop: ComplexRect,
//        at resolution: UIntSize,
//        iterationLimit: UInt,
//        updateFeed: AnySubscriber<Progress, Never>? = nil)
//    throws -> RawValue {
//        do {
//            try Task.checkCancellation()
//
//            let complexPlane = crop.rasterize(at: resolution)
//                .map { MandelbrotCoordinate(complexNumber: .init($0.actualCoordinate),
//                                            screenCoordinate: $0.screenCoordinate) }
//
//            class TrackingRawValue {
//                var rawValue: RawValue
//
//                @Published
//                var progress = Progress.discreteProgress(totalUnitCount: .max)
//
//                let iterationLimit: UInt
//
//                init(capacity: UInt, startingValue: RawValue, iterationLimit: UInt) {
//                    let capacity = Int(capacity)
////                    let prefix: LazyMapSequence = startingValue.prefix(capacity).lazy.map { ($0, $1) } // Annoying how much this needs :/
//                    self.rawValue = RawValue()
//                    self.rawValue.reserveCapacity(capacity)
//
//                    self.iterationLimit = iterationLimit
//
//                    self.progress = .discreteProgress(totalUnitCount: .init(clamping: capacity))
//                }
//
//
//                func save(_ iterations: MandelbrotIterations, at coordinate: MandelbrotCoordinate) {
//                    rawValue[coordinate] = iterations
//                    progress.completedUnitCount = Int64(rawValue.count)
//                }
//
//
////                func hasIterations(at coordinate: MandelbrotCoordinate) -> Bool {
////                    switch rawValue[coordinate] {
////                    case .none: return false
////                    case .some(let iterations):
////                        return iterations.iterationLimit == iterationLimit
////                    }
////                }
//            }
//
//            try Task.checkCancellation()
//
//            let tracking = TrackingRawValue(capacity: resolution.area, startingValue: startingRawValue, iterationLimit: iterationLimit)
//
//            try Task.checkCancellation()
//
//            if let updateFeed {
//                tracking.$progress.receive(subscriber: updateFeed)
//            }
//
//            complexPlane.forEach { coordinate in
////                guard !tracking.hasIterations(at: coordinate) else {
////                    print("🎉")
////                    return
////                }
//
//                let iterations = MandelbrotIterations.computeSync(at: coordinate.complexNumber,
//                                                                  iterationLimit: iterationLimit)
//
//                tracking.save(iterations, at: coordinate)
//            }
//
//            updateFeed?.receive(completion: .finished)
//            return tracking.rawValue
//        }
//        catch {
//            updateFeed?.receive(completion: .finished)
//            throw error
//        }
//    }
}



extension MandelbrotData {
    mutating func insert(_ other: Self) {
        other.rawValue.forEach { coordinate, iterations in
            self.rawValue[coordinate] = iterations
        }
    }
}



public extension MandelbrotData {
    static let defaultCrop = ComplexRect(origin: -2 + -1.5,
                                         size: CGSize(width: 3, height: 3))
}



// MARK: - Equatable

extension MandelbrotData: Equatable {}



// MARK: Collection

extension MandelbrotData: Collection {
    
    public typealias Element = RawValue.Element
    public typealias Index = RawValue.Index
    public typealias Iterator = RawValue.Iterator
    
    
    public var startIndex: Index {
        rawValue.startIndex
    }
    
    
    public var endIndex: Index {
        rawValue.endIndex
    }
    
    
    public func makeIterator() -> Iterator {
        rawValue.makeIterator()
    }
    
    
    public subscript(position: Index) -> Element {
        rawValue[position]
    }
    
    
    public func index(after i: Index) -> Index {
        rawValue.index(after: i)
    }
}



extension MandelbrotData: CollectionWhichCanBeEmpty {
    public init() {
        self.init(crop: Self.defaultCrop, rawValue: .init())
    }
}
