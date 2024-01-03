#import "WindowController.h"
#import "controller/AAPLViewController.h"
#import "view/MetalLayerView.h"

@implementation WindowController

- (instancetype)initWithFrame:(NSRect)frameRect {
    self = [super init];
    if (self) {
        unsigned int mask = NSWindowStyleMaskTitled | NSWindowStyleMaskResizable |
                            NSWindowStyleMaskClosable | NSWindowStyleMaskMiniaturizable;
        self.window = [[NSWindow alloc] initWithContentRect:frameRect
                                                  styleMask:mask
                                                    backing:NSBackingStoreBuffered
                                                      defer:false];

        AAPLViewController* viewController = [[AAPLViewController alloc] initWithFrame:frameRect];
        self.window.contentView = viewController.view;
    }
    return self;
}

- (void)showWindow {
    [self.window center];
    [self.window setFrameAutosaveName:@"metal-app"];
    [self.window makeKeyAndOrderFront:nil];
}

@end
