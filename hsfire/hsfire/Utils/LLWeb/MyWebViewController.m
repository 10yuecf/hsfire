//
//  LLWebViewController.m
//  LLWebViewController
//
//  Created by liushaohua on 2017/1/19.
//  Copyright © 2017年 liushaohua. All rights reserved.
//  修改带导航的webview控件和自定义返回
#import <WebKit/WebKit.h>

#import "MyWebViewController.h"
#import "BNRoutePlanModel.h"
#import "BNCoreServices.h"
#import "BNaviModel.h"

#import "MapTViewController.h"
#import "MapFivViewController.h"
#import "MapFivViewController.h"
#import "MapSixViewController.h"
#import "MapFViewController.h"

#define NAVI_HEIGHT  64
@interface MyWebViewController ()<UIWebViewDelegate,WKNavigationDelegate,WKUIDelegate,UIGestureRecognizerDelegate>

@property (nonatomic, strong) WKWebView *wk_WebView;
@property (nonatomic, strong) UIWebView *webView;
@property (nonatomic, strong) UIBarButtonItem *backBarButtonItem;
@property (nonatomic, strong) UIBarButtonItem *closeBarButtonItem;
@property (nonatomic, strong) id <UIGestureRecognizerDelegate>delegate;
@property (nonatomic, strong) UIRefreshControl *refreshControl;
@property (nonatomic, strong) UIProgressView *loadingProgressView;
@property (nonatomic, strong) UIButton *reloadButton;

@end

@implementation MyWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16], NSForegroundColorAttributeName:[UIColor colorWithRed:255 / 255.0 green:255 / 255.0 blue:255 / 255.0 alpha:1.0]}];
    
    [self createWebView];
    [self createNaviItem];
    [self loadRequest];
}

#pragma mark 版本适配
- (void)createWebView {
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self.view addSubview:self.reloadButton];
    if ([[[UIDevice currentDevice]systemVersion]floatValue] >= 8.0) {
        [self.view addSubview:self.wk_WebView];
        [self.view addSubview:self.loadingProgressView];
    } else {
        [self.view addSubview:self.webView];
    }
}

- (UIWebView*)webView {
    if (!_webView) {
        _webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height - NAVI_HEIGHT)];
        _webView.delegate = self;
        if ([[[UIDevice currentDevice]systemVersion]floatValue] >= 10.0 && _isPullRefresh) {
            _webView.scrollView.refreshControl = self.refreshControl;
        }
    }
    return _webView;
}


- (WKWebView*)wk_WebView {
    if (!_wk_WebView) {
        WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc]init];
        config.preferences = [[WKPreferences alloc]init];
        config.userContentController = [[WKUserContentController alloc]init];
        _wk_WebView = [[WKWebView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height - NAVI_HEIGHT) configuration:config];
        _wk_WebView.navigationDelegate = self;
        _wk_WebView.UIDelegate = self;
        //添加此属性可触发侧滑返回上一网页与下一网页操作
        _wk_WebView.allowsBackForwardNavigationGestures = YES;
        //下拉刷新
        if ([[[UIDevice currentDevice]systemVersion]floatValue] >= 10.0 && _isPullRefresh) {
            _wk_WebView.scrollView.refreshControl = self.refreshControl;
        }
        //进度监听
        [_wk_WebView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:NULL];
    }
    return _wk_WebView;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:@"estimatedProgress"]) {
        _loadingProgressView.progress = [change[@"new"] floatValue];
        if (_loadingProgressView.progress == 1.0) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.4 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                _loadingProgressView.hidden = YES;
            });
        }
    }
}

- (void)dealloc {
    [_wk_WebView removeObserver:self forKeyPath:@"estimatedProgress"];
    [_wk_WebView stopLoading];
    [_webView stopLoading];
    _wk_WebView.UIDelegate = nil;
    _wk_WebView.navigationDelegate = nil;
    _webView.delegate = nil;
}


- (UIProgressView*)loadingProgressView {
    if (!_loadingProgressView) {
        _loadingProgressView = [[UIProgressView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 2)];
        _loadingProgressView.progressTintColor = [UIColor redColor];
    }
    return _loadingProgressView;
}

- (UIRefreshControl*)refreshControl {
    if (!_refreshControl) {
        _refreshControl = [[UIRefreshControl alloc]init];
        [_refreshControl addTarget:self action:@selector(webViewReload) forControlEvents:UIControlEventValueChanged];
    }
    return _refreshControl;
}

