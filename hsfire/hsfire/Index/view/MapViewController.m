//
//  MapViewController.m
//  hsfire
//
//  Created by louislee on 2017/8/12.
//  Copyright © 2017年 hsdcw. All rights reserved.
//

#import "MapViewController.h"
#import "JYJSliderMenuTool.h"
#import "Macro.h"

@interface MapViewController ()<UIGestureRecognizerDelegate>
/** tapGestureRec */
@property (nonatomic, weak) UITapGestureRecognizer *tapGestureRec;
/** panGestureRec */
@property (nonatomic, strong) UIPanGestureRecognizer *panGestureRec;

@end

@implementation MapViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [_mapView viewWillAppear];
    _mapView.delegate = self; // 此处记得不用的时候需要置nil，否则影响内存的释放
    _locService.delegate = self;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [_mapView viewWillDisappear];
    _mapView.delegate = nil; // 不用时，置nil
    _locService.delegate = nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //适配ios7
    if(([[[UIDevice currentDevice] systemVersion] doubleValue]>=7.0)) {
        self.navigationController.navigationBar.translucent = NO;
    }
    
    _mapView = [[BMKMapView alloc]initWithFrame:CGRectMake(0, 0, kWidth, kHeight - 64)];
    _mapView.showsUserLocation = YES; //是否显示定位图层
    _mapView.zoomLevel = 17; //地图显示比例
    
    _geocodesearch = [[BMKGeoCodeSearch alloc] init];
    _geocodesearch.delegate = self;
    
    [self startLocation];
    
    self.view = _mapView;
    
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
    //    [scrollView.panGestureRecognizer requireGestureRecognizerToFail:leftEdgeGesture];
    
    //加载底部按钮组
    [self loadbtns];
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

- (void)msgClick {
    UIViewController *vc = [[UIViewController alloc] init];
    vc.view.backgroundColor = [UIColor greenColor];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)profileCenter {
    // 展示个人中心
    [JYJSliderMenuTool showWithRootViewController:self];
}

- (void)setupNav {
    self.title = @"摩 拜 单 车";
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:20], NSForegroundColorAttributeName:[UIColor colorWithRed:222 / 255.0 green:91 / 255.0 blue:78 / 255.0 alpha:1.0]}];
    
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    negativeSpacer.width = -15;
    
    UIButton *profileButton = [[UIButton alloc] init];
    // 设置按钮的背景图片
    [profileButton setImage:[UIImage imageNamed:@"navigationbar_list_normal"] forState:UIControlStateNormal];
    [profileButton setImage:[UIImage imageNamed:@"navigationbar_list_hl"] forState:UIControlStateHighlighted];
    // 设置按钮的尺寸为背景图片的尺寸
    profileButton.frame = CGRectMake(0, 0, 44, 44);
    //监听按钮的点击
    [profileButton addTarget:self action:@selector(profileCenter) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *profile = [[UIBarButtonItem alloc] initWithCustomView:profileButton];
    self.navigationItem.leftBarButtonItems = @[negativeSpacer, profile];
    
    // 右边按钮
    UIButton *searchButton = [[UIButton alloc] init];
    [searchButton setImage:[UIImage imageNamed:@"search"] forState:UIControlStateNormal];
    [searchButton setImage:[UIImage imageNamed:@"search_down"] forState:UIControlStateHighlighted];
    searchButton.frame = CGRectMake(0, 0, 44, 44);
    [searchButton addTarget:self action:@selector(msgClick) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *msgButton = [[UIButton alloc] init];
    [msgButton setImage:[UIImage imageNamed:@"notification"] forState:UIControlStateNormal];
    [msgButton setImage:[UIImage imageNamed:@"notification_down"] forState:UIControlStateHighlighted];
    msgButton.frame = CGRectMake(40, 0, 44, 44);
    [msgButton addTarget:self action:@selector(msgClick) forControlEvents:UIControlEventTouchUpInside];
    
    UIView *rightView = [[UIView alloc] init];
    rightView.frame = CGRectMake(0, 0, 88, 44);
    [rightView addSubview:searchButton];
    [rightView addSubview:msgButton];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:rightView];
    self.navigationItem.rightBarButtonItems = @[negativeSpacer, rightItem];
}

