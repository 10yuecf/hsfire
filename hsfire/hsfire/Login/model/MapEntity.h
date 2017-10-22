//
//  MapEntity.h
//  hsfire
//
//  Created by louislee on 2017/10/9.
//  Copyright © 2017年 hsdcw. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <BaiduMapAPI_Map/BMKMapView.h>

@interface MapEntity : NSObject {
    NSArray *dataList; // 详细地址 ， 显示在cell的title上
    NSArray *districtList; // 搜索回调的区
    NSArray *cityList; // 搜索回调的市
    NSArray *ptList; // 搜索回调的坐标点
    NSString *addrname; //返回的地址名称
    NSValue *points; //
}

@property (nonatomic, strong) NSArray *dataList; // 详细地址 ， 显示在cell的title上
@property (nonatomic, strong) NSArray *districtList; // 搜索回调的区
@property (nonatomic, strong) NSArray *cityList; // 搜索回调的市
@property (nonatomic, strong) NSArray *ptList; // 搜索回调的坐标点
@property (nonatomic, strong) NSString *addrname;
@property (nonatomic, strong) NSValue *points;
@end
