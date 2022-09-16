//
//  Subscriber+eraseToAnySubscriber.swift
//  Swiftelbrot (iOS)
//
//  Created by S🌟System on 9/13/22.
//

import Combine



public extension Subscriber {
    func eraseToAnySubscriber() -> AnySubscriber<Input, Failure> {
        AnySubscriber(self)
    }
}
