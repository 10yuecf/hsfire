//
//  AppDelegate.m
//  fireyun
//
//  Created by louislee on 2017/7/29.
//  Copyright © 2017年 hsdcw. All rights reserved.
//

#import <BaiduMapAPI_Map/BMKMapComponent.h>
#import "AppDelegate.h"
#import "LoginViewController.h"
#import "JYJNavigationController.h"
#import "MapViewController.h"

#import "UMMobClick/MobClick.h"
#import "UMessage.h"

#import "hsdcwUtils.h"
#import "UserEntity.h"
#import "CKHttpCommunicate.h"
#import "UserTool.h"
#import "User.h"

#import "TestViewController.h"
#import "MapTwoViewController.h"

BMKMapManager* _mapManager;
@interface AppDelegate ()<UNUserNotificationCenterDelegate>
@property (nonatomic, strong) NSMutableArray *datas;
@property (nonatomic, strong) UserEntity *userEntity;
@end

@implementation AppDelegate

@synthesize window;
@synthesize navigationController;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    //友盟统计
    UMConfigInstance.appKey = @"55472c7267e58e7e6e0020f1";
    UMConfigInstance.channelId = @"App Store";
    [MobClick startWithConfigure:UMConfigInstance];//配置以上参数后调用此方法初始化SDK！
    
    //友盟推送
    [UMessage startWithAppkey:@"597b3b6b310c9371a7001b15" launchOptions:launchOptions httpsEnable:YES];
    //注册通知，如果要使用category的自定义策略，可以参考demo中的代码。
    [UMessage registerForRemoteNotifications];
    
    //iOS10必须加下面这段代码。
    UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
    center.delegate=self;
    UNAuthorizationOptions types10=UNAuthorizationOptionBadge|  UNAuthorizationOptionAlert|UNAuthorizationOptionSound;
    [center requestAuthorizationWithOptions:types10     completionHandler:^(BOOL granted, NSError * _Nullable error) {
        if (granted) {
            //点击允许
            //这里可以添加一些自己的逻辑
        } else {
            //点击不允许
            //这里可以添加一些自己的逻辑
        }
    }];
    //打开日志，方便调试
    [UMessage setLogEnabled:YES];
    
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
    
    self.window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    [[UINavigationBar appearance] setBarTintColor:[UIColor whiteColor]];
    
    //判断用户是否已登录过
    NSString *chkuser = [NSString stringWithFormat:@"select * from t_user where loginstatus = '1' limit 1"];
    _datas = [UserTool userWithSql:chkuser];
    //NSLog(@"%lu",(unsigned long)_datas.count);
    if (_datas.count == 1) {
        // 自动登录
        MapViewController *map = [[MapViewController alloc]init];
        window.rootViewController = [[JYJNavigationController alloc]initWithRootViewController:map];
    }
    else {
        // 设置窗口的根控制器
        LoginViewController *login = [[LoginViewController alloc]init];
        window.rootViewController = [[JYJNavigationController alloc]initWithRootViewController:login];
    }
    
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
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

//iOS10以下使用这个方法接收通知
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    
    [UMessage didReceiveRemoteNotification:userInfo];
    
    //    self.userInfo = userInfo;
    //    //定制自定的的弹出框
    //    if([UIApplication sharedApplication].applicationState == UIApplicationStateActive)
    //    {
    //        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"标题"
    //                                                            message:@"Test On ApplicationStateActive"
    //                                                           delegate:self
    //                                                  cancelButtonTitle:@"确定"
    //                                                  otherButtonTitles:nil];
    //
    //        [alertView show];
    //
    //    }
}

//iOS10新增：处理前台收到通知的代理方法
-(void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler{
    NSDictionary * userInfo = notification.request.content.userInfo;
    if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        //应用处于前台时的远程推送接受
        //关闭U-Push自带的弹出框
        [UMessage setAutoAlert:NO];
        //必须加这句代码
        [UMessage didReceiveRemoteNotification:userInfo];
        
    }else{
        //应用处于前台时的本地推送接受
    }
    //当应用处于前台时提示设置，需要哪个可以设置哪一个
    completionHandler(UNNotificationPresentationOptionSound|UNNotificationPresentationOptionBadge|UNNotificationPresentationOptionAlert);
}

//iOS10新增：处理后台点击通知的代理方法
-(void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler {
    NSDictionary * userInfo = response.notification.request.content.userInfo;
    if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        //应用处于后台时的远程推送接受
        //必须加这句代码
        [UMessage didReceiveRemoteNotification:userInfo];
    }
    else {
        //应用处于后台时的本地推送接受
    }
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    // 1.2.7版本开始不需要用户再手动注册devicetoken，SDK会自动注册
    //[UMessage registerDeviceToken:deviceToken];
    
    NSString *devcode = [[[[deviceToken description] stringByReplacingOccurrencesOfString: @"<" withString: @""]
                          stringByReplacingOccurrencesOfString: @">" withString: @""]
                         stringByReplacingOccurrencesOfString: @" " withString: @""];
    
    NSLog(@"ios dev code%@",devcode);
    
    //记录最新设备码至本地数据库
    //写本地前判断一下是否存在设备码信息
    NSString *chkdev = [NSString stringWithFormat:@"select * from t_base"];
    _datas = [UserTool baseWithSql:chkdev];
    //NSLog(@"%lu",(unsigned long)_datas.count);
    
    if(_datas.count == 0) {
        NSString *insert = [NSString stringWithFormat:@"insert into t_base (strname,keyname,keyvalue) values('设备码','设备码','%@')",devcode];
        [UserTool baseWithSql:insert];
    }
    else {
        NSString *update = [NSString stringWithFormat:@"update t_base set keyvalue = '%@'",devcode];
        [UserTool baseWithSql:update];
    }
    
    NSString *chkuser = [NSString stringWithFormat:@"select * from t_user where loginstatus = '1' limit 1"];
    NSMutableArray *user_arr = [UserTool userWithSql:chkuser];
    
    NSString *uid;
    
    if (user_arr.count == 0) {
        uid = @"0";
    }
    else {
        User *u = user_arr[0];
        uid = u.userID;
    }
    
    //NSLog(@"id========%@",uid);
    
    //记录用户设备号
    NSDictionary *param_dev = @{@"type":@"ios",
                                @"id":uid,
                                @"code":devcode
                                };
    [CKHttpCommunicate createRequest:SandUmcode WithParam:param_dev withMethod:POST success:^(id response) {
        if (response) {
            NSString *result = response[@"code"];
            if ([result isEqualToString:@"200"]) {
                NSLog(@"%s","update dev code successful!");
            }
            else if ([result isEqualToString:@"400"]) {
                NSLog(@"%s","update dev code error!");
            }
        }
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    } showHUD:self.inputView];
    //--
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
