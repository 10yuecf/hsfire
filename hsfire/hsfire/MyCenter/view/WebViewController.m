//
//  WebViewController.m
//  hsjhb
//
//  Created by louislee on 16/6/20.
//  Copyright © 2016年 hsdcw. All rights reserved.
//
#import <JavaScriptCore/JavaScriptCore.h>
#import <QuartzCore/QuartzCore.h>
#import "WebViewController.h"
#import "XBWebBridge.h"
#import "hsdcwUtils.h"
#import "CKHttpCommunicate.h"

@interface WebViewController ()
@property (nonatomic,strong) UIWebView *myWebView;
@property (nonatomic,strong) JSContext *context;
@property (nonatomic,strong) XBWebBridge *bridge;
@property (nonatomic,copy) NSString *callBack;
@end

@implementation WebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSString *pageurl = self.userEntity.pageUrl;
    self.myWebView = [[UIWebView alloc] initWithFrame:self.view.bounds];
    NSString *bundleFile = [[NSBundle mainBundle] pathForResource:@"html" ofType:@"bundle"];
    NSString *htmlFile = [bundleFile stringByAppendingPathComponent:pageurl];
    NSData *htmlData = [NSData dataWithContentsOfFile:htmlFile];
    [_myWebView loadData:htmlData MIMEType:@"text/html" textEncodingName:@"UTF-8" baseURL:[NSURL fileURLWithPath:bundleFile]];
    
    _myWebView.scalesPageToFit = YES; //自动对页面进行缩放以适应屏幕
    
    [self.view addSubview:self.myWebView];
    
    self.navigationController.navigationBar.tintColor = [UIColor orangeColor];
    
    __weak typeof(self) weakSelf = self;
    self.bridge = [[XBWebBridge alloc]initWithWebView:self.myWebView];
    [self.bridge registerObjcFunctionforJavaScriptWithFunctionName:@"liveCallHanlder"];
    [self.bridge registerObjcFunctionforJavaScriptWithFunctionName:@"liveAjax"];
    
    self.bridge.handleResultDictionary = ^(NSDictionary *result,NSString *registerFunctionName) {
        if ([registerFunctionName isEqualToString:@"liveCallHanlder"]) {
            NSLog(@"liveCallHanlder === %@",result);
        }
        else {
            NSLog(@"liveAjax === %@",result);
        }
        
        weakSelf.callBack = result[@"callBack"];
        //NSLog(@"%@",result[@"callBack"]);
        NSString *url = result[@"url"];
        NSString *action = result[@"action"];
        NSString *jsonstr = result[@"jsonstr"];
        //NSString *getFunc = result[@"callBack"];
        
        //NSLog(@"%@",jsonstr);
        
        //if ([getFunc isEqualToString:@"jhb.jsToOc"]) {
        [weakSelf sendToken:action url:url jsonstr:jsonstr];
        //}
    };
    
    //[weakSelf event2JS];
    
}

- (void)sendToken:(NSString *)action url:(NSString*)url jsonstr:(NSString *)jsonstr {
    //读取本地数据用户token
    hsdcwUtils *utils = [[hsdcwUtils alloc]init];
    NSArray *u_arr = [utils getUserInfo];
    //NSLog(@"%@",u_arr[2]);
    
    NSString *usertoken = u_arr[2];
    NSString *userId = [NSString stringWithFormat:@"%@",self.userEntity.userId];
    
    NSDictionary *parameter = @{@"action":action,
                                @"usertoken":usertoken,
                                @"id":userId,
                                @"jsonstr":jsonstr};
    [CKHttpCommunicate createRequest:GetYzm WithParam:parameter withMethod:POST success:^(id response) {
        if (response) {
            [self.bridge callJavaScriptWithFunctionName:self.callBack param:response[@"data"]];
        }
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    } showHUD:self.view];
}

- (void)send2JS {
    //NSLog(@"123");
    //NSLog(@"%@",self.callBack);
    
    NSDictionary *param = @{
                            @"id":@"lilei",
                            @"age":@"13",
                            @"sex":@"男",
                            @"friends":@[@"han",@"li"]
                            };
    [self.bridge callJavaScriptFunctionWhenWebViewFinishLoadWithFunctionName:@"pageinit" param:param];
}

//读取活动页面数据
- (void)event2JS {
    NSString *userId = self.userEntity.userId;
    //NSLog(@"%@",userId);
    
    NSDictionary *parameter = @{@"id":userId};
    [CKHttpCommunicate createRequest:GetPartyShow WithParam:parameter withMethod:GET success:^(id response) {
        //NSLog(@"%@",response);
        if (response) {
            //NSLog(@"%@",response);
            
            [self.bridge callJavaScriptFunctionWhenWebViewFinishLoadWithFunctionName:@"pageinit" param:response[@"data"]];
        }
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    } showHUD:self.view];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    self.tabBarController.hidesBottomBarWhenPushed = YES;
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:NO];
    self.tabBarController.hidesBottomBarWhenPushed = NO;
}

@end