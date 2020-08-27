//
//  UniformBufferData.swift
//  LayersRender
//
//  Created by Andriy K. on 5/23/19.
//  Copyright © 2019 haawa. All rights reserved.
//

import Foundation

struct UniformBufferData {
    let xMultiplier: Float
    let yMultiplier: Float
    
    init(aspectRatio: Float) {
        if aspectRatio < 1 {
            xMultiplier = 1
            yMultiplier = aspectRatio
        } else {
            xMultiplier = 1 / aspectRatio
            yMultiplier = 1
        }
    }
}
