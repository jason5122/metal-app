#import "MetalLayerView.h"
#import <Metal/Metal.h>

@implementation MetalLayerView

- (instancetype)initWithFrame:(NSRect)frameRect {
    self = [super initWithFrame:frameRect];
    if (self) {
        self.wantsLayer = true;
        // self.layer.backgroundColor =
        //     [NSColor colorWithCalibratedRed:1 green:0 blue:0 alpha:1.0f].CGColor;

        id<MTLDevice> device = MTLCreateSystemDefaultDevice();
        renderer = [[Renderer alloc] initWithPixelFormat:MTLPixelFormatBGRA8Unorm device:device];
    }
    return self;
}

- (CALayer*)makeBackingLayer {
    metalLayer = [CAMetalLayer layer];
    metalLayer.pixelFormat = MTLPixelFormatBGRA8Unorm;
    metalLayer.device = renderer.device;
    metalLayer.delegate = self;

    metalLayer.allowsNextDrawableTimeout = false;

    // these properties are crucial to resizing working
    metalLayer.autoresizingMask = kCALayerHeightSizable | kCALayerWidthSizable;
    metalLayer.needsDisplayOnBoundsChange = true;
    metalLayer.presentsWithTransaction = true;

    return metalLayer;
}

- (void)setFrameSize:(NSSize)newSize {
    [super setFrameSize:newSize];
    renderer->viewportSize.x = newSize.width;
    renderer->viewportSize.y = newSize.height;
    // the conversion below is necessary for high DPI drawing
    metalLayer.drawableSize = [self convertSizeToBacking:newSize];
}

- (void)display {
    id<CAMetalDrawable> drawable = [metalLayer nextDrawable];
    MTLRenderPassDescriptor* passDescriptor = [[MTLRenderPassDescriptor alloc] init];
    MTLRenderPassColorAttachmentDescriptor* colorAttachment = passDescriptor.colorAttachments[0];
    colorAttachment.texture = drawable.texture;
    colorAttachment.loadAction = MTLLoadActionClear;
    colorAttachment.storeAction = MTLStoreActionStore;
    colorAttachment.clearColor = MTLClearColorMake(0, 0, 0, 0);

    id<MTLCommandBuffer> commandBuffer = [renderer drawWithPassDescriptor:passDescriptor];
    [commandBuffer commit];
    [commandBuffer waitUntilScheduled];
    [commandBuffer presentDrawable:drawable];
}

@end
