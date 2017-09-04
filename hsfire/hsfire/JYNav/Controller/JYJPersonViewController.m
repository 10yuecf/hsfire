//
//  JYJPersonViewController.m
//  导航测试demo
//
//  Created by JYJ on 2017/6/5.
//  Copyright © 2017年 baobeikeji. All rights reserved.
//

#import "JYJPersonViewController.h"
#import "JYJMyWalletViewController.h"
#import "JYJMyCardViewController.h"
#import "JYJMyTripViewController.h"
#import "JYJMyFriendViewController.h"
#import "JYJMyStickerViewController.h"
#import "JYJCommenItem.h"
#import "JYJProfileCell.h"
#import "JYJPushBaseViewController.h"
#import "JYJAnimateViewController.h"

#import "Macro.h"

#import "SettingViewController.h"
#import "MapViewController.h"

@interface JYJPersonViewController () <UITableViewDelegate, UITableViewDataSource>
/** tableView */
@property (nonatomic, weak) UITableView *tableView;
/** headerIcon */
@property (nonatomic, weak) UIImageView *headerIcon;
/** data */
@property (nonatomic, strong) NSArray *data;
@end

@implementation JYJPersonViewController

- (NSArray *)data {
    if (!_data) {
        self.data = [NSArray array];
    }
    return _data;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self setupUI];
    
    [self setupData];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.tableView.frame = self.view.bounds;
    self.headerIcon.frame = CGRectMake(self.tableView.frame.size.width / 2 - 36, 20, 62, 62);
}

- (void)setupUI {
    UITableView *tableView = [[UITableView alloc] init];
    tableView.scrollEnabled = NO;
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.separatorStyle = UITableViewCellSelectionStyleNone;
    tableView.showsVerticalScrollIndicator = NO;
    tableView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:tableView];
    self.tableView = tableView;
    
    UIView *headerView = [[UIView alloc] init];
    headerView.backgroundColor = [UIColor colorWithRed:245 / 255.0 green:247 / 255.0 blue:250 / 255.0 alpha:1.0];
    headerView.frame = CGRectMake(0, 0, 0, 100);
    self.tableView.tableHeaderView = headerView;
    
    /** 头像图片 **/
    UIImageView *headerIcon = [[UIImageView alloc] init];
    headerIcon.image = [UIImage imageNamed:@"avatar_login"];
    //headerIcon.frame = CGRectMake(0, 29, 62, 62);
    headerIcon.layer.cornerRadius = 30;
    headerIcon.clipsToBounds = YES;
    [headerView addSubview:headerIcon];
    self.headerIcon = headerIcon;

    UIImageView *line1 = [[UIImageView alloc]initWithFrame:CGRectMake(0, kHeight - 40, kWidth, 1)];
    line1.backgroundColor = [UIColor colorWithRed:180/255.0 green:180/255.0 blue:180/255.0 alpha:0.3];
    [tableView addSubview:line1];
    
    //设置
    UILabel *setlabel = [[UILabel alloc]initWithFrame:CGRectMake(20, kHeight - 35, 100, 30)];
    setlabel.text = @"设置";
    setlabel.textColor = [UIColor colorWithRed:51/255.0f green:51/255.0f blue:51/255.0f alpha:1.0];
    setlabel.font = [UIFont systemFontOfSize:14];
    [tableView addSubview:setlabel];
    
    //为setlabel添加点击事件
    setlabel.userInteractionEnabled = YES;
    UITapGestureRecognizer *setlabelTapGestureRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(setlab:)];
    [setlabel addGestureRecognizer:setlabelTapGestureRecognizer];
    
    //离线地图
    UILabel *hplabel = [[UILabel alloc]initWithFrame:CGRectMake(80, kHeight - 35, 100, 30)];
    hplabel.text = @"离线地图";
    hplabel.textColor = [UIColor colorWithRed:51/255.0f green:51/255.0f blue:51/255.0f alpha:1.0];
    hplabel.font = [UIFont systemFontOfSize:14];
    [tableView addSubview:hplabel];
    
    //为hplabel添加点击事件
    hplabel.userInteractionEnabled = YES;
    UITapGestureRecognizer *hplabelTapGestureRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hplab:)];
    [hplabel addGestureRecognizer:hplabelTapGestureRecognizer];
}

//设置
-(void)setlab:(UITapGestureRecognizer *)recognizer {
    SettingViewController *set = [[SettingViewController alloc]init];
    [self.navigationController pushViewController:set animated:YES];
}

//离线地图
-(void)hplab:(UITapGestureRecognizer *)recognizer {
    JYJMyWalletViewController *my1 = [[JYJMyWalletViewController alloc]init];
    [self.navigationController pushViewController:my1 animated:YES];
}

- (void)setupData {
    JYJCommenItem *my1 = [JYJCommenItem itemWithIcon:@"menu1" title:@"水源管理" subtitle:@"" destVcClass:[MapViewController class]];
    
    JYJCommenItem *my2 = [JYJCommenItem itemWithIcon:@"menu2" title:@"重点单位" subtitle:@"" destVcClass:[JYJMyCardViewController class]];
    
    JYJCommenItem *my3 = [JYJCommenItem itemWithIcon:@"menu3" title:@"消安委" subtitle:nil destVcClass:[JYJMyTripViewController class]];
    
    JYJCommenItem *my4 = [JYJCommenItem itemWithIcon:@"menu4" title:@"战保物资" subtitle:nil destVcClass:[JYJMyFriendViewController class]];
    
    JYJCommenItem *my5 = [JYJCommenItem itemWithIcon:@"menu4" title:@"应急救援" subtitle:nil destVcClass:[JYJMyFriendViewController class]];
    
    JYJCommenItem *my6 = [JYJCommenItem itemWithIcon:@"menu4" title:@"执勤力量" subtitle:nil destVcClass:[JYJMyFriendViewController class]];
    
    JYJCommenItem *my7 = [JYJCommenItem itemWithIcon:@"menu4" title:@"消防知识" subtitle:nil destVcClass:[JYJMyFriendViewController class]];
    
    JYJCommenItem *my8 = [JYJCommenItem itemWithIcon:@"menu4" title:@"消防审批" subtitle:nil destVcClass:[JYJMyFriendViewController class]];
    
    JYJCommenItem *myxf = [JYJCommenItem itemWithIcon:@"menu5" title:@"我的消防" subtitle:nil destVcClass:[JYJMyStickerViewController class]];
    
    //读取权限
    
    self.data = @[my1, my2, my3, my4, my5, my6, my7, my8, myxf];
}

#pragma mark - TableView DataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.data.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    // 创建cell
    JYJProfileCell *cell = [JYJProfileCell cellWithTableView:tableView];
    cell.item = self.data[indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    JYJCommenItem *item = self.data[indexPath.row];
    if (item.destVcClass == nil) return;
    
    JYJPushBaseViewController *vc = [[item.destVcClass alloc] init];
    vc.title = item.title;
    vc.animateViewController = (JYJAnimateViewController *)self.parentViewController;
    [self.parentViewController.navigationController pushViewController:vc animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
