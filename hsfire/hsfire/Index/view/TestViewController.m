//
//  TestViewController.m
//  hsfire
//
//  Created by louislee on 2017/8/18.
//  Copyright © 2017年 hsdcw. All rights reserved.
//

#import <BaiduMapAPI_Map/BMKMapView.h>
#import <BaiduMapAPI_Map/BMKMapComponent.h>
#import <BaiduMapAPI_Location/BMKLocationComponent.h>
#import <BaiduMapAPI_Search/BMKSearchComponent.h>//引入检索功能所有的头文件
#import <BaiduMapAPI_Search/BMKPoiSearch.h>
#import <BaiduMapAPI_Search/BMKRouteSearch.h>
#import <BaiduMapAPI_Utils/BMKUtilsComponent.h>

#import "TestViewController.h"
#import "Macro.h"
#import "SVProgressHUD.h"

@interface TestViewController ()<BMKMapViewDelegate,BMKLocationServiceDelegate,BMKGeoCodeSearchDelegate,UITextFieldDelegate,BMKPoiSearchDelegate,BMKRouteSearchDelegate>
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
@property (nonatomic,strong) UIButton *sureButton;
@property (nonatomic,strong) BMKGeoCodeSearch *searchAddress;
@property (nonatomic,strong) NSString * name;
@property (nonatomic,assign) CLLocationCoordinate2D location2D;

@end

@implementation TestViewController

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
    
    _locService = [[BMKLocationService alloc]init];
    _geoCodeSearch = [[BMKGeoCodeSearch alloc] init];
    _mapAnnoView = [[BMKAnnotationView alloc] init];
    _searchAddress = [[BMKGeoCodeSearch alloc] init];
    
    _mapView = [[BMKMapView alloc] initWithFrame:CGRectMake(0, 100, kWidth, kHeight - 100)];
    [self.view addSubview:_mapView];
    
    for (NSInteger i = 0; i < 20; i++) {
        _pointAnnotation2 = [[BMKPointAnnotation alloc]init];
        CLLocationCoordinate2D coor2;
        
        double lat =  (arc4random() % 100) * 0.001f;
        double lon =  (arc4random() % 100) * 0.001f;
        
        coor2.longitude = 115.092267 + lon;
        coor2.latitude = 30.22411 + lat;
        
        NSLog(@"%f",coor2.longitude);
        NSLog(@"%f",coor2.latitude);
        
        _pointAnnotation2.coordinate = coor2;  //每次不同的gps坐标
        _pointAnnotation2.title = @"tttt";
        _pointAnnotation2.subtitle = @"此Annotation可拖拽!";
        //[_mapView addAnnotation:_pointAnnotation2];
    }
    
    [self creatbtns];
}

