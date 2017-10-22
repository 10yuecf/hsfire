//
//  MapViewController.m
//  hsfire
//
//  Created by louislee on 2017/8/12.
//  Copyright © 2017年 hsdcw. All rights reserved.
//

#import "MapTwoViewController.h"
#import "JYJSliderMenuTool.h"
#import "Macro.h"
#import "MyAnimatedAnnotationView.h"

@interface MapTwoViewController ()<UIGestureRecognizerDelegate>
{
    BMKCircle* circle;
    BMKPolygon* polygon;
    BMKPolygon* polygon2;
    BMKPolyline* polyline;
    BMKPolyline* colorfulPolyline;
    BMKArcline* arcline;
    BMKGroundOverlay* ground2;
    BMKPointAnnotation* pointAnnotation;
    BMKPointAnnotation* animatedAnnotation;
}

/** tapGestureRec */
@property (nonatomic, weak) UITapGestureRecognizer *tapGestureRec;
/** panGestureRec */
@property (nonatomic, strong) UIPanGestureRecognizer *panGestureRec;

@property (nonatomic,strong) UIView *locationView;
@property (nonatomic,strong) UIImageView *locImageView;
@property (nonatomic,strong) UIView *messageView;
@property (nonatomic,strong) UILabel *addressLabel;
@property (nonatomic,strong) UIButton *sureButton;
@end

@implementation MapTwoViewController

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
    
    NSLog(@"================%@",self.userEntity.userId);
    
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
    
    [self loadmapbtns];
    
    //加载底部按钮组
    [self loadbtns];
}

- (void)dealloc {
    if (_mapView) {
        _mapView = nil;
    }
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
    self.title = @"消防栓显示";
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
    //[msgButton addTarget:self action:@selector(msgClick) forControlEvents:UIControlEventTouchUpInside];
    
    UIView *rightView = [[UIView alloc] init];
    rightView.frame = CGRectMake(0, 0, 88, 44);
    //[rightView addSubview:msgButton];
    [rightView addSubview:searchButton];
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:rightView];
    self.navigationItem.rightBarButtonItems = @[negativeSpacer, rightItem];
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

//地图定位
-(void)dwbtnClick:(UIButton *)button {
    //启动LocationService
    _locService.delegate = self;
    
    //_mapView.zoomLevel = 17;
    _mapView.showsUserLocation = YES; //是否显示小蓝点，no不显示，我们下面要自定义的
    _mapView.userTrackingMode = BMKUserTrackingModeNone;
    
    //定位
    [_locService startUserLocationService];
    
    //[_mapView removeAnnotation:_pointAnnotation];
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
    [btn1 setImage:[UIImage imageNamed:@"xfs"] forState:UIControlStateNormal];
    [self.view addSubview:btn1];
    
    UIButton *btn2 = [UIButton buttonWithType:UIButtonTypeCustom];
    btn2.frame = CGRectMake(btn_w + 5, kHeight - maph, btn_w + 10, btn_h);
    btn2.tag = 1;
    btn2.titleLabel.font = [UIFont systemFontOfSize:14.0];
    [btn2 setTitle:@"天然水源" forState:UIControlStateNormal];
    [btn2 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btn2 addTarget:self action:@selector(buttonTap:) forControlEvents:UIControlEventTouchUpInside];
    [btn2 setImage:[UIImage imageNamed:@"water"] forState:UIControlStateNormal];
    [self.view addSubview:btn2];
    
    UIButton *btn3 = [UIButton buttonWithType:UIButtonTypeCustom];
    btn3.frame = CGRectMake(btn_w * 2 + 25, kHeight - maph, btn_w + 10, btn_h);
    btn3.tag = 2;
    btn3.titleLabel.font = [UIFont systemFontOfSize:14.0];
    [btn3 setTitle:@"添加水源" forState:UIControlStateNormal];
    [btn3 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btn3 addTarget:self action:@selector(buttonTap:) forControlEvents:UIControlEventTouchUpInside];
    [btn3 setImage:[UIImage imageNamed:@"addwt"] forState:UIControlStateNormal];
    [self.view addSubview:btn3];
    
    UIButton *btn4 = [UIButton buttonWithType:UIButtonTypeCustom];
    btn4.frame = CGRectMake(btn_w * 3 + 28, kHeight - maph, btn_w + 10, btn_h);
    btn4.tag = 3;
    btn4.titleLabel.font = [UIFont systemFontOfSize:14.0];
    [btn4 setTitle:@"刷新" forState:UIControlStateNormal];
    [btn4 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btn4 addTarget:self action:@selector(buttonTap:) forControlEvents:UIControlEventTouchUpInside];
    [btn4 setImage:[UIImage imageNamed:@"refwt"] forState:UIControlStateNormal];
    [self.view addSubview:btn4];
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
    CGPoint point = [_mapView convertCoordinate:_mapView.centerCoordinate toPointToView:_mapView];
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
    
    [_mapView addSubview:self.messageView];
    
    [_mapView addSubview:self.locationView];
}

