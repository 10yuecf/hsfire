//
//  LoginViewController.m
//  fireyun
//
//  Created by louislee on 2017/7/28.
//  Copyright © 2017年 hsdcw. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "LoginViewController.h"
#import "MapViewController.h"
#import "JYJNavigationController.h"
#import "JYJBaseNavigationController.h"
#import "RegViewController.h"

#import "UITextField+Shake.h"
#import "MyMD5.h"
#import "hsdcwUtils.h"
#import "CKHttpCommunicate.h"
#import "MBProgressHUD+Add.h"
#import "Macro.h"
#import "UserTool.h"
#import "User.h"
#import "UserEntity.h"
#import "BaseInfo.h"
#import "JYJMyWalletViewController.h"
#import "JYJMyStickerViewController.h"

//#import "TestViewController.h"

#import "ForPassViewController.h"

//第一步，导入头文件
#import "NewEditionTestManager.h"

static void *ProgressObserverContext = &ProgressObserverContext;
@interface LoginViewController ()<UITextFieldDelegate>
@property (nonatomic ,strong)UIImageView *imageView;
@property (nonatomic ,strong)UIButton *registerBtn;
@property (nonatomic ,strong)UILabel *loginLabel;
@property (nonatomic, strong)UITextField *accountFiled;
@property (nonatomic, strong)UITextField *passFiled;
@property (nonatomic, strong)UIView *accountView;
@property (nonatomic, strong)UIView *passView;

@property (nonatomic, strong) NSMutableArray *datas;
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
    
    [self upver];
}

/**
 1，使用的时候直接把NewEditionCheck文件夹拖入项目即可
 2，使用步骤很简单，第一和第二步，
 */
- (void)upver {
    
    //第二步  appID:应用在Store里面的ID (应用的AppStore地址里面可获取)
    [NewEditionTestManager checkNewEditionWithAppID:@"1294012388" ctrl:self]; //1种用法，系统Alert
    
    
    //[NewEditionTestManager checkNewEditionWithAppID:@"xxxx" CustomAlert:^(AppStoreInfoModel *appInfo) {
        
    //}];//2种用法,自定义Alert
    
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
    
    _passFiled = [[UITextField alloc]initWithFrame:CGRectMake(40, 5, 190, 20)];
    _passFiled.delegate = self;
    _passFiled.placeholder = @"密码";
    _passFiled.font = [UIFont systemFontOfSize:14];
    _passFiled.clearButtonMode = UITextFieldViewModeWhileEditing;
    _passFiled.secureTextEntry = YES;
    [_passView addSubview:_passFiled];
    
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
    
//    UIButton *forgetButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    forgetButton.titleLabel.font = [UIFont systemFontOfSize:13];
//    forgetButton.frame = CGRectMake(kWidth / 3, kHeight / 1.5, 100, 30);
//    [forgetButton setTitle:@"忘记密码?" forState:UIControlStateNormal];
//    [forgetButton setTitleColor:[UIColor colorWithRed:225/255.0f green:208/255.0f blue:208/255.0f alpha:1] forState:UIControlStateNormal];
//    [forgetButton addTarget:self action:@selector(forgotPwdButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    //[self.view addSubview:forgetButton];
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(kWidth / 2.5, kHeight / 1.5, 100, 30)];
    label.text = @"忘记密码??";
    label.textColor = [UIColor colorWithRed:225/255.0f green:208/255.0f blue:208/255.0f alpha:1];
    label.textAlignment = NSTextAlignmentLeft;
    label.font = [UIFont systemFontOfSize:13];
    [self.view addSubview:label];
    
    //为label添加点击事件
    label.userInteractionEnabled = YES;
    UITapGestureRecognizer *labelTapGestureRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(labelTouchUpInside:)];
    [label addGestureRecognizer:labelTapGestureRecognizer];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

//忘记密码
-(void)labelTouchUpInside:(UITapGestureRecognizer *)recognizer {
    //UILabel *label=(UILabel*)recognizer.view;
    //NSLog(@"%@被点击了",label.text);
    
    ForPassViewController *forpass = [[ForPassViewController alloc]init];
    [self.navigationController pushViewController:forpass animated:YES];
}

-(void)registerButtonClick:(UIButton *)button {
    RegViewController *reg = [[RegViewController alloc]init];
    [self.navigationController pushViewController:reg animated:YES];
}

