//
//  DMRegisterViewController.m
//  LoginView
//
//  Created by SDC201 on 16/3/9.
//  Copyright © 2016年 PCEBG. All rights reserved.
//
#import <sqlite3.h>
#import "ForPassViewController.h"
#import "UITextField+Shake.h"
#import "LoginViewController.h"
#import "UIImageView+WebCache.h"
#import "User.h"
#import "UserTool.h"
#import "hsdcwUtils.h"
#import "UserEntity.h"
#import "MyMD5.h"
#import "HelpViewController.h"
#import "CKHttpCommunicate.h"
#import "HQSelectView.h"
#import "MBProgressHUD+Add.h"
#import "Macro.h"

@interface ForPassViewController ()<UITextFieldDelegate>
@property (nonatomic ,strong) UIView *baceView;
@property (nonatomic ,strong) UITextField *phoneTextFiled;
@property (nonatomic ,strong) UITextField *codeTextFiled;
@property (nonatomic ,strong) UITextField *pwdTextFiled;
@property (nonatomic ,strong) UIButton *yzButton;
@property(nonatomic, copy) NSString *oUserPhoneNum;
@property(assign, nonatomic) NSInteger timeCount;
@property(strong, nonatomic) NSTimer *timer;
@property(nonatomic ,strong) NSString *code;
//验证码
@property(copy, nonatomic) NSString *smsId;
@property (nonatomic ,strong) UIButton *backBtn;
@property (nonatomic ,strong) UILabel *loginLabel;

//网络数据
@property (nonatomic, strong) NSMutableArray *datas;
@property (nonatomic, strong) NSString *str;

//指针对象
@property (nonatomic,assign) sqlite3 *db;

//checkbox状态
@property(nonatomic ,strong) NSString *checkbox;

@end

@implementation ForPassViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[UINavigationBar appearance] setBarTintColor:[UIColor whiteColor]];
    self.view.backgroundColor = [UIColor colorWithRed:240/255.0f green:240/255.0f blue:240/255.0f alpha:1];
    
    [self setupNav];
    [self createTextFiled];
}

-(void)backBtnClick {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)setupNav {
    self.title = @"找回密码";
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:20], NSForegroundColorAttributeName:[UIColor colorWithRed:255 / 255.0 green:255 / 255.0 blue:255 / 255.0 alpha:1.0]}];
    
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    negativeSpacer.width = -15;
    
    UIButton *profileButton = [[UIButton alloc] init];
    // 设置按钮的背景图片
    [profileButton setImage:[UIImage imageNamed:@"backarr"] forState:UIControlStateNormal];
    // 设置按钮的尺寸为背景图片的尺寸
    profileButton.frame = CGRectMake(0, 0, 44, 44);
    //监听按钮的点击
    [profileButton addTarget:self action:@selector(backBtnClick) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *profile = [[UIBarButtonItem alloc] initWithCustomView:profileButton];
    self.navigationItem.leftBarButtonItems = @[negativeSpacer, profile];
}

