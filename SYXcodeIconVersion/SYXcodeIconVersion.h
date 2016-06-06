//
//  SYXcodeIconVersion.h
//  SYXcodeIconVersion
//
//  Created by Stan Chevallier on 28/01/2016.
//  Copyright © 2016 Syan. All rights reserved.
//

#import <AppKit/AppKit.h>

@interface SYXcodeIconVersion : NSObject

+ (instancetype)sharedPlugin;

@property (nonatomic, strong, readonly) NSBundle* bundle;
@end