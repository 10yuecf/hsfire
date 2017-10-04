//
//  MapViewController.m
//  hsfire
//
//  Created by louislee on 2017/8/12.
//  Copyright © 2017年 hsdcw. All rights reserved.
//  应急救援

#import <BaiduMapAPI_Map/BMKMapView.h>
#import <BaiduMapAPI_Map/BMKMapComponent.h>
#import <BaiduMapAPI_Location/BMKLocationComponent.h>
#import <BaiduMapAPI_Search/BMKSearchComponent.h>//引入检索功能所有的头文件
#import <BaiduMapAPI_Search/BMKPoiSearch.h>
#import <BaiduMapAPI_Search/BMKRouteSearch.h>
#import <BaiduMapAPI_Utils/BMKUtilsComponent.h>

#import "MapFivViewController.h"
#import "JYJSliderMenuTool.h"
#import "Macro.h"
#import "MyAnimatedAnnotationView.h"
//#import "AddSyViewController.h"
#import "UserEntity.h"

@interface MapFivViewController ()<UIGestureRecognizerDelegate,BMKMapViewDelegate,BMKLocationServiceDelegate,BMKGeoCodeSearchDelegate,UITextFieldDelegate,BMKPoiSearchDelegate,BMKRouteSearchDelegate>

/** tapGestureRec */
@property (nonatomic, weak) UITapGestureRecognizer *tapGestureRec;
/** panGestureRec */
@property (nonatomic, strong) UIPanGestureRecognizer *panGestureRec;

@property (nonatomic, strong) BMKMapView *mapView;
@property (nonatomic, strong) BMKLocationService *locService;
@property (nonatomic, strong) BMKGeoCodeSearch *geoCodeSearch;
@property (nonatomic, strong) BMKAnnotationView *mapAnnoView;
@property (nonatomic, strong) BMKPointAnnotation *pointAnnotation;
@property (nonatomic, strong) BMKPointAnnotation *pointAnnotation2;
@property (nonatomic, strong) BMKPoiSearch *poiSearch;
@property (nonatomic, strong) BMKRouteSearch *routeSearch;

@property (nonatomic,strong) UIView *locationView;
@property (nonatomic,strong) UIImageView *locImageView;
@property (nonatomic,strong) UIView *messageView;
@property (nonatomic,strong) UILabel *addressLabel;
@property (nonatomic,strong) NSString *lat;
@property (nonatomic,strong) NSString *lon;
@property (nonatomic,strong) UIButton *sureButton;
@property (nonatomic,strong) BMKGeoCodeSearch *searchAddress;
@property (nonatomic,strong) NSString *name;
@property (nonatomic,assign) CLLocationCoordinate2D location2D;
@property (nonatomic,strong) NSString *btnflag;

@end

@implementation MapFivViewController

- (void)viewWillAppear:(BOOL)animated {
    [_mapView viewWillAppear];
    _mapView.delegate = self;
    _locService.delegate = self;
    _geoCodeSearch.delegate = self;
    _routeSearch.delegate = self;
    _searchAddress.delegate = self;
}

