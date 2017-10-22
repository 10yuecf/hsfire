//
//  SettingViewController.m
//  hsjhb
//
//  Created by louislee on 16/6/19.
//  Copyright © 2016年 hsdcw. All rights reserved.
//

//#import <sqlite3.h>
#import <QuartzCore/QuartzCore.h>
#import <CoreLocation/CoreLocation.h>
#import "SettingViewController.h"
#import "JHBCellConfig.h"
#import "SettingCell.h"
#import "UserTool.h"
#import "EditPassViewController.h"
#import "SuggestViewController.h"
#import "ContactUsViewController.h"
#import "LoginViewController.h"
#import "SZKCleanCache.h"
#import "MBProgressHUD+Add.h"
#import "hsdcwUtils.h"
#import "MapViewController.h"
#import "Macro.h"
#import "LLWebViewController.h"

#define IOS8 ([[[UIDevice currentDevice] systemVersion] doubleValue] >=8.0 ? YES : NO)

@interface SettingViewController ()<UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) UITableView *mainTableView;

// cellConfig数据源
@property (nonatomic, strong) NSMutableArray *dataArray;

// 数据模型
@property (nonatomic, strong) Model *modelToShow;

@property (nonatomic, strong) NSString *cachenum; //缓存
@property (nonatomic, strong) NSString *dwflag; //定位标识
@property (nonatomic, strong) NSString *tzflag; //通知标识
@end

@implementation SettingViewController

#pragma mark - 懒加载
- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        
        _dataArray = [NSMutableArray array];
        
        JHBCellConfig *cell1 = [JHBCellConfig cellConfigWithClassName:NSStringFromClass([SettingCell class]) title:@"通知设置" showInfoMethod:@selector(showInfo: title:) heightOfCell:40];
        JHBCellConfig *cell2 = [JHBCellConfig cellConfigWithClassName:NSStringFromClass([SettingCell class]) title:@"定位设置" showInfoMethod:@selector(showInfo: title:) heightOfCell:40];
        JHBCellConfig *cell3 = [JHBCellConfig cellConfigWithClassName:NSStringFromClass([SettingCell class]) title:@"清理缓存" showInfoMethod:@selector(showInfo: title:) heightOfCell:40];
        JHBCellConfig *cell4 = [JHBCellConfig cellConfigWithClassName:NSStringFromClass([SettingCell class]) title:@"修改密码" showInfoMethod:@selector(showInfo: title:) heightOfCell:40];
        JHBCellConfig *cell5 = [JHBCellConfig cellConfigWithClassName:NSStringFromClass([SettingCell class]) title:@"使用指南" showInfoMethod:@selector(showInfo: title:) heightOfCell:40];
        JHBCellConfig *cell6 = [JHBCellConfig cellConfigWithClassName:NSStringFromClass([SettingCell class]) title:@"意见反馈" showInfoMethod:@selector(showInfo: title:) heightOfCell:40];
        JHBCellConfig *cell7 = [JHBCellConfig cellConfigWithClassName:NSStringFromClass([SettingCell class]) title:@"联系我们" showInfoMethod:@selector(showInfo: title:) heightOfCell:40];
        JHBCellConfig *cell8 = [JHBCellConfig cellConfigWithClassName:NSStringFromClass([SettingCell class]) title:@"关于黄石消防云平台" showInfoMethod:@selector(showInfo: title:) heightOfCell:40];
        //JHBCellConfig *cell9 = [JHBCellConfig cellConfigWithClassName:NSStringFromClass([SettingCell class]) title:@"退出帐号" showInfoMethod:@selector(showInfo: title:) heightOfCell:40];
        [_dataArray addObject:@[cell1, cell2, cell3, cell4, cell5, cell7, cell8]];
    }
    
    return _dataArray;
}

