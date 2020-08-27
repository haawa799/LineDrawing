//
//  LinePoint.swift
//  LineDrawing
//
//  Created by Andriy K. on 5/21/19.
//  Copyright © 2019 haawa. All rights reserved.
//

import UIKit

public struct LinePoint {
    public let point: CGPoint
    public let thickness: CGFloat
    public let color: DrawingColor
    
    public init(point: CGPoint,
                thickness: CGFloat,
                color: DrawingColor) {
        self.point = point
        self.thickness = thickness
        self.color = color
    }
}
