//
//  DMRegisterViewController.m
//  LoginView
//
//  Created by SDC201 on 16/3/9.
//  Copyright © 2016年 PCEBG. All rights reserved.
//
#import <sqlite3.h>
#import "RegViewController.h"
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

@interface RegViewController ()<UITextFieldDelegate>
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

@implementation RegViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _checkbox = @"no";
    
    [[UINavigationBar appearance] setBarTintColor:[UIColor whiteColor]];
    self.view.backgroundColor = [UIColor colorWithRed:240/255.0f green:240/255.0f blue:240/255.0f alpha:1];
    
    [self setupNav];
    [self createTextFiled];
}

-(void)backBtnClick {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)setupNav {
    self.title = @"消防栓显示";
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:20], NSForegroundColorAttributeName:[UIColor colorWithRed:255 / 255.0 green:255 / 255.0 blue:255 / 255.0 alpha:1.0]}];
    
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    negativeSpacer.width = -15;
    
    UIButton *profileButton = [[UIButton alloc] init];
    // 设置按钮的背景图片
    [profileButton setImage:[UIImage imageNamed:@"tt"] forState:UIControlStateNormal];
    // 设置按钮的尺寸为背景图片的尺寸
    profileButton.frame = CGRectMake(0, 0, 44, 44);
    //监听按钮的点击
    [profileButton addTarget:self action:@selector(backBtnClick) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *profile = [[UIBarButtonItem alloc] initWithCustomView:profileButton];
    self.navigationItem.leftBarButtonItems = @[negativeSpacer, profile];
}

-(void)createTextFiled {
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake((self.view.frame.size.width)/2 - 37, _baceView.frame.size.height + _baceView.frame.origin.y + 340, self.view.frame.size.width - 90, 30)];
    label.text = @"已有帐号登录";
    label.textColor = [UIColor colorWithRed:61/255.0f green:133/255.0f blue:198/255.0f alpha:1];
    label.textAlignment = NSTextAlignmentLeft;
    label.font = [UIFont systemFontOfSize:13];
    [self.view addSubview:label];
    
    //为label添加点击事件
    label.userInteractionEnabled = YES;
    UITapGestureRecognizer *labelTapGestureRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(labelTouchUpInside:)];
    [label addGestureRecognizer:labelTapGestureRecognizer];
    
    UILabel *footlabel1 = [[UILabel alloc]initWithFrame:CGRectMake((self.view.frame.size.width)/2 - 100, self.view.frame.size.height - 50, self.view.frame.size.width - 90, 30)];
    footlabel1.text = @"注册即表示同意结婚吧";
    footlabel1.textColor = [UIColor grayColor];
    footlabel1.textAlignment = NSTextAlignmentLeft;
    footlabel1.font = [UIFont systemFontOfSize:13];
    //[self.view addSubview:footlabel1];
    
    //UILabel *footlabel2 = [[UILabel alloc]initWithFrame:CGRectMake((self.view.frame.size.width)/2 + 30, self.view.frame.size.height - 50, self.view.frame.size.width-90, 30)];
    
    
    //白色背景框
    _baceView = [[UIView alloc]initWithFrame:CGRectMake(10, 110, self.view.frame.size.width - 20, 150)];
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
    pwdlabel.text = @"密    码";
    pwdlabel.textColor = [UIColor blackColor];
    pwdlabel.textAlignment = NSTextAlignmentLeft;
    pwdlabel.font = [UIFont systemFontOfSize:14];
    [_baceView addSubview:pwdlabel];
    
    _yzButton = [[UIButton alloc]initWithFrame:CGRectMake(_baceView.frame.size.width-100, 62, 80, 30)];
    _yzButton.layer.cornerRadius = 3.0f;
    _yzButton.backgroundColor = [UIColor colorWithRed:248/255.0f green:144/255.0f blue:34/255.0f alpha:1];
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
    
    HQSelectView *selectView = [[HQSelectView alloc] initWithFrame:CGRectMake(10, _baceView.frame.size.height + _baceView.frame.origin.y + 5, 30, 30)];
    [self.view addSubview:selectView];
    selectView.block = ^(BOOL is){
        if (is == YES) {
            _checkbox = @"yes";
        }
        else {
            _checkbox = @"no";
        }
    };
    
    UILabel *fwtk = [[UILabel alloc]initWithFrame:CGRectMake(40, _baceView.frame.size.height + _baceView.frame.origin.y + 5, self.view.frame.size.width-90, 30)];
    fwtk.text = @"《结婚吧注册服务条款》";
    fwtk.textColor = [UIColor colorWithRed:61/255.0f green:133/255.0f blue:198/255.0f alpha:1];
    fwtk.textAlignment = NSTextAlignmentLeft;
    fwtk.font = [UIFont systemFontOfSize:13];
    [self.view addSubview:fwtk];
    
    //为footlabel2添加点击事件
    fwtk.userInteractionEnabled = YES;
    UITapGestureRecognizer *footlabelTapGestureRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(footlabelTouchUpInside:)];
    [fwtk addGestureRecognizer:footlabelTapGestureRecognizer];
    
    UIButton *landBtn = [[UIButton alloc]initWithFrame:CGRectMake(10,_baceView.frame.size.height + _baceView.frame.origin.y + 40, _baceView.frame.size.width, 37)];
    [landBtn setTitle:@"下一步" forState:UIControlStateNormal];
    [landBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    landBtn.titleLabel.font = [UIFont systemFontOfSize:17];
    [landBtn addTarget:self action:@selector(next:) forControlEvents:UIControlEventTouchUpInside];
    landBtn.backgroundColor = [UIColor colorWithRed:248/255.0f green:144/255.0f blue:34/255.0f alpha:1];
    landBtn.layer.cornerRadius = 5.0;
    [self.view addSubview:landBtn];
    
}