- (Model *)modelToShow {
    if (!_modelToShow) {
        _modelToShow = [Model new];
        
        NSString *key1 = [NSString stringWithFormat:@"cell1"];
        NSString *value1 = [NSString stringWithFormat:@"通知设置"];
        
        NSString *key2 = [NSString stringWithFormat:@"cell2"];
        NSString *value2 = [NSString stringWithFormat:@"修改密码"];
        
        [_modelToShow setValue:value1 forKey:key1];
        [_modelToShow setValue:value2 forKey:key2];
    }
    return _modelToShow;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithRed:245/255.0f green:245/255.0f blue:245/255.0f alpha:1];
    
    [self setupNav];
    [self addAllViews];
    
    UIButton *loginButton = [UIButton buttonWithType:UIButtonTypeCustom];
    loginButton.frame = CGRectMake(10, self.mainTableView.frame.size
                                   .height + 10, self.view.frame.size.width - 20, 37);
    [loginButton setTitle:@"退出账号" forState:UIControlStateNormal];
    loginButton.titleLabel.font = [UIFont systemFontOfSize:19];
    [loginButton addTarget:self action:@selector(loginButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [loginButton setBackgroundColor:[UIColor colorWithRed:204/255.0f green:0/255.0f blue:0/255.0f alpha:1]];
    loginButton.layer.cornerRadius = 5.0;
    [self.view addSubview:loginButton];
    
    //输出缓存大小 m
    hsdcwUtils *utils = [[hsdcwUtils alloc]init];
    NSLog(@"%.2fm",[SZKCleanCache folderSizeAtPath]);
    
    float cachef = [SZKCleanCache folderSizeAtPath];
    _cachenum = [utils notRounding:cachef afterPoint:2];
    
    if([CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied) {
        _dwflag = @"未开启"; //未开启
    }
    else {
        _dwflag = @"已开启"; //已开启
        //NSLog(@"已开启定位");
    }
    
    if (IOS8) { //iOS8以上包含iOS8
        if ([[UIApplication sharedApplication] currentUserNotificationSettings].types  == UIRemoteNotificationTypeNone) {
            NSLog(@"未开启通知！");
            _tzflag = @"未开启";
        }
        else {
            NSLog(@"开启通知！");
            _tzflag = @"已开启";
        }
    }else{ // ios7 以下
        if ([[UIApplication sharedApplication] enabledRemoteNotificationTypes]  == UIRemoteNotificationTypeNone) {
            NSLog(@"未开启通知！");
            _tzflag = @"未开启";
        }
        else {
            NSLog(@"开启通知！");
            _tzflag = @"已开启";
        }
    }
}

-(void)backBtnClick {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)setupNav {
    self.title = @"我的消防设置";
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:18], NSForegroundColorAttributeName:[UIColor colorWithRed:255 / 255.0 green:255 / 255.0 blue:255 / 255.0 alpha:1.0]}];
    
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    negativeSpacer.width = -15;
    
    UIButton *profileButton = [[UIButton alloc] init];
    // 设置按钮的背景图片
    [profileButton setImage:[UIImage imageNamed:@"backarr"] forState:UIControlStateNormal];
    // 设置按钮的尺寸为背景图片的尺寸
    profileButton.frame = CGRectMake(0, 0, 44, 44);
    //监听按钮的点击
    [profileButton addTarget:self action:@selector(backBtnClick) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *profile = [[UIBarButtonItem alloc] initWithCustomView:profileButton];
    self.navigationItem.leftBarButtonItems = @[negativeSpacer, profile];
}

- (void)addAllViews {
    self.mainTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kWidth, 280) style:UITableViewStylePlain];
    [self.view addSubview:self.mainTableView];
    
    self.mainTableView.delegate = self;
    self.mainTableView.dataSource = self;
    
    //self.mainTableView.separatorStyle = UITableViewCellSelectionStyleNone; //去掉系统自定义分割线
}

