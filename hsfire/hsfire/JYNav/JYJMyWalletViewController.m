//
//  JYJMyWalletViewController.m
//  JYJSlideMenuController
//
//  Created by JYJ on 2017/6/16.
//  Copyright © 2017年 baobeikeji. All rights reserved.
//

#import "JYJMyWalletViewController.h"
#import "WKWebviewController.h"

@interface JYJMyWalletViewController ()

@end

@implementation JYJMyWalletViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor colorWithRed:245/255.0f green:245/255.0f blue:245/255.0f alpha:1];
    
    [self setupNav];
    
    UIButton *btn1 = [UIButton buttonWithType:UIButtonTypeCustom];
    btn1.tag = 1;
    btn1.frame = CGRectMake(10, 50, self.view.frame.size.width - 100, 37);
    btn1.titleLabel.font = [UIFont systemFontOfSize:19];
    [btn1 setTitle:@"科普宣传" forState:UIControlStateNormal];
    [btn1 addTarget:self action:@selector(tourl:) forControlEvents:UIControlEventTouchUpInside];
    [btn1 setBackgroundColor:[UIColor colorWithRed:204/255.0f green:0/255.0f blue:0/255.0f alpha:1]];
    btn1.layer.cornerRadius = 5.0;
    [self.view addSubview:btn1];
    
    UIButton *btn2 = [UIButton buttonWithType:UIButtonTypeCustom];
    btn2.tag = 2;
    btn2.frame = CGRectMake(10, 100, self.view.frame.size.width - 100, 37);
    btn2.titleLabel.font = [UIFont systemFontOfSize:19];
    [btn2 setTitle:@"消防云课堂" forState:UIControlStateNormal];
    [btn2 addTarget:self action:@selector(tourl:) forControlEvents:UIControlEventTouchUpInside];
    [btn2 setBackgroundColor:[UIColor colorWithRed:204/255.0f green:0/255.0f blue:0/255.0f alpha:1]];
    btn2.layer.cornerRadius = 5.0;
    [self.view addSubview:btn2];
    
    UIButton *btn3 = [UIButton buttonWithType:UIButtonTypeCustom];
    btn3.tag = 3;
    btn3.frame = CGRectMake(10, 150, self.view.frame.size.width - 100, 37);
    btn3.titleLabel.font = [UIFont systemFontOfSize:19];
    [btn3 setTitle:@"消防职业资格考试" forState:UIControlStateNormal];
    [btn3 addTarget:self action:@selector(tourl:) forControlEvents:UIControlEventTouchUpInside];
    [btn3 setBackgroundColor:[UIColor colorWithRed:204/255.0f green:0/255.0f blue:0/255.0f alpha:1]];
    btn3.layer.cornerRadius = 5.0;
    [self.view addSubview:btn3];
    
    UIButton *btn4 = [UIButton buttonWithType:UIButtonTypeCustom];
    btn4.tag = 4;
    btn4.frame = CGRectMake(10, 200, self.view.frame.size.width - 100, 37);
    btn4.titleLabel.font = [UIFont systemFontOfSize:19];
    [btn4 setTitle:@"市民消防知识考试" forState:UIControlStateNormal];
    [btn4 addTarget:self action:@selector(tourl:) forControlEvents:UIControlEventTouchUpInside];
    [btn4 setBackgroundColor:[UIColor colorWithRed:204/255.0f green:0/255.0f blue:0/255.0f alpha:1]];
    btn4.layer.cornerRadius = 5.0;
    [self.view addSubview:btn4];
}

-(void)tourl:(UIButton *)button {
    NSString *url;
    
    if(button.tag == 1) {
        //NSLog(@"科普宣传");
        url = @"http://www.qq.com";
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
    
    WKWebviewController *webVC = [WKWebviewController new];
    webVC.urlString = url;
    [self.navigationController pushViewController:webVC animated:YES];
}

-(void)backBtnClick {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)setupNav {
    self.title = @"消防知识";
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