- (void)webViewReload {
    [_webView reload];
    [_wk_WebView reload];
}

- (UIButton*)reloadButton {
    if (!_reloadButton) {
        _reloadButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _reloadButton.frame = CGRectMake(0, 0, 150, 150);
        _reloadButton.center = self.view.center;
        _reloadButton.layer.cornerRadius = 75.0;
        [_reloadButton setBackgroundImage:[UIImage imageNamed:@"placeholder"] forState:UIControlStateNormal];
        [_reloadButton setTitle:@"您的网络有问题，请检查您的网络设置" forState:UIControlStateNormal];
        [_reloadButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        [_reloadButton setTitleEdgeInsets:UIEdgeInsetsMake(200, -50, 0, -50)];
        _reloadButton.titleLabel.numberOfLines = 0;
        _reloadButton.titleLabel.textAlignment = NSTextAlignmentCenter;
        CGRect rect = _reloadButton.frame;
        rect.origin.y -= 100;
        _reloadButton.frame = rect;
        _reloadButton.enabled = NO;
    }
    return _reloadButton;
}

#pragma mark 导航按钮
- (void)createNaviItem {
    [self showLeftBarButtonItem];
    [self showRightBarButtonItem];
}

- (void)showLeftBarButtonItem {
    if ([_webView canGoBack] || [_wk_WebView canGoBack]) {
        self.navigationItem.leftBarButtonItems = @[self.backBarButtonItem,self.closeBarButtonItem];
    } else {
        self.navigationItem.leftBarButtonItem = self.backBarButtonItem;
    }
}

- (void)showRightBarButtonItem {
    UIBarButtonItem *naviBtn = [[UIBarButtonItem alloc]initWithTitle:@"导航" style:UIBarButtonItemStylePlain target:self action:@selector(realNavi:)];
    [naviBtn setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:15],NSFontAttributeName,nil] forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem = naviBtn;
    self.navigationItem.rightBarButtonItem.tintColor = [UIColor whiteColor];
}

- (UIBarButtonItem*)backBarButtonItem {
    if (!_backBarButtonItem) {
        //UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        //[button setImage:[UIImage imageNamed:@"webview_back"] forState:UIControlStateNormal];
        _backBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"backarr"] style:UIBarButtonItemStylePlain target:self action:@selector(back:)];
        [_backBarButtonItem setTintColor:[UIColor whiteColor]];
        
        //设置距离左边屏幕的宽度距离
//        self.leftBarButton = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"backarr"] style:UIBarButtonItemStylePlain target:self action:@selector(selectedToBack)];
//        [self.leftBarButton setTintColor:[UIColor whiteColor]];
//        self.negativeSpacer = [[UIBarButtonItem alloc]   initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace   target:nil action:nil];
//        self.negativeSpacer.width = -5;
    }
    
    return _backBarButtonItem;
}

- (UIBarButtonItem*)closeBarButtonItem {
    if (!_closeBarButtonItem) {
        _closeBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"关闭" style:UIBarButtonItemStylePlain target:self action:@selector(close:)];
    }
    return _closeBarButtonItem;
}

- (void)back:(UIBarButtonItem*)item {
    if ([_webView canGoBack] || [_wk_WebView canGoBack]) {
        [_webView goBack];
        [_wk_WebView goBack];
    } else {
        NSString *viewname = self.userEntity.viewName;
        //NSLog(@"%@",viewname);
        
        CATransition* transition = [CATransition animation];
        transition.type = kCATransitionPush;//可更改为其他方式
        transition.subtype = kCATransitionFromLeft;//可更改为其他方式
        [self.navigationController.view.layer addAnimation:transition forKey:kCATransition];
        
        if([viewname isEqualToString:@"zddw_view"]) {
            //重点单位
            MapTViewController *map_zddw = [[MapTViewController alloc]init];
            [self.navigationController pushViewController:map_zddw animated:NO];
        }
        else if([viewname isEqualToString:@"zqbz_view"]) {
            //战报物资
            MapFViewController *map_zqbz = [[MapFViewController alloc]init];
            [self.navigationController pushViewController:map_zqbz animated:NO];
        }
        else if([viewname isEqualToString:@"jy_view"]) {
            //应急救援
            MapFivViewController *map_jy = [[MapFivViewController alloc]init];
            [self.navigationController pushViewController:map_jy animated:NO];
        }
        else if([viewname isEqualToString:@"zqll_view"]) {
            //战勤力量
            MapSixViewController *map_zqll = [[MapSixViewController alloc]init];
            [self.navigationController pushViewController:map_zqll animated:NO];
        }
        else {
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
}

- (void)close:(UIBarButtonItem*)item {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark 自定义导航按钮支持侧滑手势处理
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (self.navigationController.viewControllers.count > 1) {
        self.delegate = self.navigationController.interactivePopGestureRecognizer.delegate;
        self.navigationController.interactivePopGestureRecognizer.delegate = self;
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.navigationController.interactivePopGestureRecognizer.delegate = self.delegate;
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    return self.navigationController.viewControllers.count > 1;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return self.navigationController.viewControllers.count > 1;
}

#pragma mark 加载请求
- (void)loadRequest {
    if (![self.urlStr hasPrefix:@"http"]) {//是否具有http前缀
        self.urlStr = [NSString stringWithFormat:@"http://%@",self.urlStr];
    }
    if ([[[UIDevice currentDevice]systemVersion]floatValue] >= 8.0) {
        [_wk_WebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.urlStr]]];
    } else {
        [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.urlStr]]];
    }
}

