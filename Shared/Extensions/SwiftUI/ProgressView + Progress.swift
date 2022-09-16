//
//  ProgressView + Progress.swift
//  Swiftelbrot
//
//  Created by S🌟System on 9/13/22.
//

import Foundation
import SwiftUI



public extension ProgressView {
    init(_ progress: Progress)
        where Label == EmptyView,
            CurrentValueLabel == EmptyView
    {
        self = .init(value: progress.isIndeterminate ? nil : progress.fractionCompleted)
    }
}
