//
//  MapViewController.m
//  hsfire
//
//  Created by louislee on 2017/8/12.
//  Copyright © 2017年 hsdcw. All rights reserved.
//
//执勤力量
#import <BaiduMapAPI_Map/BMKMapView.h>
#import <BaiduMapAPI_Map/BMKMapComponent.h>
#import <BaiduMapAPI_Location/BMKLocationComponent.h>
#import <BaiduMapAPI_Search/BMKSearchComponent.h>//引入检索功能所有的头文件
#import <BaiduMapAPI_Search/BMKPoiSearch.h>
#import <BaiduMapAPI_Search/BMKRouteSearch.h>
#import <BaiduMapAPI_Utils/BMKUtilsComponent.h>

#import "MapSixViewController.h"
#import "JYJSliderMenuTool.h"
#import "Macro.h"
#import "MyAnimatedAnnotationView.h"
#import "SyAddViewController.h"
#import "UserEntity.h"
#import "CKHttpCommunicate.h"
#import "SyInfoViewController.h"
#import "User.h"
#import "BaseInfo.h"
#import "UserTool.h"
#import "MyWebViewController.h"
#import "LLWebViewController.h"
#import "hsdcwUtils.h"

#import "Test2ViewController.h"
#import "SyTestViewController.h"

@interface MapSixViewController ()<UIGestureRecognizerDelegate,BMKMapViewDelegate,BMKLocationServiceDelegate,BMKGeoCodeSearchDelegate,UITextFieldDelegate,BMKPoiSearchDelegate,BMKRouteSearchDelegate>

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
@property (nonatomic,strong) NSString *lng;
@property (nonatomic,strong) NSString *latc;
@property (nonatomic,strong) NSString *lngc;
@property (nonatomic,strong) NSString *latcnow;
@property (nonatomic,strong) NSString *lngcnow;

@property (nonatomic,strong) UIButton *sureButton;
@property (nonatomic,strong) BMKGeoCodeSearch *searchAddress;
@property (nonatomic,strong) NSString *name;
@property (nonatomic,assign) CLLocationCoordinate2D location2D;
@property (nonatomic,strong) NSString *btnflag;

@property (nonatomic,strong) NSString *sytype;
@property (nonatomic, strong) BMKPointAnnotation *pointXfs; //车辆
@property (nonatomic, strong) BMKPointAnnotation *pointSy; //装备
@property (nonatomic, strong) BMKPointAnnotation *pointWz; //器材
@property (nonatomic, strong) BMKPointAnnotation *pointMhq; //灭火器
@property (nonatomic, strong) BMKPointAnnotation *pointCt; //船艇
@end

