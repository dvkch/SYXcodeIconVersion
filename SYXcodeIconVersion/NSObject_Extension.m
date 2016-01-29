//
//  NSObject_Extension.m
//  SYXcodeIconVersion
//
//  Created by Stan Chevallier on 28/01/2016.
//  Copyright © 2016 Syan. All rights reserved.
//


#import "NSObject_Extension.h"
#import "SYXcodeIconVersion.h"

@implementation NSObject (Xcode_Plugin_Template_Extension)

+ (void)pluginDidLoad:(NSBundle *)plugin
{
    static dispatch_once_t onceToken;
    NSString *currentApplicationName = [[NSBundle mainBundle] infoDictionary][@"CFBundleName"];
    if ([currentApplicationName isEqual:@"Xcode"]) {
        dispatch_once(&onceToken, ^{
            sharedPlugin = [[SYXcodeIconVersion alloc] initWithBundle:plugin];
        });
    }
}
@end
