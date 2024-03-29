#import "WindowController.h"
#import "controller/ViewController.h"

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
        self.window.title = @"Metal App";

        self.window.titlebarAppearsTransparent = true;
        self.window.backgroundColor = [NSColor colorWithSRGBRed:228 / 255.f
                                                          green:228 / 255.f
                                                           blue:228 / 255.f
                                                          alpha:1.f];

        ViewController* viewController = [[ViewController alloc] initWithFrame:frameRect];
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
