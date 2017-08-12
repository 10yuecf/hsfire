//
//  JYJPushBaseViewController.m
//  JYJSlideMenuController
//
//  Created by JYJ on 2017/6/16.
//  Copyright © 2017年 baobeikeji. All rights reserved.
//

#import "JYJPushBaseViewController.h"

@interface JYJPushBaseViewController ()

@end

@implementation JYJPushBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithRed:arc4random_uniform(256) / 255.0 green:arc4random_uniform(256) / 255.0 blue:arc4random_uniform(256) / 255.0 alpha:1.0];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.animateViewController.hideStatusBar = NO;
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    self.animateViewController.hideStatusBar = YES;
    [self.animateViewController setNeedsStatusBarAppearanceUpdate];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
