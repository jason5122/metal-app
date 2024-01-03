#import "ViewController.h"
#import "model/Renderer.h"
#import "view/View.h"
#import <QuartzCore/CAMetalLayer.h>

@implementation ViewController {
    Renderer* _renderer;
}

- (instancetype)initWithFrame:(NSRect)frameRect {
    self = [super init];
    if (self) {
        id<MTLDevice> device = MTLCreateSystemDefaultDevice();

        View* metalView = [[View alloc] initWithFrame:frameRect];

        // Set the device for the layer so the layer can create drawable textures that can be
        // rendered to on this device.
        metalView.metalLayer.device = device;

        // Set this class as the delegate to receive resize and render callbacks.
        metalView.delegate = self;

        metalView.metalLayer.pixelFormat = MTLPixelFormatBGRA8Unorm;

        // This is crucial for eliminating resize judder.
        metalView.metalLayer.presentsWithTransaction = true;

        _renderer = [[Renderer alloc] initWithMetalDevice:device
                                      drawablePixelFormat:metalView.metalLayer.pixelFormat];

        self.view = metalView;
    }
    return self;
}

- (void)drawableResize:(CGSize)size {
    [_renderer drawableResize:size];
}

- (void)renderToMetalLayer:(nonnull CAMetalLayer*)layer {
    [_renderer renderToMetalLayer:layer];
}

@end
