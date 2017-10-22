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
//#import "UMessage.h"

#import "hsdcwUtils.h"
#import "UserEntity.h"
#import "CKHttpCommunicate.h"
#import "UserTool.h"
#import "User.h"

#import "TestViewController.h"
#import "MapTwoViewController.h"

#import "JYJMyStickerViewController.h"
#import "JYJMyWalletViewController.h"

#import <PgySDK/PgyManager.h>
#import <PgyUpdate/PgyUpdateManager.h>

//#import "XGPush.h"
//#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_10_0
//#import <UserNotifications/UserNotifications.h>
//#endif

//-----极光推送
// 引入JPush功能所需头文件
#import "JPUSHService.h"
// iOS10注册APNs所需头文件
#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#import <UserNotifications/UserNotifications.h>
#endif
//-----end

#import "BNCoreServices.h"
#define NAVI_BUNDLE_ID @"cn.hsdcw.fireyun"  //sdk自测bundle ID
#define NAVI_APP_KEY   @"sKt44yP9nO2Vp6PbfaRDGcxfrvy2qmzX"  //sdk自测APP KEY
BMKMapManager* _mapManager;
@interface AppDelegate ()<JPUSHRegisterDelegate>
@property (nonatomic, strong) NSMutableArray *datas;
@property (nonatomic, strong) UserEntity *userEntity;
@property (nonatomic, strong) NSString *devcode;
@end

@implementation AppDelegate

@synthesize window;
@synthesize navigationController;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    //友盟统计
    UMConfigInstance.appKey = @"55472c7267e58e7e6e0020f1";
    UMConfigInstance.channelId = @"App Store";
    [MobClick startWithConfigure:UMConfigInstance];//配置以上参数后调用此方法初始化SDK！
    
    //启动基本SDK
    [[PgyManager sharedPgyManager] startManagerWithAppId:@"85f831ead4419f3513a9ff5a628c6e49"];
    //启动更新检查SDK
    [[PgyUpdateManager sharedPgyManager] startManagerWithAppId:@"85f831ead4419f3513a9ff5a628c6e49"];
    
    //友盟推送
    //[UMessage startWithAppkey:@"597b3b6b310c9371a7001b15" launchOptions:launchOptions httpsEnable:YES];
    //注册通知，如果要使用category的自定义策略，可以参考demo中的代码。
    //[UMessage registerForRemoteNotifications];
    
    //iOS10必须加下面这段代码。
//    UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
//    center.delegate=self;
//    UNAuthorizationOptions types10=UNAuthorizationOptionBadge|  UNAuthorizationOptionAlert|UNAuthorizationOptionSound;
//    [center requestAuthorizationWithOptions:types10     completionHandler:^(BOOL granted, NSError * _Nullable error) {
//        if (granted) {
//            //点击允许
//            //这里可以添加一些自己的逻辑
//        } else {
//            //点击不允许
//            //这里可以添加一些自己的逻辑
//        }
//    }];
    //打开日志，方便调试
    //[UMessage setLogEnabled:YES];
    
//    if(launchOptions) {
//        NSDictionary* remoteNotification = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
//        if(remoteNotification) {
//            NSLog(@"推送过来的消息是%@",remoteNotification);
//            //点击推送通知进入指定界面（这个肯定是相当于从后台进入的）
//            //[self goToMssageViewControllerWith:remoteNotification];//进入相应页面的方法
//            MapTwoViewController *map = [[MapTwoViewController alloc]init];
//            window.rootViewController = [[JYJNavigationController alloc]initWithRootViewController:map];
//        }
//    }
    
    //信鸽推送start
