//
//  DMRegisterViewController.m
//  LoginView
//
//  Created by SDC201 on 16/3/9.
//  Copyright © 2016年 PCEBG. All rights reserved.
//
#import <sqlite3.h>
#import "AddSyViewController.h"
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

#import "STPickerArea.h"
#import "STPickerSingle.h"
#import "STPickerDate.h"

@interface AddSyViewController ()<UITextFieldDelegate, STPickerAreaDelegate, STPickerSingleDelegate>
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
@property (nonatomic ,strong) UIButton *yzButton;

@end

@implementation AddSyViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [[UINavigationBar appearance] setBarTintColor:[UIColor whiteColor]];
    self.view.backgroundColor = [UIColor colorWithRed:240/255.0f green:240/255.0f blue:240/255.0f alpha:1];
    
    NSLog(@"================%@",self.userEntity.title);
    NSLog(@"================%@",self.userEntity.lat);
    NSLog(@"================%@",self.userEntity.lon);
    
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
    
    syarealabel.text=@"水源地区";
    syarealabel.textColor=[UIColor blackColor];
    syarealabel.textAlignment=NSTextAlignmentLeft;
    syarealabel.font=[UIFont systemFontOfSize:14];
    [_baceView addSubview:syarealabel];
    
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
    
    _syareaText.clearButtonMode = UITextFieldViewModeWhileEditing;
    _syareaText.delegate = self;
    _syareaText.keyboardType = UIKeyboardTypeNumberPad;
    [_baceView addSubview:_syareaText];
    
    sybhlabel.text = @"水源编号";
    sybhlabel.textColor = [UIColor blackColor];
    sybhlabel.textAlignment = NSTextAlignmentLeft;
    sybhlabel.font = [UIFont systemFontOfSize:14];
    [_baceView addSubview:sybhlabel];
    
    _sybhText.clearButtonMode = UITextFieldViewModeWhileEditing;
    _sybhText.delegate = self;
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

//-(BOOL)textFieldShouldReturn:(UITextField *)textField {
//    textField = _sybhText;
//    [_sybhText resignFirstResponder];
//    return YES;
//}

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

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
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
