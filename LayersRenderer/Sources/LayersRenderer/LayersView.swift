//
//  LayersView.swift
//  LayersRender
//
//  Created by Andriy K. on 5/23/19.
//  Copyright © 2019 haawa. All rights reserved.
//

import UIKit

@available(iOS 10, *)
public class LayersView: UIView {
    
    private var renderView: LayersRenderView?
    public var layers: [DrawingLayer] = [] {
        didSet {
            renderView?.layers = layers
        }
    }
    public var clearColor = DrawingColor(r: 1, g: 1, b: 1, a: 1) {
        didSet {
            renderView?.clearColor = clearColor
        }
    }
    
    public convenience init(device: MTLDevice?, frame: CGRect) throws {
        self.init(frame: frame)
        self.renderView = try LayersRenderView(device: device,
                                               label: "MyView")
        commonSetup()
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    private func commonSetup() {
        guard let renderView = renderView else {
            return
        }
        renderView.frame = bounds
        self.addSubview(renderView)
        renderView.translatesAutoresizingMaskIntoConstraints = false
        leadingAnchor.constraint(equalTo: renderView.leadingAnchor).isActive = true
        trailingAnchor.constraint(equalTo: renderView.trailingAnchor).isActive = true
        topAnchor.constraint(equalTo: renderView.topAnchor).isActive = true
        bottomAnchor.constraint(equalTo: renderView.bottomAnchor).isActive = true
    }
}
