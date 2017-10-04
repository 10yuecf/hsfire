//
//  SyInfoViewController.h
//  hsfire
//
//  Created by louislee on 2017/9/27.
//  Copyright © 2017年 hsdcw. All rights reserved.
//
#define IphoneMapSdkDemo_OpenBaiduMapDemo_h

#import <UIKit/UIKit.h>
#import <BaiduMapAPI_Utils/BMKUtilsComponent.h>
#import "JYJPushBaseViewController.h"
#import "UserEntity.h"

@interface SyInfoViewController : JYJPushBaseViewController<UINavigationControllerDelegate,UIImagePickerControllerDelegate>
/** userEntity */
@property (retain,nonatomic) UserEntity *userEntity;

@end
