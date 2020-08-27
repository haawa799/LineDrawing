//
//  TestViewController.swift
//  LineDrawing
//
//  Created by Andriy K. on 5/23/19.
//  Copyright © 2019 haawa. All rights reserved.
//

import UIKit
import LayersRenderer

final class TestViewController: UIViewController {
    
    var testLayers: DemoLayers?
    
    @IBAction func sliderValueChange(_ sender: UISlider) {
        let progress = CGFloat(sender.value)
        testLayers?.foregroundLayer.progress = progress
    }
    
    @IBOutlet weak var layersRenderView: LayersView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let device = layersRenderView?.device else {
            return
        }
        layersRenderView.clearColor = DrawingColor(r: 1, g: 1, b: 1, a: 1.0)

        do {
            let testLayers = try DemoLayers(device: device)
            layersRenderView.layers = [testLayers.backgroundLayer,
                                       testLayers.foregroundLayer]
            self.testLayers = testLayers
        } catch {
            debugPrint(error)
        }
    }
    
}