-(void)loginButtonClick:(UIButton *)button {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"退出后您将无法收到别人的信息，是否继续？" message:nil preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [alert addAction:action];
    UIAlertAction *loginActin = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        //更新其他数据为未登录状态
        NSString *upall = [NSString stringWithFormat:@"update t_user set loginstatus = '0'"];
        [UserTool userWithSql:upall];
        
        LoginViewController *loginvc = [[LoginViewController alloc]init];
        [self.navigationController pushViewController:loginvc animated:YES];
        //exit(0); //退出app，因为暂时无法解决barbottom问题
    }];
    [alert addAction:loginActin];
    [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark - TableView DataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.dataArray[section] count];
}

#pragma mark 设置cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    // 拿到cellConfig
    JHBCellConfig *cellConfig = self.dataArray[indexPath.section][indexPath.row];
    NSString *valueString = cellConfig.title;
    
    // 拿到对应cell并根据模型显示
    UITableViewCell *cell = [cellConfig cellOfCellConfigWithTableView:tableView dataModel:self.modelToShow dataTitle:cellConfig.title];
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator; //显示最右边的箭头
    
    cell.detailTextLabel.font = [UIFont systemFontOfSize:12];
    if ([valueString isEqualToString:@"清理缓存"]) {
        NSString *str = [NSString stringWithFormat:@"%@M",_cachenum];
        cell.detailTextLabel.text = str;
        cell.detailTextLabel.textColor = [UIColor grayColor];
    }
    else if ([valueString isEqualToString:@"定位设置"]) {
        cell.detailTextLabel.text = _dwflag;
        cell.detailTextLabel.textColor = [UIColor grayColor];
    }
    else if ([valueString isEqualToString:@"通知设置"]) {
        cell.detailTextLabel.text = _tzflag;
        cell.detailTextLabel.textColor = [UIColor grayColor];
    }
    
    //选中时的系统默认颜色
    //cell.selectionStyle = UITableViewCellSelectionStyleNone; //无色
    //cell.selectionStyle = UITableViewCellSelectionStyleBlue; //蓝色
    cell.selectionStyle = UITableViewCellSelectionStyleGray; //灰色
    
    return cell;
}

