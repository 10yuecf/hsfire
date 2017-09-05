//
//  MapEgViewController.h
//  hsfire
//
//  Created by louislee on 2017/9/5.
//  Copyright © 2017年 hsdcw. All rights reserved.
//  消防审批
#define MYBUNDLE_NAME @ "mapapi.bundle"
#define MYBUNDLE_PATH [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent: MYBUNDLE_NAME]
#define MYBUNDLE [NSBundle bundleWithPath: MYBUNDLE_PATH]

#import <UIKit/UIKit.h>
#import "UserEntity.h"
#import "JYJPushBaseViewController.h"

@interface MapEgViewController : JYJPushBaseViewController
/** userEntity */
@property (retain,nonatomic) UserEntity *userEntity;

@end
