//
//  User.h
//  数据库Demo
//
//  Created by 刘亚飞 on 16/6/10.
//  Copyright © 2016年 刘亚飞. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface User : NSObject

@property (nonatomic, copy) NSString *ID;
@property (nonatomic, copy) NSString *userID;
@property (nonatomic, copy) NSString *usertoken;
@property (nonatomic, copy) NSString *username;
@property (nonatomic, copy) NSString *nickname;
@property (nonatomic, copy) NSString *photo_s;
@property (nonatomic, copy) NSString *sex;
@property (nonatomic, copy) NSString *bir;
@property (nonatomic, copy) NSString *area;
@property (nonatomic, copy) NSString *heigh;
@property (nonatomic, copy) NSString *edu;
@property (nonatomic, copy) NSString *pay;
@property (nonatomic, copy) NSString *love;
@property (nonatomic, copy) NSString *loginstatus;
@property (nonatomic, copy) NSString *degree;

+(instancetype)userWithName:(NSString *)ID
                    userID:(NSString *)userID
                    usertoken:(NSString *)usertoken
                    username:(NSString *)username
                    nickname:(NSString *)nickname
                    photo_s:(NSString *)photo_s
                    sex:(NSString *)sex
                    bir:(NSString *)bir
                    area:(NSString *)area
                    heigh:(NSString *)heigh
                    edu:(NSString *)edu
                    pay:(NSString *)pay
                    love:(NSString *)love
                    loginstatus:(NSString *)loginstatus
                    degree:(NSString *)degree;
@end
