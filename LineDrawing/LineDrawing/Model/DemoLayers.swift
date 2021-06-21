//
//  DemoLayers.swift
//  LineDrawing
//
//  Created by Andriy K. on 5/23/19.
//  Copyright © 2019 haawa. All rights reserved.
//

import UIKit
import MetalKit
import LayersRenderer
import Combine

final class DemoLayers {
    
    let layers: [DrawingLayer]
    
    init(device: MTLDevice?) {
        guard let device = device else {
            layers = []
            return
        }
        
        let grey = DrawingColor(r: 0.9, g: 0.9, b: 0.9, a: 1.0)
        let tint = DrawingColor(r: 0.9882352941,
                                g: 0.06274509804,
                                b: 0.2941176471,
                                a: 0.3)
        let thickness: CGFloat = 0.08
        do {
            let backgroundPoints = try VectorShape(color: grey,
                                                   strokeThickness: thickness).points
            let foregroundPoints = try VectorShape(color: tint,
                                                   strokeThickness: thickness).points
            
            let backgroundLayer = try DrawingLayer(points: backgroundPoints,
                                                    device: device,
                                                    initialProgress: 1)
            let foregroundLayer = try DrawingLayer(points: foregroundPoints,
                                                    device: device,
                                                    initialProgress: 0.0)
            
            foregroundLayer.progress = 0.0
            layers = [
                backgroundLayer,
                foregroundLayer
            ]
        } catch {
            layers = []
        }
        
    }
}
