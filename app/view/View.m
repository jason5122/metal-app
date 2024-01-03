#import "View.h"

@implementation View

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.wantsLayer = YES;
        self.layerContentsRedrawPolicy = NSViewLayerContentsRedrawDuringViewResize;

        _metalLayer = (CAMetalLayer*)self.layer;
        self.layer.delegate = self;
    }
    return self;
}

- (void)resizeDrawable:(CGFloat)scaleFactor {
    CGSize newSize = self.bounds.size;
    newSize.width *= scaleFactor;
    newSize.height *= scaleFactor;

    if (newSize.width <= 0 || newSize.width <= 0) {
        return;
    }

    if (newSize.width == _metalLayer.drawableSize.width &&
        newSize.height == _metalLayer.drawableSize.height) {
        return;
    }

    _metalLayer.drawableSize = newSize;

    [_delegate drawableResize:newSize];
}

- (void)render {
    [_delegate renderToMetalLayer:_metalLayer];
}

- (CALayer*)makeBackingLayer {
    return [CAMetalLayer layer];
}

- (void)viewDidMoveToWindow {
    [super viewDidMoveToWindow];
    [self resizeDrawable:self.window.screen.backingScaleFactor];
}

// Override methods needed to handle event-based rendering

- (void)displayLayer:(CALayer*)layer {
    [self renderOnEvent];
}

- (void)drawLayer:(CALayer*)layer inContext:(CGContextRef)ctx {
    [self renderOnEvent];
}

- (void)drawRect:(CGRect)rect {
    [self renderOnEvent];
}

- (void)renderOnEvent {
    [self render];
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
