//
//  IndexViewController.h
//  fireyun
//
//  Created by louislee on 2017/8/2.
//  Copyright © 2017年 hsdcw. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import <BaiduMapAPI_Map/BMKMapComponent.h>
#import <BaiduMapAPI_Location/BMKLocationComponent.h>
#import<BaiduMapAPI_Search/BMKGeocodeSearch.h>

@interface IndexViewController : UIViewController<BMKMapViewDelegate,BMKLocationServiceDelegate,BMKGeoCodeSearchDelegate> {
    BMKMapView* _mapView; //地图
    BMKLocationService* _locService; //定位
    BMKGeoCodeSearch *_geocodesearch; //地理编码主类，用来查询、返回结果信息
}

@end
