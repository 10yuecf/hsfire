//
//  SyInfoViewController.m
//  hsfire
//
//  Created by louislee on 2017/9/27.
//  Copyright © 2017年 hsdcw. All rights reserved.
//

#import "SyInfoViewController.h"
#import "MapViewController.h"
#import "Macro.h"
#import "hsdcwUtils.h"
#import "CKHttpCommunicate.h"
#import "MBProgressHUD+Add.h"
#import "UIImageView+WebCache.h"

@interface SyInfoViewController ()
@property (nonatomic, strong) UIView *baceView;
@property (nonatomic, strong) MBProgressHUD *HUD;
@property (nonatomic, strong) UIImageView *p1;
@property (nonatomic, strong) UIImageView *p2;
@property (nonatomic, strong) UIImageView *p3;
@property (nonatomic, strong) UIImageView *p4;
@property (nonatomic, strong) UIImageView *p5;
@property (nonatomic, strong) UILabel *syarealabel;//水源地区
@property (nonatomic, strong) UILabel *sybhlabel;//水源编号
@property (nonatomic, strong) UILabel *sydwlabel;//水源单位
@property (nonatomic, strong) UILabel *sylxlabel;//水源类型
@property (nonatomic, strong) UILabel *syqklabel;//水源情况
@property (nonatomic, strong) UILabel *sylxrlabel;//水源联系人
@property (nonatomic, strong) UILabel *sytellabel;//水源联系人电话
@property (nonatomic, strong) UILabel *syaddrlabel;//水源地址
@end

@implementation SyInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[UINavigationBar appearance] setBarTintColor:[UIColor whiteColor]];
    self.view.backgroundColor = [UIColor colorWithRed:240/255.0f green:240/255.0f blue:240/255.0f alpha:1];
    
    NSLog(@"================%@",self.userEntity.antitle);
    NSLog(@"================%@",self.userEntity.anlat);
    NSLog(@"================%@",self.userEntity.anlon);
    
    [self getSyInfo:self.userEntity.antitle Lat:self.userEntity.anlat Lng:self.userEntity.anlon];
    [self setupNav];
    [self createTextFiled];
}

-(void)backBtnClick {
    CATransition* transition = [CATransition animation];
    transition.type = kCATransitionPush;//可更改为其他方式
    transition.subtype = kCATransitionFromLeft;//可更改为其他方式
    [self.navigationController.view.layer addAnimation:transition forKey:kCATransition];
    
    MapViewController *mapv = [[MapViewController alloc]init];
    [self.navigationController pushViewController:mapv animated:NO];
    //[self.navigationController popViewControllerAnimated:YES];
}

- (void)getSyInfo:(NSString*)sybh Lat:(NSString *)lat Lng:(NSString*)lng {
    hsdcwUtils *utils = [[hsdcwUtils alloc]init];
    
    //加密
    NSString *xf_dt = utils.myencrypt[0];
    NSString *xf_tk = utils.myencrypt[1];
    
    //查询水源信息
    NSDictionary *param_syinfo = @{@"sybh":sybh,
                                  @"lng":lng,
                                  @"lat":lat,
                                  @"xf_dt":xf_dt,
                                  @"xf_tk":xf_tk};
    [CKHttpCommunicate createRequest:GetSyInfo WithParam:param_syinfo withMethod:POST success:^(id response) {
        NSLog(@"%@",response);
        
        if (response) {
            NSString *result = response[@"code"];
            
            if ([result isEqualToString:@"200"]) {
                //NSLog(@"%@",response[@"data"][0][@"syarea"]);
                _syarealabel.text = [NSString stringWithFormat:@"水源地区：%@",response[@"data"][0][@"syarea"]];
                _sybhlabel.text = [NSString stringWithFormat:@"水源编号：%@",response[@"data"][0][@"sybh"]];
                _sydwlabel.text = [NSString stringWithFormat:@"归属单位：%@",response[@"data"][0][@"sydw"]];
                _sylxlabel.text = [NSString stringWithFormat:@"水源类型：%@",response[@"data"][0][@"sytype"]];
                _syqklabel.text = [NSString stringWithFormat:@"水源情况：%@",response[@"data"][0][@"syzt"]];
                _sylxrlabel.text = [NSString stringWithFormat:@"联  系  人：%@",response[@"data"][0][@"sylxr"]];
                _sytellabel.text = [NSString stringWithFormat:@"联系电话：%@",response[@"data"][0][@"sylxtel"]];
                _syaddrlabel.text = [NSString stringWithFormat:@"水源地址：%@",response[@"data"][0][@"syaddr"]];
                
                [_p1 sd_setImageWithURL:response[@"data"][0][@"sypic1"] placeholderImage:[UIImage imageNamed:@"no"]];
                
            }
            else if ([result isEqualToString:@"400"]) {
                NSString *text = response[@"data"][@"text"];
                
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:text message:nil preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil];
                [alert addAction:action];
                [self presentViewController:alert animated:YES completion:nil];
            }
            else if ([result isEqualToString:@"404"]) {
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"网络异常提交失败！" message:nil preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil];
                [alert addAction:action];
                [self presentViewController:alert animated:YES completion:nil];
            }
        }
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    } showHUD:self.view];
    
}

