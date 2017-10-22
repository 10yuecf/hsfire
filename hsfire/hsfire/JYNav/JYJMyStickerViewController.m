//
//  JYJMyWalletViewController.m
//  JYJSlideMenuController
//
//  Created by JYJ on 2017/6/16.
//  Copyright © 2017年 baobeikeji. All rights reserved.
//  消安委

#import "JYJMyStickerViewController.h"
#import "hsdcwUtils.h"
#import "Macro.h"
#import "LLWebViewController.h"
#import "JYJSliderMenuTool.h"
#import "User.h"
#import "UserTool.h"
#import "BaseInfo.h"
#import "CKHttpCommunicate.h"

//-----极光推送
// 引入JPush功能所需头文件
#import "JPUSHService.h"
// iOS10注册APNs所需头文件
#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#import <UserNotifications/UserNotifications.h>
#endif
//-----end

@interface JYJMyStickerViewController ()
/** tapGestureRec */
@property (nonatomic, weak) UITapGestureRecognizer *tapGestureRec;
/** panGestureRec */
@property (nonatomic, strong) UIPanGestureRecognizer *panGestureRec;
@property (nonatomic, strong) NSString *devcode;
@end

@implementation JYJMyStickerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor colorWithRed:242/255.0f green:242/255.0f blue:242/255.0f alpha:1];
    
    [self setupNav];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    // 这个方法是为了，不让隐藏状态栏的时候出现view上移
    self.extendedLayoutIncludesOpaqueBars = YES;
    self.view.backgroundColor = [UIColor whiteColor];
    
    // 屏幕边缘pan手势(优先级高于其他手势)
    UIScreenEdgePanGestureRecognizer *leftEdgeGesture = [[UIScreenEdgePanGestureRecognizer alloc] initWithTarget:self
                                                                                                          action:@selector(moveViewWithGesture:)];
    leftEdgeGesture.edges = UIRectEdgeLeft;// 屏幕左侧边缘响应
    [self.view addGestureRecognizer:leftEdgeGesture];
    // 这里是地图处理方式，遵守代理协议，实现代理方法
    leftEdgeGesture.delegate = self;
    
    // 如果是scrollView的话，下面这行代码就可以了不用遵守代理协议，实现代理方法
    // [scrollView.panGestureRecognizer requireGestureRecognizerToFail:leftEdgeGesture];
    
    [self loadUI];
    
    [self updevcode];
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldBeRequiredToFailByGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    BOOL result = NO;
    if ([gestureRecognizer isKindOfClass:[UIScreenEdgePanGestureRecognizer class]]) {
        result = YES;
    }
    return result;
}

- (void)moveViewWithGesture:(UIPanGestureRecognizer *)panGes {
    if (panGes.state == UIGestureRecognizerStateEnded) {
        [self profileCenter];
    }
}

- (void)profileCenter {
    // 展示个人中心
    [JYJSliderMenuTool showWithRootViewController:self];
}