-(void)createTextFiled {
    //白色背景框
    _baceView = [[UIView alloc]initWithFrame:CGRectMake(10, 30, kWidth - 20, 150)];
    _baceView.layer.cornerRadius = 5.0;
    _baceView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_baceView];
    
    _phoneTextFiled = [self createTextFiledWithFrame:CGRectMake(70, 10, 200, 30) font:[UIFont systemFontOfSize:14] placeholder:@"请输入手机号"];
    _phoneTextFiled.clearButtonMode = UITextFieldViewModeWhileEditing;
    _phoneTextFiled.delegate = self;
    _phoneTextFiled.keyboardType = UIKeyboardTypeNumberPad;
    [_baceView addSubview:_phoneTextFiled];
    
    _codeTextFiled = [self createTextFiledWithFrame:CGRectMake(70, 60, 90, 30) font:[UIFont systemFontOfSize:14] placeholder:@"请输入验证码"];
    _codeTextFiled.clearButtonMode = UITextFieldViewModeWhileEditing;
    _codeTextFiled.delegate = self;
    _codeTextFiled.keyboardType = UIKeyboardTypeNumberPad;
    [_baceView addSubview:_codeTextFiled];
    
    _pwdTextFiled = [self createTextFiledWithFrame:CGRectMake(70, 110, 90, 30) font:[UIFont systemFontOfSize:14] placeholder:@"请输入密码"];
    _pwdTextFiled.clearButtonMode = UITextFieldViewModeWhileEditing;
    _pwdTextFiled.delegate = self;
    _pwdTextFiled.secureTextEntry = YES;
    [_baceView addSubview:_pwdTextFiled];
    
    UILabel *phonelabel=[[UILabel alloc]initWithFrame:CGRectMake(20, 12, 50, 25)];
    phonelabel.text=@"手机号";
    phonelabel.textColor=[UIColor blackColor];
    phonelabel.textAlignment=NSTextAlignmentLeft;
    phonelabel.font=[UIFont systemFontOfSize:14];
    [_baceView addSubview:phonelabel];
    
    UILabel *codelabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 62, 50, 25)];
    codelabel.text = @"验证码";
    codelabel.textColor = [UIColor blackColor];
    codelabel.textAlignment = NSTextAlignmentLeft;
    codelabel.font = [UIFont systemFontOfSize:14];
    [_baceView addSubview:codelabel];
    
    UILabel *pwdlabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 112, 50, 25)];
    pwdlabel.text = @"新密码";
    pwdlabel.textColor = [UIColor blackColor];
    pwdlabel.textAlignment = NSTextAlignmentLeft;
    pwdlabel.font = [UIFont systemFontOfSize:14];
    [_baceView addSubview:pwdlabel];
    
    _yzButton = [[UIButton alloc]initWithFrame:CGRectMake(_baceView.frame.size.width-100, 62, 80, 30)];
    _yzButton.layer.cornerRadius = 3.0f;
    _yzButton.backgroundColor = [UIColor colorWithRed:204/255.0f green:0/255.0f blue:0/255.0f alpha:1];
    [_yzButton setTitle:@"获取验证码" forState:UIControlStateNormal];
    [_yzButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _yzButton.titleLabel.font = [UIFont systemFontOfSize:13];
    [_yzButton addTarget:self action:@selector(getValidCode:) forControlEvents:UIControlEventTouchUpInside];
    [_baceView addSubview:_yzButton];
    
    UIImageView *line1 = [[UIImageView alloc]initWithFrame:CGRectMake(20, 50, _baceView.frame.size.width - 40, 1)];
    line1.backgroundColor = [UIColor colorWithRed:180/255.0 green:180/255.0 blue:180/255.0 alpha:0.3];
    [_baceView addSubview:line1];
    
    UIImageView *line2 = [[UIImageView alloc]initWithFrame:CGRectMake(20, 100, _baceView.frame.size.width - 40, 1)];
    line2.backgroundColor = [UIColor colorWithRed:180/255.0 green:180/255.0 blue:180/255.0 alpha:0.3];
    [_baceView addSubview:line2];
    
    UIButton *landBtn = [[UIButton alloc]initWithFrame:CGRectMake(10,_baceView.frame.size.height + _baceView.frame.origin.y + 20, _baceView.frame.size.width, 37)];
    [landBtn setTitle:@"立即找回" forState:UIControlStateNormal];
    [landBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    landBtn.titleLabel.font = [UIFont systemFontOfSize:17];
    [landBtn addTarget:self action:@selector(next:) forControlEvents:UIControlEventTouchUpInside];
    landBtn.backgroundColor = [UIColor colorWithRed:204/255.0f green:0/255.0f blue:0/255.0f alpha:1];
    landBtn.layer.cornerRadius = 5.0;
    [self.view addSubview:landBtn];
}

-(void)getValidCode:(UIButton *)sender {
    hsdcwUtils *utils = [[hsdcwUtils alloc]init];
    
    //NSScanner *scan = [NSScanner scannerWithString:_phoneTextFiled.text];
    //int val;
    //BOOL PureInt = [scan scanInt:&val]&&[scan isAtEnd];
    //if (!PureInt || _phoneTextFiled.text.length !=11) {
        //[MBProgressHUD showError:@"请输入手机号" toView:self.view];
    //}
    if ([utils isBlankString:_phoneTextFiled.text]) {
        [MBProgressHUD showError:@"请输入手机号" toView:self.view];
    }
    else if (![utils validateMobile:_phoneTextFiled.text]) {
        [MBProgressHUD showError:@"请输正确的机号" toView:self.view];
    }
    else {
        //验证码请求接口
        NSDictionary *parameter = @{@"tel":_phoneTextFiled.text,
                                    @"type":@"-1"}; //type=-1不验证手机号是否注册的参数
        [CKHttpCommunicate createRequest:GetYzm WithParam:parameter withMethod:POST success:^(id response) {
            //NSLog(@"%@",response);
            if (response) {
                NSString *result = response[@"code"];
                _code = response[@"data"][@"ran"];
                
                //当返回值为200并num为0时
                if ([result isEqualToString:@"200"]) {
                    //_codeTextFiled.text = _code;
                    sender.userInteractionEnabled = YES;
                    self.timeCount = 60; //设置验证码读秒时间60秒
                    self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(reduceTime:) userInfo:sender repeats:YES];
                }
                else if ([result isEqualToString:@"400"]) {
                    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"已经发送过验证码，请稍后再试" message:nil preferredStyle:UIAlertControllerStyleAlert];
                    UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil];
                    [alert addAction:action];
                    [self presentViewController:alert animated:YES completion:nil];
                }
            }
        } failure:^(NSError *error) {
            NSLog(@"%@",error);
        } showHUD:self.view];
    }
}

