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
@property (nonatomic, copy) NSString *devicetoken;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *account;
@property (nonatomic, copy) NSString *status;
@property (nonatomic, copy) NSString *zw;
@property (nonatomic, copy) NSString *bz;
@property (nonatomic, copy) NSString *createtime;
@property (nonatomic, copy) NSString *groupid;
@property (nonatomic, copy) NSString *tagid;
@property (nonatomic, copy) NSString *tagname;
@property (nonatomic, copy) NSString *dwtype;
@property (nonatomic, copy) NSString *tel;
@property (nonatomic, copy) NSString *dwname;
@property (nonatomic, copy) NSString *dwid;
@property (nonatomic, copy) NSString *loginstatus;

+(instancetype)userWithName:(NSString *)ID
                    userID:(NSString *)userID
                    devicetoken:(NSString *)devicetoken
                    name:(NSString *)name
                    account:(NSString *)account
                    status:(NSString *)status
                    zw:(NSString *)zw
                    bz:(NSString *)bz
                    createtime:(NSString *)createtime
                    groupid:(NSString *)groupid
                    tagid:(NSString *)tagid
                    tagname:(NSString *)tagname
                    dwtype:(NSString *)dwtype
                    tel:(NSString *)tel
                    dwname:(NSString *)dwname
                    dwid:(NSString *)dwid
                    loginstatus:(NSString *)loginstatus;
@end