-(void)loadUI {
    //hsdcwUtils *utils = [[hsdcwUtils alloc]init];
    //NSString *iphone = [utils iphoneType];
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(20, 40, 280, 30)];
    label.text = @"欢迎来到黄石消防安全委员会工作平台";
    label.textColor = [UIColor colorWithRed:0/255.0f green:0/255.0f blue:0/255.0f alpha:1];
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont boldSystemFontOfSize:16];
    [self.view addSubview:label];
    
    UIButton *btn1 = [UIButton buttonWithType:UIButtonTypeCustom];
    btn1.tag = 1;
    btn1.frame = CGRectMake(25, 140, 70, 70);
    [btn1 addTarget:self action:@selector(tourl:) forControlEvents:UIControlEventTouchUpInside];
    [btn1 setImage:[UIImage imageNamed:@"xaw1.png"] forState:UIControlStateNormal];
    [self.view addSubview:btn1];
    
    UILabel *label1 = [[UILabel alloc]initWithFrame:CGRectMake(25, 225, 70, 30)];
    label1.text = @"机构简介";
    label1.textColor = [UIColor colorWithRed:0/255.0f green:0/255.0f blue:0/255.0f alpha:1];
    label1.textAlignment = NSTextAlignmentCenter;
    label1.font = [UIFont boldSystemFontOfSize:16];
    [self.view addSubview:label1];
    
    UIButton *btn2 = [UIButton buttonWithType:UIButtonTypeCustom];
    btn2.tag = 2;
    btn2.frame = CGRectMake(kWidth / 2 - 35, 140, 70, 70);
    [btn2 addTarget:self action:@selector(tourl:) forControlEvents:UIControlEventTouchUpInside];
    [btn2 setImage:[UIImage imageNamed:@"xaw2.png"] forState:UIControlStateNormal];
    [self.view addSubview:btn2];
    
    UILabel *label2 = [[UILabel alloc]initWithFrame:CGRectMake(kWidth / 2 - 35, 225, 70, 30)];
    label2.text = @"文件通知";
    label2.textColor = [UIColor colorWithRed:0/255.0f green:0/255.0f blue:0/255.0f alpha:1];
    label2.textAlignment = NSTextAlignmentCenter;
    label2.font = [UIFont boldSystemFontOfSize:16];
    [self.view addSubview:label2];
    
    UIButton *btn3 = [UIButton buttonWithType:UIButtonTypeCustom];
    btn3.tag = 3;
    btn3.frame = CGRectMake(kWidth - 95, 140, 70, 70);
    [btn3 addTarget:self action:@selector(tourl:) forControlEvents:UIControlEventTouchUpInside];
    [btn3 setImage:[UIImage imageNamed:@"xaw3.png"] forState:UIControlStateNormal];
    [self.view addSubview:btn3];
    
    UILabel *label3 = [[UILabel alloc]initWithFrame:CGRectMake(kWidth - 95, 225, 70, 30)];
    label3.text = @"消防新闻";
    label3.textColor = [UIColor colorWithRed:0/255.0f green:0/255.0f blue:0/255.0f alpha:1];
    label3.textAlignment = NSTextAlignmentCenter;
    label3.font = [UIFont boldSystemFontOfSize:16];
    [self.view addSubview:label3];
    
    UIButton *btn4 = [UIButton buttonWithType:UIButtonTypeCustom];
    btn4.tag = 4;
    btn4.frame = CGRectMake(25, 290, 70, 70);
    [btn4 addTarget:self action:@selector(tourl:) forControlEvents:UIControlEventTouchUpInside];
    [btn4 setImage:[UIImage imageNamed:@"xaw4.png"] forState:UIControlStateNormal];
    [self.view addSubview:btn4];
    
    UILabel *label4 = [[UILabel alloc]initWithFrame:CGRectMake(25, 375, 70, 30)];
    label4.text = @"联合执法";
    label4.textColor = [UIColor colorWithRed:0/255.0f green:0/255.0f blue:0/255.0f alpha:1];
    label4.textAlignment = NSTextAlignmentCenter;
    label4.font = [UIFont boldSystemFontOfSize:16];
    [self.view addSubview:label4];
    
    UIButton *btn5 = [UIButton buttonWithType:UIButtonTypeCustom];
    btn5.tag = 5;
    btn5.frame = CGRectMake(kWidth / 2 - 35, 290, 70, 70);
    [btn5 addTarget:self action:@selector(tourl:) forControlEvents:UIControlEventTouchUpInside];
    [btn5 setImage:[UIImage imageNamed:@"xaw5.png"] forState:UIControlStateNormal];
    [self.view addSubview:btn5];
    
    UILabel *label5 = [[UILabel alloc]initWithFrame:CGRectMake(kWidth / 2 - 35, 375, 70, 30)];
    label5.text = @"隐患抄告";
    label5.textColor = [UIColor colorWithRed:0/255.0f green:0/255.0f blue:0/255.0f alpha:1];
    label5.textAlignment = NSTextAlignmentCenter;
    label5.font = [UIFont boldSystemFontOfSize:16];
    [self.view addSubview:label5];
    
    UIButton *btn6 = [UIButton buttonWithType:UIButtonTypeCustom];
    btn6.tag = 6;
    btn6.frame = CGRectMake(kWidth - 95, 290, 70, 70);
    [btn6 addTarget:self action:@selector(tourl:) forControlEvents:UIControlEventTouchUpInside];
    [btn6 setImage:[UIImage imageNamed:@"xaw6.png"] forState:UIControlStateNormal];
    [self.view addSubview:btn6];
    
    UILabel *label6 = [[UILabel alloc]initWithFrame:CGRectMake(kWidth - 95, 375, 70, 30)];
    label6.text = @"通讯录";
    label6.textColor = [UIColor colorWithRed:0/255.0f green:0/255.0f blue:0/255.0f alpha:1];
    label6.textAlignment = NSTextAlignmentCenter;
    label6.font = [UIFont boldSystemFontOfSize:16];
    [self.view addSubview:label6];
}

