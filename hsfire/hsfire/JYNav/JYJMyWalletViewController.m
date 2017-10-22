//
//  JYJMyWalletViewController.m
//  JYJSlideMenuController
//
//  Created by JYJ on 2017/6/16.
//  Copyright © 2017年 baobeikeji. All rights reserved.
//

#import "JYJMyWalletViewController.h"
#import "LLWebViewController.h"
#import "Macro.h"
#import "JYJSliderMenuTool.h"
#import "User.h"
#import "UserTool.h"
#import "BaseInfo.h"
#import "CKHttpCommunicate.h"

@interface JYJMyWalletViewController ()
/** tapGestureRec */
@property (nonatomic, weak) UITapGestureRecognizer *tapGestureRec;
/** panGestureRec */
@property (nonatomic, strong) UIPanGestureRecognizer *panGestureRec;

@end

@implementation JYJMyWalletViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor colorWithRed:245/255.0f green:245/255.0f blue:245/255.0f alpha:1];
    
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
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(20, 40, 280, 30)];
    label.text = @"欢迎使用黄石消防在线教育系统";
    label.textColor = [UIColor colorWithRed:0/255.0f green:0/255.0f blue:0/255.0f alpha:1];
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont boldSystemFontOfSize:16];
    [self.view addSubview:label];
    
    UIButton *btn1 = [UIButton buttonWithType:UIButtonTypeCustom];
    btn1.tag = 1;
    btn1.frame = CGRectMake(45, 140, 60, 60);
    [btn1 addTarget:self action:@selector(tourl:) forControlEvents:UIControlEventTouchUpInside];
    [btn1 setImage:[UIImage imageNamed:@"xfzs1.png"] forState:UIControlStateNormal];
    [self.view addSubview:btn1];
    
    UILabel *label1 = [[UILabel alloc]initWithFrame:CGRectMake(40, 225, 70, 30)];
    label1.text = @"科普宣传";
    label1.textColor = [UIColor colorWithRed:0/255.0f green:0/255.0f blue:0/255.0f alpha:1];
    label1.textAlignment = NSTextAlignmentCenter;
    label1.font = [UIFont boldSystemFontOfSize:16];
    [self.view addSubview:label1];
    
    UIButton *btn2 = [UIButton buttonWithType:UIButtonTypeCustom];
    btn2.tag = 2;
    btn2.frame = CGRectMake(kWidth - 115, 140, 60, 60);
    [btn2 addTarget:self action:@selector(tourl:) forControlEvents:UIControlEventTouchUpInside];
    [btn2 setImage:[UIImage imageNamed:@"xfzs3.png"] forState:UIControlStateNormal];
    [self.view addSubview:btn2];
    
    UILabel *label2 = [[UILabel alloc]initWithFrame:CGRectMake(kWidth - 130, 225, 100, 30)];
    label2.text = @"消防云课堂";
    label2.textColor = [UIColor colorWithRed:0/255.0f green:0/255.0f blue:0/255.0f alpha:1];
    label2.textAlignment = NSTextAlignmentCenter;
    label2.font = [UIFont boldSystemFontOfSize:16];
    [self.view addSubview:label2];
    
    UIButton *btn3 = [UIButton buttonWithType:UIButtonTypeCustom];
    btn3.tag = 3;
    btn3.frame = CGRectMake(45, 290, 60, 60);
    [btn3 addTarget:self action:@selector(tourl:) forControlEvents:UIControlEventTouchUpInside];
    [btn3 setImage:[UIImage imageNamed:@"xfzs4.png"] forState:UIControlStateNormal];
    [self.view addSubview:btn3];
    
    UILabel *label3 = [[UILabel alloc]initWithFrame:CGRectMake(30, 375, 100, 30)];
    label3.text = @"职业资格考试";
    label3.textColor = [UIColor colorWithRed:0/255.0f green:0/255.0f blue:0/255.0f alpha:1];
    label3.textAlignment = NSTextAlignmentCenter;
    label3.font = [UIFont boldSystemFontOfSize:16];
    [self.view addSubview:label3];
    
    UIButton *btn4 = [UIButton buttonWithType:UIButtonTypeCustom];
    btn4.tag = 4;
    btn4.frame = CGRectMake(kWidth - 115, 290, 60, 60);
    [btn4 addTarget:self action:@selector(tourl:) forControlEvents:UIControlEventTouchUpInside];
    [btn4 setImage:[UIImage imageNamed:@"xfzs2.png"] forState:UIControlStateNormal];
    [self.view addSubview:btn4];
    
    UILabel *label4 = [[UILabel alloc]initWithFrame:CGRectMake(kWidth - 130, 375, 100, 30)];
    label4.text = @"知识常识考试";
    label4.textColor = [UIColor colorWithRed:0/255.0f green:0/255.0f blue:0/255.0f alpha:1];
    label4.textAlignment = NSTextAlignmentCenter;
    label4.font = [UIFont boldSystemFontOfSize:16];
    [self.view addSubview:label4];
}

-(void)tourl:(UIButton *)button {
    NSString *url;
    
    if(button.tag == 1) {
        //NSLog(@"科普宣传");
        url = [NSString stringWithFormat:@"%@index.php/Home/Index/xwlist/flid/3",URL_IMG];
    }
    else if(button.tag == 2) {
        //NSLog(@"消防云课堂");
        url = @"http://www.hsfire.com/shake/";
    }
    else if(button.tag == 3) {
        //NSLog(@"消防云课堂");
        url = @"http://www.hsfire.com/xf/ks100.php";
    }
    else if(button.tag == 4) {
        //NSLog(@"消防云课堂");
        url = @"http://www.hsfire.com/xf/ks.php";
    }
    
    LLWebViewController *webV = [LLWebViewController new];
    webV.urlStr = url;
    webV.isPullRefresh = YES;
    [self.navigationController pushViewController:webV animated:YES];
}

-(void)backBtnClick {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)setupNav {
    self.title = @"消防学习园地";
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
    NSString *chkdev = [NSString stringWithFormat:@"select * from t_base"];
    NSMutableArray *dev_datas = [UserTool baseWithSql:chkdev];
    BaseInfo *bi = [BaseInfo new];//dev_datas[0];
    NSString *devcode = @"";
    if (dev_datas.count > 0) {
        devcode = bi.keyValue;
    }
    else {
        devcode = @"noid";
    }
    //NSString *devcode = bi.keyValue;
    //NSLog(@"=========================%@",devcode);
    
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