@implementation MapSixViewController

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
    
    if([CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"打开[定位服务]来允许[黄石消防云]确定您的位置" message:@"请在系统设置中开启定位服务(设置>隐私>定位服务>开启)" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        UIAlertAction *setAction = [UIAlertAction actionWithTitle:@"打开定位" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            //打开定位设置
            NSURL *settinsURL = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
            //[[UIApplication sharedApplication] openURL:settinsURL];
            [[UIApplication sharedApplication] openURL:settinsURL options:@{} completionHandler:nil];// iOS 10 的跳转方式
        }];
        
        [alert addAction:cancelAction];
        [alert addAction:setAction];
        [self presentViewController:alert animated:YES completion:nil];
    }
    
    _sytype = @"1"; //政府、企业专(兼)职队伍
    
    //适配ios7
    if(([[[UIDevice currentDevice] systemVersion] doubleValue]>=7.0)) {
        self.navigationController.navigationBar.translucent = NO;
    }
    
    _locService = [[BMKLocationService alloc]init];
    _geoCodeSearch = [[BMKGeoCodeSearch alloc] init];
    _mapAnnoView = [[BMKAnnotationView alloc] init];
    _searchAddress = [[BMKGeoCodeSearch alloc] init];
    
    _mapView = [[BMKMapView alloc]initWithFrame:CGRectMake(0, 0, kWidth, kHeight)];
    _mapView.showsUserLocation = NO; //是否显示定位图层
    _mapView.zoomLevel = 17; //地图显示比例
    [self startLocation];
    [self.view addSubview:_mapView];
    
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
    // [scrollView.panGestureRecognizer requireGestureRecognizerToFail:leftEdgeGesture];
    
    [self loadmapbtns];
    
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
    self.title = @"执勤力量";
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:20], NSForegroundColorAttributeName:[UIColor colorWithRed:255 / 255.0 green:255 / 255.0 blue:255 / 255.0 alpha:1.0]}];
    
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
    _mapView.showsUserLocation = NO;//是否显示小蓝点，no不显示，我们下面要自定义的
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
    CGFloat btn_w = 150;
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
    [btn1 setTitle:@"政企专(兼)职队" forState:UIControlStateNormal];
    [btn1 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btn1 addTarget:self action:@selector(buttonTap:) forControlEvents:UIControlEventTouchUpInside];
    [btn1 setImage:[UIImage imageNamed:@"jy1"] forState:UIControlStateNormal];
    [self.view addSubview:btn1];
    
    UIButton *btn2 = [UIButton buttonWithType:UIButtonTypeCustom];
    btn2.frame = CGRectMake(btn_w, kHeight - maph, btn_w + 10, btn_h);
    btn2.tag = 2;
    btn2.titleLabel.font = [UIFont systemFontOfSize:14.0];
    [btn2 setTitle:@"训练计划上报" forState:UIControlStateNormal];
    [btn2 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btn2 addTarget:self action:@selector(buttonTap:) forControlEvents:UIControlEventTouchUpInside];
    [btn2 setImage:[UIImage imageNamed:@"zqbz2"] forState:UIControlStateNormal];
    [self.view addSubview:btn2];
}

