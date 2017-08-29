//
//  SettingCell.h
//  hsjhb
//
//  Created by louislee on 16/6/19.
//  Copyright © 2016年 hsdcw. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "Model.h"
#import "Macro.h"

typedef void(^BlockButton)(NSString *str);

@interface SettingCell : UITableViewCell

//block属性
@property (nonatomic, copy) BlockButton button;
//自定义block方法
- (void)handlerButtonAction:(BlockButton)block;

// 根据数据模型来显示内容
- (void)showInfo:(Model *)model title:(NSString *)title;

@end