- (void)setupNav {
    self.title = @"水源信息";
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
    
    UIBarButtonItem *saveBtn = [[UIBarButtonItem alloc]initWithTitle:@"导航" style:UIBarButtonItemStylePlain target:self action:@selector(next:)];
    [saveBtn setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:15],NSFontAttributeName,nil] forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem = saveBtn;
    self.navigationItem.rightBarButtonItem.tintColor = [UIColor whiteColor];
}

-(void)createTextFiled {
    int linex = 10; //线x坐标
    int labelx = 10,labely = 7,labelyb = 30,labelw = 300,labelh = 20; //label标签x坐标
    
    //白色背景框
    _baceView = [[UIView alloc]initWithFrame:CGRectMake(10, 10, kWidth - 20, kHeight - 10)];
    _baceView.layer.cornerRadius = 5.0;
    _baceView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_baceView];
    
    _syarealabel = [[UILabel alloc]initWithFrame:CGRectMake(labelx, labely, labelw, labelh)];
    _sybhlabel = [[UILabel alloc]initWithFrame:CGRectMake(labelx, labely + labelyb, labelw, labelh)];
    _sydwlabel = [[UILabel alloc]initWithFrame:CGRectMake(labelx, labely + labelyb * 2, labelw, labelh)];
    _sylxlabel = [[UILabel alloc]initWithFrame:CGRectMake(labelx, labely + labelyb * 3, labelw, labelh)];
    _syqklabel = [[UILabel alloc]initWithFrame:CGRectMake(labelx, labely + labelyb * 4, labelw, labelh)];
    _sylxrlabel = [[UILabel alloc]initWithFrame:CGRectMake(labelx, labely + labelyb * 5, labelw, labelh)];
    _sytellabel = [[UILabel alloc]initWithFrame:CGRectMake(labelx, labely + labelyb * 6, labelw, labelh)];
    _syaddrlabel = [[UILabel alloc]initWithFrame:CGRectMake(labelx, labely + labelyb * 7, labelw, labelh)];
    
    UIImageView *line1 = [[UIImageView alloc]initWithFrame:CGRectMake(linex, labelyb, _baceView.frame.size.width - 30, 1)];
    line1.backgroundColor = [UIColor colorWithRed:180/255.0 green:180/255.0 blue:180/255.0 alpha:0.3];
    [_baceView addSubview:line1];
    
    UIImageView *line2 = [[UIImageView alloc]initWithFrame:CGRectMake(linex, labelyb * 2, _baceView.frame.size.width - 30, 1)];
    line2.backgroundColor = [UIColor colorWithRed:180/255.0 green:180/255.0 blue:180/255.0 alpha:0.3];
    [_baceView addSubview:line2];
    
    UIImageView *line3 = [[UIImageView alloc]initWithFrame:CGRectMake(linex, labelyb * 3, _baceView.frame.size.width - 30, 1)];
    line3.backgroundColor = [UIColor colorWithRed:180/255.0 green:180/255.0 blue:180/255.0 alpha:0.3];
    [_baceView addSubview:line3];
    
    UIImageView *line4 = [[UIImageView alloc]initWithFrame:CGRectMake(linex, labelyb * 4, _baceView.frame.size.width - 30, 1)];
    line4.backgroundColor = [UIColor colorWithRed:180/255.0 green:180/255.0 blue:180/255.0 alpha:0.3];
    [_baceView addSubview:line4];
    
    UIImageView *line5 = [[UIImageView alloc]initWithFrame:CGRectMake(linex, labelyb * 5, _baceView.frame.size.width - 30, 1)];
    line5.backgroundColor = [UIColor colorWithRed:180/255.0 green:180/255.0 blue:180/255.0 alpha:0.3];
    [_baceView addSubview:line5];
    
    UIImageView *line6 = [[UIImageView alloc]initWithFrame:CGRectMake(linex, labelyb * 6, _baceView.frame.size.width - 30, 1)];
    line6.backgroundColor = [UIColor colorWithRed:180/255.0 green:180/255.0 blue:180/255.0 alpha:0.3];
    [_baceView addSubview:line6];
    
    UIImageView *line7 = [[UIImageView alloc]initWithFrame:CGRectMake(linex, labelyb * 7, _baceView.frame.size.width - 30, 1)];
    line7.backgroundColor = [UIColor colorWithRed:180/255.0 green:180/255.0 blue:180/255.0 alpha:0.3];
    [_baceView addSubview:line7];
    
    UIImageView *line8 = [[UIImageView alloc]initWithFrame:CGRectMake(linex, labelyb * 8, _baceView.frame.size.width - 30, 1)];
    line7.backgroundColor = [UIColor colorWithRed:180/255.0 green:180/255.0 blue:180/255.0 alpha:0.3];
    [_baceView addSubview:line8];
    
    _syarealabel.textColor = [UIColor blackColor];
    _syarealabel.textAlignment = NSTextAlignmentLeft;
    _syarealabel.font = [UIFont systemFontOfSize:12];
    [_baceView addSubview:_syarealabel];
    
    _sybhlabel.textColor = [UIColor blackColor];
    _sybhlabel.textAlignment = NSTextAlignmentLeft;
    _sybhlabel.font = [UIFont systemFontOfSize:12];
    [_baceView addSubview:_sybhlabel];
    
    _sydwlabel.text = @"归属单位：";
    _sydwlabel.textColor = [UIColor blackColor];
    _sydwlabel.textAlignment = NSTextAlignmentLeft;
    _sydwlabel.font = [UIFont systemFontOfSize:12];
    [_baceView addSubview:_sydwlabel];
    
    _sylxlabel.text = @"水源类型：";
    _sylxlabel.textColor = [UIColor blackColor];
    _sylxlabel.textAlignment = NSTextAlignmentLeft;
    _sylxlabel.font = [UIFont systemFontOfSize:12];
    [_baceView addSubview:_sylxlabel];
    
    _syqklabel.text = @"水源情况：";
    _syqklabel.textColor = [UIColor blackColor];
    _syqklabel.textAlignment = NSTextAlignmentLeft;
    _syqklabel.font = [UIFont systemFontOfSize:12];
    [_baceView addSubview:_syqklabel];
    
    _sylxrlabel.text = @"联  系  人：";
    _sylxrlabel.textColor = [UIColor blackColor];
    _sylxrlabel.textAlignment = NSTextAlignmentLeft;
    _sylxrlabel.font = [UIFont systemFontOfSize:12];
    [_baceView addSubview:_sylxrlabel];
    
    _sytellabel.text = @"联系电话：";
    _sytellabel.textColor = [UIColor blackColor];
    _sytellabel.textAlignment = NSTextAlignmentLeft;
    _sytellabel.font = [UIFont systemFontOfSize:12];
    [_baceView addSubview:_sytellabel];
    
    _syaddrlabel.text = @"水源地址：";
    _syaddrlabel.textColor = [UIColor blackColor];
    _syaddrlabel.textAlignment = NSTextAlignmentLeft;
    _syaddrlabel.font = [UIFont systemFontOfSize:12];
    [_baceView addSubview:_syaddrlabel];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end