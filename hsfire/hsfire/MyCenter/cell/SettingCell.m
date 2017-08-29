//
//  SettingCell.m
//  hsjhb
//
//  Created by louislee on 16/6/19.
//  Copyright © 2016年 hsdcw. All rights reserved.
//

#import "SettingCell.h"

@implementation SettingCell

#pragma mark - 显示数据
- (void)showInfo:(Model *)model title:(NSString *)title {
    
    UILabel *label1 = [[UILabel alloc]initWithFrame:CGRectMake(10, -5, 200.0, 50.0)];
    //label1.text = @"通知设置";
    label1.text = title;
    label1.font = [UIFont systemFontOfSize:14];
    
    [self.contentView addSubview:label1];
}

//block的实现部分
- (void)handlerButtonAction:(BlockButton)block {
    self.button = block;
}

@end
