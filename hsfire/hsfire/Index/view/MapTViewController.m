//
//  MapViewController.m
//  hsfire
//
//  Created by louislee on 2017/8/12.
//  Copyright © 2017年 hsdcw. All rights reserved.
//  重点单位

#import <BaiduMapAPI_Map/BMKMapView.h>
#import <BaiduMapAPI_Map/BMKMapComponent.h>
#import <BaiduMapAPI_Location/BMKLocationComponent.h>
#import <BaiduMapAPI_Search/BMKSearchComponent.h>//引入检索功能所有的头文件
#import <BaiduMapAPI_Search/BMKPoiSearch.h>
#import <BaiduMapAPI_Search/BMKRouteSearch.h>
#import <BaiduMapAPI_Utils/BMKUtilsComponent.h>

#import "MapTViewController.h"
#import "JYJSliderMenuTool.h"
#import "Macro.h"
#import "MyAnimatedAnnotationView.h"
#import "UserEntity.h"
#import "hsdcwUtils.h"
#import "CKHttpCommunicate.h"

@interface MapTViewController ()<UIGestureRecognizerDelegate,BMKMapViewDelegate,BMKLocationServiceDelegate,BMKGeoCodeSearchDelegate,UITextFieldDelegate,BMKPoiSearchDelegate,BMKRouteSearchDelegate>

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
@property (nonatomic, strong) BMKPointAnnotation *pointAnnotation3;
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
@property (nonatomic,strong) NSString *dwtype;
@property (nonatomic, strong) BMKPointAnnotation *point1;
@property (nonatomic, strong) BMKPointAnnotation *point2;
@property (nonatomic, strong) BMKPointAnnotation *point3;
@end

@implementation MapTViewController

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
    
    //NSLog(@"================userid%@",self.userEntity.userId);
    
    //初始化重点单位类型
    _dwtype = @"1"; //高层建筑
    
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
    
//    // 屏幕边缘pan手势(优先级高于其他手势)
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
    self.title = @"重点单位";
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
    CGFloat btn_w = 43;
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
    [btn1 setTitle:@"高" forState:UIControlStateNormal];
    [btn1 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btn1 addTarget:self action:@selector(buttonTap:) forControlEvents:UIControlEventTouchUpInside];
    [btn1 setImage:[UIImage imageNamed:@"zddw1"] forState:UIControlStateNormal];
    [self.view addSubview:btn1];
    
    UIButton *btn2 = [UIButton buttonWithType:UIButtonTypeCustom];
    btn2.frame = CGRectMake(btn_w, kHeight - maph, btn_w + 10, btn_h);
    btn2.tag = 2;
    btn2.titleLabel.font = [UIFont systemFontOfSize:14.0];
    [btn2 setTitle:@"大" forState:UIControlStateNormal];
    [btn2 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btn2 addTarget:self action:@selector(buttonTap:) forControlEvents:UIControlEventTouchUpInside];
    [btn2 setImage:[UIImage imageNamed:@"zddw2"] forState:UIControlStateNormal];
    [self.view addSubview:btn2];
    
    UIButton *btn3 = [UIButton buttonWithType:UIButtonTypeCustom];
    btn3.frame = CGRectMake(btn_w * 2, kHeight - maph, btn_w + 10, btn_h);
    btn3.tag = 3;
    btn3.titleLabel.font = [UIFont systemFontOfSize:14.0];
    [btn3 setTitle:@"燃" forState:UIControlStateNormal];
    [btn3 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btn3 addTarget:self action:@selector(buttonTap:) forControlEvents:UIControlEventTouchUpInside];
    [btn3 setImage:[UIImage imageNamed:@"zddw3"] forState:UIControlStateNormal];
    [self.view addSubview:btn3];
    
    UIButton *btn4 = [UIButton buttonWithType:UIButtonTypeCustom];
    btn4.frame = CGRectMake(btn_w * 3, kHeight - maph, btn_w + 10, btn_h);
    btn4.tag = 4;
    btn4.titleLabel.font = [UIFont systemFontOfSize:14.0];
    [btn4 setTitle:@"古" forState:UIControlStateNormal];
    [btn4 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btn4 addTarget:self action:@selector(buttonTap:) forControlEvents:UIControlEventTouchUpInside];
    [btn4 setImage:[UIImage imageNamed:@"zddw4"] forState:UIControlStateNormal];
    [self.view addSubview:btn4];
    
    UIButton *btn5 = [UIButton buttonWithType:UIButtonTypeCustom];
    btn5.frame = CGRectMake(btn_w * 4, kHeight - maph, btn_w + 10, btn_h);
    btn5.tag = 5;
    btn5.titleLabel.font = [UIFont systemFontOfSize:14.0];
    [btn5 setTitle:@"娱" forState:UIControlStateNormal];
    [btn5 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btn5 addTarget:self action:@selector(buttonTap:) forControlEvents:UIControlEventTouchUpInside];
    [btn5 setImage:[UIImage imageNamed:@"zddw5"] forState:UIControlStateNormal];
    [self.view addSubview:btn5];
    
    UIButton *btn6 = [UIButton buttonWithType:UIButtonTypeCustom];
    btn6.frame = CGRectMake(btn_w * 5, kHeight - maph, btn_w + 10, btn_h);
    btn6.tag = 6;
    btn6.titleLabel.font = [UIFont systemFontOfSize:14.0];
    [btn6 setTitle:@"社" forState:UIControlStateNormal];
    [btn6 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btn6 addTarget:self action:@selector(buttonTap:) forControlEvents:UIControlEventTouchUpInside];
    [btn6 setImage:[UIImage imageNamed:@"zddw6"] forState:UIControlStateNormal];
    [self.view addSubview:btn6];
    
    UIButton *btn7 = [UIButton buttonWithType:UIButtonTypeCustom];
    btn7.frame = CGRectMake(btn_w * 6, kHeight - maph, btn_w + 10, btn_h);
    btn7.tag = 7;
    btn7.titleLabel.font = [UIFont systemFontOfSize:14.0];
    btn7.titleLabel.textAlignment = NSTextAlignmentLeft;
    [btn7 setTitle:@"校" forState:UIControlStateNormal];
    [btn7 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btn7 addTarget:self action:@selector(buttonTap:) forControlEvents:UIControlEventTouchUpInside];
    [btn7 setImage:[UIImage imageNamed:@"zddw7"] forState:UIControlStateNormal];
    [self.view addSubview:btn7];
}