-(void)creatbtns {
    UIButton *positionBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    positionBtn.frame = CGRectMake(30, 64, 70, 20);
    [positionBtn setTitle:@"定位" forState:UIControlStateNormal];
    [positionBtn addTarget:self action:@selector(position:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:positionBtn];
    
    UIButton *customeBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    customeBtn.frame = CGRectMake(120, 64, 100, 20);
    [customeBtn setTitle:@"自定义气泡" forState:UIControlStateNormal];
    [customeBtn addTarget:self action:@selector(custome:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:customeBtn];
    
    UIButton *planBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    planBtn.frame = CGRectMake(230, 64, 100, 20);
    [planBtn setTitle:@"添加标注" forState:UIControlStateNormal];
    [planBtn addTarget:self action:@selector(PlanBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:planBtn];
    
    UITextField *poiTextField = [[UITextField alloc] initWithFrame:CGRectMake(30, 30, 100, 20)];
    poiTextField.backgroundColor = [UIColor lightGrayColor];
    [poiTextField addTarget:self action:@selector(valueChange:) forControlEvents:UIControlEventEditingChanged];
    poiTextField.delegate = self;
    [self.view addSubview:poiTextField];
}

-(void)custome:(UIButton *)button {
    
}

-(void)valueChange:(UIButton *)button {
    
}

-(void)PlanBtn:(UIButton *)button {
    //115.091656,30.223752
    _pointAnnotation = [[BMKPointAnnotation alloc]init];
    CLLocationCoordinate2D coor;
    coor.longitude = 115.091656;
    coor.latitude = 30.223752;
    _pointAnnotation.coordinate = coor;  //每次不同的gps坐标
    _pointAnnotation.title = @"test";
    _pointAnnotation.subtitle = @"此Annotation可拖拽!";
    [_mapView addAnnotation:_pointAnnotation];
}

//这里是创建中心显示的图片和显示详细地址的View
-(void)createLocationSignImage {
    //LocationView定位在当前位置，换算为屏幕的坐标，创建的定位的图标
    self.locationView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 28, 35)];
    self.locImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 28, 35)];
    self.locImageView.image = [UIImage imageNamed:@"xfs"];
    [self.locationView addSubview:self.locImageView];
    
    //messageView 展示定位信息的View和Label和button
    self.messageView = [[UIView alloc]init];
    self.messageView.backgroundColor = [UIColor whiteColor];
    
    //把当前定位的经纬度换算为了View上的坐标
    CGPoint point = [self.mapView convertCoordinate:_mapView.centerCoordinate toPointToView:_mapView];
    NSLog(@"Point------%f-----%f",point.x,point.y);
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
    //[self.addressLabel sizeToFit];
    
    [self.messageView addSubview:self.addressLabel];
    
    //把地址信息传递到上个界面的button
    self.sureButton = [[UIButton alloc]initWithFrame:CGRectMake(self.addressLabel.frame.origin.x + self.addressLabel.frame.size.width, 0,self.messageView.frame.size.width - self.addressLabel.frame.origin.x - self.addressLabel.frame.size.width, 40)];
    
    [self.messageView addSubview:self.sureButton];
    
    self.sureButton.backgroundColor = [UIColor redColor];
    
    [self.sureButton setTitle:@"确定" forState:UIControlStateNormal];
    
    self.sureButton.titleLabel.font = [UIFont systemFontOfSize:13.0f];
    
    [self.sureButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    [self.sureButton addTarget:self action:@selector(sureButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.mapView addSubview:self.messageView];
    
    [self.mapView addSubview:self.locationView];
}

-(void)sureButtonClick:(UIButton *)button {
    NSLog(@"this is sure btn click");
}

- (void)mapView:(BMKMapView *)mapView annotationViewForBubble:(BMKAnnotationView *)view{
    NSLog(@"点击了");
    CLLocationCoordinate2D pt=(CLLocationCoordinate2D){0,0};
    pt=(CLLocationCoordinate2D){mapView.region.center.latitude,mapView.region.center.longitude};
    BMKReverseGeoCodeOption * option = [[BMKReverseGeoCodeOption alloc]init];
    option.reverseGeoPoint = pt;
    BOOL flag=[_searchAddress reverseGeoCode:option];
    
    if (flag) {
        //_mapView.showsUserLocation = NO;//不显示自己的位置
    }
}

//地图被拖动的时候，需要时时的渲染界面，当渲染结束的时候我们就去定位然后获取图片对应的经纬度
- (void)mapView:(BMKMapView *)mapView onDrawMapFrame:(BMKMapStatus*)status {
    //NSLog(@"onDrawMapFrame");
}

- (void)mapView:(BMKMapView *)mapView regionWillChangeAnimated:(BOOL)animated {
    //NSLog(@"regionWillChangeAnimated");
}

- (void)mapView:(BMKMapView *)mapView regionDidChangeAnimated:(BOOL)animated {
    NSLog(@"regionDidChangeAnimated");
    CGPoint touchPoint = self.locationView.center;
    CLLocationCoordinate2D touchMapCoordinate = [self.mapView convertPoint:touchPoint toCoordinateFromView:self.mapView];//这里touchMapCoordinate就是该点的经纬度了
    NSLog(@"touching %f,%f",touchMapCoordinate.latitude,touchMapCoordinate.longitude);
    
    BMKReverseGeoCodeOption * option = [[BMKReverseGeoCodeOption alloc]init];
    option.reverseGeoPoint = touchMapCoordinate;
    BOOL flag=[_searchAddress reverseGeoCode:option];
    
    if (flag) {
        //_mapView.showsUserLocation = NO;//不显示自己的位置
    }
}

//点击一个大头针
-(void)mapView:(BMKMapView *)mapView didSelectAnnotationView:(BMKAnnotationView *)view {
    NSLog(@"点击didSelectAnnotationView-");
}

//点击地图的空白区域
-(void)mapView:(BMKMapView *)mapView onClickedMapBlank:(CLLocationCoordinate2D)coordinate {
    NSLog(@"onClickedMapBlank-latitude==%f,longitude==%f",coordinate.latitude,coordinate.longitude);
}

//点击地图中的背景有标记的区域
- (void)mapView:(BMKMapView *)mapView onClickedMapPoi:(BMKMapPoi *)mapPoi{
    NSLog(@"点击onClickedMapPoi---%@",mapPoi.text);
    
    CLLocationCoordinate2D coordinate = mapPoi.pt;
    //长按之前删除所有标注
    NSArray *arrayAnmation=[[NSArray alloc] initWithArray:_mapView.annotations];
    [_mapView removeAnnotations:arrayAnmation];
    //设置地图标注
    BMKPointAnnotation* annotation = [[BMKPointAnnotation alloc]init];
    annotation.coordinate = coordinate;
    annotation.title = mapPoi.text;
    [_mapView addAnnotation:annotation];
    BMKReverseGeoCodeOption *re = [[BMKReverseGeoCodeOption alloc] init];
    re.reverseGeoPoint = coordinate;
    [SVProgressHUD show];
    [_searchAddress reverseGeoCode:re];
    BOOL flag =[_searchAddress reverseGeoCode:re];
    if (!flag){
        NSLog(@"search failed!");
    }
}

//根据经纬度返回点击的位置的名称
-(void)onGetReverseGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKReverseGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error{
    
    [SVProgressHUD dismiss];
    NSString * resultAddress = @"";
    NSString * houseName = @"";
    
    CLLocationCoordinate2D  coor = result.location;
    
    if(result.poiList.count > 0){
        BMKPoiInfo * info = result.poiList[0];
        if([info.name rangeOfString:@"-"].location != NSNotFound){
            houseName = [info.name componentsSeparatedByString:@"-"][0];
        }else{
            houseName = info.name;
        }
        resultAddress = [NSString stringWithFormat:@"%@%@",result.address,info.name];
    }else{
        resultAddress =result.address;
    }
    
    if(resultAddress.length == 0){
        self.addressLabel.text = @"位置解析错误，请拖动重试！";
        return;
    }
    
    self.addressLabel.text = resultAddress;
    NSLog(@"label的值==========%@",resultAddress);
    
    self.location2D = coor;
    self.name = houseName;
}

- (void)position:(UIButton *)btn {
    
    _locService.delegate = self;
    //启动LocationService
    
    _mapView.zoomLevel = 16;
    _mapView.showsUserLocation = YES;//是否显示小蓝点，no不显示，我们下面要自定义的
    _mapView.userTrackingMode = BMKUserTrackingModeNone;
    
    //定位
    [_locService startUserLocationService];
    
    [_mapView removeAnnotation:_pointAnnotation];
    
    //添加大头针
    //    _pointAnnotation = [[BMKPointAnnotation alloc] init];
    //    _pointAnnotation.coordinate = _locService.userLocation.location.coordinate;
    //    _pointAnnotation.title = @"我在这个地方";
    //    _pointAnnotation.subtitle = @"你在哪呢";
    //    [_mapView addAnnotation:_pointAnnotation];
    //    [_mapView selectAnnotation:_pointAnnotation animated:YES];
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
    BMKCoordinateRegion region;
    region.center.latitude  = userLocation.location.coordinate.latitude;
    region.center.longitude = userLocation.location.coordinate.longitude;
    region.span.latitudeDelta  = 0.0001;
    region.span.longitudeDelta = 0.0001;
    _mapView.centerCoordinate = userLocation.location.coordinate;
    //选择一个范围，让地图显示到当前界面
    [_mapView setCenterCoordinate:userLocation.location.coordinate animated:YES];
    [self.mapView setZoomEnabled:YES];
    [self.mapView setZoomEnabledWithTap:YES];
    [self.mapView setZoomLevel:16.1];
    
    NSLog(@"定位的经度:%f,定位的纬度:%f",userLocation.location.coordinate.longitude,userLocation.location.coordinate.latitude);
    _mapView.showsUserLocation = NO;//显示用户位置
    [_mapView updateLocationData:userLocation];
    //    _mapView.centerCoordinate = userLocation.location.coordinate; //让地图的中心位置在这里
    [_locService stopUserLocationService];
    
    _pointAnnotation = [[BMKPointAnnotation alloc] init];
    _pointAnnotation.coordinate = userLocation.location.coordinate;
    _pointAnnotation.title = @"我在这个地方";
    _pointAnnotation.subtitle = @"你在哪呢";
    [_mapView addAnnotation:_pointAnnotation];
    [_mapView selectAnnotation:_pointAnnotation animated:YES];
    [self createLocationSignImage];
}

- (void)didUpdateUserHeading:(BMKUserLocation *)userLocation {
    NSLog(@"heading is %@",userLocation.heading);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