- (void)viewWillDisappear:(BOOL)animated {
    [_mapView viewWillDisappear];
    _mapView.delegate = nil;
    _locService.delegate = nil;
    _geoCodeSearch.delegate = nil;
    _routeSearch.delegate = nil;
    _searchAddress = nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //适配ios7
    if(([[[UIDevice currentDevice] systemVersion] doubleValue]>=7.0)) {
        self.navigationController.navigationBar.translucent = NO;
    }
    
    NSLog(@"================%@",self.userEntity.userId);
    
    _locService = [[BMKLocationService alloc]init];
    _geoCodeSearch = [[BMKGeoCodeSearch alloc] init];
    _mapAnnoView = [[BMKAnnotationView alloc] init];
    _searchAddress = [[BMKGeoCodeSearch alloc] init];
    
    _mapView = [[BMKMapView alloc]initWithFrame:CGRectMake(0, 0, kWidth, kHeight)];
    _mapView.showsUserLocation = YES; //是否显示定位图层
    _mapView.zoomLevel = 17; //地图显示比例
    [self startLocation];
    [self.view addSubview:_mapView];
    
    [self setupNav];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    // 这个方法是为了，不让隐藏状态栏的时候出现view上移
    self.extendedLayoutIncludesOpaqueBars = YES;
    self.view.backgroundColor = [UIColor whiteColor];
    
    // 屏幕边缘pan手势(优先级高于其他手势)
//    UIScreenEdgePanGestureRecognizer *leftEdgeGesture = [[UIScreenEdgePanGestureRecognizer alloc] initWithTarget:self
//                                                                                                          action:@selector(moveViewWithGesture:)];
//    leftEdgeGesture.edges = UIRectEdgeLeft;// 屏幕左侧边缘响应
//    [self.view addGestureRecognizer:leftEdgeGesture];
//    // 这里是地图处理方式，遵守代理协议，实现代理方法
//    leftEdgeGesture.delegate = self;
    
    // 如果是scrollView的话，下面这行代码就可以了不用遵守代理协议，实现代理方法
    // [scrollView.panGestureRecognizer requireGestureRecognizerToFail:leftEdgeGesture];
    
    [self loadmapbtns];
    
    //加载底部按钮组
    [self loadbtns];
}

//- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldBeRequiredToFailByGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
//    BOOL result = NO;
//    if ([gestureRecognizer isKindOfClass:[UIScreenEdgePanGestureRecognizer class]]) {
//        result = YES;
//    }
//    return result;
//}
//
//- (void)moveViewWithGesture:(UIPanGestureRecognizer *)panGes {
//    if (panGes.state == UIGestureRecognizerStateEnded) {
//        [self profileCenter];
//    }
//}

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
    self.title = @"应急救援";
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
    
    //搜索按钮
    UIButton *searchButton = [[UIButton alloc] init];
    [searchButton setImage:[UIImage imageNamed:@"search"] forState:UIControlStateNormal];
    [searchButton setImage:[UIImage imageNamed:@"search_down"] forState:UIControlStateHighlighted];
    searchButton.frame = CGRectMake(0, 0, 44, 44);
    [searchButton addTarget:self action:@selector(msgClick) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *msgButton = [[UIButton alloc] init];
    [msgButton setImage:[UIImage imageNamed:@"mymsg"] forState:UIControlStateNormal];
    msgButton.frame = CGRectMake(40, 0, 44, 44);
    [msgButton addTarget:self action:@selector(msgClick) forControlEvents:UIControlEventTouchUpInside];
    
    UIView *rightView = [[UIView alloc] init];
    rightView.frame = CGRectMake(0, 0, 88, 44);
    [rightView addSubview:msgButton];
    [rightView addSubview:searchButton];
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:rightView];
    self.navigationItem.rightBarButtonItems = @[negativeSpacer, rightItem];
}

-(void)backBtnClick {
    [self.navigationController popViewControllerAnimated:YES];
}

