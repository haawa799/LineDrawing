//
//  DrawingColor.swift
//  LayersRender
//
//  Created by Andriy K. on 5/23/19.
//  Copyright © 2019 haawa. All rights reserved.
//

import MetalKit

public struct DrawingColor {
    public let r: Float
    public let g: Float
    public let b: Float
    public let a: Float
    
    public init(r: Float, g: Float, b: Float, a: Float) {
        self.r = r
        self.g = g
        self.b = b
        self.a = a
    }
    
    var mtlClearColor: MTLClearColor {
        
        return MTLClearColor(red: Double(r),
                             green: Double(g),
                             blue: Double(b),
                             alpha: Double(a))
        
    }
}