//底部按钮组
-(void)loadbtns {
    //按钮组
    CGFloat btn_w = 70;
    CGFloat btn_h = 30;
    int maph = 35;
    
    UIView *view = [[UIView alloc]init];
    view.frame = CGRectMake(5, kHeight - maph, kWidth - 10, btn_h);
    view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:view];
    
    UIButton *btn1 = [UIButton buttonWithType:UIButtonTypeCustom];
    btn1.frame = CGRectMake(5, kHeight - maph, btn_w, btn_h);
    btn1.tag = 0;
    btn1.titleLabel.font = [UIFont systemFontOfSize:14.0];
    [btn1 setTitle:@"消防栓" forState:UIControlStateNormal];
    [btn1 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btn1 addTarget:self action:@selector(buttonTap:) forControlEvents:UIControlEventTouchUpInside];
    [btn1 setImage:[UIImage imageNamed:@"pass"] forState:UIControlStateNormal];
    [self.view addSubview:btn1];
    
    UIButton *btn2 = [UIButton buttonWithType:UIButtonTypeCustom];
    btn2.frame = CGRectMake(btn_w + 5, kHeight - maph, btn_w + 10, btn_h);
    btn2.tag = 1;
    btn2.titleLabel.font = [UIFont systemFontOfSize:14.0];
    [btn2 setTitle:@"天然水源" forState:UIControlStateNormal];
    [btn2 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btn2 addTarget:self action:@selector(buttonTap:) forControlEvents:UIControlEventTouchUpInside];
    [btn2 setImage:[UIImage imageNamed:@"pass"] forState:UIControlStateNormal];
    [self.view addSubview:btn2];
    
    UIButton *btn3 = [UIButton buttonWithType:UIButtonTypeCustom];
    btn3.frame = CGRectMake(btn_w * 2 + 20, kHeight - maph, btn_w + 10, btn_h);
    btn3.tag = 2;
    btn3.titleLabel.font = [UIFont systemFontOfSize:14.0];
    [btn3 setTitle:@"重点单位" forState:UIControlStateNormal];
    [btn3 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btn3 addTarget:self action:@selector(buttonTap:) forControlEvents:UIControlEventTouchUpInside];
    [btn3 setImage:[UIImage imageNamed:@"pass"] forState:UIControlStateNormal];
    [self.view addSubview:btn3];
    
    UIButton *btn4 = [UIButton buttonWithType:UIButtonTypeCustom];
    btn4.frame = CGRectMake(btn_w * 3 + 25, kHeight - maph, btn_w + 10, btn_h);
    btn4.tag = 3;
    btn4.titleLabel.font = [UIFont systemFontOfSize:14.0];
    [btn4 setTitle:@"微型站" forState:UIControlStateNormal];
    [btn4 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btn4 addTarget:self action:@selector(buttonTap:) forControlEvents:UIControlEventTouchUpInside];
    [btn4 setImage:[UIImage imageNamed:@"pass"] forState:UIControlStateNormal];
    [self.view addSubview:btn4];
}

#pragma mark -- Selector
- (void)buttonTap:(UIButton *)button {
    if (button.tag == 0) {
        NSLog(@"分享");
    }
    
    if (button.tag == 1) {
        NSLog(@"消息");
    }
    
    if (button.tag == 2) {
        NSLog(@"左");
    }
    
    if (button.tag == 3) {
        NSLog(@"右");
    }
}

//加载地图
- (void)startLocation {
    //初始化BMKLocationService
    _locService = [[BMKLocationService alloc]init];
    _locService.delegate = self;
    //启动LocationService
    [_locService startUserLocationService];
}

//实现相关delegate 处理位置信息更新
//处理方向变更信息
- (void)didUpdateUserHeading:(BMKUserLocation *)userLocation {
    NSLog(@"heading is %@",userLocation.heading);
}

//处理位置坐标更新
- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation {
    NSLog(@"didUpdateUserLocation lat %f,long %f",userLocation.location.coordinate.latitude,userLocation.location.coordinate.longitude);
    
    [_mapView updateLocationData:userLocation]; //更新地图上的位置
    _mapView.centerCoordinate = userLocation.location.coordinate; //更新当前位置到地图中间
    
    //地理反编码
    BMKReverseGeoCodeOption *reverseGeocodeSearchOption = [[BMKReverseGeoCodeOption alloc]init];
    reverseGeocodeSearchOption.reverseGeoPoint = userLocation.location.coordinate;
    BOOL flag = [_geocodesearch reverseGeoCode:reverseGeocodeSearchOption];
    if(flag) {
        NSLog(@"反geo检索发送成功");
        [_locService stopUserLocationService];
    }
    else {
        NSLog(@"反geo检索发送失败");
    }
}

#pragma mark -------------地理反编码的delegate---------------
-(void)onGetReverseGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKReverseGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error {
    
    NSLog(@"address:%@----%@",result.addressDetail,result.address);
    
    //addressDetail:     层次化地址信息
    //address:    地址名称
    //businessCircle:  商圈名称
    //location:  地址坐标
    //poiList:   地址周边POI信息，成员类型为BMKPoiInfo
}

//定位失败
- (void)didFailToLocateUserWithError:(NSError *)error{
    NSLog(@"error:%@",error);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
