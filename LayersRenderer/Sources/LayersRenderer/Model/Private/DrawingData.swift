//
//  DrawingData.swift
//  LineDrawing
//
//  Created by Andriy K. on 5/21/19.
//  Copyright © 2019 haawa. All rights reserved.
//

import Foundation
import MetalKit

struct DrawingGroup {
    let vertexBuffer: MTLBuffer
    let indicesBuffer: MTLBuffer
    let indicesCount: Int
}

struct DrawingData {
    let lineRect: DrawingGroup
    let joinsCircles: DrawingGroup
    
    func lineRectIndicesCount(progress: CGFloat) -> Int {
        let indicesCount = lineRect.indicesCount
        let multiplied = Int(CGFloat(indicesCount) * progress)
        let remainder = multiplied % 6
        let result = multiplied - remainder
        return result
    }
    
    func joinsCirclesIndicesCount(progress: CGFloat) -> Int {
        let indicesCount = joinsCircles.indicesCount
        let multiplied = Int(CGFloat(indicesCount) * progress)
        let remainder = multiplied % 126
        let result = multiplied - remainder
        return result
    }
}

final class IndicesCountBundle {
    var lineRect: Int
    var joinsCircles: Int
    
    init() {
        lineRect = 0
        joinsCircles = 0
    }
}
