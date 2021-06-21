//
//  ContentView.swift
//  LineDrawing
//
//  Created by haawa on 6/21/21.
//

import SwiftUI
import LayersRenderer
import MetalKit

struct ContentView: View {
    
    private let device = MTLCreateSystemDefaultDevice()
    @State private var clearColor = DrawingColor(r: 1, g: 1, b: 1, a: 1.0)
    @State private var layers = [DrawingLayer]()
    
    @State private var progress: CGFloat = 0
    
    private let demoLayers: DemoLayers
    
    init() {
        demoLayers = DemoLayers(device: device)
    }
    
    
    var body: some View {
        VStack {
            Spacer()
            ScrollView(.horizontal, showsIndicators: true) {
                HStack {
                    LayersSwiftUIView(device: device,
                                      clearColor: $clearColor,
                                      layers: $layers)
                        .frame(width: 400, height: 400)
                    LayersSwiftUIView(device: device,
                                      clearColor: $clearColor,
                                      layers: $layers)
                        .frame(width: 400, height: 400)
                    LayersSwiftUIView(device: device,
                                      clearColor: $clearColor,
                                      layers: $layers)
                        .frame(width: 400, height: 400)
                    LayersSwiftUIView(device: device,
                                      clearColor: $clearColor,
                                      layers: $layers)
                        .frame(width: 400, height: 400)
                    LayersSwiftUIView(device: device,
                                      clearColor: $clearColor,
                                      layers: $layers)
                        .frame(width: 400, height: 400)
                    LayersSwiftUIView(device: device,
                                      clearColor: $clearColor,
                                      layers: $layers)
                        .frame(width: 400, height: 400)
                }
            }
            Spacer()
            Slider(value: $progress, in: 0...1)
                .padding(.horizontal, 40)
                .onChange(of: progress, perform: { newValue in
                    print(progress)
                    demoLayers.layers.last?.progress = progress
                })
            Text("\(Int(progress * 100))%")
            Spacer()
        }.onAppear {
            layers = demoLayers.layers
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