#pragma mark -- Selector
- (void)buttonTap:(UIButton *)button {
    if (button.tag == 1) {
        NSLog(@"显示政府队");
        _sytype = @"1";
        [self.mapView removeAnnotations:self.mapView.annotations];
        [self loadData:_lngcnow Lat:_latcnow Sytype:@"1"];
    }
    
    if (button.tag == 2) {
        NSLog(@"训练计划上报");
        
        hsdcwUtils *utils = [[hsdcwUtils alloc]init];
        NSString *xf_dt = utils.myencrypt[0];
        NSString *xf_tk = utils.myencrypt[1];
        //NSLog(@"%@========%@",xf_dt, xf_tk);
        
        NSString *url = [NSString stringWithFormat:@"%@index.php/Home/Index/xljhsb/xf_dt/",URL_IMG];
        url = [url stringByAppendingString:xf_dt];
        url = [url stringByAppendingString:@"/xf_tk/"];
        url = [url stringByAppendingString:xf_tk];
        //NSLog(@"%@",url);
        
        LLWebViewController *webV = [LLWebViewController new];
        webV.urlStr = url;
        webV.isPullRefresh = YES;
        [self.navigationController pushViewController:webV animated:YES];
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
        _mapView.showsUserLocation = NO;//是否显示小蓝点，no不显示，我们下面要自定义的
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
        _mapView.showsUserLocation = NO;//不显示自己的位置
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
    
    CLLocationCoordinate2D centercoor = _mapView.centerCoordinate;
    _latcnow = [NSString stringWithFormat:@"%lf",centercoor.latitude];
    _lngcnow = [NSString stringWithFormat:@"%lf",centercoor.longitude];
    //NSLog(@"初始化中心点的经纬度=======%@ %@",_latc,_lngc);
    //NSLog(@"当前中心点的经纬度=======%@ %@",_latcnow,_lngcnow);
    
    float latcd = [_latc floatValue];
    float lngcd = [_lngc floatValue];
    
    float latcnowd = [_latcnow floatValue];
    float lngcnowd = [_lngcnow floatValue];
    
    BMKMapPoint point1 = BMKMapPointForCoordinate(CLLocationCoordinate2DMake(latcd,lngcd));
    BMKMapPoint point2 = BMKMapPointForCoordinate(CLLocationCoordinate2DMake(latcnowd,lngcnowd));
    CLLocationDistance distance = BMKMetersBetweenMapPoints(point1,point2);
    //NSLog(@"两点间的距离======%f",distance);
    
    //如果两点距离大于800米
    if(distance > 800) {
        //重新设置水源中心点坐标
        _latc = [NSString stringWithFormat:@"%lf",centercoor.latitude];
        _lngc = [NSString stringWithFormat:@"%lf",centercoor.longitude];
        
        [self.mapView removeAnnotations:self.mapView.annotations];
        
        //异步加载标注点
        [self loadData:_lngc Lat:_latc Sytype:_sytype];
    }
    
    self.addressLabel.text = resultAddress;
    self.location2D = coor;
    self.name = houseName;
}

-(void)sureButtonClick:(UIButton *)button {
    //建立临时变量传值
    UserEntity *ue = [[UserEntity alloc]init];
    ue.title = self.addressLabel.text;
    ue.lat = self.latcnow;
    ue.lon = self.lngcnow;
    
    SyAddViewController *addsy = [[SyAddViewController alloc]init];
    //SyTestViewController *addsy = [[SyTestViewController alloc]init];
    [self.navigationController pushViewController:addsy animated:YES];
    addsy.userEntity = ue;
    
    //NSLog(@"this is sure btn click%@",self.addressLabel.text);
}

- (void)willStartLocatingUser {
    //NSLog(@"start locate");
}

- (void)didStopLocatingUser {
    //NSLog(@"stop locate");
}

- (void)didFailToLocateUserWithError:(NSError *)error {
    NSLog(@"location error");
}

-(void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation {
    [_mapView updateLocationData:userLocation]; //更新地图上的位置
    _mapView.centerCoordinate = userLocation.location.coordinate; //更新当前位置到地图中间
    
    //获取初始化中心点坐标
    _latc = [NSString stringWithFormat:@"%lf",userLocation.location.coordinate.latitude];
    _lngc = [NSString stringWithFormat:@"%lf",userLocation.location.coordinate.longitude];
    
    //获取初始化中心点坐标,用于导航
    _lat = [NSString stringWithFormat:@"%lf",userLocation.location.coordinate.latitude];
    _lng = [NSString stringWithFormat:@"%lf",userLocation.location.coordinate.longitude];
    NSLog(@"当前位置坐标：%@ %@",_lat,_lng);
    
    //异步加载标注点
    [self loadData:_lngc Lat:_latc Sytype:_sytype];
    
    //地理反编码
    BMKReverseGeoCodeOption *reverseGeocodeSearchOption = [[BMKReverseGeoCodeOption alloc]init];
    reverseGeocodeSearchOption.reverseGeoPoint = userLocation.location.coordinate;
    BOOL flag = [_geoCodeSearch reverseGeoCode:reverseGeocodeSearchOption];
    if(flag) {
        //NSLog(@"反geo检索发送成功");
        [_locService stopUserLocationService];
    }
    else {
        NSLog(@"反geo检索发送失败");
    }
    
    if([_btnflag  isEqual: @"dwbtn"]) {
        //nothing to do...
    }
    else if([_btnflag  isEqual: @"addsybtn"]) {
        [self createLocationSignImage];
    }
}

- (BMKAnnotationView *)mapView:(BMKMapView *)mapView viewForAnnotation:(id <BMKAnnotation>)annotation {
    if (annotation == _pointXfs) {
        
        NSString *AnnotationViewID = @"zfdw1mark";
        BMKPinAnnotationView *annotationView = (BMKPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:AnnotationViewID];
        if (annotationView == nil) {
            annotationView = [[BMKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:AnnotationViewID];
            // 设置颜色
            annotationView.pinColor = BMKPinAnnotationColorPurple;
            // 从天上掉下效果
            annotationView.animatesDrop = YES;
            // 设置可拖拽
            annotationView.draggable = YES;
            // 把大头针换成别的图片
            annotationView.image = [UIImage imageNamed:@"jy1"];
        }
        return annotationView;
    }
    
    return nil;
}

//点击气泡
- (void)mapView:(BMKMapView *)mapView annotationViewForBubble:(BMKAnnotationView *)view {
    //NSLog(@"点击了气泡!");
    BMKPointAnnotation *tt = (BMKPointAnnotation*)view.annotation;
    //NSLog(@"%f",tt.coordinate.latitude);
    //NSLog(@"%f",tt.coordinate.longitude);
    //NSLog(@"%@",tt.title);
    //NSLog(@"%@",tt.subtitle);
    
    //建立临时变量传值
    UserEntity *ue = [[UserEntity alloc]init];
    ue.antitle = tt.title;
    ue.ansubtitle = tt.subtitle;
    ue.anlat = [NSString stringWithFormat:@"%lf",tt.coordinate.latitude]; //终点
    ue.anlon = [NSString stringWithFormat:@"%lf",tt.coordinate.longitude];
    ue.clat = _lat; //起点
    ue.clon = _lng;
    ue.viewName = @"zqll_view"; //救援视图
    
    //Test2ViewController *navi = [[Test2ViewController alloc]init];
    //[self.navigationController pushViewController:navi animated:YES];
    //navi.userEntity = ue;
    
    hsdcwUtils *utils = [[hsdcwUtils alloc]init];
    NSString *xf_dt = utils.myencrypt[0];
    NSString *xf_tk = utils.myencrypt[1];
    //NSLog(@"%@========%@",xf_dt, xf_tk);
    
    NSString *url = [NSString stringWithFormat:@"%@index.php/Home/Index/zqinfo/xf_dt/",URL_IMG];
    url = [url stringByAppendingString:xf_dt];
    url = [url stringByAppendingString:@"/xf_tk/"];
    url = [url stringByAppendingString:xf_tk];
    //NSLog(@"%@",url);
    
    MyWebViewController *webV = [MyWebViewController new];
    webV.urlStr = url;
    webV.isPullRefresh = YES;
    webV.userEntity = ue;
    [self.navigationController pushViewController:webV animated:YES];
    
//    CHWebViewController *web = [[CHWebViewController alloc]initWithURL:url];
//    web.userEntity = ue;
//    [self.navigationController pushViewController:web animated:YES];
    
    //    MapWebViewController *webVC = [MapWebViewController new];
    //    webVC.urlString = url;
    //    webVC.userEntity = ue;
    //    [self.navigationController pushViewController:webVC animated:YES];
    
    //SyInfoViewController *syinfo = [[SyInfoViewController alloc]init];
    //[self.navigationController pushViewController:syinfo animated:YES];
    //syinfo.userEntity = ue;
}

//选中标注点
- (void)mapView:(BMKMapView *)mapView didSelectAnnotationView:(BMKAnnotationView *)view {
    //_shopCoor = view.annotation.coordinate;
    //NSLog(@"选中了标注点!");
}

//动态请求加载地图标注点
-(void)loadData:(NSString*)lng Lat:(NSString*)lat Sytype:(NSString*) sytype {
    //-----------------------------------加载数据-----------------------------------------
    NSDictionary *parameter = @{@"lng":lng,
                                @"lat":lat,
                                @"sytype":sytype};
    [CKHttpCommunicate createRequest:GetZqInfoList WithParam:parameter withMethod:POST success:^(id response) {
        //NSLog(@"%@",response);
        
        if (response) {
            NSString *code = response[@"code"];
            
            //当返回值为200并num为0时
            if ([code isEqualToString:@"200"]) {
                NSArray *array = response[@"data"];
                for (int i = 0; i < array.count; i++) {
                    CLLocationCoordinate2D coor2;
                    
                    double dlng = [array[i][@"map_lng"] doubleValue];
                    double dlat = [array[i][@"map_lat"] doubleValue];
                    
                    coor2.longitude = dlng;
                    coor2.latitude = dlat;
                    
                    if ([_sytype isEqual: @"1"]) {
                        _pointXfs = [[BMKPointAnnotation alloc]init];
                        
                        _pointXfs.coordinate = coor2;  //每次不同的gps坐标
                        _pointXfs.title = [NSString stringWithFormat:@"%@",array[i][@"dwname"]];
                        _pointXfs.subtitle = [NSString stringWithFormat:@"%@",array[i][@"adder"]];
                        [_mapView addAnnotation:_pointXfs];
                    }
                }
            }
        }
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    } showHUD:self.view];
    //-----------------------------------加载数据-----------------------------------------
}

- (void)didUpdateUserHeading:(BMKUserLocation *)userLocation {
    NSLog(@"heading is %@",userLocation.heading);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
