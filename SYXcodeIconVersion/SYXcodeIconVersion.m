//
//  SYXcodeIconVersion.m
//  SYXcodeIconVersion
//
//  Created by Stan Chevallier on 28/01/2016.
//  Copyright © 2016 Syan. All rights reserved.
//

#import "SYXcodeIconVersion.h"

static SYXcodeIconVersion *sharedPlugin;

@implementation SYXcodeIconVersion

#pragma mark - Initialization

+ (void)pluginDidLoad:(NSBundle *)plugin
{
    NSArray *allowedLoaders = [plugin objectForInfoDictionaryKey:@"me.delisa.XcodePluginBase.AllowedLoaders"];
    if ([allowedLoaders containsObject:[[NSBundle mainBundle] bundleIdentifier]]) {
        sharedPlugin = [[self alloc] initWithBundle:plugin];
    }
}

+ (instancetype)sharedPlugin
{
    return sharedPlugin;
}

- (id)initWithBundle:(NSBundle *)bundle
{
    if (self = [super init]) {
        // reference to plugin's bundle, for resource access
        _bundle = bundle;
        // NSApp may be nil if the plugin is loaded from the xcodebuild command line tool
        if (NSApp && !NSApp.mainMenu) {
            [[NSNotificationCenter defaultCenter] addObserver:self
                                                     selector:@selector(applicationDidFinishLaunching:)
                                                         name:NSApplicationDidFinishLaunchingNotification
                                                       object:nil];
        } else {
            [self initializeAndLog];
        }
    }
    return self;
}

- (void)applicationDidFinishLaunching:(NSNotification *)notification
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NSApplicationDidFinishLaunchingNotification object:nil];
    [self initializeAndLog];
}

- (void)initializeAndLog
{
    NSString *name = [self.bundle objectForInfoDictionaryKey:@"CFBundleName"];
    NSString *version = [self.bundle objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
    NSString *status = [self initialize] ? @"loaded successfully" : @"failed to load";
    NSLog(@"🔌 Plugin %@ %@ %@", name, version, status);
}

#pragma mark - Implementation

- (BOOL)initialize
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
	[NSApp setApplicationIconImage:image];
	return NSApp != nil;
}

@end
