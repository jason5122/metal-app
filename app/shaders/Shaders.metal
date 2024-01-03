#include <metal_stdlib>
#include <simd/simd.h>
using namespace metal;

// Include header shared between this Metal shader code and C code executing Metal API commands
#include "ShaderTypes.h"

// Vertex shader outputs and per-fragment inputs
struct RasterizerData {
    float4 clipSpacePosition [[position]];
    float3 color;
};

vertex RasterizerData vertexShader(uint vertexID [[vertex_id]],
                                   constant Vertex* vertexArray
                                   [[buffer(VertexInputIndexVertices)]],
                                   constant Uniforms& uniforms
                                   [[buffer(VertexInputIndexUniforms)]]) {
    RasterizerData out;

    float2 pixelSpacePosition = vertexArray[vertexID].position.xy;

    float2 viewportSize = float2(uniforms.viewportSize);

    // Fix coordinates to bottom left to test judder.
    pixelSpacePosition -= (viewportSize / 2.0);

    // Divide the pixel coordinates by half the size of the viewport to convert from positions in
    // pixel space to positions in clip space
    out.clipSpacePosition.xy = pixelSpacePosition / (viewportSize / 2.0);
    out.clipSpacePosition.z = 0.0;
    out.clipSpacePosition.w = 1.0;

    out.color = vertexArray[vertexID].color;

    return out;
}

fragment float4 fragmentShader(RasterizerData in [[stage_in]]) {
    return float4(in.color, 1.0);
}