//
//  SyAddViewController.m
//  hsfire
//
//  Created by louislee on 2017/9/23.
//  Copyright © 2017年 hsdcw. All rights reserved.
//
#import <AVFoundation/AVFoundation.h>
#import <sqlite3.h>
#import "MapViewController.h"
#import "SyAddViewController.h"
#import "UITextField+Shake.h"
#import "UIImageView+WebCache.h"
#import "User.h"
#import "UserTool.h"
#import "hsdcwUtils.h"
#import "UserEntity.h"
#import "MyMD5.h"
#import "CKHttpCommunicate.h"
#import "Macro.h"
#import "MBProgressHUD+Add.h"
#import "CustomAlertView.h"
#import "AFNetworking.h"
#import "CustomHUD.h"

#import "STPickerArea.h"
#import "STPickerSingle.h"
#import "STPickerDate.h"

#import "MXBasePhotoView.h"

#define IOS7DEVICE ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)
#define DOCUMENTS_FOLDER_TEMPIMAGE [NSHomeDirectory() stringByAppendingFormat:@"/Library/Caches/tempimage/"]
//调整间隙
#define SPACES 10

@interface SyAddViewController ()<UITextFieldDelegate, STPickerAreaDelegate, STPickerSingleDelegate, UIImagePickerControllerDelegate, MXBasePhotoViewDelegate> {
    CGFloat _viewDefaultHeight;
}
@property (nonatomic, strong) UIView *baceView;
@property (nonatomic, strong) UIView *photoView;
@property (nonatomic, strong) UITextField *syaddrText; //水源地址
@property (nonatomic, strong) UITextField *syareaText; //水源地区
@property (nonatomic, strong) UITextField *sylanText;  //水源经度
@property (nonatomic, strong) UITextField *sylonText;  //水源纬度
@property (nonatomic, strong) UITextField *sybhText;   //水源编号
@property (nonatomic, strong) UITextField *sydwText;   //水源单位
@property (nonatomic, strong) UITextField *sylxText;   //水源类型
@property (nonatomic, strong) UITextField *syqkText;   //水源情况
@property (nonatomic, strong) UITextField *sylxrText;   //水源联系人
@property (nonatomic, strong) UITextField *sytelText;   //水源联系人电话
@property (nonatomic, strong) UIImage *headImage;
@property (nonatomic, strong) MBProgressHUD *HUD;
@property (nonatomic, strong) NSString *str;
@property (nonatomic, strong) UIImageView *p1;
@property (nonatomic, strong) UIImageView *p2;
@property (nonatomic, strong) UIImageView *p3;
@property (nonatomic, strong) UIImageView *p4;
@property (nonatomic, strong) UIImageView *p5;
@property (nonatomic, assign) int upcot;
@property (nonatomic, strong) NSString *uid; //uid
@property (nonatomic, strong) NSString *devcode; //devcode
//一行显示几个图片
@property (nonatomic) NSInteger showNum;
//图片宽 高
@property (nonatomic) CGFloat imageWidth;
@property (nonatomic) CGFloat imageHeight;
//删除按钮
@property (nonatomic , strong) UIButton *deleBt;

@property (nonatomic, strong) UIScrollView *scrollView;
@end

@implementation SyAddViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[UINavigationBar appearance] setBarTintColor:[UIColor whiteColor]];
    self.view.backgroundColor = [UIColor colorWithRed:240/255.0f green:240/255.0f blue:240/255.0f alpha:1];
    
    NSLog(@"================%@",self.userEntity.title);
    NSLog(@"================%@",self.userEntity.lat);
    NSLog(@"================%@",self.userEntity.lon);
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    self.sybhText.delegate = self;
    self.syareaText.delegate = self;
    self.sydwText.delegate = self;
    self.sylxText.delegate = self;
    self.syqkText.delegate = self;
    
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

- (void)setupNav {
    self.title = @"水源上报";
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
    
    UIBarButtonItem *saveBtn = [[UIBarButtonItem alloc]initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(next:)];
    [saveBtn setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:15],NSFontAttributeName,nil] forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem = saveBtn;
    self.navigationItem.rightBarButtonItem.tintColor = [UIColor whiteColor];
    
    _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, kWidth, 490)];
    //_scrollView.backgroundColor = [UIColor blueColor];
    _scrollView.contentSize = self.view.bounds.size;
    CGSize size = self.view.bounds.size;
    NSLog(@"size: %@",NSStringFromCGSize(size));
    [self.view addSubview:_scrollView];
    
    UITapGestureRecognizer *myTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(scrollTap:)];
    [_scrollView addGestureRecognizer:myTap];
}

-(void)scrollTap:(id)sender {
    [self.view endEditing:YES];
}

