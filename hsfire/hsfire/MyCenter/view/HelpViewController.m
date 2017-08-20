//
//  HelpViewController.m
//  hsjhb
//
//  Created by louislee on 16/6/29.
//  Copyright © 2016年 hsdcw. All rights reserved.
//

#import "HelpViewController.h"

@interface HelpViewController ()
@property( nonatomic,strong)UIWebView *myWebView;
@end

@implementation HelpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSString *pageurl = self.userEntity.pageUrl;
    self.myWebView = [[UIWebView alloc] initWithFrame:self.view.bounds];
    NSString *bundleFile = [[NSBundle mainBundle] pathForResource:@"html" ofType:@"bundle"];
    NSString *htmlFile = [bundleFile stringByAppendingPathComponent:pageurl];
    NSData *htmlData = [NSData dataWithContentsOfFile:htmlFile];
    [_myWebView loadData:htmlData MIMEType:@"text/html" textEncodingName:@"UTF-8" baseURL:[NSURL fileURLWithPath:bundleFile]];
    
    _myWebView.scalesPageToFit = YES;//自动对页面进行缩放以适应屏幕
    
    [self.view addSubview:self.myWebView];
    
    self.navigationController.navigationBar.tintColor = [UIColor orangeColor];
}

- (BOOL)prefersStatusBarHidden {
    return NO; //隐藏状态栏,是的,是的!
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    self.tabBarController.hidesBottomBarWhenPushed = YES;
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:NO];
    self.tabBarController.hidesBottomBarWhenPushed = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
