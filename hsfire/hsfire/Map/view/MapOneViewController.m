//
//  MapOneViewController.m
//  hsfire
//
//  Created by louislee on 2017/8/20.
//  Copyright © 2017年 hsdcw. All rights reserved.
//

#import "Macro.h"
#import <BaiduMapAPI_Map/BMKMapComponent.h>


#import "MapOneViewController.h"

@interface MapOneViewController () <BMKMapViewDelegate> {
    BMKPointAnnotation* pointAnnotation;
    BMKPointAnnotation* animatedAnnotation;
}
    @property (nonatomic, strong) BMKMapView *mapView;
@end

@implementation MapOneViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _mapView = [[BMKMapView alloc]initWithFrame:CGRectMake(0, 0, kWidth, kHeight)];
    [self.view addSubview:_mapView];
    
    //添加一个PointAnnotation为地图默认位置并设置为中心点
    [self addPointAnnotation];
    
//    BMKPointAnnotation* annotation = [[BMKPointAnnotation alloc]init];
//    CLLocationCoordinate2D coor;
//    //消防坐标115.009018,30.208529
//    coor.latitude = 30.208529;
//    coor.longitude = 115.009018;
//    annotation.coordinate = coor;
//    annotation.title = @"这里是黄石消防";
//    [self.mapView addAnnotation:annotation];
//    [self.mapView setCenterCoordinate:coor animated:YES];
//    //self.mapView.gesturesEnabled = NO;
    
    //打开交通路况
    [_mapView setTrafficEnabled:YES];
    
    //设置地图显示放大级别
    [_mapView setZoomLevel:17];
}

//添加标注
- (void)addPointAnnotation {
    if (pointAnnotation == nil) {
        pointAnnotation = [[BMKPointAnnotation alloc]init];
        CLLocationCoordinate2D coor;
        
        //黄石消防坐标
        coor.latitude = 30.208529;
        coor.longitude = 115.009018;
        pointAnnotation.coordinate = coor;
        pointAnnotation.title = @"这里是黄石消防";
        pointAnnotation.subtitle = @"欢迎使用黄石消防云平台!";
        
        [self.mapView addAnnotation:pointAnnotation];
        [self.mapView setCenterCoordinate:coor animated:YES];
    }
}

// 根据anntation生成对应的View
- (BMKAnnotationView *)mapView:(BMKMapView *)mapView viewForAnnotation:(id <BMKAnnotation>)annotation {
    //普通annotation
    if (annotation == pointAnnotation) {
        NSString *AnnotationViewID = @"renameMark";
        BMKPinAnnotationView *annotationView = (BMKPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:AnnotationViewID];
        if (annotationView == nil) {
            annotationView = [[BMKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:AnnotationViewID];
            // 设置颜色
            annotationView.pinColor = BMKPinAnnotationColorPurple;
            // 从天上掉下效果
            annotationView.animatesDrop = YES;
            // 设置可拖拽
            annotationView.draggable = YES;
        }
        return annotationView;
    }
    
    //动画annotation
//    NSString *AnnotationViewID = @"AnimatedAnnotation";
//    MyAnimatedAnnotationView *annotationView = nil;
//    if (annotationView == nil) {
//        annotationView = [[MyAnimatedAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:AnnotationViewID];
//    }
//    NSMutableArray *images = [NSMutableArray array];
//    for (int i = 1; i < 4; i++) {
//        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"poi_%d.png", i]];
//        [images addObject:image];
//    }
//    annotationView.annotationImages = images;
//    return annotationView;
    return nil;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
