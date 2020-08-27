//
//  File.swift
//  
//
//  Created by Andriy K. on 6/4/19.
//

import Foundation

let shadersString: String = """
#include <metal_stdlib>
using namespace metal;

struct Uniform {
float xMultiplier;
float yMultiplier;
};

struct VertexIn {
packed_float2 position;
packed_float4 color;
};

struct VertexOut {
float4 computedPosition [[position]];
float4 color;
};

vertex VertexOut basic_vertex(const device VertexIn *vertex_array [[ buffer(0) ]],
constant Uniform &uniformBuffer [[buffer(1)]],
unsigned int vid [[ vertex_id ]]) {
VertexIn v = vertex_array[vid];
VertexOut outVertex = VertexOut();
outVertex.computedPosition = float4(v.position[0] * uniformBuffer.xMultiplier,
v.position[1] * uniformBuffer.yMultiplier,
0.0,
1.0);
outVertex.color = v.color;
return outVertex;
}

fragment float4 basic_fragment(VertexOut interpolated [[stage_in]]) {
return interpolated.color;
}
"""