-(void)loginButtonClick:(UIButton *)button {
    hsdcwUtils *utils = [[hsdcwUtils alloc]init];
    
    //用户登陆接口
    NSString *log_account = _accountFiled.text;
    NSString *log_pass = [MyMD5 md5:_passFiled.text];
    
    if ([utils isBlankString:log_account]) {
        [MBProgressHUD showError:@"请输入账号" toView:self.view];
    }
    else if ([utils isBlankString:_passFiled.text]) {
        [MBProgressHUD showError:@"请输入密码" toView:self.view];
    }
    else {
        NSDictionary *parameter = @{@"account":log_account,
                                    @"pass":log_pass};
        [CKHttpCommunicate createRequest:appLogin WithParam:parameter withMethod:POST success:^(id response) {
            //NSLog(@"%@",response);
            
            if (response) {
                NSString *result = response[@"code"];
                //NSLog(@"%@",result);
                
                //登陆成功
                if ([result isEqualToString:@"200"]) {
                    NSString *uid = response[@"data"][0][@"id"];
                    NSString *acc = response[@"data"][0][@"account"];
                    NSString *name = response[@"data"][0][@"name"];
                    NSString *status = response[@"data"][0][@"status"];
                    NSString *zw = response[@"data"][0][@"zw"];
                    NSString *bz = response[@"data"][0][@"bz"];
                    NSString *createtime = response[@"data"][0][@"create_time"];
                    NSString *groupid = response[@"data"][0][@"groupid"];
                    NSString *tagid = response[@"data"][0][@"tagid"];
                    NSString *tagname = response[@"data"][0][@"tagname"];
                    NSString *dwtype = response[@"data"][0][@"dwtype"];
                    NSString *tel = response[@"data"][0][@"tel"];
                    NSString *dwname = response[@"data"][0][@"dwname"];
                    NSString *dwid = response[@"data"][0][@"dwid"];
                    NSString *devcode;
                    
                    //----------------查询本地库最新设备码start--------------
                    
                    NSString *chkdev = [NSString stringWithFormat:@"select * from t_base order by id desc limit 1"];
                    NSMutableArray *dev_arr = [UserTool baseWithSql:chkdev];
                    if(dev_arr.count > 0) {
                        BaseInfo *ba = dev_arr[0];
                        devcode = ba.keyValue;
                        NSLog(@"devcode==========%@",devcode);
                        
                        //登录成功更新远程用户设备码
                        NSDictionary *param_dev = @{@"type":@"ios",
                                                    @"id":uid,
                                                    @"code":devcode
                                                    };
                        [CKHttpCommunicate createRequest:SandUmcode WithParam:param_dev withMethod:POST success:^(id response) {
                            if (response) {
                                NSString *result = response[@"code"];
                                if ([result isEqualToString:@"200"]) {
                                    NSLog(@"%s","update dev code successful!");
                                }
                                else if ([result isEqualToString:@"400"]) {
                                    NSLog(@"%s","update dev code error!");
                                }
                            }
                        } failure:^(NSError *error) {
                            NSLog(@"%@",error);
                        } showHUD:self.inputView];
                    }
                    //----------------查询本地库最新设备码end--------------
                    
                    //----------------判断用户信息是否存在本地start---------
                    
                    NSString *chkuser = [NSString stringWithFormat:@"select * from t_user where account = '%@' and tel = '%@'",acc,tel];
                    _datas = [UserTool userWithSql:chkuser];
                    if (_datas.count == 0) {
                        NSString *insert = [NSString stringWithFormat:@"insert into t_user (userID,devicetoken,name,account,status,zw,bz,createtime,groupid,tagid,tagname,dwtype,tel,dwname,dwid,loginstatus) values('%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','1')",uid,devcode,name,acc,status,zw,bz,createtime,groupid,tagid,tagname,dwtype,tel,dwname,dwid];
                        [UserTool userWithSql:insert];
                    }
                    else {
                        //更新此用户登录状态
                        NSString *uplogin = [NSString stringWithFormat:@"update t_user set devicetoken = '%@',name = '%@', status = '%@', zw = '%@',bz = '%@',groupid = '%@',tagid = '%@',tagname = '%@',dwtype = '%@',tel = '%@',dwname = '%@',dwid = '%@',loginstatus = '1' where userID = '%@'", devcode, name, status, zw, bz, groupid, tagid, tagname, dwtype, tel, dwname, dwid, uid];
                        [UserTool userWithSql:uplogin];
                        
                        //更新其他数据为未登录状态
                        NSString *upall = [NSString stringWithFormat:@"update t_user set loginstatus = '0' where userID != '%@' and tel != '%@'",uid, tel];
                        [UserTool userWithSql:upall];
                    }
                    
                    //----------------判断用户信息是否存在本地end-----------
                    
                    //建立临时变量传值
                    UserEntity *userEntity = [[UserEntity alloc]init];
                    userEntity.userId = uid;
                    userEntity.name = name;
                    userEntity.zw = zw;
                    userEntity.groupid = groupid;
                    userEntity.tagid = tagid;
                    userEntity.tagname = tagname;
                    userEntity.dwtype = dwtype;
                    userEntity.devcode = devcode;
                    userEntity.tel = tel;
                    userEntity.dwname = dwname;
                    userEntity.dwid = dwid;
                    
                    if([zw isEqualToString:@"普通用户"]) {
                        JYJMyWalletViewController *uv = [[JYJMyWalletViewController alloc]init];
                        uv.userEntity = userEntity;
                        [self.navigationController pushViewController:uv animated:YES];
                    }
                    else {
                        //登陆成功跳转
                        JYJMyStickerViewController *xaw = [[JYJMyStickerViewController alloc]init];
                        xaw.userEntity = userEntity;
                        [self.navigationController pushViewController:xaw animated:YES];
                        
//                        MapViewController *mapvc = [[MapViewController alloc]init];
//                        mapvc.userEntity = userEntity;
//                        [self.navigationController pushViewController:mapvc animated:YES];
                    }
                }
                else if ([result isEqualToString:@"400"]) {
                    NSString *text = response[@"data"][@"text"];
                    
                    UIAlertController *alert = [UIAlertController alertControllerWithTitle:text message:nil preferredStyle:UIAlertControllerStyleAlert];
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

- (BOOL)prefersStatusBarHidden {
    return YES;
}

- (UIStatusBarStyle)preferredStatusBarStyle {
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
