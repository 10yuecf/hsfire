//
//  BaseInfo.h
//  hsjhb
//
//  Created by louislee on 16/6/26.
//  Copyright © 2016年 hsdcw. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BaseInfo : NSObject

@property (nonatomic, copy) NSString *ID;
@property (nonatomic, copy) NSString *strName;
@property (nonatomic, copy) NSString *keyName;
@property (nonatomic, copy) NSString *keyValue;

+(instancetype)baseWithName:(NSString *)ID
                     strName:(NSString *)strName
                  keyName:(NSString *)keyName
                   keyValue:(NSString *)keyValue;

@end
