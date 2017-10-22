//
//  SearchViewController.m
//  搜索控制器Demo
//
//  Created by 樊小聪 on 2017/6/7.
//  Copyright © 2017年 樊小聪. All rights reserved.
//
#import <BaiduMapAPI_Search/BMKSearchComponent.h>

#import "SearchViewController.h"
#import "MapViewController.h"
#import "MapTViewController.h"
#import "MapFViewController.h"
#import "MapFivViewController.h"
#import "MapSixViewController.h"
#import "MapSevnViewController.h"
#import "MapEgViewController.h"

#define LazyLoadMethod(variable)    \
- (NSMutableArray *)variable \
{   \
if (!_##variable)  \
{   \
_##variable = [NSMutableArray array];  \
}   \
return _##variable;    \
}


@interface SearchViewController ()<UISearchResultsUpdating, UITableViewDataSource, UISearchBarDelegate,BMKSuggestionSearchDelegate>

@property (nonatomic, strong) UISearchController *searchController;
@property (nonatomic, strong) BMKSuggestionSearch *searcher; // 检索对象
@end


static NSString * const cellIdentifier = @"cellIdentifier";

@implementation SearchViewController

/**
 *  设置数据
 */
- (void)setupData
{
    [self.dataArr addObjectsFromArray:
     @[@"国服第一臭豆腐 No.1 Stinky Tofu CN.",
       @"比尔吉沃特(Bill Ji walter)",
       @"瓦洛兰 Valoran",
       @"祖安 Zaun",
       @"德玛西亚 Demacia",
       ]];
    
    [self.tableView reloadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    /// 设置 UI
    [self setupUI];
    
    //self.navigationItem.title = @"选择地址";
    
    self.title = @"选择地址";
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
    
    self.tableView.backgroundColor = [UIColor colorWithRed:231.0/255 green:231.0/255 blue:231.0/255 alpha:1];
    self.tableView.tableHeaderView = self.searchController.searchBar;
    self.tableView.tableFooterView = [[UIView alloc] init];
    self.definesPresentationContext = YES;
}

-(void)backBtnClick {
    CATransition* transition = [CATransition animation];
    transition.type = kCATransitionPush;//可更改为其他方式
    transition.subtype = kCATransitionFromLeft;//可更改为其他方式
    [self.navigationController.view.layer addAnimation:transition forKey:kCATransition];
    
    //NSLog(@"========%@",self.userEntity.viewName);
    NSString *viewnam = self.userEntity.viewName;
    if ([viewnam isEqualToString:@"map_sy"]) {
        MapViewController *mapv = [[MapViewController alloc]init];
        [self.navigationController pushViewController:mapv animated:NO];
    }
    else if ([viewnam isEqualToString:@"map_zddw"]) {
        MapTViewController *mapTv = [[MapTViewController alloc]init];
        [self.navigationController pushViewController:mapTv animated:NO];
    }
    else if ([viewnam isEqualToString:@"map_zbwz"]) {
        MapFViewController *mapFv = [[MapFViewController alloc]init];
        [self.navigationController pushViewController:mapFv animated:NO];
    }
    else if ([viewnam isEqualToString:@"map_yjjy"]) {
        MapFivViewController *mapFiv = [[MapFivViewController alloc]init];
        [self.navigationController pushViewController:mapFiv animated:NO];
    }
    else if ([viewnam isEqualToString:@"map_zqll"]) {
        MapSixViewController *mapSix = [[MapSixViewController alloc]init];
        [self.navigationController pushViewController:mapSix animated:NO];
    }
    else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    self.tableView.frame = self.view.bounds;
}

#pragma mark - 💤 👀 LazyLoad Method 👀

LazyLoadMethod(dataArr)

#pragma mark - lazy load
- (NSArray *)dataList {
    if (!_dataList) {
        _dataList = [NSArray array];
    }
    return _dataList;
}

- (NSArray *)districtList {
    if (!_districtList) {
        _districtList = [NSArray array];
    }
    return _districtList;
}

- (NSArray *)cityList {
    if (!_cityList) {
        _cityList = [NSArray array];
    }
    return _cityList;
}

- (NSArray *)ptList {
    if (!_ptList) {
        _ptList = [NSArray array];
    }
    return _ptList;
}

- (UISearchController *)searchController {
    if (!_searchController) {
        _searchController = [[UISearchController alloc] initWithSearchResultsController:NULL];
        _searchController.searchBar.frame = CGRectMake(0, 0, 0, 44);
        _searchController.searchResultsUpdater = self;
        _searchController.dimsBackgroundDuringPresentation = NO; // 点击背景时，取消激活
        _searchController.searchBar.placeholder = @"请输入搜索内容";
        _searchController.searchBar.delegate = self;
        _searchController.searchBar.returnKeyType = UIReturnKeyDone;
        _searchController.searchBar.barTintColor = [UIColor groupTableViewBackgroundColor];
        
        /// 去除 searchBar 上下两条黑线
        UIImageView *barImageView = [[[_searchController.searchBar.subviews firstObject] subviews] firstObject];
        barImageView.layer.borderColor =  [UIColor groupTableViewBackgroundColor].CGColor;
        barImageView.layer.borderWidth = 1;
    }
    return _searchController;
}

//- (UISearchController *)searchController
//{
//    if (!_searchController)
//    {
//        _searchController = [[UISearchController alloc] initWithSearchResultsController:NULL];
//        _searchController.searchBar.frame = CGRectMake(0, 0, 0, 44);
//        _searchController.dimsBackgroundDuringPresentation = NO;
//        _searchController.searchBar.placeholder = @"请输入搜索内容";
//        _searchController.searchBar.barTintColor = [UIColor groupTableViewBackgroundColor];
//
//        /// 去除 searchBar 上下两条黑线
////        UIImageView *barImageView = [[[_searchController.searchBar.subviews firstObject] subviews] firstObject];
////        barImageView.layer.borderColor =  [UIColor groupTableViewBackgroundColor].CGColor;
////        barImageView.layer.borderWidth = 1;
////
//        self.tableView.tableHeaderView = _searchController.searchBar;
////        [_searchController.searchBar sizeToFit];
//    }
//
//    return _searchController;
//}

#pragma mark - 设置 UI

/**
 *  设置 UI
 */
- (void)setupUI
{
    /// 设置 tableView
    [self setupTableView];
    
    self.searchController.searchBar.returnKeyType = UIReturnKeyDone;
    self.searchController.searchResultsUpdater = self;
}

/**
 *  设置 tableView
 */
- (void)setupTableView
{
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    _tableView = tableView;
    _tableView.dataSource = self;
    _tableView.delegate   = self;
    _tableView.tableFooterView = [UIView new];
    [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:cellIdentifier];
    [self.view addSubview:tableView];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"UITableViewCell"];
    }
    cell.textLabel.font = [UIFont systemFontOfSize:15];
    cell.textLabel.text = self.dataList[indexPath.row];
    
    return cell;
    
    //return [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
}