-(void)createTextFiled {
    int linex = 10; //线x坐标
    int labelx = 10,labely = 10,labelyb = 40,labelw = 60,labelh = 25; //label标签x坐标
    int inputx = 75,inputy = 8,inputyb = 40,inputw = 200,inputh = 30; //文本框x坐标
    
    //白色背景框
    _baceView = [[UIView alloc]initWithFrame:CGRectMake(10, 10, kWidth - 20, 470)];
    _baceView.layer.cornerRadius = 5.0;
    _baceView.backgroundColor = [UIColor whiteColor];
    [_scrollView addSubview:_baceView];
    
    //照片view
    _photoView = [[UIView alloc]initWithFrame:CGRectMake(10, labelyb * 10, kWidth - 20, 160)];
    _photoView.backgroundColor = [UIColor whiteColor];
    [_scrollView addSubview:_photoView];
    
    UILabel *syarealabel = [[UILabel alloc]initWithFrame:CGRectMake(labelx, labely, labelw, labelh)];
    UILabel *sybhlabel = [[UILabel alloc]initWithFrame:CGRectMake(labelx, labely + labelyb, labelw, labelh)];
    UILabel *sydwlabel = [[UILabel alloc]initWithFrame:CGRectMake(labelx, labely + labelyb * 2, labelw, labelh)];
    UILabel *sylxlabel = [[UILabel alloc]initWithFrame:CGRectMake(labelx, labely + labelyb * 3, labelw, labelh)];
    UILabel *syqklabel = [[UILabel alloc]initWithFrame:CGRectMake(labelx, labely + labelyb * 4, labelw, labelh)];
    UILabel *sylxrlabel = [[UILabel alloc]initWithFrame:CGRectMake(labelx, labely + labelyb * 5, labelw, labelh)];
    UILabel *sytellabel = [[UILabel alloc]initWithFrame:CGRectMake(labelx, labely + labelyb * 6, labelw, labelh)];
    UILabel *syaddrlabel = [[UILabel alloc]initWithFrame:CGRectMake(labelx, labely + labelyb * 7, labelw, labelh)];
    UILabel *sylatlabel = [[UILabel alloc]initWithFrame:CGRectMake(labelx, labely + labelyb * 8, labelw, labelh)];
    UILabel *sylnglabel = [[UILabel alloc]initWithFrame:CGRectMake(labelx, labely + labelyb * 9, labelw, labelh)];
    
    _syareaText = [self createTextFiledWithFrame:CGRectMake(inputx, inputy, inputw, inputh) font:[UIFont systemFontOfSize:14] placeholder:@"请选择水源地区"];
    _sybhText = [self createTextFiledWithFrame:CGRectMake(inputx, inputy + inputyb, inputw, inputh) font:[UIFont systemFontOfSize:14] placeholder:@"请输入水源编号"];
    _sydwText = [self createTextFiledWithFrame:CGRectMake(inputx, inputy + inputyb * 2, inputw, inputh) font:[UIFont systemFontOfSize:14] placeholder:@"请选择水源归属单位"];
    _sylxText = [self createTextFiledWithFrame:CGRectMake(inputx, inputy + inputyb * 3, inputw, inputh) font:[UIFont systemFontOfSize:14] placeholder:@"请选择水源类型"];
    _syqkText = [self createTextFiledWithFrame:CGRectMake(inputx, inputy + inputyb * 4, inputw, inputh) font:[UIFont systemFontOfSize:14] placeholder:@"请选择水源情况"];
    _sylxrText = [self createTextFiledWithFrame:CGRectMake(inputx, inputy + inputyb * 5, inputw, inputh) font:[UIFont systemFontOfSize:14] placeholder:@"请输入水源联系人"];
    _sytelText = [self createTextFiledWithFrame:CGRectMake(inputx, inputy + inputyb * 6, inputw, inputh) font:[UIFont systemFontOfSize:14] placeholder:@"请输入水源联系人电话"];
    _syaddrText = [self createTextFiledWithFrame:CGRectMake(inputx, inputy + inputyb * 7, inputw, inputh) font:[UIFont systemFontOfSize:14] placeholder:@"请输入水源详细地址"];
    _sylanText = [self createTextFiledWithFrame:CGRectMake(inputx, inputy + inputyb * 8, inputw, inputh) font:[UIFont systemFontOfSize:14] placeholder:@"请输入水源纬度"];
    _sylonText = [self createTextFiledWithFrame:CGRectMake(inputx, inputy + inputyb * 9, inputw, inputh) font:[UIFont systemFontOfSize:14] placeholder:@"请输入水源经度"];
    
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
    line8.backgroundColor = [UIColor colorWithRed:180/255.0 green:180/255.0 blue:180/255.0 alpha:0.3];
    [_baceView addSubview:line8];
    
    UIImageView *line9 = [[UIImageView alloc]initWithFrame:CGRectMake(linex, labelyb * 9, _baceView.frame.size.width - 30, 1)];
    line9.backgroundColor = [UIColor colorWithRed:180/255.0 green:180/255.0 blue:180/255.0 alpha:0.3];
    [_baceView addSubview:line9];
    
    syarealabel.text = @"水源地区";
    syarealabel.textColor = [UIColor blackColor];
    syarealabel.textAlignment = NSTextAlignmentLeft;
    syarealabel.font = [UIFont systemFontOfSize:14];
    [_baceView addSubview:syarealabel];
    
    _syareaText.clearButtonMode = UITextFieldViewModeWhileEditing;
    _syareaText.delegate = self;
    [_baceView addSubview:_syareaText];
    
    sybhlabel.text = @"水源编号";
    sybhlabel.textColor = [UIColor blackColor];
    sybhlabel.textAlignment = NSTextAlignmentLeft;
    sybhlabel.font = [UIFont systemFontOfSize:14];
    [_baceView addSubview:sybhlabel];
    
    _sybhText.clearButtonMode = UITextFieldViewModeWhileEditing;
    _sybhText.delegate = self;
    _sybhText.tag = 0;
    [_baceView addSubview:_sybhText];
    
    sydwlabel.text = @"归属单位";
    sydwlabel.textColor = [UIColor blackColor];
    sydwlabel.textAlignment = NSTextAlignmentLeft;
    sydwlabel.font = [UIFont systemFontOfSize:14];
    [_baceView addSubview:sydwlabel];
    
    _sydwText.clearButtonMode = UITextFieldViewModeWhileEditing;
    _sydwText.delegate = self;
    [_baceView addSubview:_sydwText];
    
    sylxlabel.text = @"水源类型";
    sylxlabel.textColor = [UIColor blackColor];
    sylxlabel.textAlignment = NSTextAlignmentLeft;
    sylxlabel.font = [UIFont systemFontOfSize:14];
    [_baceView addSubview:sylxlabel];
    
    _sylxText.clearButtonMode = UITextFieldViewModeWhileEditing;
    _sylxText.delegate = self;
    [_baceView addSubview:_sylxText];
    
    syqklabel.text = @"水源情况";
    syqklabel.textColor = [UIColor blackColor];
    syqklabel.textAlignment = NSTextAlignmentLeft;
    syqklabel.font = [UIFont systemFontOfSize:14];
    [_baceView addSubview:syqklabel];
    
    _syqkText.clearButtonMode = UITextFieldViewModeWhileEditing;
    _syqkText.delegate = self;
    [_baceView addSubview:_syqkText];
    
    sylxrlabel.text = @"联  系  人";
    sylxrlabel.textColor = [UIColor blackColor];
    sylxrlabel.textAlignment = NSTextAlignmentLeft;
    sylxrlabel.font = [UIFont systemFontOfSize:14];
    [_baceView addSubview:sylxrlabel];
    
    _sylxrText.clearButtonMode = UITextFieldViewModeWhileEditing;
    _sylxrText.delegate = self;
    [_baceView addSubview:_sylxrText];
    
    sytellabel.text = @"联系电话";
    sytellabel.textColor = [UIColor blackColor];
    sytellabel.textAlignment = NSTextAlignmentLeft;
    sytellabel.font = [UIFont systemFontOfSize:14];
    [_baceView addSubview:sytellabel];
    
    _sytelText.clearButtonMode = UITextFieldViewModeWhileEditing;
    _sytelText.delegate = self;
    _sytelText.keyboardType = UIKeyboardTypeNumberPad;
    [_baceView addSubview:_sytelText];
    
    syaddrlabel.text = @"水源地址";
    syaddrlabel.textColor = [UIColor blackColor];
    syaddrlabel.textAlignment = NSTextAlignmentLeft;
    syaddrlabel.font = [UIFont systemFontOfSize:14];
    [_baceView addSubview:syaddrlabel];
    
    _syaddrText.clearButtonMode = UITextFieldViewModeWhileEditing;
    _syaddrText.delegate = self;
    _syaddrText.text = self.userEntity.title;
    _syaddrText.font = [UIFont systemFontOfSize:10];
    [_baceView addSubview:_syaddrText];
    
    sylnglabel.text = @"水源经度";
    sylnglabel.textColor = [UIColor blackColor];
    sylnglabel.textAlignment = NSTextAlignmentLeft;
    sylnglabel.font = [UIFont systemFontOfSize:14];
    [_baceView addSubview:sylnglabel];
    
    _sylonText.clearButtonMode = UITextFieldViewModeWhileEditing;
    _sylonText.delegate = self;
    _sylonText.enabled = NO;
    _sylonText.text = self.userEntity.lon;
    [_baceView addSubview:_sylonText];
    
    sylatlabel.text = @"水源纬度";
    sylatlabel.textColor = [UIColor blackColor];
    sylatlabel.textAlignment = NSTextAlignmentLeft;
    sylatlabel.font = [UIFont systemFontOfSize:14];
    [_baceView addSubview:sylatlabel];
    
    _sylanText.clearButtonMode = UITextFieldViewModeWhileEditing;
    _sylanText.delegate = self;
    _sylanText.enabled = NO;
    _sylanText.text = self.userEntity.lat;
    [_baceView addSubview:_sylanText];
    
    UIButton *landBtn = [[UIButton alloc]initWithFrame:CGRectMake(10,_baceView.frame.size.height + _baceView.frame.origin.y + 10, _baceView.frame.size.width, 37)];
    [landBtn setTitle:@"提交" forState:UIControlStateNormal];
    [landBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    landBtn.titleLabel.font = [UIFont systemFontOfSize:17];
    [landBtn addTarget:self action:@selector(next:) forControlEvents:UIControlEventTouchUpInside];
    landBtn.backgroundColor = [UIColor colorWithRed:204/255.0f green:0/255.0f blue:0/255.0f alpha:1];
    landBtn.layer.cornerRadius = 5.0;
    //[self.view addSubview:landBtn];
    
    //拍照按钮
    UIButton *photoBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    photoBtn.frame = CGRectMake(20, inputy + inputyb * 6 + 50, 60, 60);
    photoBtn.titleLabel.text = @"photoimg";
    [photoBtn setImage:[UIImage imageNamed:@"photo.png"] forState:UIControlStateNormal];
    [photoBtn.layer setMasksToBounds:YES];
    [photoBtn.layer setCornerRadius:3.0];
    [photoBtn addTarget:self action:@selector(uploadHeadImg:) forControlEvents:UIControlEventTouchUpInside];
    //[self.view addSubview:photoBtn];
    
    //初始化图片视图 加手势 点击弹框提示选择拍照or相册
    UIImageView *mxImageV = [[UIImageView alloc] initWithFrame:CGRectMake(SPACES, SPACES+5, 60, 60)];
    _viewDefaultHeight = self.view.frame.size.height;
    _imageWidth = 70;
    _imageHeight = 70;
    mxImageV.tag = 100;
    mxImageV.image = [UIImage imageNamed:@"choose_add"];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickImageToSelect:)];
    mxImageV.userInteractionEnabled = YES;
    [mxImageV addGestureRecognizer:tap];
    [_photoView addSubview:mxImageV];
}

