#import "model/Renderer.h"
#import <Cocoa/Cocoa.h>
#import <QuartzCore/QuartzCore.h>

@interface MetalLayerView : NSView <CALayerDelegate> {
    Renderer* renderer;
    CAMetalLayer* metalLayer;
}

@end
