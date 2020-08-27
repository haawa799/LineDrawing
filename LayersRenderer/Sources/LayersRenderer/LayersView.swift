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
    
    private let renderView: LayersRenderView?
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
    
    public override init(frame: CGRect) {
        self.renderView = try? LayersRenderView(label: "MyView")
        super.init(frame: frame)
        commonSetup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.renderView = try? LayersRenderView(label: "MyView")
        super.init(coder: aDecoder)
        commonSetup()
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

public extension LayersView  {
    
    var device: MTLDevice? {
        return renderView?.device
    }
    
    var sampleCount: Int {
        return renderView?.sampleCount ?? 0
    }
}
