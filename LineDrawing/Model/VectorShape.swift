//
//  VectorShape.swift
//  LineDrawing
//
//  Created by Andriy K. on 5/22/19.
//  Copyright © 2019 haawa. All rights reserved.
//

import UIKit
import LayersRenderer

struct VectorShape {
    
    let points: [[LinePoint]]
    
    init(color: DrawingColor,
         strokeThickness: CGFloat) throws {
        
        // Read UIBezierPaths from binary file
        guard let fileURL = Bundle.main.url(forResource: "bezier_paths_努",
                                            withExtension: "bin") else {
                                                throw "Cannot find file with bezier paths"
        }
        
        let data = try Data(contentsOf: fileURL)
        guard let bezierPaths = try? NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data) as? [UIBezierPath] else {
            throw "Error decoding UIBezierPath from binary file"
        }
        
        let coloredBezierPath = bezierPaths.map { ColoredBezierPath(path: $0,
                                                                    color: color,
                                                                    thickness: strokeThickness) }
        
        self.points = BezierPathConverter.linePathPoints(from: coloredBezierPath) {
            CGPoint(x: ($0.x / (106/2)) - 1,
                    y: (-$0.y / (106/2)) + 1)
        }
    }
}
