//
//  BaseInfo.m
//  hsjhb
//
//  Created by louislee on 16/6/26.
//  Copyright © 2016年 hsdcw. All rights reserved.
//

#import "BaseInfo.h"

@implementation BaseInfo

+(instancetype)baseWithName:(NSString *)ID strName:(NSString *)strName keyName:(NSString *)keyName keyValue:(NSString *)keyValue
{
    BaseInfo *base = [[BaseInfo alloc]init];
    base.ID = ID;
    base.strName = strName;
    base.keyName = keyName;
    base.keyValue = keyValue;
    
    return base;
}

@end
