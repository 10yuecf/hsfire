//
//  hsdcwUtils.m
//  hsjhb
//
//  Created by louislee on 16/6/15.
//  Copyright © 2016年 hsdcw. All rights reserved.
//

#import <sqlite3.h>
#import "hsdcwUtils.h"
#import "UserTool.h"
#import "User.h"

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

- (NSMutableArray *) getUserInfo {
    
    NSString *chkuser = [NSString stringWithFormat:@"select * from t_user where loginstatus = '1' limit 1"];
    NSMutableArray *user_arr = [UserTool userWithSql:chkuser];
    User *u = user_arr[0];
    
    //是否应该添加本地数据为空的判断
    NSMutableArray *datas = [[NSMutableArray alloc]initWithCapacity:5];
    [datas addObject:u.ID]; //0
    [datas addObject:u.userID]; //1
    [datas addObject:u.usertoken]; //2
    [datas addObject:u.nickname]; //3
    [datas addObject:u.username]; //4
    [datas addObject:u.photo_s]; //5
    [datas addObject:u.sex]; //6
    [datas addObject:u.bir]; //7
    [datas addObject:u.area]; //8
    [datas addObject:u.heigh]; //9
    [datas addObject:u.edu]; //10
    [datas addObject:u.pay]; //11
    [datas addObject:u.love]; //12
    [datas addObject:u.loginstatus]; //13
    [datas addObject:u.degree]; //14
    
    return datas;
}

-(int)getRandomNumber:(int)from to:(int)to {
    return (int)(from + (arc4random() % (to - from + 1)));
}

@end