//地图组件按钮组
-(void)loadmapbtns {
    //定位按钮
    UIButton *dwbtn = [UIButton buttonWithType:UIButtonTypeCustom];
    dwbtn.frame = CGRectMake(5, kHeight - 70, 30, 30);
    dwbtn.layer.cornerRadius = 3.0;
    [dwbtn setBackgroundColor:[UIColor whiteColor]];
    [dwbtn addTarget:self action:@selector(dwbtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [dwbtn setImage:[UIImage imageNamed:@"pos"] forState:UIControlStateNormal];
    [self.view addSubview:dwbtn];
    
    //放大按钮
    UIButton *fdbtn = [UIButton buttonWithType:UIButtonTypeCustom];
    fdbtn.frame = CGRectMake(kWidth - 35, kHeight - 105, 30, 30);
    fdbtn.layer.cornerRadius = 3.0;
    [fdbtn setBackgroundColor:[UIColor whiteColor]];
    [fdbtn addTarget:self action:@selector(fdbtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [fdbtn setImage:[UIImage imageNamed:@"plus"] forState:UIControlStateNormal];
    [self.view addSubview:fdbtn];
    
    //缩小按钮
    UIButton *sxbtn = [UIButton buttonWithType:UIButtonTypeCustom];
    sxbtn.frame = CGRectMake(kWidth - 35, kHeight - 70, 30, 30);
    sxbtn.layer.cornerRadius = 3.0;
    [sxbtn setBackgroundColor:[UIColor whiteColor]];
    [sxbtn addTarget:self action:@selector(sxbtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [sxbtn setImage:[UIImage imageNamed:@"min"] forState:UIControlStateNormal];
    [self.view addSubview:sxbtn];
}

//加载地图
- (void)startLocation {
    //初始化BMKLocationService
    _locService = [[BMKLocationService alloc]init];
    _locService.delegate = self;
    //启动LocationService
    [_locService startUserLocationService];
}

//地图定位
-(void)dwbtnClick:(UIButton *)button {
    //初始化BMKLocationService
    _locService = [[BMKLocationService alloc]init];
    _locService.delegate = self;
    
    _mapView.zoomLevel = 17;
    _mapView.showsUserLocation = YES;//是否显示小蓝点，no不显示，我们下面要自定义的
    _mapView.userTrackingMode = BMKUserTrackingModeNone;
    
    _btnflag = @"dwbtn";
    
    //定位,启动LocationService
    [_locService startUserLocationService];
}

//放大
-(void)fdbtnClick:(UIButton *)button {
    [_mapView setZoomLevel:_mapView.zoomLevel + 1];
}

//缩小
-(void)sxbtnClick:(UIButton *)button {
    [_mapView setZoomLevel:_mapView.zoomLevel - 1];
}

//底部按钮组
-(void)loadbtns {
    //按钮组
    CGFloat btn_w = 100;
    CGFloat btn_h = 30;
    int maph = 35;
    
    UIView *view = [[UIView alloc]init];
    view.frame = CGRectMake(5, kHeight - maph, kWidth - 10, btn_h);
    view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:view];
    
    UIButton *btn1 = [UIButton buttonWithType:UIButtonTypeCustom];
    btn1.frame = CGRectMake(0, kHeight - maph, btn_w, btn_h);
    btn1.tag = 1;
    btn1.titleLabel.font = [UIFont systemFontOfSize:14.0];
    [btn1 setTitle:@"救援队伍" forState:UIControlStateNormal];
    [btn1 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btn1 addTarget:self action:@selector(buttonTap:) forControlEvents:UIControlEventTouchUpInside];
    [btn1 setImage:[UIImage imageNamed:@"jy1"] forState:UIControlStateNormal];
    [self.view addSubview:btn1];
    
    UIButton *btn2 = [UIButton buttonWithType:UIButtonTypeCustom];
    btn2.frame = CGRectMake(btn_w, kHeight - maph, btn_w + 10, btn_h);
    btn2.tag = 2;
    btn2.titleLabel.font = [UIFont systemFontOfSize:14.0];
    [btn2 setTitle:@"特种车辆" forState:UIControlStateNormal];
    [btn2 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btn2 addTarget:self action:@selector(buttonTap:) forControlEvents:UIControlEventTouchUpInside];
    [btn2 setImage:[UIImage imageNamed:@"jy2"] forState:UIControlStateNormal];
    [self.view addSubview:btn2];
    
    UIButton *btn3 = [UIButton buttonWithType:UIButtonTypeCustom];
    btn3.frame = CGRectMake(btn_w * 2 + 10, kHeight - maph, btn_w + 10, btn_h);
    btn3.tag = 3;
    btn3.titleLabel.font = [UIFont systemFontOfSize:14.0];
    [btn3 setTitle:@"应急物资" forState:UIControlStateNormal];
    [btn3 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btn3 addTarget:self action:@selector(addsy:) forControlEvents:UIControlEventTouchUpInside];
    [btn3 setImage:[UIImage imageNamed:@"jy3"] forState:UIControlStateNormal];
    [self.view addSubview:btn3];
}

#pragma mark -- Selector
- (void)buttonTap:(UIButton *)button {
    if (button.tag == 0) {
        NSLog(@"显示消防栓");
    }
    
    if (button.tag == 1) {
        NSLog(@"天然水源");
    }
    
    if (button.tag == 3) {
        NSLog(@"刷新获取最新水源信息");
    }
}

//这里是创建中心显示的图片和显示详细地址的View
-(void)createLocationSignImage {
    //LocationView定位在当前位置，换算为屏幕的坐标，创建的定位的图标
    self.locationView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 28, 35)];
    self.locImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 28, 35)];
    self.locImageView.image = [UIImage imageNamed:@"xfs"];
    
    //messageView 展示定位信息的View和Label和button
    self.messageView = [[UIView alloc]init];
    self.messageView.backgroundColor = [UIColor whiteColor];
    
    //把当前定位的经纬度换算为了View上的坐标
    CGPoint point = [self.mapView convertCoordinate:_mapView.centerCoordinate toPointToView:_mapView];
    //NSLog(@"Point------%f-----%f",point.x,point.y);
    
    //重新定位了LocationView
    self.locationView.center = point;
    [self.locationView setFrame:CGRectMake(point.x-14, point.y-18, 28, 35)];
    
    //重新定位了messageView
    [self.messageView setFrame:CGRectMake(30, point.y-40-20, kWidth-60, 40)];
    
    //展示地址信息的label
    self.addressLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, self.messageView.frame.size.width - 80, 40)];
    
    self.addressLabel.font = [UIFont systemFontOfSize:12.0f];
    self.addressLabel.text = @"拖动地图，停止后可显示当前位置";
    self.addressLabel.numberOfLines = 0;
    
    //把地址信息传递到上个界面的button
    self.sureButton = [[UIButton alloc]initWithFrame:CGRectMake(self.addressLabel.frame.origin.x + self.addressLabel.frame.size.width, 0,self.messageView.frame.size.width - self.addressLabel.frame.origin.x - self.addressLabel.frame.size.width, 40)];
    
    self.sureButton.backgroundColor = [UIColor redColor];
    [self.sureButton setTitle:@"确定" forState:UIControlStateNormal];
    self.sureButton.titleLabel.font = [UIFont systemFontOfSize:13.0f];
    [self.sureButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.sureButton addTarget:self action:@selector(sureButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.mapView addSubview:self.messageView];
    [self.mapView addSubview:self.locationView];
    [self.messageView addSubview:self.sureButton];
    [self.messageView addSubview:self.addressLabel];
    [self.locationView addSubview:self.locImageView];
}

