#import <AppKit/AppKit.h>
#import <Metal/Metal.h>
#import <QuartzCore/CAMetalLayer.h>

// Protocol to provide resize and redraw callbacks to a delegate
@protocol AAPLViewDelegate <NSObject>

- (void)drawableResize:(CGSize)size;

- (void)renderToMetalLayer:(nonnull CAMetalLayer*)metalLayer;

@end

// Metal view base class
@interface AAPLView : NSView <CALayerDelegate>

@property(nonatomic, nonnull, readonly) CAMetalLayer* metalLayer;

@property(nonatomic, nullable) id<AAPLViewDelegate> delegate;

- (void)resizeDrawable:(CGFloat)scaleFactor;

- (void)render;

@end
