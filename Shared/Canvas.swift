//
//  SwiftUIView.swift
//  Swiftelbrot
//
//  Created by S🌟System on 2022-08-05.
//

import Combine
import SwiftUI

import ColorSwatches
import CrossKitTypes
import DrawingTools
import RectangleTools
import SimpleLogging



private let jobList = OperationQueue()



struct MandelbrotView: View {
    
    @State
    private var scale: CGFloat = 1
    
    @State
    private var scaleFactor: CGFloat = 0
    
    @State
    private var startOffset = CGPoint(x: -840, y: 240)
    
    @State
    private var offset = CGPoint.zero
    
    @State
    private var iterations: UInt = 4
    
    @State
    private var jobCount = UIntSize(width: 1, height: 1) //UIntSize(width: 2, height: 8)
    
    @State
    private var threadCount = 8
    
    @State
    private var showCrosshair = true
    
    @State
    private var pictureNumber = 0
    
    @State
    private var cachedSize = CGSize(width: 1, height: 1)
    
    @State
    private var renderedImage = NativeImage.swatch(color: .windowBackgroundColor)
    
    @State
    private var mandelbrotData = MandelbrotData.empty
    
    @State
    private var colorPalette: FractalColorPalette = .blackToOrange
    
    @State
    private var computeTask: Task<Void, Never>?
    
    @State
    private var drawTask: Task<Void, Never>?
    
    @State
    private var progress: Progress = .indeterminate
    
    @State
    private var progressUpdateFeed: AnySubscriber<Progress, Never> = Subscribers.Sink(receiveCompletion: {_ in }, receiveValue: { _ in}).eraseToAnySubscriber()
    
    
    init() {
        progressUpdateFeed = Subscribers.Assign(object: self, keyPath: \.progress).eraseToAnySubscriber()
    }
    
    
    var body: some View {
        VStack {
            GeometryReader { geometry in
                Image(nativeImage: renderedImage)
                    .resizable()
                    .scaledToFill()
                    .onChange(of: geometry.size) { size in
                        cachedSize = size
                    }
            }
            VStack {
                HStack {
                    ProgressView(value: progress.fractionCompleted) {
                        if progress.isFinished {
                            Text("Done")
                        }
                        else {
                            Text("\(progress.fractionCompleted, format: .percent)")
                                .font(.body.monospacedDigit())
                        }
                    }
                }
                
                VStack {
                    Text(mandelbrotData.crop.minToMaxDescription)
                    Text(cachedSize.minToMaxDescription)
                }
                .font(.caption)
                
                HStack {
                    Stepper("Iterations", value: $iterations, in: 3...50)
                    Text("\(iterations)")
                }
            }
            .padding()
        }
        .onChange(of: [cachedSize.hashValue, iterations.hashValue]) { _ in
            let oldComputeTask = computeTask
            computeTask?.cancel()
            computeTask = nil
            
            drawTask?.cancel()
            drawTask = nil
            
            computeTask = Task(priority: .high) {
                do {
                    try Task.checkCancellation()

                    oldComputeTask?.cancel()
                    
                    self.progress = .indeterminate
//
                    await mandelbrotData.compute(
                        resolution: .init(cachedSize * 2),
                        iterationLimit: iterations,
                        updateFeed: progressUpdateFeed)
//                    mandelbrotData.computeSync(
//                        resolution: .init(cachedSize),
//                        iterationLimit: iterations,
//                        updateFeed: progressUpdateFeed)
                }
                catch {
                    print("🙄")
                }
            }
            
            
        }
        .onChange(of: mandelbrotData) { mandelbrotData in
//            drawTask?.cancel()
//            drawTask = nil
//
//            drawTask = Task(priority: .high) {
//                renderedImage = await try mandelbrotData.image(size: .init(cachedSize),
//                                                               in: colorPalette)
//            }
            
            renderedImage = mandelbrotData.image_sync(size: .init(cachedSize),
                                                      in: colorPalette)
        }
        
        .onAppear {
            self.progressUpdateFeed = Subscribers.Sink<Progress, Never> { _ in
                progress.finish()
            } receiveValue: { progress in
                Task {
                    await MainActor.run {
                        self.progress = progress
                    }
                }
                print(progress.fractionCompleted)
            }
            .eraseToAnySubscriber()
        }
    }
}



//extension MandelbrotView {
//
//
//    func keyPressed_i() {
//        defer { repaint() }
//        scale *= scaleFactor
//        if offset.x < startOffset.x {
//            offset.x =  (startOffset.x - (abs(offset.x) - abs(startOffset.x)) * (1/scaleFactor))
//        }
//        if offset.x > startOffset.x {
//            offset.x =  (startOffset.x + abs(abs(startOffset.x) + offset.x) * (1/scaleFactor))
//        }
//        if offset.y < startOffset.y {
//            offset.y =  (startOffset.y - abs(offset.y - startOffset.y) * (1/scaleFactor))
//        }
//        if offset.y > startOffset.y {
//            offset.y =  (startOffset.y + abs(offset.y - startOffset.y) * (1/scaleFactor))
//        }
//    }
//
//
//    func keyPressed_o() {
//        defer { repaint() }
//        scale /= scaleFactor
//        if offset.x < startOffset.x {
//            offset.x =  (startOffset.x - (abs(offset.x) - abs(startOffset.x)) * scaleFactor)
//        }
//        if offset.x > startOffset.x {
//            offset.x =  (startOffset.x + abs(abs(startOffset.x) + offset.x) * scaleFactor)
//        }
//        if offset.y < startOffset.y {
//            offset.y =  (startOffset.y - abs(offset.y - startOffset.y) * scaleFactor)
//        }
//        if offset.y > startOffset.y {
//            offset.y =  (startOffset.y + abs(offset.y - startOffset.y) * scaleFactor)
//        }
//    }
//
//    func keyPressed_c() {
//        defer { repaint() }
//        showCrosshair.toggle()
//    }
//
//    func goLeft() {
//        defer { repaint() }
//        offset.x -= 50
//    }
//    func goRight() {
//        defer { repaint() }
//        offset.x += 50
//    }
//    func goDown() {
//        defer { repaint() }
//        offset.y -= 50
//    }
//    func goUp() {
//        defer { repaint() }
//        offset.y += 50
//    }
//
//    func updateOffset() {
//        // xOffset -= (cachedWidth - cachedLength) / 2.5
//        // startXOffset -= (cachedWidth - cachedLength) / 2
//        // yOffset += (cachedHeight - cachedHeight) / 4
//        // startYOffset += (cachedHeight - cachedHeight) / 4
//    }
//
//
//    func repaint() {
//
//    }
//}



struct SwiftUIView_Previews: PreviewProvider {
    static var previews: some View {
        MandelbrotView()
    }
}
