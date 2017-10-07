//
//  Test2ViewController.m
//  hsfire
//
//  Created by louislee on 2017/8/18.
//  Copyright © 2017年 hsdcw. All rights reserved.
//

#import "Test2ViewController.h"
#import "UserEntity.h"

#import "BNRoutePlanModel.h"
#import "BNCoreServices.h"
#import "BNaviModel.h"

#import "MapViewController.h"

@interface Test2ViewController ()<BNNaviUIManagerDelegate,BNNaviRoutePlanDelegate>

@end

@implementation Test2ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //适配ios7
    if(([[[UIDevice currentDevice] systemVersion] doubleValue]>=7.0)) {
        self.navigationController.navigationBar.translucent = NO;
    }
    
    [[UINavigationBar appearance] setBarTintColor:[UIColor whiteColor]];
    self.view.backgroundColor = [UIColor colorWithRed:240/255.0f green:240/255.0f blue:240/255.0f alpha:1];
    
    //NSLog(@"%@",self.userEntity.antitle);
    //NSLog(@"%@",self.userEntity.ansubtitle);
    
    //NSLog(@"起点 %@",self.userEntity.clon);
    //NSLog(@"起点 %@",self.userEntity.clat);
    
    //NSLog(@"终点 %@",self.userEntity.anlon);
    //NSLog(@"终点 %@",self.userEntity.anlat);
    
    UILabel* startNodeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 130, self.view.frame.size.width, 30)];
    startNodeLabel.backgroundColor = [UIColor clearColor];
    startNodeLabel.text = @"起点：我的位置";
    startNodeLabel.textAlignment = NSTextAlignmentCenter;
    startNodeLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    [self.view addSubview:startNodeLabel];
    
    NSString* str1 = @"终点：";
    UILabel* endNodeLabel = [[UILabel alloc] initWithFrame:CGRectMake(startNodeLabel.frame.origin.x, startNodeLabel.frame.origin.y+startNodeLabel.frame.size.height, self.view.frame.size.width, startNodeLabel.frame.size.height)];
    endNodeLabel.backgroundColor = [UIColor clearColor];
    endNodeLabel.text = [str1 stringByAppendingString:self.userEntity.ansubtitle];
    endNodeLabel.textAlignment = NSTextAlignmentCenter;
    endNodeLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    endNodeLabel.numberOfLines = 0;
    [endNodeLabel sizeToFit];
    [self.view addSubview:endNodeLabel];
    
    CGSize buttonSize = {240,40};
    CGRect buttonFrame = {(self.view.frame.size.width-buttonSize.width)/2,40+endNodeLabel.frame.size.height+endNodeLabel.frame.origin.y,buttonSize.width,buttonSize.height};
    UIButton* realNaviButton = [self createButton:@"开始导航" target:@selector(realNavi:) frame:buttonFrame];
    [self.view addSubview:realNaviButton];
    
    //设置白天黑夜模式
    //[BNCoreServices_Strategy setDayNightType:BNDayNight_CFG_Type_Auto];
    //设置停车场
    //[BNCoreServices_Strategy setParkInfo:YES];
    
    CLLocationCoordinate2D wgs84llCoordinate;
    //assign your coordinate here...
    
    CLLocationCoordinate2D bd09McCoordinate;
    //the coordinate in bd09MC standard, which can be used to show poi on baidu map
    bd09McCoordinate = [BNCoreServices_Instance convertToBD09MCWithWGS84ll: wgs84llCoordinate];
    
    [self setupNav];
}

- (BOOL)checkServicesInited
{
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

- (UIButton*)createButton:(NSString*)title target:(SEL)selector frame:(CGRect)frame {
    UIButton* button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    button.frame = frame;
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7) {
        [button setBackgroundColor:[UIColor whiteColor]];
    }else
    {
        [button setBackgroundColor:[UIColor clearColor]];
    }
    [button addTarget:self action:selector forControlEvents:UIControlEventTouchUpInside];
    return button;
}

-(void)backBtnClick {
//    CATransition* transition = [CATransition animation];
//    transition.type = kCATransitionPush;//可更改为其他方式
//    transition.subtype = kCATransitionFromLeft;//可更改为其他方式
//    [self.navigationController.view.layer addAnimation:transition forKey:kCATransition];
//
//    MapViewController *mapv = [[MapViewController alloc]init];
//    [self.navigationController pushViewController:mapv animated:NO];
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)setupNav {
    self.title = @"开始导航";
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