-(void)tourl:(UIButton *)button {
    NSString *chkuser = [NSString stringWithFormat:@"select * from t_user where loginstatus = '1' limit 1"];
    NSMutableArray *user_arr = [UserTool userWithSql:chkuser];
    
    NSString *uid;
    
    if (user_arr.count == 0) {
        uid = @"0";
    }
    else {
        User *u = user_arr[0];
        uid = u.userID;
    }
    
    NSString *url = [NSString stringWithFormat:@"%@index.php/Home/Index/",URL_IMG];
    
    if(button.tag == 1) {
        url = [url stringByAppendingString:@"xaw_jg"];
    }
    else if(button.tag == 2) {
        url = [url stringByAppendingString:@"xwlist/flid/2"];
    }
    else if(button.tag == 3) {
        url = [url stringByAppendingString:@"xwlist/flid/1"];
    }
    else if(button.tag == 4) {
        url = [url stringByAppendingString:@"xaw_lhzflist"];
    }
    else if(button.tag == 5) {
        url = [url stringByAppendingString:@"yhsblist/uid/"];
        url = [url stringByAppendingString:uid];
    }
    else if(button.tag == 6) {
        url = [url stringByAppendingString:@"gulist"];
    }
    
    NSLog(@"%@",url);
    
    LLWebViewController *webV = [LLWebViewController new];
    webV.urlStr = url;
    webV.isPullRefresh = YES;
    [self.navigationController pushViewController:webV animated:YES];
}

-(void)backBtnClick {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)setupNav {
    self.title = @"消防安全委员会";
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:18], NSForegroundColorAttributeName:[UIColor colorWithRed:255 / 255.0 green:255 / 255.0 blue:255 / 255.0 alpha:1.0]}];
    
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    negativeSpacer.width = -15;
    
    UIButton *profileButton = [[UIButton alloc] init];
    // 设置按钮的背景图片
    [profileButton setImage:[UIImage imageNamed:@"tt"] forState:UIControlStateNormal];
    // 设置按钮的尺寸为背景图片的尺寸
    profileButton.frame = CGRectMake(0, 0, 44, 44);
    //监听按钮的点击
    [profileButton addTarget:self action:@selector(profileCenter) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *profile = [[UIBarButtonItem alloc] initWithCustomView:profileButton];
    self.navigationItem.leftBarButtonItems = @[negativeSpacer, profile];
}

-(void)updevcode {
    hsdcwUtils *utils = [hsdcwUtils new];
    NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
    NSString *devcode = [userDefaultes stringForKey:@"devcode"];
    
    if([utils isBlankString:devcode]) {
        devcode = @"noid";
    }
    else {
        devcode = [userDefaultes stringForKey:@"devcode"];
    }
    NSLog(@"=========================%@",devcode);
    
    NSString *chkuser = [NSString stringWithFormat:@"select * from t_user where loginstatus = '1' limit 1"];
    NSMutableArray *user_arr = [UserTool userWithSql:chkuser];
    
    NSString *uid;
    
    if (user_arr.count == 0) {
        uid = @"0";
    }
    else {
        User *u = user_arr[0];
        uid = u.userID;
    }
    
    //更新本地设备码
    NSString *update = [NSString stringWithFormat:@"update t_user set devicetoken = '%@'",devcode];
    [UserTool userWithSql:update];
    
    //NSLog(@"id========%@",uid);
    
    //记录用户设备号
    NSDictionary *param_dev = @{@"type":@"ios",
                                @"id":uid,
                                @"code":devcode
                                };
    [CKHttpCommunicate createRequest:SandUmcode WithParam:param_dev withMethod:POST success:^(id response) {
        //NSLog(@"%@",response);
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