#pragma mark WebViewDelegate
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    webView.hidden = NO;
    // 不加载空白网址
    if ([request.URL.scheme isEqual:@"about"]) {
        webView.hidden = YES;
        return NO;
    }
    return YES;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    //导航栏配置
    self.navigationItem.title = [webView stringByEvaluatingJavaScriptFromString:@"document.title"];
    [self showLeftBarButtonItem];
    [_refreshControl endRefreshing];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    webView.hidden = YES;
}

#pragma mark WKNavigationDelegate

#pragma mark 加载状态回调
//页面开始加载
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(null_unspecified WKNavigation *)navigation{
    webView.hidden = NO;
    _loadingProgressView.hidden = NO;
    if ([webView.URL.scheme isEqual:@"about"]) {
        webView.hidden = YES;
    }
}

//页面加载完成
- (void)webView:(WKWebView *)webView didFinishNavigation:(null_unspecified WKNavigation *)navigation{
    //导航栏配置
    [webView evaluateJavaScript:@"document.title" completionHandler:^(id _Nullable title, NSError * _Nullable error) {
        self.navigationItem.title = title;
    }];
    
    [self showLeftBarButtonItem];
    
    [_refreshControl endRefreshing];
}

//页面加载失败
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error{
    webView.hidden = YES;
}

//HTTPS认证
- (void)webView:(WKWebView *)webView didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition disposition, NSURLCredential *credential))completionHandler {
    if ([challenge.protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust]) {
        if ([challenge previousFailureCount] == 0) {
            NSURLCredential *credential = [NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust];
            completionHandler(NSURLSessionAuthChallengeUseCredential, credential);
        } else {
            completionHandler(NSURLSessionAuthChallengeCancelAuthenticationChallenge, nil);
        }
    } else {
        completionHandler(NSURLSessionAuthChallengeCancelAuthenticationChallenge, nil);
    }
}

//进程被终止时调用
-(void)webViewWebContentProcessDidTerminate:(WKWebView *)webView {
    //NSLog(@"==========");
}

//-------------导航-------------------
- (BOOL)checkServicesInited {
    if(![BNCoreServices_Instance isServicesInited]) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示"
                                                            message:@"引擎尚未初始化完成，请稍后再试"
                                                           delegate:nil
                                                  cancelButtonTitle:@"我知道了"
                                                  otherButtonTitles:nil];
        [alertView show];
        return NO;
    }
    return YES;
}

//模拟导航
- (void)simulateNavi:(UIButton*)button {
    if (![self checkServicesInited]) return;
    [self startNavi];
}

//真实GPS导航
- (void)realNavi:(UIButton*)button {
    if (![self checkServicesInited]) return;
    [self startNavi];
}

