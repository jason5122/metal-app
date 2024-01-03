#import <Cocoa/Cocoa.h>
#import <Metal/Metal.h>
#import <simd/SIMD.h>

@interface Renderer : NSObject {
@public
    // id<MTLDevice> device;
    id<MTLCommandQueue> commandQueue;
    id<MTLRenderPipelineState> pipelineState;
    vector_uint2 viewportSize;
}

@property(nonatomic, strong) id<MTLDevice> device;

- (instancetype)initWithPixelFormat:(MTLPixelFormat)pixelFormat device:(id<MTLDevice>)device;
- (id<MTLCommandBuffer>)drawWithPassDescriptor:(MTLRenderPassDescriptor*)passDescriptor;

@end
