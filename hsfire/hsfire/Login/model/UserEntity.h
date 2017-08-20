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
}

@property(nonatomic,retain) NSString *userToken;
@property(nonatomic,retain) NSString *userId;
@property(nonatomic,retain) NSString *pageUrl;
@property(nonatomic,retain) NSString *hdId;
@property(nonatomic,retain) NSString *jzbmTime;
@property(nonatomic,retain) NSString *title;
@property(nonatomic,retain) NSString *other;
@property(nonatomic,retain) NSString *tel;
@end