#pragma mark - UITableViewDelegate
//点击cell
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    //NSLog(@"点击了第 %zi 行", indexPath.row);
    //NSString *title = self.dataList[indexPath.row];
    //NSLog(@"---%@---", title);
    
    //UIViewController *vc = [[UIViewController alloc] init];
    //vc.view.backgroundColor = [UIColor greenColor];
    //[self.navigationController pushViewController:vc animated:YES];
    
    MapEntity *mapEntity = [[MapEntity alloc]init];
    mapEntity.cityList = self.cityList;
    mapEntity.dataList = self.dataList;
    mapEntity.districtList = self.districtList;
    mapEntity.ptList = self.ptList;
    mapEntity.addrname = self.dataList[indexPath.row];
    mapEntity.points = self.ptList[indexPath.row];
    
    NSString *viewnam = self.userEntity.viewName;
    if ([viewnam isEqualToString:@"map_sy"]) {
        MapViewController *mapvc = [[MapViewController alloc] init];
        mapvc.mapEntity = mapEntity;
        [self.navigationController pushViewController:mapvc animated:YES];
    }
    else if ([viewnam isEqualToString:@"map_zddw"]) {
        MapTViewController *mapTv = [[MapTViewController alloc]init];
        mapTv.mapEntity = mapEntity;
        [self.navigationController pushViewController:mapTv animated:YES];
    }
    else if ([viewnam isEqualToString:@"map_zbwz"]) {
        MapFViewController *mapFv = [[MapFViewController alloc]init];
        mapFv.mapEntity = mapEntity;
        [self.navigationController pushViewController:mapFv animated:YES];
    }
    else if ([viewnam isEqualToString:@"map_yjjy"]) {
        MapFivViewController *mapFiv = [[MapFivViewController alloc]init];
        mapFiv.mapEntity = mapEntity;
        [self.navigationController pushViewController:mapFiv animated:YES];
    }
    else if ([viewnam isEqualToString:@"map_zqll"]) {
        MapSixViewController *mapSix = [[MapSixViewController alloc]init];
        mapSix.mapEntity = mapEntity;
        [self.navigationController pushViewController:mapSix animated:YES];
    }
    else {
        [self.navigationController popViewControllerAnimated:YES];
    }
    
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}

