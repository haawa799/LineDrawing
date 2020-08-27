//
//  DrawingLayer.swift
//  LineDrawing
//
//  Created by Andriy K. on 5/23/19.
//  Copyright © 2019 haawa. All rights reserved.
//

import UIKit
import MetalKit

public final class DrawingLayer {
    
    private let indicesCountBundle = IndicesCountBundle()
    private let uniformBufferSize = MemoryLayout<UniformBufferData>.size
    private let data: DrawingData
    private let device: MTLDevice
    private let uniformBuffer: MTLBuffer
    var aspectRatio: CGFloat = 1 {
        didSet {
            updateUniformBuffer()
        }
    }
    
    public var progress: CGFloat = 0 {
        didSet {
            indicesCountBundle.lineRect = data.lineRectIndicesCount(progress: progress)
            indicesCountBundle.joinsCircles = data.joinsCirclesIndicesCount(progress: progress)
        }
    }
    
    public init(points: [[LinePoint]],
                device: MTLDevice,
                initialProgress: CGFloat = 0) throws {
        self.device = device
        let linePath = try LinePath(strokes: points)
        self.data = linePath.drawingData(device: device)
        self.progress = initialProgress
        indicesCountBundle.lineRect = data.lineRectIndicesCount(progress: progress)
        indicesCountBundle.joinsCircles = data.joinsCirclesIndicesCount(progress: progress)
        var uniformData = UniformBufferData(aspectRatio: Float(aspectRatio))
        self.uniformBuffer = device.makeBuffer(bytes: &uniformData,
                                              length: uniformBufferSize,
                                              options: [])!
    }
    
    private func updateUniformBuffer() {
        var uniformData = UniformBufferData(aspectRatio: Float(aspectRatio))
        uniformBuffer.contents().copyMemory(from: &uniformData,
                                            byteCount: uniformBufferSize)
    }
    
    func render(_ renderEncoder: MTLRenderCommandEncoder) {
        
        if indicesCountBundle.lineRect > 0,
            indicesCountBundle.joinsCircles > 0 {
            
            // Set uniform buffer
            renderEncoder.setVertexBuffer(uniformBuffer, offset: 0, index: 1)
            
            // Draw line rects
            renderEncoder.setVertexBuffer(data.lineRect.vertexBuffer, offset: 0, index: 0)
            renderEncoder.drawIndexedPrimitives(type: .triangle,
                                                indexCount: indicesCountBundle.lineRect,
                                                indexType: .uint32,
                                                indexBuffer: data.lineRect.indicesBuffer,
                                                indexBufferOffset: 0)
            // Draw joins circles
            renderEncoder.setVertexBuffer(data.joinsCircles.vertexBuffer, offset: 0, index: 0)
            renderEncoder.drawIndexedPrimitives(type: .triangle,
                                                indexCount: indicesCountBundle.joinsCircles,
                                                indexType: .uint32,
                                                indexBuffer: data.joinsCircles.indicesBuffer,
                                                indexBufferOffset: 0)
        }
        
    }
}
