//
//  SyAddViewController.h
//  hsfire
//
//  Created by louislee on 2017/9/23.
//  Copyright © 2017年 hsdcw. All rights reserved.
//

#import "JYJPushBaseViewController.h"
#import "UserEntity.h"

@interface SyAddViewController : JYJPushBaseViewController<UINavigationControllerDelegate,UIImagePickerControllerDelegate>
/** userEntity */
@property (retain,nonatomic) UserEntity *userEntity;

@end
