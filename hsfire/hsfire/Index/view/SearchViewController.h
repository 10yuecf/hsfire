//
//  SearchViewController.h
//  搜索控制器Demo
//
//  Created by 樊小聪 on 2017/6/7.
//  Copyright © 2017年 樊小聪. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MapEntity.h"
#import "UserEntity.h"

typedef NS_ENUM(NSInteger, SearchMode)
{
    /// 实时搜索(搜索内容随着文字的改变实时改变)
    SearchModeRealTime = 0,
    
    /// 非实时搜索(只有当点击键盘上面的搜索按钮时，才进行搜索)
    SearchModeAction
};


@interface SearchViewController : UIViewController <UITableViewDelegate>

@property (weak, nonatomic, readonly) UITableView *tableView;
/**搜索模式 */
@property (assign, nonatomic) SearchMode searchMode;

#pragma mark - Configure - Data
/**数据源*/
@property(nonatomic, strong) NSMutableArray *dataArr;

/**搜索结果*/
@property(nonatomic, strong, readonly) NSArray *searchResults;

/** 👀 更新搜索结果的数据源 */
@property (copy, nonatomic) NSArray * (^updateSearchResultsConfigure)(NSString *searchText);

@property (nonatomic, strong)NSArray *dataList; // 详细地址 ， 显示在cell的title上
@property (nonatomic, strong)NSArray *districtList; // 搜索回调的区
@property (nonatomic, strong)NSArray *cityList; // 搜索回调的市
@property (nonatomic, strong)NSArray *ptList; // 搜索回调的坐标点

@property (retain,nonatomic) MapEntity *mapEntity;
@property (retain,nonatomic) UserEntity *userEntity;
@end
