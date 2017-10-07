//
//  MapWebViewController.h
//  hsfire
//
//  Created by louislee on 2017/10/6.
//  Copyright © 2017年 hsdcw. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserEntity.h"

@interface MapWebViewController : UIViewController
@property (nonatomic,copy) NSString *urlString;
/** userEntity */
@property (retain,nonatomic) UserEntity *userEntity;

@end
