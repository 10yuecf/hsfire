//
//  MapViewController.h
//  hsfire
//
//  Created by louislee on 2017/8/12.
//  Copyright © 2017年 hsdcw. All rights reserved.
//

#define MYBUNDLE_NAME @ "mapapi.bundle"
#define MYBUNDLE_PATH [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent: MYBUNDLE_NAME]
#define MYBUNDLE [NSBundle bundleWithPath: MYBUNDLE_PATH]

#import <UIKit/UIKit.h>
#import "UserEntity.h"
#import "JYJPushBaseViewController.h"

@interface MapViewController : JYJPushBaseViewController
/** userEntity */
@property (retain,nonatomic) UserEntity *userEntity;

@end
