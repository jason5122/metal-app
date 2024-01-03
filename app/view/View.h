#import <AppKit/AppKit.h>
#import <Metal/Metal.h>
#import <QuartzCore/CAMetalLayer.h>

// Protocol to provide resize and redraw callbacks to a delegate
@protocol ViewDelegate <NSObject>

- (void)drawableResize:(CGSize)size;

- (void)renderToMetalLayer:(nonnull CAMetalLayer*)metalLayer;

@end

// Metal view base class
@interface View : NSView <CALayerDelegate>

@property(nonatomic, nonnull, readonly) CAMetalLayer* metalLayer;

@property(nonatomic, nullable) id<ViewDelegate> delegate;

- (void)resizeDrawable:(CGFloat)scaleFactor;

- (void)render;

@end
