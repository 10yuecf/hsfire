//
//  JYJMyWalletViewController.m
//  JYJSlideMenuController
//
//  Created by JYJ on 2017/6/16.
//  Copyright © 2017年 baobeikeji. All rights reserved.
//

#import "JYJMyTripViewController.h"
#import "LLWebViewController.h"
#import "hsdcwUtils.h"
#import "Macro.h"

@interface JYJMyTripViewController ()

@end

@implementation JYJMyTripViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor colorWithRed:245/255.0f green:245/255.0f blue:245/255.0f alpha:1];
    
    [self setupNav];
    
    UIButton *btn1 = [UIButton buttonWithType:UIButtonTypeCustom];
    btn1.tag = 1;
    btn1.frame = CGRectMake(kWidth / 6, 50, kWidth - 100, 37);
    btn1.titleLabel.font = [UIFont systemFontOfSize:19];
    [btn1 setTitle:@"消防设计备案" forState:UIControlStateNormal];
    [btn1 addTarget:self action:@selector(tourl:) forControlEvents:UIControlEventTouchUpInside];
    [btn1 setBackgroundColor:[UIColor colorWithRed:204/255.0f green:0/255.0f blue:0/255.0f alpha:1]];
    btn1.layer.cornerRadius = 5.0;
    [self.view addSubview:btn1];
    
    UIButton *btn2 = [UIButton buttonWithType:UIButtonTypeCustom];
    btn2.tag = 2;
    btn2.frame = CGRectMake(kWidth / 6, 120, kWidth - 100, 37);
    btn2.titleLabel.font = [UIFont systemFontOfSize:19];
    [btn2 setTitle:@"竣工验收消防备案" forState:UIControlStateNormal];
    [btn2 addTarget:self action:@selector(tourl:) forControlEvents:UIControlEventTouchUpInside];
    [btn2 setBackgroundColor:[UIColor colorWithRed:204/255.0f green:0/255.0f blue:0/255.0f alpha:1]];
    btn2.layer.cornerRadius = 5.0;
    [self.view addSubview:btn2];
    
    UIButton *btn3 = [UIButton buttonWithType:UIButtonTypeCustom];
    btn3.tag = 3;
    btn3.frame = CGRectMake(kWidth / 6, 190, kWidth - 100, 37);
    btn3.titleLabel.font = [UIFont systemFontOfSize:19];
    [btn3 setTitle:@"消防设计审核" forState:UIControlStateNormal];
    [btn3 addTarget:self action:@selector(tourl:) forControlEvents:UIControlEventTouchUpInside];
    [btn3 setBackgroundColor:[UIColor colorWithRed:204/255.0f green:0/255.0f blue:0/255.0f alpha:1]];
    btn3.layer.cornerRadius = 5.0;
    [self.view addSubview:btn3];
    
    UIButton *btn4 = [UIButton buttonWithType:UIButtonTypeCustom];
    btn4.tag = 4;
    btn4.frame = CGRectMake(kWidth / 6, 260, kWidth - 100, 37);
    btn4.titleLabel.font = [UIFont systemFontOfSize:19];
    [btn4 setTitle:@"消防验收" forState:UIControlStateNormal];
    [btn4 addTarget:self action:@selector(tourl:) forControlEvents:UIControlEventTouchUpInside];
    [btn4 setBackgroundColor:[UIColor colorWithRed:204/255.0f green:0/255.0f blue:0/255.0f alpha:1]];
    btn4.layer.cornerRadius = 5.0;
    [self.view addSubview:btn4];
    
    UIButton *btn5 = [UIButton buttonWithType:UIButtonTypeCustom];
    btn5.tag = 5;
    btn5.frame = CGRectMake(kWidth / 6, 330, kWidth - 100, 37);
    btn5.titleLabel.font = [UIFont systemFontOfSize:19];
    [btn5 setTitle:@"公共场所安全检查" forState:UIControlStateNormal];
    [btn5 addTarget:self action:@selector(tourl:) forControlEvents:UIControlEventTouchUpInside];
    [btn5 setBackgroundColor:[UIColor colorWithRed:204/255.0f green:0/255.0f blue:0/255.0f alpha:1]];
    btn5.layer.cornerRadius = 5.0;
    [self.view addSubview:btn5];
}

-(void)tourl:(UIButton *)button {
//    hsdcwUtils *utils = [[hsdcwUtils alloc]init];
//    NSString *xf_dt = utils.myencrypt[0];
//    NSString *xf_tk = utils.myencrypt[1];
    //NSLog(@"%@========%@",xf_dt, xf_tk);
    
    NSString *url = [NSString stringWithFormat:@"%@index.php/Home/Index/splist/type/",URL_IMG];
    if(button.tag == 1) {
        url = [url stringByAppendingString:@"sjba"];
    }
    else if(button.tag == 2) {
        url = [url stringByAppendingString:@"jgba"];
    }
    else if(button.tag == 3) {
        url = [url stringByAppendingString:@"sjsh"];
    }
    else if(button.tag == 4) {
        url = [url stringByAppendingString:@"xfys"];
    }
    else if(button.tag == 5) {
        url = [url stringByAppendingString:@"aqjc"];
    }
    
    //NSLog(@"%@",url);
    
    LLWebViewController *webV = [LLWebViewController new];
    webV.urlStr = url;
    webV.isPullRefresh = YES;
    [self.navigationController pushViewController:webV animated:YES];
    
//    WKWebviewController *webVC = [WKWebviewController new];
//    webVC.urlString = url;
//    [self.navigationController pushViewController:webVC animated:YES];
}

-(void)backBtnClick {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)setupNav {
    self.title = @"消防审批";
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
