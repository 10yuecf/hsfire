//
//  hsdcwUtils.m
//  hsjhb
//
//  Created by louislee on 16/6/15.
//  Copyright © 2016年 hsdcw. All rights reserved.
//

#import <sqlite3.h>
#import "hsdcwUtils.h"

@implementation hsdcwUtils

- (BOOL) isBlankString:(NSString *)string {
    if (string == nil || string == NULL || [string isEqualToString:@" "] || [string isEqualToString:@"null"] || [string isEqualToString:@"NULL"] || [string isEqualToString:@""]) {
        return YES;
    }
    if ([string isKindOfClass:[NSNull class]]) {
        return YES;
    }
    if ([[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length]==0) {
        return YES;
    }
    return NO;
}

-(int)getRandomNumber:(int)from to:(int)to {
    return (int)(from + (arc4random() % (to - from + 1)));
}

@end
