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
#import "RegViewController.h"

#import "UITextField+Shake.h"
#import "MyMD5.h"
#import "hsdcwUtils.h"
#import "CKHttpCommunicate.h"
#import "MBProgressHUD.h"
#import "Macro.h"

#import "TestViewController.h"
#import "HouseTypeMapVC.h"

static void *ProgressObserverContext = &ProgressObserverContext;
@interface LoginViewController ()<UITextFieldDelegate>
@property (nonatomic ,strong)UIImageView *imageView;
@property (nonatomic ,strong)UIButton *registerBtn;
@property (nonatomic ,strong)UILabel *loginLabel;
@property (nonatomic, strong)UITextField *accountFiled;
@property (nonatomic, strong)UITextField *passTextFiled;
@property (nonatomic, strong)UIView *accountView;
@property (nonatomic, strong)UIView *passView;
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
    
    //加载UI界面
    [self createUI];
}

-(void)createUI {
    //账号view
    _accountView = [[UIView alloc]initWithFrame:CGRectMake(50, 230, kWidth - 90, 30)];
    _accountView.layer.cornerRadius = 2.0;
    //_backView.alpha = 0.7;
    _accountView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_accountView];
    
    //密码view
    _passView = [[UIView alloc]initWithFrame:CGRectMake(50, 280, kWidth - 90, 30)];
    _passView.layer.cornerRadius = 2.0;
    //_backView.alpha = 0.7;
    _passView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_passView];
    
    _accountFiled = [[UITextField alloc]initWithFrame:CGRectMake(40, 5, 190, 20)];
    _accountFiled.delegate = self;
    _accountFiled.placeholder = @"账号";
    _accountFiled.font = [UIFont systemFontOfSize:14];
    _accountFiled.clearButtonMode = UITextFieldViewModeWhileEditing;
    //_phoneTextFiled.keyboardType = UIKeyboardTypeNumberPad;
    [_accountView addSubview:_accountFiled];
    
    _passTextFiled = [[UITextField alloc]initWithFrame:CGRectMake(40, 5, 190, 20)];
    _passTextFiled.delegate = self;
    _passTextFiled.placeholder = @"密码";
    _passTextFiled.font = [UIFont systemFontOfSize:14];
    _passTextFiled.clearButtonMode = UITextFieldViewModeWhileEditing;
    _passTextFiled.secureTextEntry = YES;
    [_passView addSubview:_passTextFiled];
    
    UIImageView *accountIV = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 30, 30)];
    accountIV.image = [UIImage imageNamed:@"account"];
    accountIV.layer.cornerRadius = 2.0;
    accountIV.layer.masksToBounds = YES;
    [_accountView addSubview:accountIV];
    
    UIImageView *passIV = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 30, 30)];
    passIV.image= [UIImage imageNamed:@"pass"];
    passIV.layer.cornerRadius = 2.0;
    passIV.layer.masksToBounds =YES;
    [_passView addSubview:passIV];
    
    int btn_x = _passView.frame.origin.x;
    int btn_y = _passView.frame.origin.y;
    
    UIButton *loginButton = [UIButton buttonWithType:UIButtonTypeCustom];
    loginButton.frame = CGRectMake(btn_x, btn_y + 50, (kWidth - 30)/3, 37);
    //[loginButton setTitle:@"登录" forState:UIControlStateNormal];
    //loginButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [loginButton addTarget:self action:@selector(loginButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    //[loginButton setBackgroundColor:[UIColor colorWithRed:255/255.0f green:0/255.0f blue:0/255.0f alpha:1]];
    loginButton.layer.cornerRadius = 3.0;
    [loginButton setImage:[UIImage imageNamed:@"loginbtn"] forState:UIControlStateNormal];
    [self.view addSubview:loginButton];
    
    UIButton *regButton = [UIButton buttonWithType:UIButtonTypeCustom];
    regButton.frame = CGRectMake(btn_x * 3.5, btn_y + 50, (kWidth - 30)/3, 37);
    //regButton.titleLabel.font = [UIFont systemFontOfSize:14];
    regButton.layer.cornerRadius = 3.0;
    [regButton setImage:[UIImage imageNamed:@"regbtn"] forState:UIControlStateNormal];
    //[regButton setTitle:@"注册" forState:UIControlStateNormal];
    [regButton addTarget:self action:@selector(registerButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    //[regButton setBackgroundColor:[UIColor colorWithRed:255/255.0f green:0/255.0f blue:0/255.0f alpha:1]];
    [self.view addSubview:regButton];
    
    UIButton *forgetButton = [UIButton buttonWithType:UIButtonTypeCustom];
    forgetButton.titleLabel.font = [UIFont systemFontOfSize:13];
    forgetButton.frame = CGRectMake(kWidth / 3, kHeight / 1.5, 100, 30);
    [forgetButton setTitle:@"忘记密码?" forState:UIControlStateNormal];
    [forgetButton setTitleColor:[UIColor colorWithRed:225/255.0f green:208/255.0f blue:208/255.0f alpha:1] forState:UIControlStateNormal];
    [forgetButton addTarget:self action:@selector(forgotPwdButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:forgetButton];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

-(void)forgotPwdButtonClick:(UIButton *)button {
    NSLog(@"%s","forgot pass");
}

-(void)registerButtonClick:(UIButton *)button {
    //RegViewController *reg = [[RegViewController alloc]init];
    //[self.navigationController pushViewController:reg animated:YES];
    
    TestViewController *test = [[TestViewController alloc]init];
    [self.navigationController pushViewController:test animated:YES];
    
    //ClusterDemoViewController *cluster = [[ClusterDemoViewController alloc]init];
    ///[self.navigationController pushViewController:cluster animated:YES];
    
    //HouseTypeMapVC *hs = [[HouseTypeMapVC alloc]init];
    //[self.navigationController pushViewController:hs animated:YES];
}

-(void)loginButtonClick:(UIButton *)button {
    MapViewController *map = [[MapViewController alloc]init];
    [self.navigationController pushViewController:map animated:YES];
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
