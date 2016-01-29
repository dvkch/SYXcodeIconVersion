//
//  SYXcodeIconVersion.h
//  SYXcodeIconVersion
//
//  Created by Stan Chevallier on 28/01/2016.
//  Copyright © 2016 Syan. All rights reserved.
//

#import <AppKit/AppKit.h>

@class SYXcodeIconVersion;

static SYXcodeIconVersion *sharedPlugin;

@interface SYXcodeIconVersion : NSObject

+ (instancetype)sharedPlugin;
- (id)initWithBundle:(NSBundle *)plugin;

@property (nonatomic, strong, readonly) NSBundle* bundle;
@end