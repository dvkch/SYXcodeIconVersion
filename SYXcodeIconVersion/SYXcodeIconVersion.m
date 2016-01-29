//
//  SYXcodeIconVersion.m
//  SYXcodeIconVersion
//
//  Created by Stan Chevallier on 28/01/2016.
//  Copyright © 2016 Syan. All rights reserved.
//

#import "SYXcodeIconVersion.h"

@interface SYXcodeIconVersion()

@property (nonatomic, strong, readwrite) NSBundle *bundle;
@end

@implementation SYXcodeIconVersion

+ (instancetype)sharedPlugin
{
    return sharedPlugin;
}

- (id)initWithBundle:(NSBundle *)plugin
{
    if (self = [super init]) {
        // reference to plugin's bundle, for resource access
        self.bundle = plugin;
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(didApplicationFinishLaunchingNotification:)
                                                     name:NSApplicationDidFinishLaunchingNotification
                                                   object:nil];
    }
    return self;
}

- (void)didApplicationFinishLaunchingNotification:(NSNotification*)notification
{
    //removeObserver
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NSApplicationDidFinishLaunchingNotification object:nil];
    
    //main method
    [self addXcodeVersionToDockImage];
}

- (void)addXcodeVersionToDockImage
{
    CGFloat size = 256;
    CGFloat factor = size / 128.;
    
    // Text
    NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    
    // Text attributes
    NSShadow *shadow = [[NSShadow alloc] init];
    [shadow setShadowBlurRadius:5*factor];
    [shadow setShadowColor:[[NSColor blackColor] colorWithAlphaComponent:0.5]];
    [shadow setShadowOffset:NSMakeSize(-1*factor, -3*factor)];
    NSDictionary *attributes = @{NSFontAttributeName:[NSFont systemFontOfSize:25*factor weight:.5],
                                 NSForegroundColorAttributeName:[NSColor whiteColor],
                                 NSShadowAttributeName:shadow,
                                 NSStrokeColorAttributeName:[NSColor blackColor],
                                 NSStrokeWidthAttributeName:@(-1),
                                 };
    
    // Image
    NSImage *image = [[NSWorkspace sharedWorkspace] iconForFile:[[NSBundle mainBundle] bundlePath]];
    [image setSize:NSMakeSize(size, size)];
    [image lockFocus];
    {
        NSGraphicsContext *context = [NSGraphicsContext currentContext];
        [context saveGraphicsState];
        {
            NSAffineTransform *rotate = [[NSAffineTransform alloc] init];
            [rotate rotateByDegrees:9.f];
            [rotate concat];
            
            [version drawAtPoint:NSMakePoint(25*factor, 10*factor) withAttributes:attributes];
        }
        [context restoreGraphicsState];
    }
    
    [image unlockFocus];
#if DEBUG
    [self saveImage:image];
#endif
    [NSApp setApplicationIconImage:image];
}

- (void)saveImage:(NSImage *)image
{
    // PNG Data
    CGImageRef imageRef = [image CGImageForProposedRect:NULL context:nil hints:nil];
    NSBitmapImageRep *imageRep = [[NSBitmapImageRep alloc] initWithCGImage:imageRef];
    [imageRep setSize:[image size]];
    NSData *pngData = [imageRep representationUsingType:NSPNGFileType properties:@{}];
    
    // Path
    NSString *userDesktopPath = NSSearchPathForDirectoriesInDomains(NSDesktopDirectory, NSUserDomainMask, YES)[0];
    NSString *imageName = [NSString stringWithFormat:@"xcode_dock_icon@%dx%d.png", (int)image.size.width, (int)image.size.height];
    NSString *imagePath = [userDesktopPath stringByAppendingPathComponent:imageName];
    
    // Saving
    [pngData writeToFile:imagePath atomically:YES];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
