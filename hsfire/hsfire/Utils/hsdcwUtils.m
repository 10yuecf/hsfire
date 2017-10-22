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
    NSString *xf_dt = [self getCurrentTime];
    NSString *md5key = @"qr4kit1";
    NSString *tmpstr = [NSString stringWithFormat:@"%@%@",xf_dt,md5key];
    NSString *xf_tk = [MyMD5 md5:tmpstr];
    
    NSMutableArray *datas = [[NSMutableArray alloc]initWithCapacity:5];
    [datas addObject:xf_dt]; //0
    [datas addObject:xf_tk]; //1
    
    return datas;
}

//获取当前时间戳
- (NSString*)getCurrentTime {
    NSDate *datenow = [NSDate date];
    NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[datenow timeIntervalSince1970]];
    //NSTimeZone *zone = [NSTimeZone timeZoneWithName:@"Asia/Beijing"];
    //NSInteger interval = [zone secondsFromGMTForDate:datenow];
    //NSDate *localeDate = [datenow dateByAddingTimeInterval:interval];
    //NSString *timeSpp = [NSString stringWithFormat:@"%f", [localeDate timeIntervalSince1970]];
    
    return timeSp;
}

- (NSString *)iphoneType {
    struct utsname systemInfo;
    uname(&systemInfo);
    
    NSString *platform = [NSString stringWithCString:systemInfo.machine encoding:NSASCIIStringEncoding];
    
    if ([platform isEqualToString:@"iPhone1,1"]) return @"iPhone 2G";
    
    if ([platform isEqualToString:@"iPhone1,2"]) return @"iPhone 3G";
    
    if ([platform isEqualToString:@"iPhone2,1"]) return @"iPhone 3GS";
    
    if ([platform isEqualToString:@"iPhone3,1"]) return @"iPhone 4";
    
    if ([platform isEqualToString:@"iPhone3,2"]) return @"iPhone 4";
    
    if ([platform isEqualToString:@"iPhone3,3"]) return @"iPhone 4";
    
    if ([platform isEqualToString:@"iPhone4,1"]) return @"iPhone 4S";
    
    if ([platform isEqualToString:@"iPhone5,1"]) return @"iPhone 5";
    
    if ([platform isEqualToString:@"iPhone5,2"]) return @"iPhone 5";
    
    if ([platform isEqualToString:@"iPhone5,3"]) return @"iPhone 5c";
    
    if ([platform isEqualToString:@"iPhone5,4"]) return @"iPhone 5c";
    
    if ([platform isEqualToString:@"iPhone6,1"]) return @"iPhone 5s";
    
    if ([platform isEqualToString:@"iPhone6,2"]) return @"iPhone 5s";
    
    if ([platform isEqualToString:@"iPhone7,1"]) return @"iPhone 6 Plus";
    
    if ([platform isEqualToString:@"iPhone7,2"]) return @"iPhone 6";
    
    if ([platform isEqualToString:@"iPhone8,1"]) return @"iPhone 6s";
    
    if ([platform isEqualToString:@"iPhone8,2"]) return @"iPhone 6s Plus";
    
    if ([platform isEqualToString:@"iPhone8,4"]) return @"iPhone SE";
    
    if ([platform isEqualToString:@"iPhone9,1"]) return @"iPhone 7";
    
    if ([platform isEqualToString:@"iPhone9,2"]) return @"iPhone 7 Plus";
    
    if ([platform isEqualToString:@"iPod1,1"])   return @"iPod Touch 1G";
    
    if ([platform isEqualToString:@"iPod2,1"])   return @"iPod Touch 2G";
    
    if ([platform isEqualToString:@"iPod3,1"])   return @"iPod Touch 3G";
    
    if ([platform isEqualToString:@"iPod4,1"])   return @"iPod Touch 4G";
    
    if ([platform isEqualToString:@"iPod5,1"])   return @"iPod Touch 5G";
    
    if ([platform isEqualToString:@"iPad1,1"])   return @"iPad 1G";
    
    if ([platform isEqualToString:@"iPad2,1"])   return @"iPad 2";
    
    if ([platform isEqualToString:@"iPad2,2"])   return @"iPad 2";
    
    if ([platform isEqualToString:@"iPad2,3"])   return @"iPad 2";
    
    if ([platform isEqualToString:@"iPad2,4"])   return @"iPad 2";
    
    if ([platform isEqualToString:@"iPad2,5"])   return @"iPad Mini 1G";
    
    if ([platform isEqualToString:@"iPad2,6"])   return @"iPad Mini 1G";
    
    if ([platform isEqualToString:@"iPad2,7"])   return @"iPad Mini 1G";
    
    if ([platform isEqualToString:@"iPad3,1"])   return @"iPad 3";
    
    if ([platform isEqualToString:@"iPad3,2"])   return @"iPad 3";
    
    if ([platform isEqualToString:@"iPad3,3"])   return @"iPad 3";
    
    if ([platform isEqualToString:@"iPad3,4"])   return @"iPad 4";
    
    if ([platform isEqualToString:@"iPad3,5"])   return @"iPad 4";
    
    if ([platform isEqualToString:@"iPad3,6"])   return @"iPad 4";
    
    if ([platform isEqualToString:@"iPad4,1"])   return @"iPad Air";
    
    if ([platform isEqualToString:@"iPad4,2"])   return @"iPad Air";
    
    if ([platform isEqualToString:@"iPad4,3"])   return @"iPad Air";
    
    if ([platform isEqualToString:@"iPad4,4"])   return @"iPad Mini 2G";
    
    if ([platform isEqualToString:@"iPad4,5"])   return @"iPad Mini 2G";
    
    if ([platform isEqualToString:@"iPad4,6"])   return @"iPad Mini 2G";
    
    if ([platform isEqualToString:@"i386"])      return @"iPhone Simulator";
    
    if ([platform isEqualToString:@"x86_64"])    return @"iPhone Simulator";
    
    return platform;
}

//四舍五入 price:需要处理的数字 position：保留小数点第几位
-(NSString *)notRounding:(float)price afterPoint:(int)position {
    
    NSDecimalNumberHandler* roundingBehavior = [NSDecimalNumberHandler decimalNumberHandlerWithRoundingMode:NSRoundDown scale:position raiseOnExactness:NO raiseOnOverflow:NO raiseOnUnderflow:NO raiseOnDivideByZero:NO];
    
    NSDecimalNumber *ouncesDecimal;
    
    NSDecimalNumber *roundedOunces;
    
    ouncesDecimal = [[NSDecimalNumber alloc] initWithFloat:price];
    
    roundedOunces = [ouncesDecimal decimalNumberByRoundingAccordingToBehavior:roundingBehavior];
    //[ouncesDecimal release];
    
    return [NSString stringWithFormat:@"%@",roundedOunces];
}

@end
