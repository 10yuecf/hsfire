//
//  hsdcwUtils.h
//  hsjhb
//
//  Created by louislee on 16/6/15.
//  Copyright © 2016年 hsdcw. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sys/utsname.h>

@interface hsdcwUtils : NSObject

-(BOOL)isBlankString:(NSString *)string;

-(BOOL)validateMobile:(NSString *)mobile;

-(NSMutableArray *)getUserInfo;

-(int)getRandomNumber:(int)from to:(int)to;

-(NSMutableArray *)myencrypt;

- (NSString *)iphoneType;

@end
