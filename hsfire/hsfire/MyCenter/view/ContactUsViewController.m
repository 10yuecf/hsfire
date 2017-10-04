//
//  ContactUsViewController.m
//  hsjhb
//
//  Created by louislee on 16/6/29.
//  Copyright © 2016年 hsdcw. All rights reserved.
//

#import "Macro.h"
#import "ContactUsViewController.h"
#import "JHBCellConfig.h"
#import "SettingCell.h"

@interface ContactUsViewController ()<UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) UITableView *mainTableView;

// cellConfig数据源
@property (nonatomic, strong) NSMutableArray *dataArray;

// 数据模型
@property (nonatomic, strong) Model *modelToShow;
@end

@implementation ContactUsViewController

#pragma mark - 懒加载
- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        
        _dataArray = [NSMutableArray array];
        
        JHBCellConfig *cell1 = [JHBCellConfig cellConfigWithClassName:NSStringFromClass([SettingCell class]) title:@"联系电话" showInfoMethod:@selector(showInfo: title:) heightOfCell:40];
        JHBCellConfig *cell2 = [JHBCellConfig cellConfigWithClassName:NSStringFromClass([SettingCell class]) title:@"电子邮箱" showInfoMethod:@selector(showInfo: title:) heightOfCell:40];
        JHBCellConfig *cell3 = [JHBCellConfig cellConfigWithClassName:NSStringFromClass([SettingCell class]) title:@"技术支持电话" showInfoMethod:@selector(showInfo: title:) heightOfCell:40];
        JHBCellConfig *cell4 = [JHBCellConfig cellConfigWithClassName:NSStringFromClass([SettingCell class]) title:@"技术支持邮箱" showInfoMethod:@selector(showInfo: title:) heightOfCell:40];
        
        [_dataArray addObject:@[cell1, cell2, cell3, cell4]];
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
    
    [self setupNav];
    
    [self addAllViews];
}

- (void)addAllViews {
    self.mainTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kWidthOfScreen, kHeightOfScreen) style:UITableViewStyleGrouped];
    [self.view addSubview:self.mainTableView];
    
    self.mainTableView.delegate = self;
    self.mainTableView.dataSource = self;
}

-(void)backBtnClick {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)setupNav {
    self.title = @"联系我们";
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:20], NSForegroundColorAttributeName:[UIColor colorWithRed:255 / 255.0 green:255 / 255.0 blue:255 / 255.0 alpha:1.0]}];
    
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
    
    //NSLog(@"%@",valueString);
    cell.detailTextLabel.font = [UIFont systemFontOfSize:12];
    
    if ([valueString isEqualToString:@"联系电话"]) {
        cell.detailTextLabel.text = @"0714-6376055";
        //cell.detailTextLabel.textColor = [UIColor orangeColor];
    }
    else if ([valueString isEqualToString:@"电子邮箱"]) {
        cell.detailTextLabel.text = @"24454471@qq.com";
    }
    else if ([valueString isEqualToString:@"技术支持电话"]) {
        cell.detailTextLabel.text = @"0714-6516673";
    }
    else if ([valueString isEqualToString:@"技术支持邮箱"]) {
        cell.detailTextLabel.text = @"24454471@qq.com";
    }
    
    //选中时的系统默认颜色
    cell.selectionStyle = UITableViewCellSelectionStyleNone; //无色
    
    return cell;
}

#pragma mark - TableView Delegate
#pragma mark 选中cell
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // 拿到cellConfig
    JHBCellConfig *cellConfig = self.dataArray[indexPath.section][indexPath.row];
    NSString *valueString = nil;
    valueString = cellConfig.title;
    
    if ([valueString isEqualToString:@"联系电话"]) {
        //NSLog(@"弹出联系电话");
        //UIWebView *webView = [[UIWebView alloc]init];
        //NSURL *url = [NSURL URLWithString:@"tel://10010"];
        //[webView loadRequest:[NSURLRequest requestWithURL:url]];
        
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"tel:0714-6376055"]];
    }
    else if ([valueString isEqualToString:@"技术支持电话"]) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"tel:0714-6516673"]];
    }
    else if ([valueString isEqualToString:@"电子邮箱"]) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"mailto:24454471@qq.com"]];
    }
    else if ([valueString isEqualToString:@"技术支持邮箱"]) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"mailto:24454471@qq.com"]];
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
    return 8;
}

- (BOOL)prefersStatusBarHidden {
    return NO; //隐藏状态栏,是的,是的!
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    self.tabBarController.hidesBottomBarWhenPushed = YES;
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:NO];
    self.tabBarController.hidesBottomBarWhenPushed = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