#pragma mark -- Selector
- (void)buttonTap:(UIButton *)button {
    if (button.tag == 1) {
        NSLog(@"高层建筑");
        _dwtype = @"1";
        [self.mapView removeAnnotations:self.mapView.annotations];
    }
    
    if (button.tag == 2) {
        NSLog(@"大型建筑");
        _dwtype = @"2";
        [self.mapView removeAnnotations:self.mapView.annotations];
    }
    
    if (button.tag == 3) {
        NSLog(@"易燃建筑");
        _dwtype = @"3";
        [self.mapView removeAnnotations:self.mapView.annotations];
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
    
    [self.mapView removeAnnotation:_pointAnnotation3];
    
    NSString *resultAddress = @"";
    NSString *houseName = @"";
    
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
    
    if(resultAddress.length == 0) {
        self.addressLabel.text = @"位置解析错误，请拖动重试！";
        return;
    }
    
    self.addressLabel.text = resultAddress;
    //NSLog(@"label的值==========%@",resultAddress);
    
    CLLocationCoordinate2D coor = result.location;
    
    CLLocationCoordinate2D centercoor = _mapView.centerCoordinate;
    _latcnow = [NSString stringWithFormat:@"%lf",centercoor.latitude];
    _lngcnow = [NSString stringWithFormat:@"%lf",centercoor.longitude];
    //NSLog(@"初始化中心点的经纬度=======%@ %@",_latc,_lngc);
    //NSLog(@"当前中心点的经纬度=======%@ %@",_latcnow,_lngcnow);
    
    _pointAnnotation3 = [[BMKPointAnnotation alloc]init];
    _pointAnnotation3.coordinate = centercoor;  //每次不同的gps坐标
    _pointAnnotation3.title = [NSString stringWithFormat:@"水源中心点"];
    _pointAnnotation3.subtitle = [NSString stringWithFormat:@"我的坐标是 %f %f",centercoor.latitude,centercoor.longitude];
    //[_mapView addAnnotation:_pointAnnotation3];
    
    float latcd = [_latc floatValue];
    float lngcd = [_lngc floatValue];
    
    float latcnowd = [_latcnow floatValue];
    float lngcnowd = [_lngcnow floatValue];
    
    BMKMapPoint point1 = BMKMapPointForCoordinate(CLLocationCoordinate2DMake(latcd,lngcd));
    BMKMapPoint point2 = BMKMapPointForCoordinate(CLLocationCoordinate2DMake(latcnowd,lngcnowd));
    CLLocationDistance distance = BMKMetersBetweenMapPoints(point1,point2);
    //NSLog(@"两点间的距离======%f",distance);
    
    //如果两点距离大于800米
    if(distance > 400) {
        //重新设置水源中心点坐标
        _latc = [NSString stringWithFormat:@"%lf",centercoor.latitude];
        _lngc = [NSString stringWithFormat:@"%lf",centercoor.longitude];
        
        [self.mapView removeAnnotations:self.mapView.annotations];
        
        //异步加载标注点
        [self loadData:_lngc Lat:_latc];
    }
    
//    for (NSInteger i = 0; i < x; i++) {
//        _pointAnnotation2 = [[BMKPointAnnotation alloc]init];
//        CLLocationCoordinate2D coor2;
//        
//        double lat =  (arc4random() % 100) * 0.0001f;
//        double lon =  (arc4random() % 100) * 0.0001f;
//        
//        coor2.longitude = result.location.longitude + lon;
//        coor2.latitude = result.location.latitude + lat;
//        
//        NSLog(@"%f",coor2.longitude);
//        NSLog(@"%f",coor2.latitude);
//        
//        _pointAnnotation2.coordinate = coor2;  //每次不同的gps坐标
//        _pointAnnotation2.title = [NSString stringWithFormat:@"%ld 水源标题",(long)i];
//        _pointAnnotation2.subtitle = @"此Annotation可拖拽!";
//        [_mapView addAnnotation:_pointAnnotation2];
//    }
    
    self.location2D = coor;
    self.name = houseName;
}

//动态请求加载地图标注点
-(void)loadData:(NSString*)lng Lat:(NSString*)lat {
    //-----------------------------------加载数据-----------------------------------------
    NSDictionary *parameter = @{@"lng":lng,
                                @"lat":lat};
    [CKHttpCommunicate createRequest:GetSyInfoList WithParam:parameter withMethod:POST success:^(id response) {
        //NSLog(@"%@",response);
        
        if (response) {
            NSString *code = response[@"code"];
            
            //当返回值为200并num为0时
            if ([code isEqualToString:@"200"]) {
                NSArray *array = response[@"data"];
                for (int i = 0; i < array.count; i++) {
                    CLLocationCoordinate2D coor2;
                    
                    double dlng = [array[i][@"syaddr_lng"] doubleValue];
                    double dlat = [array[i][@"syaddr_lat"] doubleValue];
                    
                    coor2.longitude = dlng;
                    coor2.latitude = dlat;
                    
                    if ([_dwtype isEqual: @"1"]) {
                        _point1 = [[BMKPointAnnotation alloc]init];
                        
                        _point1.coordinate = coor2;  //每次不同的gps坐标
                        _point1.title = [NSString stringWithFormat:@"%@",array[i][@"sybh"]];
                        _point1.subtitle = [NSString stringWithFormat:@"%@",array[i][@"syaddr"]];
                        [_mapView addAnnotation:_point1];
                    }
                    else if ([_dwtype isEqual: @"2"]) {
                        _point2 = [[BMKPointAnnotation alloc]init];
                        
                        _point2.coordinate = coor2;  //每次不同的gps坐标
                        _point2.title = [NSString stringWithFormat:@"%@",array[i][@"sybh"]];
                        _point2.subtitle = [NSString stringWithFormat:@"%@",array[i][@"syaddr"]];
                        [_mapView addAnnotation:_point2];
                    }
                    else if ([_dwtype isEqual: @"3"]) {
                        _point3 = [[BMKPointAnnotation alloc]init];
                        
                        _point3.coordinate = coor2;  //每次不同的gps坐标
                        _point3.title = [NSString stringWithFormat:@"%@",array[i][@"sybh"]];
                        _point3.subtitle = [NSString stringWithFormat:@"%@",array[i][@"syaddr"]];
                        [_mapView addAnnotation:_point3];
                    }
                }
            }
        }
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    } showHUD:self.view];
    //-----------------------------------加载数据-----------------------------------------
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
    
    //异步加载标注点
    [self loadData:_lngc Lat:_latc];
    
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
}

- (BMKAnnotationView *)mapView:(BMKMapView *)mapView viewForAnnotation:(id <BMKAnnotation>)annotation {
    //NSLog(@"%@",annotation);
    
    if (annotation == _point1) {
        NSLog(@"点1");
        NSString *AnnotationViewID = @"zddw1mark";
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
            annotationView.image = [UIImage imageNamed:@"zddw1"];
        }
        return annotationView;
    }
    else if (annotation == _point2) {
        NSLog(@"点2");
        NSString *AnnotationViewID = @"zddw2mark";
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
            annotationView.image = [UIImage imageNamed:@"zddw2"];
        }
        return annotationView;
    }
    else if (annotation == _point3) {
        NSLog(@"点3");
        NSString *AnnotationViewID = @"zddw3mark";
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
            annotationView.image = [UIImage imageNamed:@"zddw3"];
        }
        return annotationView;
    }
    
    return nil;
}

- (void)didUpdateUserHeading:(BMKUserLocation *)userLocation {
    NSLog(@"heading is %@",userLocation.heading);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
