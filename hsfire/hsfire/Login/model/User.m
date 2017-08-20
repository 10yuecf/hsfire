//
//  User.m
//  数据库Demo
//
//  Created by 刘亚飞 on 16/6/10.
//  Copyright © 2016年 刘亚飞. All rights reserved.
//

#import "User.h"

@implementation User

+(instancetype)userWithName:(NSString *)ID userID:(NSString *)userID usertoken:(NSString *)usertoken username:(NSString *)username nickname:(NSString *)nickname photo_s:(NSString *)photo_s sex:(NSString *)sex bir:(NSString *)bir area:(NSString *)area heigh:(NSString *)heigh edu:(NSString *)edu pay:(NSString *)pay love:(NSString *)love loginstatus:(NSString *)loginstatus degree:(NSString *)degree {
    
    User *user = [[self alloc]init];
    user.ID = ID;
    user.userID = userID;
    user.usertoken = usertoken;
    user.username = username;
    user.nickname = nickname;
    user.photo_s = photo_s;
    user.sex = sex;
    user.bir = bir;
    user.area = area;
    user.heigh = heigh;
    user.edu = edu;
    user.pay = pay;
    user.love = love;
    user.loginstatus = loginstatus;
    user.degree = degree;
    
    return user;
}

@end