-(void)reduceTime:(NSTimer *)codeTimer {
    self.timeCount--;
    if (self.timeCount == 0) {
        [_yzButton setTitle:@"重新获取" forState:UIControlStateNormal];
        [_yzButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _yzButton.titleLabel.font = [UIFont systemFontOfSize:13];
        UIButton *info = codeTimer.userInfo;
        info.enabled = YES;
        _yzButton.userInteractionEnabled = YES;
        [self.timer invalidate];
    }
    else {
        NSString *str = [NSString stringWithFormat:@"%lu秒", (long)self.timeCount];
        [_yzButton setTitle:str forState:UIControlStateNormal];
        _yzButton.userInteractionEnabled = NO;
    }
}

//立即找回
-(void)next:(UIButton *)button {
    hsdcwUtils *utils = [[hsdcwUtils alloc]init];
    //NSString *usertoken = utils.getUserInfo[2];
    //NSString *nickname = utils.getUserInfo[3];
    //NSLog(@"%@   %@",usertoken, nickname);
    
    if ([utils isBlankString:_phoneTextFiled.text]) {
        [MBProgressHUD showError:@"请输入手机号" toView:self.view];
    }
    else if ([utils isBlankString:_codeTextFiled.text]) {
        [MBProgressHUD showError:@"请输入验证码" toView:self.view];
    }
    else if ([utils isBlankString:_pwdTextFiled.text]) {
        [MBProgressHUD showError:@"请输入新密码" toView:self.view];
    }
    else if (_pwdTextFiled.text.length < 6 ) {
        [MBProgressHUD showError:@"密码不能少于6位" toView:self.view];
    }
    else {
        //修改密码
        NSString *password = [MyMD5 md5:_pwdTextFiled.text];
        NSDictionary *parameter = @{@"yzm":_codeTextFiled.text,
                                    @"newpassword":password,
                                    @"tel":_phoneTextFiled.text};
        [CKHttpCommunicate createRequest:FindPassword WithParam:parameter withMethod:POST success:^(id response) {
            //NSLog(@"%@",response);
            if (response) {
                NSString *result = response[@"code"];
                if ([result isEqualToString:@"200"]) {
                    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"密码修改成功！" message:nil preferredStyle:UIAlertControllerStyleAlert];
                    UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
                        [self.navigationController popViewControllerAnimated:YES];
                    }];
                    [alert addAction:action];
                    [self presentViewController:alert animated:YES completion:nil];
                }
                else if ([result isEqualToString:@"400"]) {
                    [MBProgressHUD showError:@"修改失败" toView:self.view];
                }
            }
        } failure:^(NSError *error) {
            [MBProgressHUD showError:@"修改失败" toView:self.view];
            
            NSLog(@"%@",error);
        } showHUD:self.view];
    }
}

-(UITextField *)createTextFiledWithFrame:(CGRect)frame font:(UIFont *)font placeholder:(NSString *)placeholder {
    UITextField *textField = [[UITextField alloc]initWithFrame:frame];
    textField.font  =font;
    textField.textColor = [UIColor grayColor];
    textField.borderStyle = UITextBorderStyleNone;
    textField.placeholder = placeholder;
    return textField;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField == _phoneTextFiled) {
        [_phoneTextFiled resignFirstResponder];
    }
    
    if (textField == _pwdTextFiled) {
        [_pwdTextFiled resignFirstResponder];
    }
    
    return YES;
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    //self.navigationController.navigationBarHidden = YES;
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    //self.navigationController.navigationBarHidden = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
