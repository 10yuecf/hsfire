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
    NSString *lat;
    NSString *lon;
    NSString *photo_s;
    NSString *antitle; //气泡标题
    NSString *ansubtitle;
    NSString *anlat;
    NSString *anlon;
    NSString *clat;
    NSString *clon;
    NSString *syid;
    NSString *syzt;
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
@property(nonatomic,retain) NSString *lat;
@property(nonatomic,retain) NSString *lon;
@property(nonatomic,retain) NSString *photo_s;
@property(nonatomic,retain) NSString *antitle;
@property(nonatomic,retain) NSString *ansubtitle;
@property(nonatomic,retain) NSString *anlat;
@property(nonatomic,retain) NSString *anlon;
@property(nonatomic,retain) NSString *clat;
@property(nonatomic,retain) NSString *clon;
@property(nonatomic,retain) NSString *syid;
@property(nonatomic,retain) NSString *syzt;
@end