-(void)labelTouchUpInside:(UITapGestureRecognizer *)recognizer {
    //UILabel *label=(UILabel*)recognizer.view;
    //NSLog(@"%@被点击了",label.text);
    LoginViewController *loginVc = [[LoginViewController alloc]init];
    [self.navigationController pushViewController:loginVc animated:YES];
}

-(void)footlabelTouchUpInside:(UITapGestureRecognizer *)recognizer {
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationItem.backBarButtonItem = item;
    
    UserEntity *userEntity = [[UserEntity alloc] init];
    userEntity.pageUrl = @"/service.html";
    HelpViewController *helpVc = [[HelpViewController alloc]init];
    helpVc.title = @"服务协议";
    [self.navigationController pushViewController:helpVc animated:YES];
    helpVc.userEntity = userEntity;
}

-(void)getValidCode:(UIButton *)sender {
    NSScanner *scan = [NSScanner scannerWithString:_phoneTextFiled.text];
    int val;
    BOOL PureInt = [scan scanInt:&val]&&[scan isAtEnd];
    //NSLog(@"%d",PureInt);
    if (!PureInt || _phoneTextFiled.text.length !=11) {
        [_phoneTextFiled shake];
    }
    else {
        //验证码请求接口
        NSDictionary *parameter = @{@"tel":_phoneTextFiled.text};
        [CKHttpCommunicate createRequest:GetYzm WithParam:parameter withMethod:POST success:^(id response) {
            if (response) {
                NSString *result = response[@"code"];
                NSString *numstr = response[@"data"][@"num"];
                NSInteger num = [numstr integerValue];
                _code = response[@"data"][@"ran"];
                
                //当返回值为200并num为0时
                if ([result isEqualToString:@"200"]) {
                    if (num == 0) {
                        _codeTextFiled.text = _code;
                    }
                    else {
                        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"您的手机号已注册" message:@"请重新输入或直接登录" preferredStyle:UIAlertControllerStyleAlert];
                        UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil];
                        [alert addAction:action];
                        UIAlertAction *loginActin = [UIAlertAction actionWithTitle:@"去登录" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                            LoginViewController *loginvc = [[LoginViewController alloc]init];
                            [self.navigationController pushViewController:loginvc animated:YES];
                        }];
                        [alert addAction:loginActin];
                        [self presentViewController:alert animated:YES completion:nil];
                    }
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
        
        sender.userInteractionEnabled = YES;
        self.timeCount = 10;
        self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(reduceTime:) userInfo:sender repeats:YES];
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

-(void)next:(UIButton *)button {
    NSLog(@"%@",_checkbox);
    
    NSString *pwd = _pwdTextFiled.text;
    hsdcwUtils *utils = [[hsdcwUtils alloc]init];
    
    if (_phoneTextFiled.text.length == 11 && _codeTextFiled.text == _code && ![utils isBlankString:pwd]) {
        
        if ([_checkbox isEqualToString:@"yes"]) {
            //提交注册并进入下一步
            //注册请求接口
            NSString *yzm = _codeTextFiled.text;
            NSString *password = [MyMD5 md5:_pwdTextFiled.text];
            NSString *tel = _phoneTextFiled.text;
            NSDictionary *parameter = @{@"yzm":yzm,
                                        @"password":password,
                                        @"tel":_phoneTextFiled.text};
            [CKHttpCommunicate createRequest:Register1 WithParam:parameter withMethod:POST success:^(id response) {
                if (response) {
                    NSString *result = response[@"code"];
                    
                    //当返回值为200并num为0时
                    if ([result isEqualToString:@"200"]) {
                        NSString *token = response[@"data"][0][@"token"];
                        NSString *uidstr = response[@"data"][0][@"id"];
                        
                        //注册成功写本地
                        //写本地前判断一下是否存在用户信息
                        NSString *chkuser = [NSString stringWithFormat:@"select * from t_user where username = '%@'",tel];
                        _datas = [UserTool userWithSql:chkuser];
                        //NSLog(@"%lu",(unsigned long)_datas.count);
                        
                        if(_datas.count == 0) {
                            NSString *insert = [NSString stringWithFormat:@"insert into t_user (userID, usertoken, username) values('%@','%@','%@')",uidstr, token, tel];
                            [UserTool userWithSql:insert];
                        }
                        
                        //建立临时变量传值
                        UserEntity *userEntity = [[UserEntity alloc]init];
                        userEntity.userToken = token;
                        userEntity.userId = uidstr;
                    }
                    else if ([result isEqualToString:@"400"]) {
                        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"注册失败" message:nil preferredStyle:UIAlertControllerStyleAlert];
                        UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil];
                        [alert addAction:action];
                        [self presentViewController:alert animated:YES completion:nil];
                    }
                }
            } failure:^(NSError *error) {
                NSLog(@"%@",error);
            } showHUD:self.view];
        }
        else {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"请同意结婚吧注册服务条款" message:nil preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil];
            [alert addAction:action];
            [self presentViewController:alert animated:YES completion:nil];
        }
    }
    else {
        [_pwdTextFiled shake];
        [_phoneTextFiled shake];
        [_codeTextFiled shake];
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"请输入正确的手机号码和验证码" message:nil preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil];
        [alert addAction:action];
        [self presentViewController:alert animated:YES completion:nil];
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