- (void)startNavi {
    //BOOL useMyLocation = NO;
    NSMutableArray *nodesArray = [[NSMutableArray alloc]initWithCapacity:2];
    //起点 传入的是原始的经纬度坐标，若使用的是百度地图坐标，可以使用BNTools类进行坐标转化
    //CLLocation *myLocation = [BNCoreServices_Location getLastLocation];
    BNRoutePlanNode *startNode = [[BNRoutePlanNode alloc] init];
    startNode.pos = [[BNPosition alloc] init];
    //if (useMyLocation) {
    //startNode.pos.x = myLocation.coordinate.longitude;
    //startNode.pos.y = myLocation.coordinate.latitude;
    //startNode.pos.eType = BNCoordinate_OriginalGPS;
    //}
    //else {
    startNode.pos.x = [self.userEntity.clon doubleValue];
    startNode.pos.y = [self.userEntity.clat doubleValue];
    startNode.pos.eType = BNCoordinate_BaiduMapSDK;
    //}
    NSLog(@"起点 %f",startNode.pos.x);
    [nodesArray addObject:startNode];
    
    //也可以在此加入1到3个的途经点
    BNRoutePlanNode *midNode = [[BNRoutePlanNode alloc] init];
    midNode.pos = [[BNPosition alloc] init];
    midNode.pos.x = [self.userEntity.anlon doubleValue];
    midNode.pos.y = [self.userEntity.anlat doubleValue];
    //midNode.pos.eType = BNCoordinate_BaiduMapSDK;
    //    [nodesArray addObject:midNode];
    
    //终点
    BNRoutePlanNode *endNode = [[BNRoutePlanNode alloc] init];
    endNode.pos = [[BNPosition alloc] init];
    //endNode.pos.x = 113.977004;
    //endNode.pos.y = 22.556393;
    endNode.pos.x = [self.userEntity.anlon doubleValue];
    endNode.pos.y = [self.userEntity.anlat doubleValue];
    endNode.pos.eType = BNCoordinate_BaiduMapSDK;
    NSLog(@"终点 %f",endNode.pos.x);
    [nodesArray addObject:endNode];
    
    //关闭openURL,不想跳转百度地图可以设为YES
    [BNCoreServices_RoutePlan setDisableOpenUrl:YES];
    [BNCoreServices_RoutePlan startNaviRoutePlan:BNRoutePlanMode_Recommend naviNodes:nodesArray time:nil delegete:self userInfo:nil];
}

#pragma mark - BNNaviRoutePlanDelegate
//算路成功回调
-(void)routePlanDidFinished:(NSDictionary *)userInfo
{
    NSLog(@"算路成功");
    
    //路径规划成功，开始导航
    [BNCoreServices_UI showPage:BNaviUI_NormalNavi delegate:self extParams:nil];
    
    //导航中改变终点方法示例
    /*dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(15 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
     BNRoutePlanNode *endNode = [[BNRoutePlanNode alloc] init];
     endNode.pos = [[BNPosition alloc] init];
     endNode.pos.x = 114.189863;
     endNode.pos.y = 22.546236;
     endNode.pos.eType = BNCoordinate_BaiduMapSDK;
     [[BNaviModel getInstance] resetNaviEndPoint:endNode];
     });*/
}

//算路失败回调
- (void)routePlanDidFailedWithError:(NSError *)error andUserInfo:(NSDictionary*)userInfo
{
    switch ([error code]%10000)
    {
        case BNAVI_ROUTEPLAN_ERROR_LOCATIONFAILED:
            NSLog(@"暂时无法获取您的位置,请稍后重试");
            break;
        case BNAVI_ROUTEPLAN_ERROR_ROUTEPLANFAILED:
            NSLog(@"无法发起导航");
            break;
        case BNAVI_ROUTEPLAN_ERROR_LOCATIONSERVICECLOSED:
            NSLog(@"定位服务未开启,请到系统设置中打开定位服务。");
            break;
        case BNAVI_ROUTEPLAN_ERROR_NODESTOONEAR:
            NSLog(@"起终点距离起终点太近");
            break;
        default:
            NSLog(@"算路失败");
            break;
    }
}

//算路取消回调
-(void)routePlanDidUserCanceled:(NSDictionary*)userInfo {
    NSLog(@"算路取消");
}

#pragma mark - 安静退出导航
- (void)exitNaviUI {
    [BNCoreServices_UI exitPage:EN_BNavi_ExitTopVC animated:YES extraInfo:nil];
}

#pragma mark - BNNaviUIManagerDelegate

//退出导航页面回调
- (void)onExitPage:(BNaviUIType)pageType  extraInfo:(NSDictionary*)extraInfo
{
    if (pageType == BNaviUI_NormalNavi) {
        NSLog(@"退出导航");
    }
    else if (pageType == BNaviUI_Declaration) {
        NSLog(@"退出导航声明页面");
    }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
    return NO;
}

- (BOOL)shouldAutorotate {
    return NO;
}

- (NSUInteger)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}

-(id)naviPresentedViewController {
    return self;
}

@end