- (void)clickImageToSelect:(UITapGestureRecognizer *)tap {
    //NSLog(@"拍照");
    hsdcwUtils *utils = [[hsdcwUtils alloc]init];
    _str = @"photo";
    
    NSString *sybh = _sybhText.text;
    if ([utils isBlankString:sybh]) {
        [MBProgressHUD showError:@"请输入水源编号" toView:self.view];
    }
    else {
        if(_upcot >= 5) {
            [MBProgressHUD showError:@"对不起，最多只能上传五张照片！" toView:self.view];
        }
        else {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"上传照片" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
            UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
            UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [self snapImage];
            }];
            UIAlertAction *action3 = [UIAlertAction actionWithTitle:@"从相册中上传" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [self localPhoto];
            }];
            [alert addAction:action1];
            [alert addAction:action2];
            [alert addAction:action3];
            
            [self presentViewController:alert animated:YES completion:nil];
        }
    }
}

- (void)uploadHeadImg:(UIButton *)sender {
    NSLog(@"拍照");
    _str = @"photo";
    
    if(_upcot >= 5) {
        [MBProgressHUD showError:@"最多只能上传五张照片！" toView:self.view];
    }
    else {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"上传照片" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self snapImage];
        }];
        UIAlertAction *action3 = [UIAlertAction actionWithTitle:@"从相册中上传" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self localPhoto];
        }];
        [alert addAction:action1];
        [alert addAction:action2];
        [alert addAction:action3];
        
        [self presentViewController:alert animated:YES completion:nil];
    }
}