//添加水源
- (void)addsy:(UIButton *)button {
    if(button.tag == 331) {
        //NSLog(@"取消");
        //NSog(@"====%ld",(long)button.tag);
        //初始化BMKLocationService
        _locService = [[BMKLocationService alloc]init];
        _locService.delegate = self;
        
        _mapView.zoomLevel = 17;
        _mapView.showsUserLocation = YES;//是否显示小蓝点，no不显示，我们下面要自定义的
        _mapView.userTrackingMode = BMKUserTrackingModeNone;
        
        _btnflag = @"addsybtn";
        
        //定位,启动LocationService
        [_locService startUserLocationService];
        
        [button setTitle:@"取消添加" forState:UIControlStateNormal];
        [button setTag:332];
    }
    else if(button.tag == 332) {
        //NSLog(@"====%ld",(long)button.tag);
        //NSLog(@"添加水源");
        [button setTitle:@"添加水源" forState:UIControlStateNormal];
        [button setTag:331];
        
        //关闭定位view
        [self.messageView removeFromSuperview];
        [self.locationView removeFromSuperview];
    }
}

- (void)mapView:(BMKMapView *)mapView regionDidChangeAnimated:(BOOL)animated {
    //NSLog(@"regionDidChangeAnimated");
    CGPoint touchPoint = self.locationView.center;
    CLLocationCoordinate2D touchMapCoordinate = [self.mapView convertPoint:touchPoint toCoordinateFromView:self.mapView];
    //这里touchMapCoordinate就是该点的经纬度了
    //NSLog(@"touching %f,%f",touchMapCoordinate.latitude,touchMapCoordinate.longitude);
    
    BMKReverseGeoCodeOption *option = [[BMKReverseGeoCodeOption alloc]init];
    option.reverseGeoPoint = touchMapCoordinate;
    BOOL flag = [_searchAddress reverseGeoCode:option];
    
    if (flag) {
        //_mapView.showsUserLocation = NO;//不显示自己的位置
    }
}

