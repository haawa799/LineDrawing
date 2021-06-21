//
//  LayersRenderView.swift
//  LineDrawing
//
//  Created by Andriy K. on 5/21/19.
//  Copyright © 2019 haawa. All rights reserved.
//

import UIKit
import MetalKit

protocol LayersRenderViewProtocol {
    var device: MTLDevice { get }
    var layers: [DrawingLayer] { get set }
    var sampleCount: Int { get }
}

@available(iOS 10, *)
final class LayersRenderView: UIView, LayersRenderViewProtocol {
    
    // MARK: - Initialization
    let label: String
    let device: MTLDevice
    private let commandQueue: MTLCommandQueue
    private let library: MTLLibrary
    private let pipelineState: MTLRenderPipelineState
    var layers = [DrawingLayer]()
    let sampleCount: Int
    var clearColor = DrawingColor(r: 1, g: 1, b: 1, a: 1)
    
    required init(device: MTLDevice?, label: String) throws {
        
        guard let device = device,
              let commandQueue = device.makeCommandQueue() else {
                throw "Setup error. Most likely MTLDevice not provided"
        }
        let library = try device.makeDefaultLibrary(bundle: Bundle.module)
        
        self.label = label
        self.device = device
        self.library = library
        self.commandQueue = commandQueue
        if device.supportsTextureSampleCount(4) {
            sampleCount = 4
        } else {
            sampleCount = 1
        }
        // pipelineState
        let fragmentProgram = library.makeFunction(name: "basic_fragment")
        let vertexProgram = library.makeFunction(name: "basic_vertex")
        let pipelineStateDescriptor = MTLRenderPipelineDescriptor()
        pipelineStateDescriptor.sampleCount = sampleCount
        pipelineStateDescriptor.vertexFunction = vertexProgram
        pipelineStateDescriptor.fragmentFunction = fragmentProgram
        pipelineStateDescriptor.colorAttachments[0].pixelFormat = .bgra8Unorm
        pipelineState = try device.makeRenderPipelineState(descriptor: pipelineStateDescriptor)
        super.init(frame: CGRect.zero)
        commonSetup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func commonSetup() {
        let metalView = MTKView(frame: bounds, device: device)
        metalView.preferredFramesPerSecond = 120
        metalView.sampleCount = sampleCount
        self.addSubview(metalView)
        metalView.translatesAutoresizingMaskIntoConstraints = false
        leadingAnchor.constraint(equalTo: metalView.leadingAnchor).isActive = true
        trailingAnchor.constraint(equalTo: metalView.trailingAnchor).isActive = true
        topAnchor.constraint(equalTo: metalView.topAnchor).isActive = true
        bottomAnchor.constraint(equalTo: metalView.bottomAnchor).isActive = true
        metalView.delegate = self
    }
    
    private weak var metalView: MTKView?
}

extension LayersRenderView: MTKViewDelegate {
    
    func mtkView(_ view: MTKView, drawableSizeWillChange size: CGSize) {
        let aspectRatio = size.width / size.height
        layers.forEach { $0.aspectRatio = aspectRatio }
    }
    
    func draw(in view: MTKView) {
        render(view)
    }
    
    private func render(_ view: MTKView) {
        
        guard let drawable = view.currentDrawable,
            let renderPassDescriptor = view.currentRenderPassDescriptor  else {
            return
        }
        
        renderPassDescriptor.colorAttachments[0].loadAction = .clear
        renderPassDescriptor.colorAttachments[0].clearColor = clearColor.mtlClearColor
        
        let commandBuffer = commandQueue.makeCommandBuffer()!
        let renderEncoder = commandBuffer.makeRenderCommandEncoder(descriptor: renderPassDescriptor)!
        renderEncoder.setRenderPipelineState(pipelineState)
        
        for layer in layers {
            layer.render(renderEncoder)
        }
        
        renderEncoder.endEncoding()
        commandBuffer.present(drawable)
        commandBuffer.commit()
    }
}

