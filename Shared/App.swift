//
//  App.swift
//  Shared
//
//  Created by S🌟System on 2022-08-05.
//

import SwiftUI
import SimpleLogging

@main
struct App: SwiftUI.App {
    
    init() {
        LogManager.defaultChannels = [
            try! .init(name: "Scream", location: .swiftPrintDefault, severityFilter: .specificAndHigher(lowest: .info))
        ]
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