//根据经纬度返回点击的位置的名称
-(void)onGetReverseGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKReverseGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error {
    
    NSString * resultAddress = @"";
    NSString * houseName = @"";
    
    CLLocationCoordinate2D coor = result.location;
    
    if(result.poiList.count > 0){
        BMKPoiInfo * info = result.poiList[0];
        if([info.name rangeOfString:@"-"].location != NSNotFound){
            houseName = [info.name componentsSeparatedByString:@"-"][0];
        }
        else {
            houseName = info.name;
        }
        resultAddress = [NSString stringWithFormat:@"%@%@",result.address,info.name];
    }
    else {
        resultAddress =result.address;
    }
    
    if(resultAddress.length == 0){
        self.addressLabel.text = @"位置解析错误，请拖动重试！";
        return;
    }
    
    self.addressLabel.text = resultAddress;
    _lat = [NSString stringWithFormat:@"%lf",result.location.latitude];
    _lon = [NSString stringWithFormat:@"%lf",result.location.longitude];
    //self.longitudeLabel.text =
    
    NSLog(@"label的值==========%@",resultAddress);
    NSLog(@"经纬度的值==========%f %f",result.location.latitude,result.location.longitude);
    
    self.location2D = coor;
    self.name = houseName;
}

-(void)sureButtonClick:(UIButton *)button {
    //建立临时变量传值
    UserEntity *ue = [[UserEntity alloc]init];
    ue.title = self.addressLabel.text;
    ue.lat = self.lat;
    ue.lon = self.lon;
    
    //AddSyViewController *addsy = [[AddSyViewController alloc]init];
    //[self.navigationController pushViewController:addsy animated:YES];
    //addsy.userEntity = ue;
    
    //NSLog(@"this is sure btn click%@",self.addressLabel.text);
}

- (void)willStartLocatingUser {
    NSLog(@"start locate");
}

- (void)didStopLocatingUser {
    NSLog(@"stop locate");
}

- (void)didFailToLocateUserWithError:(NSError *)error {
    NSLog(@"location error");
}

-(void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation {
    //NSLog(@"didUpdateUserLocation lat %f,long %f",userLocation.location.coordinate.latitude,userLocation.location.coordinate.longitude);
    
    [_mapView updateLocationData:userLocation]; //更新地图上的位置
    _mapView.centerCoordinate = userLocation.location.coordinate; //更新当前位置到地图中间
    
    //地理反编码
    BMKReverseGeoCodeOption *reverseGeocodeSearchOption = [[BMKReverseGeoCodeOption alloc]init];
    reverseGeocodeSearchOption.reverseGeoPoint = userLocation.location.coordinate;
    BOOL flag = [_geoCodeSearch reverseGeoCode:reverseGeocodeSearchOption];
    if(flag) {
        NSLog(@"反geo检索发送成功");
        [_locService stopUserLocationService];
    }
    else {
        NSLog(@"反geo检索发送失败");
    }
    
    NSLog(@"点击了%@",_btnflag);
    
    if([_btnflag  isEqual: @"dwbtn"]) {
        //nothing to do...
    }
    else if([_btnflag  isEqual: @"addsybtn"]) {
        [self createLocationSignImage];
    }
}

- (void)didUpdateUserHeading:(BMKUserLocation *)userLocation {
    NSLog(@"heading is %@",userLocation.heading);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