-(void)next:(UIButton *)button {
    hsdcwUtils *utils = [[hsdcwUtils alloc]init];
    //读取本地数据用户token
    //NSArray *u_arr = [utils getUserInfo];
    
    NSString *chkuser = [NSString stringWithFormat:@"select * from t_user where loginstatus = '1' limit 1"];
    NSMutableArray *user_arr = [UserTool userWithSql:chkuser];
    User *u = user_arr[0];
    
    //加密
    NSString *xf_dt = utils.myencrypt[0];
    NSString *xf_tk = utils.myencrypt[1];
    
    //提交注册完成接口
    NSString *syaddr = _syaddrText.text;
    NSString *sylat = self.userEntity.lat;
    NSString *sylon = self.userEntity.lon;
    NSString *syarea = _syareaText.text;
    NSString *sybh = _sybhText.text;
    NSString *sydw = _sydwText.text;
    NSString *sylx = _sylxText.text;
    NSString *syqk = _syqkText.text;
    NSString *sylxr = _sylxrText.text;
    NSString *sytel = _sytelText.text;
    NSString *addp = u.name;
    NSString *uid = u.userID;
    NSString *devcode = u.devicetoken;
    
    if ([utils isBlankString:syaddr]) {
        [MBProgressHUD showError:@"未获取到水源地址，请返回上页重新获取" toView:self.view];
    }
    else if ([utils isBlankString:sylat]) {
        [MBProgressHUD showError:@"未获取到水源经度，请返回上页重新获取" toView:self.view];
    }
    else if ([utils isBlankString:sylon]) {
        [MBProgressHUD showError:@"未获取到水源维度，请返回上页重新获取" toView:self.view];
    }
    else if ([utils isBlankString:syarea]) {
        [MBProgressHUD showError:@"请选择水源地区" toView:self.view];
    }
    else if ([utils isBlankString:sybh]) {
        [MBProgressHUD showError:@"请输入水源编号" toView:self.view];
    }
    else if ([utils isBlankString:sydw]) {
        [MBProgressHUD showError:@"请选择水源归属单位" toView:self.view];
    }
    else if ([utils isBlankString:sylx]) {
        [MBProgressHUD showError:@"请选择水源类型" toView:self.view];
    }
    else if ([utils isBlankString:syqk]) {
        [MBProgressHUD showError:@"请选择水源情况" toView:self.view];
    }
    else if ([utils isBlankString:sylxr]) {
        [MBProgressHUD showError:@"请输入水源联系人" toView:self.view];
    }
    else if (![utils validateMobile:sytel]) {
        [MBProgressHUD showError:@"请输入正确的联系电话" toView:self.view];
    }
    else if(_upcot < 1) {
        [MBProgressHUD showError:@"请上传一张水源照片" toView:self.view];
    }
    else {
        //验证水源编号是否存在
        NSDictionary *param_syadd = @{@"syaddr":syaddr,
                                      @"sylat":sylat,
                                      @"sylon":sylon,
                                      @"syarea":syarea,
                                      @"sybh":sybh,
                                      @"sydw":sydw,
                                      @"sylx":sylx,
                                      @"syqk":syqk,
                                      @"sylxr":sylxr,
                                      @"sytel":sytel,
                                      @"addp":addp,
                                      @"uid":uid,
                                      @"devcode":devcode,
                                      @"devtype":@"ios",
                                      @"xf_dt":xf_dt,
                                      @"xf_tk":xf_tk};
        
        [CKHttpCommunicate createRequest:Sybhchk WithParam:param_syadd withMethod:POST success:^(id response) {
            //NSLog(@"%@",response);
            
            if (response) {
                NSString *result = response[@"code"];
                
                if ([result isEqualToString:@"200"]) {
                    //NSLog(@"添加成功");
                    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"添加成功！" message:nil preferredStyle:UIAlertControllerStyleAlert];

                    UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                        //返回
                        [self backBtnClick];
                    }];

                    [alert addAction:action];
                    [self presentViewController:alert animated:YES completion:nil];
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
}

-(UITextField *)createTextFiledWithFrame:(CGRect)frame font:(UIFont *)font placeholder:(NSString *)placeholder {
    UITextField *textField = [[UITextField alloc]initWithFrame:frame];
    textField.font  =font;
    textField.textColor = [UIColor grayColor];
    textField.borderStyle = UITextBorderStyleNone;
    textField.placeholder = placeholder;
    return textField;
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    //NSLog(@"%ld",(long)textField.tag);
    //NSLog(@"%@",textField);
    NSInteger tag = textField.tag;
    if (tag == 0 || tag == 4) {
        [self.view endEditing:YES];
    }
    
    return YES;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

- (void)pickerArea:(STPickerArea *)pickerArea province:(NSString *)province city:(NSString *)city area:(NSString *)area {
    NSString *text = [NSString stringWithFormat:@"%@ %@ %@", province, city, area];
    self.syareaText.text = text;
}

- (void)pickerSingle:(STPickerSingle *)pickerSingle selectedTitle:(NSString *)selectedTitle selectFlag:(NSString *)selectFlag {
    NSString *text = [NSString stringWithFormat:@"%@", selectedTitle];
    
    //NSLog(@"%@",selectFlag);
    if ([selectFlag isEqualToString:@"syarea"]) {
        self.syareaText.text = text;
    }
    else if ([selectFlag isEqualToString:@"sydw"]) {
        self.sydwText.text = text;
    }
    else if ([selectFlag isEqualToString:@"sylx"]) {
        self.sylxText.text = text;
    }
    else if ([selectFlag isEqualToString:@"syqk"]) {
        self.syqkText.text = text;
    }
}

#pragma mark - --- delegate 视图委托 ---
- (void)textFieldDidBeginEditing:(UITextField *)textField {
    
    if (textField == self.syareaText) {
        //NSLog(@"=======111111");
        [self.syareaText resignFirstResponder];
        
        //接口
        NSMutableArray *arrayData = [NSMutableArray array];
        
        [arrayData addObject:@"黄石港区"];
        [arrayData addObject:@"西塞山区"];
        [arrayData addObject:@"开发区"];
        [arrayData addObject:@"大冶市"];
        [arrayData addObject:@"阳新县"];
        [arrayData addObject:@"铁山区"];
        [arrayData addObject:@"下陆区"];
        
        STPickerSingle *single = [[STPickerSingle alloc]init];
        [single setArrayData:arrayData];
        [single setTitle:@"请选择水源地区"];
        [single setFlag:@"syarea"];
        [single setDelegate:self];
        [single show];
    }
    
    if (textField == self.sydwText) {
        [self.sydwText resignFirstResponder];
        
        //接口
        NSMutableArray *arrayData = [NSMutableArray array];
        
        [arrayData addObject:@"市政"];
        [arrayData addObject:@"非市政"];
        
        STPickerSingle *single = [[STPickerSingle alloc]init];
        [single setArrayData:arrayData];
        [single setTitle:@"请选择水源单位"];
        [single setFlag:@"sydw"];
        [single setDelegate:self];
        [single show];
    }
    
    if (textField == self.sylxText) {
        [self.sylxText resignFirstResponder];
        
        //接口
        NSMutableArray *arrayData = [NSMutableArray array];
        
        [arrayData addObject:@"消防栓"];
        [arrayData addObject:@"天然湖泊"];
        [arrayData addObject:@"其他"];
        
        STPickerSingle *single = [[STPickerSingle alloc]init];
        [single setArrayData:arrayData];
        [single setTitle:@"请选择水源类型"];
        [single setFlag:@"sylx"];
        [single setDelegate:self];
        [single show];
    }
    
    if (textField == self.syqkText) {
        [self.syqkText resignFirstResponder];
        
        //接口
        NSMutableArray *arrayData = [NSMutableArray array];
        
        [arrayData addObject:@"完好"];
        [arrayData addObject:@"损坏"];
        [arrayData addObject:@"维修中"];
        [arrayData addObject:@"可取水"];
        [arrayData addObject:@"不可取水"];
        
        STPickerSingle *single = [[STPickerSingle alloc]init];
        [single setArrayData:arrayData];
        [single setTitle:@"请选择水源情况"];
        [single setFlag:@"syqk"];
        [single setDelegate:self];
        [single show];
    }
}

//-------------------------------上传图片处理------------------------------------------
//打开摄像头
-(void)snapImage {
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        __block UIImagePickerController *ipc = [[UIImagePickerController alloc] init];
        ipc.sourceType = UIImagePickerControllerSourceTypeCamera;
        ipc.delegate = self;
        ipc.allowsEditing = YES;
        ipc.navigationBar.barTintColor =[UIColor whiteColor];
        ipc.navigationBar.tintColor = [UIColor whiteColor];
        ipc.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:[UIColor whiteColor]};
        [self presentViewController:ipc animated:YES completion:^{
            NSLog(@"已经拍照成功");
            ipc = nil;
        }];
    }
    else {
        NSLog(@"模拟器无法打开照相机");
    }
}

//选择本地照片
-(void)localPhoto {
    UIImagePickerController *pickImage = [[UIImagePickerController alloc]init];
    UIImagePickerControllerSourceType sourceType ;
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]){
        sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }
    else {
        [CustomAlertView showCustomAlertViewWithContent:@"您的设备没有相册或相册不可用" andRect:KTOASTRECT andTime:1.50f andObject:self];
        return;
    }
    
    pickImage.delegate = self;
    pickImage.sourceType = sourceType;
    pickImage.allowsEditing = YES;
    [self presentViewController:pickImage animated:YES completion:nil];
}

