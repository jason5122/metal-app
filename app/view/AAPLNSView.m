#import "AAPLNSView.h"

@implementation AAPLNSView {
    CVDisplayLinkRef _displayLink;
}

- (void)initCommon {
    self.wantsLayer = YES;

    self.layerContentsRedrawPolicy = NSViewLayerContentsRedrawDuringViewResize;

    [super initCommon];
}

- (CALayer*)makeBackingLayer {
    return [CAMetalLayer layer];
}

- (void)viewDidMoveToWindow {
    [super viewDidMoveToWindow];
    [self resizeDrawable:self.window.screen.backingScaleFactor];
}

// Override all methods which indicate the view's size has changed.

- (void)viewDidChangeBackingProperties {
    [super viewDidChangeBackingProperties];
    [self resizeDrawable:self.window.screen.backingScaleFactor];
}

- (void)setFrameSize:(NSSize)size {
    [super setFrameSize:size];
    [self resizeDrawable:self.window.screen.backingScaleFactor];
}

- (void)setBoundsSize:(NSSize)size {
    [super setBoundsSize:size];
    [self resizeDrawable:self.window.screen.backingScaleFactor];
}

@end
