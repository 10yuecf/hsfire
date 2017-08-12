//
//  AppDelegate.m
//  fireyun
//
//  Created by louislee on 2017/7/29.
//  Copyright © 2017年 hsdcw. All rights reserved.
//
#import "AppDelegate.h"
#import <BaiduMapAPI_Map/BMKMapComponent.h>
#import "LoginViewController.h"
#import "JYJNavigationController.h"
#import "ViewController.h"
#import "MapViewController.h"

BMKMapManager* _mapManager;
@interface AppDelegate ()

@end

@implementation AppDelegate

@synthesize window;
@synthesize navigationController;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // 要使用百度地图，请先启动BaiduMapManager
    _mapManager = [[BMKMapManager alloc]init];
    
    /**
     *百度地图SDK所有接口均支持百度坐标（BD09）和国测局坐标（GCJ02），用此方法设置您使用的坐标类型.
     *默认是BD09（BMK_COORDTYPE_BD09LL）坐标.
     *如果需要使用GCJ02坐标，需要设置CoordinateType为：BMK_COORDTYPE_COMMON.
     */
    if ([BMKMapManager setCoordinateTypeUsedInBaiduMapSDK:BMK_COORDTYPE_BD09LL]) {
        NSLog(@"经纬度类型设置成功");
    } else {
        NSLog(@"经纬度类型设置失败");
    }
    
    BOOL ret = [_mapManager start:@"sKt44yP9nO2Vp6PbfaRDGcxfrvy2qmzX" generalDelegate:self];
    if (!ret) {
        NSLog(@"manager start failed!");
    }
    
    // 设置窗口的根控制器
    LoginViewController *login = [[LoginViewController alloc]init];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    self.window.rootViewController = [[JYJNavigationController alloc]initWithRootViewController:login];
//    self.window.rootViewController = [[JYJNavigationController alloc] initWithRootViewController:[[MapViewController alloc] init]];
    [self.window makeKeyAndVisible];
    
    //self.window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    //[[UINavigationBar appearance] setBarTintColor:[UIColor whiteColor]];
    //UINavigationController *BarNav = [[UINavigationController alloc]initWithRootViewController:login];
    //self.window.rootViewController = BarNav;
    //self.window.backgroundColor = [UIColor whiteColor];
    //[self.window makeKeyAndVisible];
    
    return YES;
}

- (void)onGetNetworkState:(int)iError {
    if (0 == iError) {
        NSLog(@"联网成功");
    }
    else{
        NSLog(@"onGetNetworkState %d",iError);
    }
}

- (void)onGetPermissionState:(int)iError {
    if (0 == iError) {
        NSLog(@"授权成功");
    }
    else {
        NSLog(@"onGetPermissionState %d",iError);
    }
}

- (void)applicationWillResignActive:(UIApplication *)application {
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
}

- (void)applicationWillTerminate:(UIApplication *)application {
}

@end