#pragma mark UIImagePickerControllerDelegate
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    //NSLog(@"%@",info);
    //NSLog(@"%@",_str);
    
    UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
    [picker dismissViewControllerAnimated:YES completion:^{
        [self useImage:image uType:_str];
    }];
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:nil];
}

//使用图片压缩图片
- (void)useImage:(UIImage *)image uType:(NSString *)uType {
    //NSLog(@"with-----%f-----%f",image.size.width,image.size.height);
    @autoreleasepool {
        float scales = image.size.height / image.size.width;
        UIImage * normalImg;
        NSData *newData;
        if (image.size.width > 600 || image.size.height > 600) {
            if (scales > 1) {
                normalImg = [self imageWithImageSimple:image scaledToSize:CGSizeMake(600 / scales, 600)];
            }
            else {
                normalImg = [self imageWithImageSimple:image scaledToSize:CGSizeMake(600 ,600 * scales)];
            }
        }
        else {
            normalImg = image;
        }
        
        CGSize newSize = CGSizeMake(normalImg.size.width, normalImg.size.height);
        UIGraphicsBeginImageContext(newSize);
        [normalImg drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
        UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        float kk = 1.0f;//图片压缩系数
        int mm;//压缩后的大小
        float aa = 0.1f;//图片压缩系数变化步长(可变)
        mm = (int)UIImageJPEGRepresentation(newImage, kk).length;
        while (mm/1024>450) {
            if (kk>aa+aa/10) {
                kk-=aa;
                if (mm==(int)UIImageJPEGRepresentation(newImage, kk).length) {
                    break;
                }
                mm=(int)UIImageJPEGRepresentation(newImage, kk).length;
            }
            else {
                aa/=10;
            }
        }
        newData = UIImageJPEGRepresentation(newImage, kk);//最后压缩结果
        
        //NSLog(@"%lu",newData.length);
        //NSLog(@"%lu",newData.length/1024);
        if (newData.length/1024 > 450) {
            [CustomAlertView showCustomAlertViewWithContent:@"上传图片过大,请处理后重新上传" andRect:KTOASTRECT andTime:2.0f andObject:self];
        }
        else {
            self.headImage = [UIImage imageWithData:newData];
            [CustomAlertView showCustomAlertViewWithContent:@"上传成功" andRect:KTOASTRECT andTime:1.50f andObject:self];
            //将处理后的图片上传至后台服务器
            [self setUploadHeadImageRequest:newData uType:uType];
        }
    }
}

-(void)setUploadHeadImageRequest:(NSData*)imageData uType:(NSString *)uType {
    //hsdcwUtils *utils = [[hsdcwUtils alloc]init];
    //NSArray *u_arr = [utils getUserInfo];
    
    NSString *chkuser = [NSString stringWithFormat:@"select * from t_user where loginstatus = '1' limit 1"];
    NSMutableArray *user_arr = [UserTool userWithSql:chkuser];
    
    NSString *uid;
    NSString *devcode;
    NSString *sybh = _sybhText.text;
    
    if (user_arr.count == 0) {
        [MBProgressHUD showError:@"未获取到用户登录信息，请重新登录！" toView:self.view];
        uid = @"0";
        devcode = @"no";
    }
    else {
        User *u = user_arr[0];
        uid = u.userID;
        _uid = uid; //赋值给全局变量
        devcode = u.devicetoken;
        _devcode = devcode; //赋值给全局变量
        //NSLog(@"%@",uid);
        
        NSDictionary *dic = @{@"uid":uid,@"devcode":devcode,@"uptype":@"photo",@"sybh":sybh};
        [self updateImageToServer:imageData paramDict:dic];
        //图片上传网络服务器
        [CustomAlertView showCustomAlertViewWithContent:@"正在上传中..." andRect:KTOASTRECT andTime:1.50f andObject:self];
    }
}

/*上传图片*/
- (void)updateImageToServer:(NSData *)imageData paramDict:(NSDictionary *)paramDict {
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"text/plain", nil];
    
    // 上传文件时，文件不允许被覆盖(文件重名)
    //可以在上传时使用当前的系统时间作为文件名
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyyMMddHHmmss";
    NSString *str = [formatter stringFromDate:[NSDate date]];
    NSString *fileName = [NSString stringWithFormat:@"%@.png", str];
    
    _upcot++;
    int viewtag = 100 + _upcot;
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:paramDict];
    [dict setValue:[NSNumber numberWithInt:viewtag] forKey:@"apptag"];
    [dict setValue:@"ios" forKey:@"devtype"];
    //NSLog(@"new dict is%@",dict);
    
    [self hudTipWillShow:YES];
    NSString *urlStr = @"http://10yue.hsdcw.com/fireyun/api/socket.php?action=up";
    [manager POST:urlStr parameters:dict constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        [self hudTipWillShow:NO];
        
        //imageData 要上传的[二进制数据]
        //type 对应网站上处理文件的[字段"file"]
        //fileName 要保存在服务器上的[文件名]
        //image/png 上传文件的[mimeType]
        [formData appendPartWithFileData:imageData name:paramDict[@"uptype"] fileName:fileName mimeType:@"image/png"];
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        //NSLog(@"上传中...");
        self.HUD.progress = uploadProgress.fractionCompleted;
        _HUD.labelText = [NSString stringWithFormat:@"%2.f%%",uploadProgress.fractionCompleted*100];
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable response) {
        //NSLog(@"上传=======%@",response);
        
        NSString *result = response[@"code"];
        if ([result isEqualToString:@"200"]) {
            NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
            NSString *filePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@",fileName]];
            UIImage *headimg = [UIImage imageWithData:imageData];
            BOOL result = [UIImagePNGRepresentation(headimg)writeToFile:filePath atomically:YES]; //保存成功会返回YES
            if (result) {
                if ([paramDict[@"uptype"] isEqualToString:@"avata"]) {
                    //记录本地库
                    //更新其他数据为未登录状态
                    NSString *upall = [NSString stringWithFormat:@"update t_user set photo_s = '%@'",fileName];
                    [UserTool userWithSql:upall];
                }
                
                //NSLog(@"filepath %@",filePath);
                //NSLog(@"filename %@",fileName);
                
                [self addImageLayoutSubviews];
                MXBasePhotoView *imageView = [[MXBasePhotoView alloc] initWithFrame:CGRectMake(SPACES, SPACES, _imageWidth, _imageHeight)];
                imageView.tag = viewtag;
                imageView.photoDelegate = self;
                imageView.showImageView.image = [UIImage imageNamed:filePath];
                imageView.deleBt.tag = viewtag;
                [_photoView addSubview:imageView];
            }
            
            [self hudTipWillShow:NO];
            [CustomAlertView showCustomAlertViewWithContent:@"上传成功！" andRect:KTOASTRECT andTime:1.50f andObject:self];
        }
        else {
            [CustomAlertView showCustomAlertViewWithContent:@"上传失败，请重试!" andRect:KTOASTRECT andTime:1.50f andObject:self];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        //NSLog(@"%@", task.currentRequest.allHTTPHeaderFields);
        //NSLog(@"%@", error);
        [self hudTipWillShow:NO];
        [CustomAlertView showCustomAlertViewWithContent:@"上传失败！" andRect:KTOASTRECT andTime:1.50f andObject:self];
    }];
}

