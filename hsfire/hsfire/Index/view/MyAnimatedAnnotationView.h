//
//  MyAnimatedAnnotationView.h
//  hsfire
//
//  Created by louislee on 2017/8/18.
//  Copyright © 2017年 hsdcw. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <BaiduMapAPI_Map/BMKMapComponent.h>

@interface MyAnimatedAnnotationView : BMKAnnotationView

@property (nonatomic, strong) NSMutableArray *annotationImages;
@property (nonatomic, strong) UIImageView *annotationImageView;

@end