#pragma mark - TableView Delegate
#pragma mark 选中cell
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // 拿到cellConfig
    JHBCellConfig *cellConfig = self.dataArray[indexPath.section][indexPath.row];
    NSString *valueString = nil;
    
    valueString = cellConfig.title;
    
    if ([valueString isEqualToString:@"通知设置"]) {
        if([_tzflag isEqualToString:@"已开启"]) {
            [MBProgressHUD showError:@"已开启，无需重复开启！" toView:self.view];
        }
        else {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"打开[通知服务]来允许[黄石消防云]给您推送通知" message:@"请在系统设置中开启定位服务(设置>隐私>通知>开启)" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
            UIAlertAction *setAction = [UIAlertAction actionWithTitle:@"打开通知" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                //打开定位设置
                NSURL *settinsURL = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
                //[[UIApplication sharedApplication] openURL:settinsURL];
                [[UIApplication sharedApplication] openURL:settinsURL options:@{} completionHandler:nil];// iOS 10 的跳转方式
            }];
            
            [alert addAction:cancelAction];
            [alert addAction:setAction];
            [self presentViewController:alert animated:YES completion:nil];
        }
    }
    else if ([valueString isEqualToString:@"定位设置"]) {
        if([_dwflag isEqualToString:@"已开启"]) {
            [MBProgressHUD showError:@"已开启，无需重复开启！" toView:self.view];
        }
        else {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"打开[定位服务]来允许[黄石消防云]确定您的位置" message:@"请在系统设置中开启定位服务(设置>隐私>定位服务>开启)" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
            UIAlertAction *setAction = [UIAlertAction actionWithTitle:@"打开定位" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                //打开定位设置
                NSURL *settinsURL = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
                //[[UIApplication sharedApplication] openURL:settinsURL];
                [[UIApplication sharedApplication] openURL:settinsURL options:@{} completionHandler:nil];// iOS 10 的跳转方式
            }];
            
            [alert addAction:cancelAction];
            [alert addAction:setAction];
            [self presentViewController:alert animated:YES completion:nil];
        }
    }
    else if ([valueString isEqualToString:@"清理缓存"]) {
        //清楚缓存
        [SZKCleanCache cleanCache:^{
            //NSLog(@"清除成功");
            NSString *txt = [NSString stringWithFormat:@"已成功清理 %@ M缓存",_cachenum];
            [MBProgressHUD showError:txt toView:self.view];
            
            //更新其他数据为未登录状态
            NSString *upall = [NSString stringWithFormat:@"update t_user set loginstatus = '0'"];
            [UserTool userWithSql:upall];
            
            LoginViewController *loginvc = [[LoginViewController alloc]init];
            [self.navigationController pushViewController:loginvc animated:YES];
        }];
    }
    else if ([valueString isEqualToString:@"修改密码"]) {
        EditPassViewController *editpass = [[EditPassViewController alloc]init];
        editpass.title = valueString;
        [self.navigationController pushViewController:editpass animated:YES];
    }
    else if ([valueString isEqualToString:@"使用指南"]) {
        hsdcwUtils *utils = [[hsdcwUtils alloc]init];
        NSString *xf_dt = utils.myencrypt[0];
        NSString *xf_tk = utils.myencrypt[1];
        //NSLog(@"%@========%@",xf_dt, xf_tk);
        
        NSString *url = [NSString stringWithFormat:@"%@index.php/Home/Index/about/",URL_IMG];
        url = [url stringByAppendingString:xf_dt];
        url = [url stringByAppendingString:@"/xf_tk/"];
        url = [url stringByAppendingString:xf_tk];
        NSLog(@"%@",url);
        
        LLWebViewController *webV = [LLWebViewController new];
        webV.urlStr = url;
        webV.isPullRefresh = YES;
        [self.navigationController pushViewController:webV animated:YES];
    }
    else if ([valueString isEqualToString:@"意见反馈"]) {
        SuggestViewController *sugg = [[SuggestViewController alloc]init];
        sugg.title = valueString;
        [self.navigationController pushViewController:sugg animated:YES];
    }
    else if ([valueString isEqualToString:@"联系我们"]) {
        ContactUsViewController *contact = [[ContactUsViewController alloc]init];
        contact.title = valueString;
        [self.navigationController pushViewController:contact animated:YES];
    }
    else if ([valueString isEqualToString:@"关于黄石消防云平台"]) {
        hsdcwUtils *utils = [[hsdcwUtils alloc]init];
        NSString *xf_dt = utils.myencrypt[0];
        NSString *xf_tk = utils.myencrypt[1];
        //NSLog(@"%@========%@",xf_dt, xf_tk);
        
        NSString *url = [NSString stringWithFormat:@"%@index.php/Home/Index/about/xf_dt/",URL_IMG];
        url = [url stringByAppendingString:xf_dt];
        url = [url stringByAppendingString:@"/xf_tk/"];
        url = [url stringByAppendingString:xf_tk];
        NSLog(@"%@",url);
        
        LLWebViewController *webV = [LLWebViewController new];
        webV.urlStr = url;
        webV.isPullRefresh = YES;
        [self.navigationController pushViewController:webV animated:YES];
        
//        UIWebView *webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
//        [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:url]]];
//        [self.view addSubview:webView];
        
//        WKWebviewController *webVC = [WKWebviewController new];
//        webVC.urlString = url;
//        [self.navigationController pushViewController:webVC animated:YES];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    JHBCellConfig *cellConfig = self.dataArray[indexPath.section][indexPath.row];
    return cellConfig.heightOfCell;
}

#pragma mark Header
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.1;
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    //self.navigationController.navigationBarHidden = YES;
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    //self.navigationController.navigationBarHidden = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
