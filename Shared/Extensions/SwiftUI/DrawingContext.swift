//
//  DrawingContext.swift
//  Swiftelbrot
//
//  Created by S🌟System on 2022-08-07.
//

import SwiftUI

struct DrawingContext<Content: View>: View {
    
    @ViewBuilder
    let bodyGenerator: (CGContext?) -> Content
    
    @State
    private var currentContext: CGContext?
    
    var body: some View {
        bodyGenerator(currentContext)
            .onAppear {
                let currentContext = CGContext.current
                if currentContext != self.currentContext {
                    self.currentContext = currentContext
                }
            }
    }
}

//struct DrawingContext_Previews: PreviewProvider {
//    static var previews: some View {
//        DrawingContext()
//    }
//}
