//
//  SyAddViewController.m
//  hsfire
//
//  Created by louislee on 2017/9/23.
//  Copyright © 2017年 hsdcw. All rights reserved.
//
#import <AVFoundation/AVFoundation.h>
#import <sqlite3.h>
#import "SyTestViewController.h"
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

#import "STPickerArea.h"
#import "STPickerSingle.h"
#import "STPickerDate.h"

#define IOS7DEVICE ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)
#define DOCUMENTS_FOLDER_TEMPIMAGE [NSHomeDirectory() stringByAppendingFormat:@"/Library/Caches/tempimage/"]

@interface SyTestViewController ()<UITextFieldDelegate, STPickerAreaDelegate, STPickerSingleDelegate, UIImagePickerControllerDelegate>
@property (nonatomic ,strong) UIView *baceView;
@property (nonatomic ,strong) UITextField *syaddrText; //水源地址
@property (nonatomic ,strong) UITextField *syareaText; //水源地区
@property (nonatomic ,strong) UITextField *sylanText;  //水源经度
@property (nonatomic ,strong) UITextField *sylonText;  //水源纬度
@property (nonatomic ,strong) UITextField *sybhText;   //水源编号
@property (nonatomic ,strong) UITextField *sydwText;   //水源单位
@property (nonatomic ,strong) UITextField *sylxText;   //水源类型
@property (nonatomic ,strong) UITextField *syqkText;   //水源情况
@property (nonatomic ,strong) UITextField *sylxrText;   //水源联系人
@property (nonatomic ,strong) UITextField *sytelText;   //水源联系人电话
@property (nonatomic, strong) UIImage *headImage;
@property (nonatomic, strong) MBProgressHUD *HUD;
@property (nonatomic, strong) NSString *str;
@property (nonatomic, strong) UIImageView *p1;
@property (nonatomic, strong) UIImageView *p2;
@property (nonatomic, strong) UIImageView *p3;
@property (nonatomic, strong) UIImageView *p4;
@property (nonatomic, strong) UIImageView *p5;
@property (nonatomic, assign) int upcot;
@end

@implementation SyTestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[UINavigationBar appearance] setBarTintColor:[UIColor whiteColor]];
    self.view.backgroundColor = [UIColor colorWithRed:240/255.0f green:240/255.0f blue:240/255.0f alpha:1];
    
    NSLog(@"================%@",self.userEntity.title);
    NSLog(@"================%@",self.userEntity.lat);
    NSLog(@"================%@",self.userEntity.lon);
    
    self.sybhText.delegate = self;
    self.syareaText.delegate = self;
    self.sydwText.delegate = self;
    self.sylxText.delegate = self;
    self.syqkText.delegate = self;
    
    [self setupNav];
    [self createTextFiled];
}

-(void)backBtnClick {
    [self.navigationController popViewControllerAnimated:YES];
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
}

