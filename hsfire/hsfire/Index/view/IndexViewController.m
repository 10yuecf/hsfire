//
//  IndexViewController.m
//  fireyun
//
//  Created by louislee on 2017/8/2.
//  Copyright © 2017年 hsdcw. All rights reserved.
//

#import "IndexViewController.h"
#import "Macro.h"

@interface IndexViewController ()

@end

@implementation IndexViewController

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
}

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

//视图即将呈现时
-(void)viewWillAppear:(BOOL)animated {
    [_mapView viewWillAppear];
    _mapView.delegate = self; // 此处记得不用的时候需要置nil，否则影响内存的释放
    _locService.delegate = self;
    self.navigationController.navigationBarHidden = NO;
}

//视图即将消失时
-(void)viewWillDisappear:(BOOL)animated {
    [_mapView viewWillDisappear];
    _mapView.delegate = nil; // 不用时，置nil
    _locService.delegate = nil;
    self.navigationController.navigationBarHidden = YES;
}

@end
