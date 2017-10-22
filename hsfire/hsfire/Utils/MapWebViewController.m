//
//  WKWebviewController.m
//  KaizeOCR
//
//  Created by YYKit on 2017/6/16.
//  Copyright © 2017年 zl. All rights reserved.
//  首页的WKWebview，用于显示公司主页

#import <WebKit/WebKit.h>
#import "MapWebViewController.h"
#import "Test2ViewController.h"
#import "MapFivViewController.h"

#import "BNRoutePlanModel.h"
#import "BNCoreServices.h"
#import "BNaviModel.h"

#define WIDTH [UIScreen mainScreen].bounds.size.width
#define HEIGHT [UIScreen mainScreen].bounds.size.height
@interface MapWebViewController ()<WKUIDelegate,WKNavigationDelegate>

@property (nonatomic,strong) WKWebView *wkWebview;
@property (nonatomic,strong) UIProgressView *progress;
@property (nonatomic,strong) UIBarButtonItem *leftBarButton;
@property (nonatomic,strong) UIBarButtonItem *leftBarButtonSecond;
@property (nonatomic,strong)  UIBarButtonItem *negativeSpacer;
@property (nonatomic,strong)  UIBarButtonItem *negativeSpacer2;

@end

@implementation MapWebViewController

#pragma mark --- wk
- (WKWebView *)wkWebview {
    if (_wkWebview == nil) {
        _wkWebview = [[WKWebView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT)];
        _wkWebview.UIDelegate = self;
        _wkWebview.navigationDelegate = self;
        _wkWebview.backgroundColor = [UIColor clearColor];
        _wkWebview.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _wkWebview.multipleTouchEnabled = YES;
        _wkWebview.autoresizesSubviews = YES;
        _wkWebview.scrollView.alwaysBounceVertical = YES;
        _wkWebview.allowsBackForwardNavigationGestures = YES; /**这一步是，开启侧滑返回上一历史界面**/
        [self.view addSubview:_wkWebview];
    }
    return _wkWebview;
}

#pragma mark 加载进度条
- (UIProgressView *)progress {
    if (_progress == nil) {
        _progress = [[UIProgressView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, 4)];
        _progress.tintColor = [UIColor redColor];
        _progress.backgroundColor = [UIColor grayColor];
        [self.view addSubview:_progress];
    }
    return _progress;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self LoadRequest];
    [self addObserver];
    [self setBarButtonItem];
}

#pragma mark 加载网页
- (void)LoadRequest {
    //TODO:加载
    [self.wkWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.urlString]]];
    //[self.wkWebview loadHTMLString:self.urlString baseURL:[NSURL URLWithString:self.urlString]];
}

#pragma mark 添加KVO观察者
- (void)addObserver {
    //TODO:kvo监听，获得页面title和加载进度值，以及是否可以返回
    [self.wkWebview addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:NULL];
    [self.wkWebview addObserver:self forKeyPath:@"canGoBack" options:NSKeyValueObservingOptionNew context:NULL];
    [self.wkWebview addObserver:self forKeyPath:@"title" options:NSKeyValueObservingOptionNew context:NULL];
}

#pragma mark 设置BarButtonItem
- (void)setBarButtonItem {
    //设置距离左边屏幕的宽度距离
    self.leftBarButton = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"backarr"] style:UIBarButtonItemStylePlain target:self action:@selector(selectedToBack)];
    [self.leftBarButton setTintColor:[UIColor whiteColor]];
    self.negativeSpacer = [[UIBarButtonItem alloc]   initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace   target:nil action:nil];
    self.negativeSpacer.width = -5;
    
    //设置关闭按钮，以及关闭按钮和返回按钮之间的距离
    self.leftBarButtonSecond = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"close_item"] style:UIBarButtonItemStylePlain target:self action:@selector(selectedToClose)];
    [self.leftBarButtonSecond setTintColor:[UIColor whiteColor]];
    self.leftBarButtonSecond.imageInsets = UIEdgeInsetsMake(0, -20, 0, 20);
    self.navigationItem.leftBarButtonItems = @[self.negativeSpacer,self.leftBarButton];
    
    //设置刷新按妞
//    UIBarButtonItem *reloadItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"reload_item"] style:UIBarButtonItemStylePlain target:self action:@selector(selectedToReloadData)];
//    self.navigationItem.rightBarButtonItem = reloadItem;
//    [self.navigationItem.rightBarButtonItem setTintColor:[UIColor whiteColor]];
    
    UIBarButtonItem *saveBtn = [[UIBarButtonItem alloc]initWithTitle:@"导航" style:UIBarButtonItemStylePlain target:self action:@selector(realNavi:)];
    [saveBtn setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:15],NSFontAttributeName,nil] forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem = saveBtn;
    self.navigationItem.rightBarButtonItem.tintColor = [UIColor whiteColor];
}