-(void)createTextFiled {
    int linex = 10; //线x坐标
    int labelx = 10,labely = 10,labelyb = 40,labelw = 60,labelh = 25; //label标签x坐标
    int inputx = 75,inputy = 8,inputyb = 40,inputw = 200,inputh = 30; //文本框x坐标
    
    //白色背景框
    _baceView = [[UIView alloc]initWithFrame:CGRectMake(10, 10, kWidth - 20, 430)];
    _baceView.layer.cornerRadius = 5.0;
    _baceView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_baceView];
    
    UILabel *syarealabel = [[UILabel alloc]initWithFrame:CGRectMake(labelx, labely, labelw, labelh)];
    UILabel *sybhlabel = [[UILabel alloc]initWithFrame:CGRectMake(labelx, labely + labelyb, labelw, labelh)];
    UILabel *sydwlabel = [[UILabel alloc]initWithFrame:CGRectMake(labelx, labely + labelyb * 2, labelw, labelh)];
    UILabel *sylxlabel = [[UILabel alloc]initWithFrame:CGRectMake(labelx, labely + labelyb * 3, labelw, labelh)];
    UILabel *syqklabel = [[UILabel alloc]initWithFrame:CGRectMake(labelx, labely + labelyb * 4, labelw, labelh)];
    UILabel *sylxrlabel = [[UILabel alloc]initWithFrame:CGRectMake(labelx, labely + labelyb * 5, labelw, labelh)];
    UILabel *sytellabel = [[UILabel alloc]initWithFrame:CGRectMake(labelx, labely + labelyb * 6, labelw, labelh)];
    
    _syareaText = [self createTextFiledWithFrame:CGRectMake(inputx, inputy, inputw, inputh) font:[UIFont systemFontOfSize:14] placeholder:@"请选择水源地区"];
    _sybhText = [self createTextFiledWithFrame:CGRectMake(inputx, inputy + inputyb, inputw, inputh) font:[UIFont systemFontOfSize:14] placeholder:@"请输入水源编号"];
    _sydwText = [self createTextFiledWithFrame:CGRectMake(inputx, inputy + inputyb * 2, inputw, inputh) font:[UIFont systemFontOfSize:14] placeholder:@"请选择水源归属单位"];
    _sylxText = [self createTextFiledWithFrame:CGRectMake(inputx, inputy + inputyb * 3, inputw, inputh) font:[UIFont systemFontOfSize:14] placeholder:@"请选择水源类型"];
    _syqkText = [self createTextFiledWithFrame:CGRectMake(inputx, inputy + inputyb * 4, inputw, inputh) font:[UIFont systemFontOfSize:14] placeholder:@"请选择水源情况"];
    _sylxrText = [self createTextFiledWithFrame:CGRectMake(inputx, inputy + inputyb * 5, inputw, inputh) font:[UIFont systemFontOfSize:14] placeholder:@"请输入水源联系人"];
    _sytelText = [self createTextFiledWithFrame:CGRectMake(inputx, inputy + inputyb * 6, inputw, inputh) font:[UIFont systemFontOfSize:14] placeholder:@"请输入水源联系人电话"];
    
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
    
    syarealabel.text=@"水源地区";
    syarealabel.textColor=[UIColor blackColor];
    syarealabel.textAlignment=NSTextAlignmentLeft;
    syarealabel.font=[UIFont systemFontOfSize:14];
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
    
    UIButton *landBtn = [[UIButton alloc]initWithFrame:CGRectMake(10,_baceView.frame.size.height + _baceView.frame.origin.y + 10, _baceView.frame.size.width, 37)];
    [landBtn setTitle:@"提交" forState:UIControlStateNormal];
    [landBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    landBtn.titleLabel.font = [UIFont systemFontOfSize:17];
    [landBtn addTarget:self action:@selector(next:) forControlEvents:UIControlEventTouchUpInside];
    landBtn.backgroundColor = [UIColor colorWithRed:204/255.0f green:0/255.0f blue:0/255.0f alpha:1];
    landBtn.layer.cornerRadius = 5.0;
    [self.view addSubview:landBtn];
    
    //拍照按钮
    UIButton *photoBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    photoBtn.frame = CGRectMake(20, inputy + inputyb * 6 + 50, 60, 60);
    photoBtn.titleLabel.text = @"photoimg";
    [photoBtn setImage:[UIImage imageNamed:@"photo.png"] forState:UIControlStateNormal];
    [photoBtn.layer setMasksToBounds:YES];
    [photoBtn.layer setCornerRadius:3.0];
    [photoBtn addTarget:self action:@selector(uploadHeadImg:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:photoBtn];
    
    _p1 = [[UIImageView alloc] initWithFrame:CGRectZero];
    _p1.frame = CGRectMake(90, inputy + inputyb * 6 + 50, 60, 60);
    _p1.layer.masksToBounds = YES;
    _p1.layer.cornerRadius = 3.0;
    _p1.image = [UIImage imageNamed:@"nophoto.png"];
    [self.view addSubview:_p1];
    
    _p2 = [[UIImageView alloc] initWithFrame:CGRectZero];
    _p2.frame = CGRectMake(160, inputy + inputyb * 6 + 50, 60, 60);
    _p2.layer.masksToBounds = YES;
    _p2.layer.cornerRadius = 3.0;
    _p2.image = [UIImage imageNamed:@"nophoto.png"];
    [self.view addSubview:_p2];
    
    _p3 = [[UIImageView alloc] initWithFrame:CGRectZero];
    _p3.frame = CGRectMake(20, inputy + inputyb * 6 + 120, 60, 60);
    _p3.layer.masksToBounds = YES;
    _p3.layer.cornerRadius = 3.0;
    _p3.image = [UIImage imageNamed:@"nophoto.png"];
    [self.view addSubview:_p3];
    
    _p4 = [[UIImageView alloc] initWithFrame:CGRectZero];
    _p4.frame = CGRectMake(90, inputy + inputyb * 6 + 120, 60, 60);
    _p4.layer.masksToBounds = YES;
    _p4.layer.cornerRadius = 3.0;
    _p4.image = [UIImage imageNamed:@"nophoto.png"];
    [self.view addSubview:_p4];
    
    _p5 = [[UIImageView alloc] initWithFrame:CGRectZero];
    _p5.frame = CGRectMake(160, inputy + inputyb * 6 + 120, 60, 60);
    _p5.layer.masksToBounds = YES;
    _p5.layer.cornerRadius = 3.0;
    _p5.image = [UIImage imageNamed:@"nophoto.png"];
    [self.view addSubview:_p5];
}

- (void)uploadHeadImg:(UIButton *)sender {
    NSLog(@"拍照");
    _str = @"photo";
    
    if(_upcot >= 5) {
        [MBProgressHUD showError:@"未获取到水源地址，请返回上页重新获取" toView:self.view];
    }
    
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
    NSString *syaddr = self.userEntity.title;
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
                                      @"xf_dt":xf_dt,
                                      @"xf_tk":xf_tk};
        
        [CKHttpCommunicate createRequest:Sybhchk WithParam:param_syadd withMethod:POST success:^(id response) {
            //NSLog(@"%@",response);
            
            if (response) {
                NSString *result = response[@"code"];
                
                if ([result isEqualToString:@"200"]) {
                    NSLog(@"添加成功");
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
        
        [arrayData addObject:@"黄石"];
        [arrayData addObject:@"大冶"];
        [arrayData addObject:@"阳新"];
        [arrayData addObject:@"市辖区"];
        [arrayData addObject:@"铁山"];
        [arrayData addObject:@"下陆"];
        
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
    
    if (user_arr.count == 0) {
        uid = @"0";
    }
    else {
        User *u = user_arr[0];
        uid = u.userID;
    }
    NSLog(@"%@",uid);
    
    NSDictionary *dic = @{@"uid":uid,@"token":@"123",@"uptype":@"photo"};
    //NSDictionary *dic = @{@"uid":u_arr[1],@"token":u_arr[2],@"uptype":uType};
    
    [self updateImageToServer:imageData paramDict:dic];
    //图片上传网络服务器
    [CustomAlertView showCustomAlertViewWithContent:@"正在上传中..." andRect:KTOASTRECT andTime:1.50f andObject:self];
}

/*上传图片*/
- (void)updateImageToServer:(NSData *)imageData paramDict:(NSDictionary *)paramDict {
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"text/plain", nil];
    //NSDictionary * parametDic = @{@"uid":@(15100),@"op":@"123"};
    
    // 上传文件时，文件不允许被覆盖(文件重名)
    //可以在上传时使用当前的系统时间作为文件名
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyyMMddHHmmss";
    NSString *str = [formatter stringFromDate:[NSDate date]];
    NSString *fileName = [NSString stringWithFormat:@"%@.png", str];
    
    [self hudTipWillShow:YES];
    //NSString *urlStr = @"http://www.jhb1314.com/api/socket.php?action=up";
    NSString *urlStr = @"http://10yue.hsdcw.com/fireyun/api/socket.php?action=up";
    [manager POST:urlStr parameters:paramDict constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
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
                
                //[_p1 sd_setImageWithURL:fileName placeholderImage:[UIImage imageNamed:@""]];
                
                // 刷新TableView
                //[self.mainTableView reloadData];
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
