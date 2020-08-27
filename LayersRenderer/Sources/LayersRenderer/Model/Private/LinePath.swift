//
//  LinePath.swift
//  LineDrawing
//
//  Created by Andriy K. on 5/21/19.
//  Copyright © 2019 haawa. All rights reserved.
//

import UIKit
import MetalKit

struct LinePath {
    let lines: [Line]
    
    init(strokes: [[LinePoint]]) throws {
        var lines = [Line]()
        for stroke in strokes {
            var previousPoint: LinePoint?
            for point in stroke {
                if let previousPoint = previousPoint {
                    let line = Line(start: previousPoint, end: point)
                    lines.append(line)
                }
                previousPoint = point
            }
        }
        guard !lines.isEmpty else {
            throw "Not enough points"
        }
        self.lines = lines
    }
    
    func drawingData(device: MTLDevice) -> DrawingData {
        
        var triangleVertices = [Vertex]()
        var triangleIndices = [UInt32]()
        
        var fanVertices = [Vertex]()
        var fanIndices = [UInt32]()
        
        for line in lines {
            
            // Rectangle part
            let vertices = line.vertices
            let triangleIndexShift = UInt32(triangleVertices.count)
            let indices = line.indices.map { $0 + triangleIndexShift }
            triangleIndices.append(contentsOf: indices)
            triangleVertices.append(contentsOf: vertices)
            
            // Circles
            // start
            let startShift = UInt32(fanVertices.count)
            let startCircleData = circleTriangles(line.start.point,
                                              thickness: line.start.thickness,
                                              shift: startShift,
                                              color: line.start.color)
            fanVertices.append(contentsOf: startCircleData.0)
            fanIndices.append(contentsOf: startCircleData.1)
            // end
            let endShift = UInt32(fanVertices.count)
            let endCircleData = circleTriangles(line.end.point,
                                                thickness: line.end.thickness,
                                                shift: endShift,
                                                color: line.start.color)
            fanVertices.append(contentsOf: endCircleData.0)
            fanIndices.append(contentsOf: endCircleData.1)
        }
        
        let trianglesGroup = drawingGroupData(device: device,
                                              vertices: triangleVertices,
                                              indices: triangleIndices)
        let fanGroup = drawingGroupData(device: device,
                                        vertices: fanVertices,
                                        indices: fanIndices)
        return DrawingData(lineRect: trianglesGroup, joinsCircles: fanGroup)
    }
    
    func circleTriangles(_ center: CGPoint,
                         thickness: CGFloat,
                         shift: UInt32,
                         color: DrawingColor) -> ([Vertex], [UInt32]) {
        
        var fanVertices = [Vertex]()
        var fanIndices = [UInt32]()
        
        // Fans
        let fanIndexShift = shift
        let n = 20
        let q = Vertex(x: Float(center.x),
                       y: Float(center.y),
                       color: color)
        let angleStep = (2 * Float.pi) / Float(n)
        let r = Float(thickness) * 0.5
        
        fanVertices.append(q) // center
        let centerIndex = fanIndexShift
        var lastVertexIndex: UInt32?
        
        for i in 0...n+1 {
            let currentIndex = centerIndex + UInt32(i)
            if let lastVertexIndex = lastVertexIndex {
                fanIndices.append(currentIndex)
                fanIndices.append(centerIndex)
                fanIndices.append(lastVertexIndex)
            }
            let angle = Float(i) * angleStep
            let x = cos(angle) * r + q.x
            let y = sin(angle) * r + q.y
            let vertex = Vertex(x: x, y: y, color: color)
            fanVertices.append(vertex)
            lastVertexIndex = currentIndex
        }
        
        return (fanVertices, fanIndices)
    }
    
    func drawingGroupData(device: MTLDevice,
             vertices: [Vertex],
             indices: [UInt32]) -> DrawingGroup {
        
        let dataSize = vertices.count * MemoryLayout<Vertex>.size
        let vertexBuffer = device.makeBuffer(bytes: vertices,
                                             length: dataSize,
                                             options: [])!
        let indicesBufferSize = indices.count * MemoryLayout<UInt32>.size
        let indicesBuffer = device.makeBuffer(bytes: indices,
                                              length: indicesBufferSize,
                                              options: [])!
        
        return DrawingGroup(vertexBuffer: vertexBuffer,
                     indicesBuffer: indicesBuffer,
                     indicesCount: indices.count)
    }
}

extension String: Error {
}