-(void)navi {
    //建立临时变量传值
    UserEntity *ue = self.userEntity;
    //NSLog(@"%@",ue.antitle);
    
    Test2ViewController *navi = [[Test2ViewController alloc]init];
    [self.navigationController pushViewController:navi animated:YES];
    navi.userEntity = ue;
}

#pragma mark 关闭并上一界面
- (void)selectedToClose {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark 返回上一个网页还是上一个Controller
- (void)selectedToBack
{
    if (self.wkWebview.canGoBack == 1)
    {
        [self.wkWebview goBack];
    }
    else
    {
        [self.navigationController popViewControllerAnimated:YES];
        
//        CATransition* transition = [CATransition animation];
//        transition.type = kCATransitionPush;//可更改为其他方式
//        transition.subtype = kCATransitionFromLeft;//可更改为其他方式
//        [self.navigationController.view.layer addAnimation:transition forKey:kCATransition];
//
//        //NSLog(@"%@",self.userEntity.dwtype);
//        NSString *dwtype = self.userEntity.dwtype;
//        if([dwtype isEqualToString:@"jyview"]) {
//            MapFivViewController *mapv = [[MapFivViewController alloc]init];
//            [self.navigationController pushViewController:mapv animated:NO];
//        }
////        else {
////            [self.navigationController popViewControllerAnimated:YES];
////        }
        
    }
}

#pragma mark reload
- (void)selectedToReloadData
{
    [self.wkWebview reload];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor colorWithRed:245/255.0f green:245/255.0f blue:245/255.0f alpha:1];
    
    //设置导航栏标题颜色、字体大小
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:18], NSForegroundColorAttributeName:[UIColor colorWithRed:255 / 255.0 green:255 / 255.0 blue:255 / 255.0 alpha:1.0]}];
    
    CLLocationCoordinate2D wgs84llCoordinate;
    //assign your coordinate here...
    
    CLLocationCoordinate2D bd09McCoordinate;
    //the coordinate in bd09MC standard, which can be used to show poi on baidu map
    bd09McCoordinate = [BNCoreServices_Instance convertToBD09MCWithWGS84ll: wgs84llCoordinate];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark KVO的监听代理
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    
    //加载进度值
    if ([keyPath isEqualToString:@"estimatedProgress"])
    {
        if (object == self.wkWebview)
        {
            [self.progress setAlpha:1.0f];
            [self.progress setProgress:self.wkWebview.estimatedProgress animated:YES];
            if(self.wkWebview.estimatedProgress >= 1.0f)
            {
                [UIView animateWithDuration:1.5f
                                      delay:0.0f
                                    options:UIViewAnimationOptionCurveEaseOut
                                 animations:^{
                                     [self.progress setAlpha:0.0f];
                                 }
                                 completion:^(BOOL finished) {
                                     [self.progress setProgress:0.0f animated:NO];
                                 }];
            }
        }
        else
        {
            [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
        }
    }
    //网页title
    else if ([keyPath isEqualToString:@"title"])
    {
        if (object == self.wkWebview)
        {
            self.navigationItem.title = self.wkWebview.title;
        }
        else
        {
            [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
        }
    }
    //是否可以返回
    else if ([keyPath isEqualToString:@"canGoBack"])
    {
        if (object == self.wkWebview)
        {
            if (self.wkWebview.canGoBack == 1)
            {
                self.navigationItem.leftBarButtonItems = @[self.negativeSpacer,self.leftBarButton,self.leftBarButtonSecond];
            }
            else
            {
                self.navigationItem.leftBarButtonItems = @[self.negativeSpacer,self.leftBarButton];
            }
        }
        else
        {
            [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
        }
    }
    else
    {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

#pragma mark 在这里处理短暂性的加载错误
/*
 *-1009 没有网络连接
 *-1003
 *-999
 *101
 */
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error {
    NSLog(@"ErrorCode:%ld",(long)error.code);
    if (error.code == -1099) {
    }
}

#pragma mark 添加返回键和关闭按钮
- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}

#pragma mark 移除观察者
- (void)dealloc {
    [self.wkWebview removeObserver:self forKeyPath:@"estimatedProgress"];
    [self.wkWebview removeObserver:self forKeyPath:@"canGoBack"];
    [self.wkWebview removeObserver:self forKeyPath:@"title"];
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
