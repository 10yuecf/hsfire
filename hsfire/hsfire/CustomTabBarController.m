//
//  CustomTabBarController.m
//  jhb
//
//  Created by louislee on 16/7/11.
//  Copyright © 2016年 hsdcw. All rights reserved.
//

#import "CustomTabBarController.h"
#import "MyNavigationController.h"

#import "IndexViewController.h"

#define KWIDTH ([UIScreen mainScreen].bounds.size.width)
#define KHEIGHT ([UIScreen mainScreen].bounds.size.height)
#define RGBA(r,g,b,a) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]
#define Font(num) [UIFont systemFontOfSize:num]

@interface CustomTabBarController () {
    NSArray     *normalImageArray;
    NSArray     *highlightedImageArray;
    NSArray     *titleArray;
    
    UIImageView *tempImageView;//临时图片
    UILabel     *tempLabel;//临时标签
    UIButton    *tempButton;//临时按钮
    
    NSInteger   index;//记录上次点击的按钮
}

@property (nonatomic,strong)UIView *tabBarBgView;

@end

@implementation CustomTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    index = 0;//初始化
    
    normalImageArray = [[NSArray alloc]initWithObjects:@"1.png",@"2.png",@"3.png",@"4.png",@"5.png", nil];
    highlightedImageArray = [[NSArray alloc]initWithObjects:@"12.png",@"22.png",@"32.png",@"42.png",@"52.png", nil];
    titleArray = [[NSArray alloc]initWithObjects:@"邂逅",@"搜索",@"消息",@"活动",@"我的", nil];
    
    [self configerVC];//配置底部tabbar
    
    [self configerUI];//配置UI界面
}

#pragma mark---配置底部标签栏
- (void)configerVC {
    //第一个view不需要导航栏
    IndexViewController *IndexVC = [[IndexViewController alloc]init];
    MyNavigationController *IndexNav = [[MyNavigationController alloc]initWithRootViewController:IndexVC];
    
    //SecondViewController *SearchVc = [[SecondViewController alloc]init];
    //JhbNavigationController *SecondNav = [[JhbNavigationController alloc]initWithRootViewController:SearchVc];
    
    //MessTableViewController *MessTbVc = [[MessTableViewController alloc]init];
    //JhbNavigationController *ThirdNav = [[JhbNavigationController alloc]initWithRootViewController:MessTbVc];
    
    //FourthViewController *EventVc = [[FourthViewController alloc]init];
    //JhbNavigationController *FourthNav = [[JhbNavigationController alloc]initWithRootViewController:EventVc];
    
    //FifthViewController *FifthVC = [[FifthViewController alloc]init];
    //JhbNavigationController *FifthNav = [[JhbNavigationController alloc]initWithRootViewController:FifthVC];
    
    self.viewControllers = @[IndexNav];
}

- (void)configerUI {
    //背景
    self.tabBarBgView = [[UIView alloc]initWithFrame:CGRectMake(0, KHEIGHT-49, KWIDTH, 49)];
    self.tabBarBgView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.tabBarBgView];
    
    float interValX = KWIDTH/5-20;
    
    //创建5个按钮
    for (int i = 0; i<5; i++) {
        //图片
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake((KWIDTH/5-20)/2+(20+interValX)*i, 6, 20, 20)];
        imageView.image = [UIImage imageNamed:normalImageArray[i]];
        imageView.tag = i+200;
        [self.tabBarBgView addSubview:imageView];
        
        //标题
        UILabel *titleLabel = [[UILabel alloc]init];
        titleLabel.frame = CGRectMake((KWIDTH/5)*i, CGRectGetMinY(imageView.frame)+25, KWIDTH/5, 15);
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.font = Font(10);
        titleLabel.textColor = RGBA(100, 100, 100, 1);
        titleLabel.text = titleArray[i];
        titleLabel.tag = i+300;
        [self.tabBarBgView addSubview:titleLabel];
        
        //按钮
        UIButton *tabBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        tabBtn.frame = CGRectMake((KWIDTH/5)*i, 0, KWIDTH/5, 49);
        [tabBtn addTarget:self action:@selector(tabBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        tabBtn.tag = i+100;
        tabBtn.selected = NO;
        [self.tabBarBgView addSubview:tabBtn];
        
        //第一个默认被选中
        if (i == 0) {
            imageView.image = [UIImage imageNamed:highlightedImageArray[0]];
            titleLabel.textColor = [UIColor redColor];
            tabBtn.selected = YES;
        }
    }
}

#pragma mark---tabBar 按钮点击
- (void)tabBtnClick:(UIButton *)btn {
    //第一个不被选中
    UIImageView *img0    = (UIImageView *)[self.view viewWithTag:200];
    UILabel     *lab0    = (UILabel *)[self.view viewWithTag:300];
    UIButton    *button0 = (UIButton *)[self.view viewWithTag:100];
    img0.image = [UIImage imageNamed:normalImageArray[0]];
    lab0.textColor = RGBA(100, 100, 100, 1);
    button0.selected = NO;
    
    //切换VC
    self.selectedIndex = btn.tag - 100;
    
    //取反
    btn.selected = !btn.selected;
    
    UIImageView *imageView = (UIImageView *)[self.view viewWithTag:btn.tag+100];
    UILabel *label = (UILabel *)[self.view viewWithTag:btn.tag+200];
    
    if (btn.selected == YES) {
        //临时图片转换
        tempImageView.image = [UIImage imageNamed:normalImageArray[index]];
        imageView.image = [UIImage imageNamed:highlightedImageArray[btn.tag-100]];
        tempImageView = imageView;
        
        //临时标签转换
        tempLabel.textColor = RGBA(100, 100, 100, 1);
        label.textColor = [UIColor redColor];
        tempLabel = label;
        
        //临时按钮转换
        tempButton.selected = NO;
        btn.selected = YES;
        tempButton = btn;
    }
    
    //记录上次按钮
    index  = self.selectedIndex;
}

//自定义UITabBarController 的高度
- (void)viewWillLayoutSubviews {
    //CGRect tabFrame = self.tabBar.frame; //self.TabBar is IBOutlet of your TabBar
    //tabFrame.size.height = 80;
    //tabFrame.size.width = 20;
    //tabFrame.origin.y = self.view.frame.size.height - 80;
    //self.tabBar.frame = tabFrame;
}

-(void)setHidesBottomBarWhenPushed:(BOOL)hidesBottomBarWhenPushed {
    _tabBarBgView.hidden = hidesBottomBarWhenPushed;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
