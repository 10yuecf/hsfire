//
//  UserEntity.h
//  hsjhb
//
//  Created by louislee on 16/6/18.
//  Copyright © 2016年 hsdcw. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserEntity : NSObject {
    NSString *userToken;
    NSString *userId;
    NSString *pageUrl;
    NSString *hdId;
    NSString *jzbmTime;
    NSString *title;
    NSString *other;
    NSString *tel;
    NSString *devcode;
    NSString *name;
    NSString *zw;
    NSString *groupid;
    NSString *tagid;
    NSString *tagname;
    NSString *dwtype;
    NSString *dwname;
    NSString *dwid;
}

@property(nonatomic,retain) NSString *userToken;
@property(nonatomic,retain) NSString *userId;
@property(nonatomic,retain) NSString *pageUrl;
@property(nonatomic,retain) NSString *hdId;
@property(nonatomic,retain) NSString *jzbmTime;
@property(nonatomic,retain) NSString *title;
@property(nonatomic,retain) NSString *other;
@property(nonatomic,retain) NSString *tel;
@property(nonatomic,retain) NSString *devcode;
@property(nonatomic,retain) NSString *name;
@property(nonatomic,retain) NSString *zw;
@property(nonatomic,retain) NSString *groupid;
@property(nonatomic,retain) NSString *tagid;
@property(nonatomic,retain) NSString *tagname;
@property(nonatomic,retain) NSString *dwtype;
@property(nonatomic,retain) NSString *dwname;
@property(nonatomic,retain) NSString *dwid;
@end