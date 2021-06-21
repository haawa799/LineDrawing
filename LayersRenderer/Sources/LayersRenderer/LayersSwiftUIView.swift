//
//  LayersSwiftUIView.swift
//  
//
//  Created by haawa on 6/21/21.
//

import SwiftUI

public struct LayersSwiftUIView: UIViewRepresentable {
    
    @Binding private var clearColor: DrawingColor
    @Binding private var layers: [DrawingLayer]
    
    public let device: MTLDevice?
    
    public init(device: MTLDevice?,
                clearColor: Binding<DrawingColor>,
                layers: Binding<[DrawingLayer]>) {
        self.device = device
        self._clearColor = clearColor
        self._layers = layers
    }

    public func makeUIView(context: Context) -> LayersView {
        let view = try! LayersView(device: device, frame: CGRect.zero)
        return view
    }

    public func updateUIView(_ uiView: LayersView, context: Context) {
        uiView.clearColor = clearColor
        uiView.layers = layers
    }
}
