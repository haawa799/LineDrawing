//
//  Line.swift
//  LineDrawing
//
//  Created by Andriy K. on 5/21/19.
//  Copyright © 2019 haawa. All rights reserved.
//

import UIKit

class Line {
    let start: LinePoint
    let end: LinePoint
    
    init(start: LinePoint, end: LinePoint) {
        self.start = start
        self.end = end
    }
    
    var vertices: [Vertex] {
        let x0 = Float(start.point.x)
        let x1 = Float(end.point.x)
        let y0 = Float(start.point.y)
        let y1 = Float(end.point.y)
        
        var vertices = [Vertex]()
        
        let xLength = x1 - x0
        let yLength = y1 - y0
        let startThickness = Float(start.thickness)
        let endThickness = Float(end.thickness)
        
        let alpha = atan(yLength/xLength)
        let px = -sin(alpha) * 0.5
        let py = cos(alpha) * 0.5
        
        vertices.append(Vertex(x: x0 + px * startThickness,
                               y: y0 + py * startThickness,
                               color: start.color)) // A
        vertices.append(Vertex(x: x1 + px * endThickness,
                               y: y1 + py * endThickness,
                               color: end.color)) // B
        vertices.append(Vertex(x: x1 - px * endThickness,
                               y: y1 - py * endThickness,
                               color: end.color)) // C
        vertices.append(Vertex(x: x0 - px * startThickness,
                               y: y0 - py * startThickness,
                               color: start.color)) // D
        
        return vertices
    }
    
    var indices: [UInt32] = [
        0, 1, 2,
        2, 3, 0
    ]
}


extension Array {
    func size() -> Int {
        return count * MemoryLayout.size(ofValue: self[0])
    }
}
