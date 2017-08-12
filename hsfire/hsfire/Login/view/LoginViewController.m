//
//  LoginViewController.m
//  fireyun
//
//  Created by louislee on 2017/7/28.
//  Copyright © 2017年 hsdcw. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "LoginViewController.h"
#import "IndexViewController.h"
#import "MapViewController.h"
#import "CustomTabBarController.h"
#import "JYJNavigationController.h"
#import "JYJBaseNavigationController.h"

#import "UITextField+Shake.h"
#import "MyMD5.h"
#import "hsdcwUtils.h"
#import "CKHttpCommunicate.h"
#import "MBProgressHUD.h"

@interface LoginViewController ()<UITextFieldDelegate>
@property (nonatomic ,strong)UIImageView *imageView;
@property (nonatomic ,strong)UIButton *registerBtn;
@property (nonatomic ,strong)UILabel *loginLabel;
@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if([CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"打开[定位服务]来允许[黄石消防云]确定您的位置" message:@"请在系统设置中开启定位服务(设置>隐私>定位服务>开启)" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        UIAlertAction *setAction = [UIAlertAction actionWithTitle:@"打开定位" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            //打开定位设置
            NSURL *settinsURL = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
            //[[UIApplication sharedApplication] openURL:settinsURL];
            [[UIApplication sharedApplication] openURL:settinsURL options:@{} completionHandler:nil];// iOS 10 的跳转方式
        }];
        
        [alert addAction:cancelAction];
        [alert addAction:setAction];
        [self presentViewController:alert animated:YES completion:nil];
    }
    
    [self login];
}

-(void)login {
    //设置背景
    _imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    _imageView.image = [UIImage imageNamed:@"loginbg.jpg"];
    [self.view addSubview:_imageView];
    
    //为登陆界面添加Button
    [self createButtons];
}

-(void)createButtons {
    UIButton *loginButton = [UIButton buttonWithType:UIButtonTypeCustom];
    loginButton.frame = CGRectMake(10, self.view.frame.size.height - 60, (self.view.frame.size.width - 30)/2, 37);
    [loginButton setTitle:@"登录" forState:UIControlStateNormal];
    loginButton.titleLabel.font = [UIFont systemFontOfSize:16];
    [loginButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [loginButton addTarget:self action:@selector(loginButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [loginButton setBackgroundColor:[UIColor colorWithRed:255/255.0f green:255/255.0f blue:255/255.0f alpha:1]];
    loginButton.layer.cornerRadius = 5.0;
    [self.view addSubview:loginButton];
    
    UIButton *regButton = [UIButton buttonWithType:UIButtonTypeCustom];
    regButton.frame = CGRectMake((self.view.frame.size.width + 10)/2, self.view.frame.size.height - 60, (self.view.frame.size.width - 30)/2, 37);
    [regButton setTitle:@"注册" forState:UIControlStateNormal];
    regButton.titleLabel.font = [UIFont systemFontOfSize:16];
    [regButton addTarget:self action:@selector(registerButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [regButton setBackgroundColor:[UIColor colorWithRed:248/255.0f green:144/255.0f blue:34/255.0f alpha:1]];
    regButton.layer.cornerRadius = 5.0;
    [self.view addSubview:regButton];
}

-(void)registerButtonClick:(UIButton *)button {
    IndexViewController *index = [[IndexViewController alloc]init];
    [self.navigationController pushViewController:index animated:YES];
}

-(void)loginButtonClick:(UIButton *)button {
    MapViewController *map = [[MapViewController alloc]init];
    IndexViewController *index = [[IndexViewController alloc]init];
    //[self.navigationController pushViewController:index animated:YES];
    [self.navigationController pushViewController:map animated:YES];
    
    //JYJNavigationController *Jnav = [[JYJNavigationController alloc]init];
    //[self.navigationController pushViewController:Jnav animated:YES];
    NSLog(@"%s","baidu");
    
    //self.window.rootViewController = [[JYJNavigationController alloc]initWithRootViewController:map];
    
    //UINavigationController *BarNav = [[JYJNavigationController alloc]init];
    
    
    //UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"我的" style:UIBarButtonItemStylePlain target:nil action:nil];
    //self.navigationItem.backBarButtonItem = item;
    
    //IndexViewController *index = [[IndexViewController alloc]init];
    //[self.navigationController pushViewController:index animated:YES];
    
    //登录成功
//    CustomTabBarController *CustomTabBar = [[CustomTabBarController alloc] init];
//    
//    CATransition* transition = [CATransition animation];
//    transition.type = kCATransitionPush;//可更改为其他方式
//    transition.subtype = kCATransitionFromRight;//可更改为其他方式
//    [self.navigationController.view.layer addAnimation:transition forKey:kCATransition];
//    [self.navigationController pushViewController:CustomTabBar animated:NO];
}

- (BOOL)prefersStatusBarHidden{
    return YES;
}

- (UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleDefault;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

//视图即将呈现时
-(void)viewWillAppear:(BOOL)animated {
    self.navigationController.navigationBarHidden = YES;
}

//视图即将消失时
-(void)viewWillDisappear:(BOOL)animated {
    self.navigationController.navigationBarHidden = NO;
}

@end