//    [[XGPush defaultManager] setEnableDebug:YES];
//    XGNotificationAction *action1 = [XGNotificationAction actionWithIdentifier:@"xgaction001" title:@"xgAction1" options:XGNotificationActionOptionNone];
//    XGNotificationAction *action2 = [XGNotificationAction actionWithIdentifier:@"xgaction002" title:@"xgAction2" options:XGNotificationActionOptionDestructive];
//    XGNotificationCategory *category = [XGNotificationCategory categoryWithIdentifier:@"xgCategory" actions:@[action1, action2] intentIdentifiers:@[] options:XGNotificationCategoryOptionNone];
//    XGNotificationConfigure *configure = [XGNotificationConfigure configureNotificationWithCategories:[NSSet setWithObject:category] types:XGUserNotificationTypeAlert|XGUserNotificationTypeBadge|XGUserNotificationTypeSound];
//    [[XGPush defaultManager] setNotificationConfigure:configure];
//    [[XGPush defaultManager] startXGWithAppID:2200268364 appKey:@"ID2Q49G8Q2PR" delegate:self];
//    [[XGPush defaultManager] setXgApplicationBadgeNumber:0];
//    [[XGPush defaultManager] reportXGNotificationInfo:launchOptions];
    //end
    
    //极光推送
    //Required
    //notice: 3.0.0及以后版本注册可以这样写，也可以继续用之前的注册方式
    JPUSHRegisterEntity * entity = [[JPUSHRegisterEntity alloc] init];
    entity.types = JPAuthorizationOptionAlert|JPAuthorizationOptionBadge|JPAuthorizationOptionSound;
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        // 可以添加自定义categories
        // NSSet<UNNotificationCategory *> *categories for iOS10 or later
        // NSSet<UIUserNotificationCategory *> *categories for iOS8 and iOS9
    }
    [JPUSHService registerForRemoteNotificationConfig:entity delegate:self];
    
    // Required
    // init Push
    // notice: 2.1.5版本的SDK新增的注册方法，改成可上报IDFA，如果没有使用IDFA直接传nil
    // 如需继续使用pushConfig.plist文件声明appKey等配置内容，请依旧使用[JPUSHService setupWithOption:launchOptions]方式初始化。
    [JPUSHService setupWithOption:launchOptions appKey:appKey
                          channel:channel
                 apsForProduction:isProduction
            advertisingIdentifier:nil];
    
    //[JPUSHService setDebugMode];//设置开启 JPush 日志
    //[JMessage setDebugMode];//设置开启 JMessage 日志
    //end
    
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
    
    //2.1.9版本新增获取registration id block接口。
    [JPUSHService registrationIDCompletionHandler:^(int resCode, NSString *registrationID) {
        if(resCode == 0) {
            NSLog(@"registrationID获取成功：%@",registrationID);
            _devcode = registrationID;
            //将上述数据全部存储到NSUserDefaults中
            NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
            [userDefaults setObject:_devcode forKey:@"devcode"];
            [userDefaults synchronize];
        }
        else {
            _devcode = @"noid";
            //将上述数据全部存储到NSUserDefaults中
            NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
            [userDefaults setObject:_devcode forKey:@"devcode"];
            [userDefaults synchronize];
            
            NSLog(@"registrationID获取失败，code：%d",resCode);
        }
    }];
    
    //判断用户是否已登录过
    NSString *chkuser = [NSString stringWithFormat:@"select * from t_user where loginstatus = '1' limit 1"];
    _datas = [UserTool userWithSql:chkuser];
    //NSLog(@"%lu",(unsigned long)_datas.count);
    if (_datas.count == 1) {
        // 自动登录
        //JYJMyStickerViewController *xaw = [[JYJMyStickerViewController alloc]init];
        //window.rootViewController = [[JYJNavigationController alloc]initWithRootViewController:xaw];
        
        User *u = _datas[0];
        //NSLog(@"===========%@",u.zw);

        if([u.bz isEqualToString:@"普通用户"]) {
            NSLog(@"普通用户");
            JYJMyWalletViewController *uv = [[JYJMyWalletViewController alloc]init];
            window.rootViewController = [[JYJNavigationController alloc]initWithRootViewController:uv];
        }
        else {
            NSLog(@"消防用户");
            // 自动登录
            JYJMyStickerViewController *xaw = [[JYJMyStickerViewController alloc]init];
            window.rootViewController = [[JYJNavigationController alloc]initWithRootViewController:xaw];

            //MapViewController *map = [[MapViewController alloc]init];
            //window.rootViewController = [[JYJNavigationController alloc]initWithRootViewController:map];
        }
    }
    else {
        // 设置窗口的根控制器
        LoginViewController *login = [[LoginViewController alloc]init];
        window.rootViewController = [[JYJNavigationController alloc]initWithRootViewController:login];
    }
    
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    //初始化导航SDK
    [BNCoreServices_Instance initServices: NAVI_APP_KEY];
    //TTS在线授权
    [BNCoreServices_Instance setTTSAppId:@"9945092"];
    //设置是否自动退出导航
    [BNCoreServices_Instance setAutoExitNavi:NO];
    [BNCoreServices_Instance startServicesAsyn:nil fail:nil];
    
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
//- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    
    //[UMessage didReceiveRemoteNotification:userInfo];
    
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
//}