-(void)sureButtonClick:(UIButton *)button {
    NSLog(@"this is sure btn click");
}

#pragma mark -- Selector
- (void)buttonTap:(UIButton *)button {
    if (button.tag == 0) {
        NSLog(@"显示消防栓");
    }
    
    if (button.tag == 1) {
        NSLog(@"天然水源");
    }
    
    if (button.tag == 2) {
        NSLog(@"添加水源");
    }
    
    if (button.tag == 3) {
        NSLog(@"刷新获取最新水源信息");
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
    //NSLog(@"didUpdateUserLocation lat %f,long %f",userLocation.location.coordinate.latitude,userLocation.location.coordinate.longitude);
    
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
    
    [self createLocationSignImage];
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

#pragma mark -
#pragma mark implement BMKMapViewDelegate

//根据overlay生成对应的View
- (BMKOverlayView *)mapView:(BMKMapView *)mapView viewForOverlay:(id <BMKOverlay>)overlay
{
    if ([overlay isKindOfClass:[BMKCircle class]])
    {
        BMKCircleView* circleView = [[BMKCircleView alloc] initWithOverlay:overlay];
        circleView.fillColor = [[UIColor alloc] initWithRed:1 green:0 blue:0 alpha:0.5];
        circleView.strokeColor = [[UIColor alloc] initWithRed:0 green:0 blue:1 alpha:0.5];
        circleView.lineWidth = 5.0;
        
        return circleView;
    }
    
    if ([overlay isKindOfClass:[BMKPolyline class]])
    {
        BMKPolylineView* polylineView = [[BMKPolylineView alloc] initWithOverlay:overlay];
        if (overlay == colorfulPolyline) {
            polylineView.lineWidth = 5;
            /// 使用分段颜色绘制时，必须设置（内容必须为UIColor）
            polylineView.colors = [NSArray arrayWithObjects:
                                   [[UIColor alloc] initWithRed:0 green:1 blue:0 alpha:1],
                                   [[UIColor alloc] initWithRed:1 green:0 blue:0 alpha:1],
                                   [[UIColor alloc] initWithRed:1 green:1 blue:0 alpha:0.5], nil];
        } else {
            polylineView.strokeColor = [[UIColor blueColor] colorWithAlphaComponent:1];
            polylineView.lineWidth = 20.0;
            [polylineView loadStrokeTextureImage:[UIImage imageNamed:@"texture_arrow.png"]];
        }
        return polylineView;
    }
    
    if ([overlay isKindOfClass:[BMKPolygon class]])
    {
        BMKPolygonView* polygonView = [[BMKPolygonView alloc] initWithOverlay:overlay];
        polygonView.strokeColor = [[UIColor alloc] initWithRed:0.0 green:0 blue:0.5 alpha:1];
        polygonView.fillColor = [[UIColor alloc] initWithRed:0 green:1 blue:1 alpha:0.2];
        polygonView.lineWidth =2.0;
        polygonView.lineDash = (overlay == polygon2);
        return polygonView;
    }
    if ([overlay isKindOfClass:[BMKGroundOverlay class]])
    {
        BMKGroundOverlayView* groundView = [[BMKGroundOverlayView alloc] initWithOverlay:overlay];
        return groundView;
    }
    if ([overlay isKindOfClass:[BMKArcline class]]) {
        BMKArclineView *arclineView = [[BMKArclineView alloc] initWithArcline:overlay];
        arclineView.strokeColor = [UIColor blueColor];
        arclineView.lineDash = YES;
        arclineView.lineWidth = 6.0;
        return arclineView;
    }
    return nil;
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
    NSString *AnnotationViewID = @"AnimatedAnnotation";
    MyAnimatedAnnotationView *annotationView = nil;
    if (annotationView == nil) {
        annotationView = [[MyAnimatedAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:AnnotationViewID];
    }
    NSMutableArray *images = [NSMutableArray array];
    for (int i = 1; i < 4; i++) {
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"poi_%d.png", i]];
        [images addObject:image];
    }
    annotationView.annotationImages = images;
    return annotationView;
    
}

// 当点击annotation view弹出的泡泡时，调用此接口
- (void)mapView:(BMKMapView *)mapView annotationViewForBubble:(BMKAnnotationView *)view {
    NSLog(@"paopaoclick");
}

//定位失败
- (void)didFailToLocateUserWithError:(NSError *)error{
    NSLog(@"error:%@",error);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
