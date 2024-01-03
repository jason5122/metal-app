#import "util/AAPLConfig.h"
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

@property(nonatomic, getter=isPaused) BOOL paused;

@property(nonatomic, nullable) id<AAPLViewDelegate> delegate;

- (void)initCommon;

#if AUTOMATICALLY_RESIZE
- (void)resizeDrawable:(CGFloat)scaleFactor;
#endif

#if ANIMATION_RENDERING
- (void)stopRenderLoop;
#endif

- (void)render;

@end