//iOS10新增：处理前台收到通知的代理方法
//-(void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler{
//    NSDictionary * userInfo = notification.request.content.userInfo;
//    if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
//        //应用处于前台时的远程推送接受
//        //关闭U-Push自带的弹出框
//        [UMessage setAutoAlert:NO];
//        //必须加这句代码
//        [UMessage didReceiveRemoteNotification:userInfo];
//        
//    }else{
//        //应用处于前台时的本地推送接受
//    }
//    //当应用处于前台时提示设置，需要哪个可以设置哪一个
//    completionHandler(UNNotificationPresentationOptionSound|UNNotificationPresentationOptionBadge|UNNotificationPresentationOptionAlert);
//}

////iOS10新增：处理后台点击通知的代理方法
//-(void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler {
//    NSDictionary * userInfo = response.notification.request.content.userInfo;
//    if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
//        //应用处于后台时的远程推送接受
//        //必须加这句代码
//        [UMessage didReceiveRemoteNotification:userInfo];
//    }
//    else {
//        //应用处于后台时的本地推送接受
//    }
//}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    //NSLog(@"[XGDemo] device token is %@", [[XGPushTokenManager defaultTokenManager] deviceTokenString]);
    //NSString *devcode = [[XGPushTokenManager defaultTokenManager] deviceTokenString];
    
    /// Required - 注册 DeviceToken
    //NSLog(@"%@", [NSString stringWithFormat:@"Device Token: %@", deviceToken]);
    [JPUSHService registerDeviceToken:deviceToken];
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    //NSLog(@"[XGDemo] register APNS fail.\n[XGDemo] reason : %@", error);
    //[[NSNotificationCenter defaultCenter] postNotificationName:@"registerDeviceFailed" object:nil];
    
    //Optional 极光推送
    NSLog(@"did Fail To Register For Remote Notifications With Error: %@", error);
}

#pragma mark- JPUSHRegisterDelegate
// iOS 10 Support
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(NSInteger))completionHandler {
    // Required
    NSDictionary * userInfo = notification.request.content.userInfo;
    if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
    }
    completionHandler(UNNotificationPresentationOptionAlert); // 需要执行这个方法，选择是否提醒用户，有Badge、Sound、Alert三种类型可以选择设置
}

// iOS 10 Support
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler {
    // Required
    NSDictionary * userInfo = response.notification.request.content.userInfo;
    if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
    }
    completionHandler();  // 系统要求执行这个方法
}

/**
 收到静默推送的回调
 
 @param application  UIApplication 实例
 @param userInfo 推送时指定的参数
 @param completionHandler 完成回调
 */
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    
//    NSLog(@"[XGDemo] receive slient Notification");
//    NSLog(@"[XGDemo] userinfo %@", userInfo);
//    [[XGPush defaultManager] reportXGNotificationInfo:userInfo];
//
//    completionHandler(UIBackgroundFetchResultNewData);
    
    // Required, iOS 7 Support
    [JPUSHService handleRemoteNotification:userInfo];
    completionHandler(UIBackgroundFetchResultNewData);
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    
    // Required,For systems with less than or equal to iOS6
    [JPUSHService handleRemoteNotification:userInfo];
}

//// iOS 10 新增 API
//// iOS 10 会走新 API, iOS 10 以前会走到老 API
//#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_10_0
//// App 用户点击通知的回调
//// 无论本地推送还是远程推送都会走这个回调
//- (void)xgPushUserNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)(void))completionHandler {
//    NSLog(@"[XGDemo] click notification");
//    if ([response.actionIdentifier isEqualToString:@"xgaction001"]) {
//        NSLog(@"click from Action1");
//    } else if ([response.actionIdentifier isEqualToString:@"xgaction002"]) {
//        NSLog(@"click from Action2");
//    } else if ([response.actionIdentifier isEqualToString:@"xgaction003"]) {
//        NSLog(@"click from Action3");
//    }
//
//    [[XGPush defaultManager] reportXGNotificationInfo:response.notification.request.content.userInfo];
//
//    completionHandler();
//}

// App 在前台弹通知需要调用这个接口
//- (void)xgPushUserNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler {
//    [[XGPush defaultManager] reportXGNotificationInfo:notification.request.content.userInfo];
//
//    completionHandler(UNNotificationPresentationOptionBadge | UNNotificationPresentationOptionSound | UNNotificationPresentationOptionAlert);
//}
//#endif

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