#pragma mark - UISearchResultsUpdating

#pragma mark - 这里主要处理实时搜索的配置
- (void)updateSearchResultsForSearchController:(UISearchController *)searchController {
    //初始化检索对象
    _searcher =[[BMKSuggestionSearch alloc]init];
    _searcher.delegate = self;
    BMKSuggestionSearchOption *option = [[BMKSuggestionSearchOption alloc] init];
    //NSLog(@"[[NSUserDefaults standardUserDefaults] valueForKey:UserCurrentCity]%@",[[NSUserDefaults standardUserDefaults] valueForKey:@"UserCurrentCity"]);
    option.cityname = [[NSUserDefaults standardUserDefaults] valueForKey:@"UserCurrentCity"];
    NSString *keyword = [NSString stringWithFormat:@"黄石%@",self.searchController.searchBar.text];
    option.keyword  = keyword;
    BOOL flag = [_searcher suggestionSearch:option];
    if(flag) {
        NSLog(@"建议检索发送成功1");
    }
    else {
        NSLog(@"建议检索发送失败1");
    }
}

#pragma mark - BMKSuggestionSearchDelegate
- (void)onGetSuggestionResult:(BMKSuggestionSearch*)searcher result:(BMKSuggestionResult*)result errorCode:(BMKSearchErrorCode)error{
    if (error == BMK_SEARCH_NO_ERROR) {
        //在此处理正常结果
        self.cityList = result.cityList;
        self.districtList = result.districtList;
        self.dataList = result.keyList;
        self.ptList = result.ptList;
        
        //在此处理正常结果
//        for (int i = 0; i < result.keyList.count; i++) {
//            //FJSearchResultModel *model = [[FJSearchResultModel alloc]init];
//            //model.name = result.keyList[i];
//            CLLocationCoordinate2D coor;
//            NSLog(@"%@",result.keyList[i]);
//            //NSLog(@"%@",result.ptList[i]);
//            [result.ptList[i] getValue:&coor];
//            NSLog(@"%f=====%f",coor.latitude,coor.longitude);
//            //model.kCoordinate = coor;
//            //[searchResultArray addObject:model];
//        }
        
        [self.tableView reloadData];
    }
    else {
        NSLog(@"抱歉，未找到结果");
    }
}

#pragma mark - UISearchBarDelegate

#pragma mark - 这里主要处理非实时搜索的配置

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{    
    /// 如果是实时搜索，则直接返回
    if (self.searchMode == SearchModeRealTime)  return;
    
    if (self.updateSearchResultsConfigure)
    {
        /// 获取搜索结果的数据
        _searchResults = self.updateSearchResultsConfigure(self.searchController.searchBar.text);
        
        /// 刷新 tableView
        [self.tableView reloadData];
    }
}

/**
 *  结束编辑的时候，显示搜索之前的界面，并将 _searchResults 清空
 */
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    /// 如果是实时搜索，则直接返回
    if (self.searchMode == SearchModeRealTime)  return;
    
    self.searchController.active = NO;
    _searchResults = nil;
    [self.tableView reloadData];
}

/**
 *  开始编辑的时候，显示搜索结果控制器
 */
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    /// 如果是实时搜索，则直接返回
    if (self.searchMode == SearchModeRealTime)  return;
    
    self.searchController.active = YES;
    [self.tableView reloadData];
}

//不使用时将delegate设置为 nil
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    _searcher.delegate = nil;
}

@end
