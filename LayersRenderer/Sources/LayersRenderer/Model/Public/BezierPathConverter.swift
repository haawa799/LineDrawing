//
//  BezierPathConverter.swift
//  LayersRender
//
//  Created by Andriy K. on 5/23/19.
//  Copyright © 2019 haawa. All rights reserved.
//

import UIKit

public struct ColoredBezierPath {
    public let path: UIBezierPath
    public let color: DrawingColor
    public let thickness: CGFloat
    
    public init(path: UIBezierPath,
                color: DrawingColor,
                thickness: CGFloat) {
        self.path = path
        self.color = color
        self.thickness = thickness
    }
}

public final class BezierPathConverter {
    
    public static func linePathPoints(from paths: [ColoredBezierPath],
                                      coordinateNormalizer: (CGPoint) -> CGPoint) -> [[LinePoint]] {
        
        var result = [[LinePoint]]()
        for coloredPath in paths {
            let pathWithLookup = BezierPathWithLookup(bezierPath: coloredPath.path)
            let points: [CGPoint] = pathWithLookup.lookupTable
            let qPoints = points.lazy.map(coordinateNormalizer)
            let linePoints = qPoints.lazy.map { LinePoint(point: $0,
                                                     thickness: coloredPath.thickness,
                                                     color: coloredPath.color) }
            result.append(Array(linePoints))
        }
        return result
    }
    
}
