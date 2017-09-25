//
//  User.m
//  数据库Demo
//
//  Created by 刘亚飞 on 16/6/10.
//  Copyright © 2016年 刘亚飞. All rights reserved.
//

#import "User.h"

@implementation User

+(instancetype)userWithName:(NSString *)ID userID:(NSString *)userID devicetoken:(NSString *)devicetoken name:(NSString *)name account:(NSString *)account status:(NSString *)status zw:(NSString *)zw bz:(NSString *)bz createtime:(NSString *)createtime groupid:(NSString *)groupid tagid:(NSString *)tagid tagname:(NSString *)tagname dwtype:(NSString *)dwtype tel:(NSString *)tel dwname:(NSString *)dwname dwid:(NSString *)dwid loginstatus:(NSString *)loginstatus photo_s:(NSString *)photo_s {
    
    User *user = [[self alloc]init];
    user.ID = ID;
    user.userID = userID;
    user.devicetoken = devicetoken;
    user.name = name;
    user.account = account;
    user.status = status;
    user.zw = zw;
    user.bz = bz;
    user.createtime = createtime;
    user.groupid = groupid;
    user.tagid = tagid;
    user.tagname = tagname;
    user.dwtype = dwtype;
    user.tel = tel;
    user.dwtype = dwname;
    user.dwid = dwid;
    user.loginstatus = loginstatus;
    user.photo_s = photo_s;
    
    return user;
}

@end