#pragma mark -- init MBProgressHUD
- (void)hudTipWillShow:(BOOL)willShow {
    if (willShow) {
        [self resignFirstResponder];
        UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
        if (!_HUD) {
            _HUD = [MBProgressHUD showHUDAddedTo:keyWindow animated:YES];
            _HUD.mode = MBProgressHUDModeDeterminateHorizontalBar;
            _HUD.progress = 0;
            _HUD.labelText = @"0%";
            _HUD.removeFromSuperViewOnHide = YES;
        }
        else {
            _HUD.progress = 0;
            _HUD.labelText = @"0%";
            [keyWindow addSubview:_HUD];
            [_HUD show:YES];
        }
    }
    else {
        [_HUD hide:YES];
    }
}

//图片处理
-(UIImage*)imageWithImageSimple:(UIImage*)image scaledToSize:(CGSize)newSize {
    UIGraphicsBeginImageContext(newSize);
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

- (void)addImageWithRect:(CGRect)rect andCorlor:(UIColor *)corlor andTag:(NSInteger)tag andWidth:(CGFloat)width andSuperView:(UIView *)superView WithImage:(UIImage *)image {
    if (![superView viewWithTag:tag]) {
        UIImageView * imageView = [[UIImageView alloc] initWithFrame:rect];
        [imageView setUserInteractionEnabled:NO];
        imageView.layer.cornerRadius = rect.size.width / 2;
        imageView.layer.masksToBounds = YES;
        //imageView.layer.borderWidth = width;
        imageView.image = image;
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        [superView addSubview:imageView];
    }
    else {
        UIImageView * imageView = (UIImageView *)[superView viewWithTag:tag];
        imageView.frame = rect;
    }
}
//-------------------------------上传图片处理end------------------------------------------

//删除图片
- (void)clickDeleBtToDelePhotoWithView:(UIView *)view BtnTag:(NSString*)btntag {
    //NSLog(@"%ld", view.tag);
    __weak typeof(self) ws = self;
    //记录删除视图的标签
    NSInteger tag = view.tag;
    //记录删除视图的frame
    __block CGRect frame = view.frame;
    //从父视图中删除
    [view removeFromSuperview];
    //调整布局
    [UIView animateWithDuration:0.3 animations:^{
        for (int i = (int)tag-1; i>= 100; i--) {
            UIView *vw = [ws.photoView viewWithTag:i];
            CGRect tempFrame = vw.frame;
            if (i == 100) {
                frame.size.width = frame.size.width-SPACES;
                frame.size.height = frame.size.height-SPACES;
                frame.origin.x = frame.origin.x+5;
                frame.origin.y = frame.origin.y+5;
            }
            vw.frame = frame;
            frame = tempFrame;
        }
    }];
    UIView *imgV = [self.photoView viewWithTag:100];
    __block CGRect sframe = self.photoView.frame;
    //调整默认自身高度
    [UIView animateWithDuration:0.3 animations:^{
        if (imgV.frame.origin.y-5+_imageHeight*2+2*SPACES < ws.photoView.frame.size.height && ws.photoView.frame.size.height-_imageHeight-SPACES >= _viewDefaultHeight) {
            sframe.size.height = sframe.size.height-_imageHeight-SPACES;
            ws.photoView.frame = sframe;
        }
    }];
    //减小tag count 防止出鬼
    for (int i = (int)tag+1; i<=100+_upcot; i++) {
        UIView *vw = [self.photoView viewWithTag:i];
        vw.tag = vw.tag-1;
    }
    
    //远程删除数据库
    //NSLog(@"btntag==========%@",btntag);
    NSDictionary *param_sydel = @{@"userid":_uid,
                                  @"apptag":btntag,
                                  @"sybh":_sybhText.text,
                                  @"devcode":_devcode
                                  };
    [CKHttpCommunicate createRequest:DelSyPic WithParam:param_sydel withMethod:POST success:^(id response) {
        //NSLog(@"%@",response);
        
        if (response) {
            NSString *result = response[@"code"];
            
            if ([result isEqualToString:@"200"]) {
                NSLog(@"删除成功");
            }
            else if ([result isEqualToString:@"400"]) {
                NSLog(@"删除失败");
            }
            else if ([result isEqualToString:@"404"]) {
                NSLog(@"网络异常删除失败！");
            }
        }
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    } showHUD:self.view];
    
    _upcot--;
}

- (void)addImageLayoutSubviews {
    __block CGFloat height = 0.0;
    __weak typeof(self) ws = self;
    //NSLog(@"ws=============%@",ws);
    [UIView animateWithDuration:0.5 animations:^{
        //添加图片，已经存在的图片后移 最新添加的现实在最前面
        for (UIView *view in ws.photoView.subviews) {
            CGRect frame = view.frame;
            //默认的图片和选择的图片要分开处理 尺寸不同
            CGFloat x = 0.f;
            if (view.tag == 100) {
                x = frame.origin.x-5;
            }
            else {
                x = frame.origin.x;
            }
            
            //做换行处理
            if (x+_imageWidth*2+SPACES*2>ws.photoView.frame.size.width) {
                if (view.tag == 100) {
                    frame.origin.x = SPACES+5;
                }
                else {
                    frame.origin.x = SPACES;
                }
                frame.origin.y = frame.origin.y+_imageHeight+SPACES;
            }
            else {
                frame.origin.x = frame.origin.x+_imageWidth+SPACES;
            }
            
            //记录高度
            if (frame.origin.y + _imageHeight+SPACES > height) {
                height = frame.origin.y + _imageHeight+SPACES;
            }
            view.frame = frame;
        }
        
        //根据前面纪录的高度调整视图高度
        if (height > ws.photoView.frame.size.height) {
            CGRect frame = ws.photoView.frame;
            frame.size.height = frame.size.height + _imageHeight +SPACES;
            ws.photoView.frame = frame;
        }
    }];
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

