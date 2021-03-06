//
//  MapFViewController.h
//  hsfire
//
//  Created by louislee on 2017/9/5.
//  Copyright © 2017年 hsdcw. All rights reserved.
//  战保物资
#define MYBUNDLE_NAME @ "mapapi.bundle"
#define MYBUNDLE_PATH [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent: MYBUNDLE_NAME]
#define MYBUNDLE [NSBundle bundleWithPath: MYBUNDLE_PATH]

#import <UIKit/UIKit.h>
#import "UserEntity.h"
#import "MapEntity.h"
#import "JYJPushBaseViewController.h"

@interface MapFViewController : JYJPushBaseViewController
/** userEntity */
@property (retain,nonatomic) UserEntity *userEntity;
@property (retain,nonatomic) MapEntity *mapEntity;
@end
