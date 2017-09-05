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
#import "MyMD5.h"
#import "Macro.h"

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

/**
 *  正则表达式验证手机号
 *  @param mobile 传入手机号
 */
-(BOOL)validateMobile:(NSString *)mobile {
    // 130-139  150-153,155-159  180-189  145,147  170,171,173,176,177,178
    NSString *phoneRegex = @"^((13[0-9])|(15[^4,\\D])|(18[0-9])|(14[57])|(17[013678]))\\d{8}$";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneRegex];
    return [phoneTest evaluateWithObject:mobile];
}

-(NSMutableArray *) getUserInfo {
    NSString *chkuser = [NSString stringWithFormat:@"select * from t_user where loginstatus = '1' limit 1"];
    NSMutableArray *user_arr = [UserTool userWithSql:chkuser];
    User *u = user_arr[0];
    
    //是否应该添加本地数据为空的判断
    NSMutableArray *datas = [[NSMutableArray alloc]initWithCapacity:5];
    [datas addObject:u.ID]; //0
    [datas addObject:u.userID]; //1
    [datas addObject:u.devicetoken]; //2
    [datas addObject:u.name]; //3
    [datas addObject:u.account]; //4
    [datas addObject:u.status]; //5
    [datas addObject:u.zw]; //6
    [datas addObject:u.bz]; //7
    [datas addObject:u.createtime]; //8
    [datas addObject:u.groupid]; //9
    [datas addObject:u.tagid]; //10
    [datas addObject:u.tagname]; //11
    [datas addObject:u.dwtype]; //12
    [datas addObject:u.tel]; //13
    [datas addObject:u.dwname]; //14
    [datas addObject:u.dwid]; //14
    
    return datas;
}

-(int)getRandomNumber:(int)from to:(int)to {
    return (int)(from + (arc4random() % (to - from + 1)));
}

//传输加密方法
-(NSMutableArray *) myencrypt {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    NSDate *datenow = [NSDate date];
    NSString *cTimeStr = [formatter stringFromDate:datenow];
    NSString *xf_dt = [MyMD5 md5:cTimeStr];
    NSString *md5key = @"qr4kit11";
    NSString *tmpstr = [NSString stringWithFormat:@"%@%@",xf_dt,md5key];
    NSString *xf_tk = [MyMD5 md5:tmpstr];
    
    NSMutableArray *datas = [[NSMutableArray alloc]initWithCapacity:5];
    [datas addObject:xf_dt]; //0
    [datas addObject:xf_tk]; //1
    
    return datas;
}

@end
