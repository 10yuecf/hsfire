//
//  MyWebViewController.h
//  hsfire
//
//  Created by louislee on 2017/10/7.
//  Copyright © 2017年 hsdcw. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserEntity.h"

@interface MyWebViewController : UIViewController
@property (nonatomic, copy) NSString *urlStr;
/**是否支持web下拉刷新 default is NO*/
@property (nonatomic, assign) BOOL isPullRefresh;
/** userEntity */
@property (retain,nonatomic) UserEntity *userEntity;

@end
