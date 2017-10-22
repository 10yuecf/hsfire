//
//  SuggestViewController.m
//  hsjhb
//
//  Created by louislee on 16/6/28.
//  Copyright © 2016年 hsdcw. All rights reserved.
//

#import "Macro.h"
#import "SuggestViewController.h"
#import "PlaceholderTextView.h"
#import "hsdcwUtils.h"
#import "CustomHUD.h"
#import "CKHttpCommunicate.h"
#import "Macro.h"
#import "PhotoCollectionViewCell.h"
#import "UserTool.h"
#import "User.h"

#define kTextBorderColor     RGBCOLOR(227,224,216)

#undef  RGBCOLOR
#define RGBCOLOR(r,g,b) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1]

@interface SuggestViewController ()<UITextViewDelegate,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UINavigationControllerDelegate,UIImagePickerControllerDelegate>

@property (nonatomic, strong) PlaceholderTextView *textView;
@property (nonatomic, strong) UIButton *sendButton;
@property (nonatomic, strong) UIView *aView;
@property (nonatomic, strong)UICollectionView *collectionV;
//字数的限制
@property (nonatomic, strong)UILabel *wordCountLabel;
//上传图片的个数
@property (nonatomic, strong)NSMutableArray *photoArrayM;
//上传图片的button
@property (nonatomic, strong)UIButton *photoBtn;
//回收键盘
@property (nonatomic, strong)UITextField *textField;

@end

@implementation SuggestViewController

//懒加载数组
- (NSMutableArray *)photoArrayM{
    if (!_photoArrayM) {
        _photoArrayM = [NSMutableArray arrayWithCapacity:0];
    }
    return _photoArrayM;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupNav];
    
    self.view.backgroundColor = [UIColor colorWithRed:245.0/255 green:245.0/255 blue:245.0/255 alpha:1.0f];
    self.aView = [[UIView alloc]init];
    _aView.backgroundColor = [UIColor whiteColor];
    _aView.frame = CGRectMake(0, 20, self.view.frame.size.width, 300);
    [self.view addSubview:_aView];
    
    self.wordCountLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.textView.frame.origin.x + 25,  self.aView.frame.size.height - 40, kWidthOfScreen - 40, 20)];
    _wordCountLabel.font = [UIFont systemFontOfSize:14.f];
    _wordCountLabel.textColor = [UIColor lightGrayColor];
    self.wordCountLabel.text = @"0/300";
    self.wordCountLabel.textAlignment = NSTextAlignmentRight;
    [self.view addSubview:_wordCountLabel];
    
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, self.aView.frame.size.height - 15, kWidthOfScreen, 1)];
    lineView.backgroundColor = [UIColor colorWithRed:245.0/255 green:245.0/255 blue:245.0/255 alpha:1.0f];
    [self.view addSubview:lineView];
    [self.view addSubview:self.textView];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
}

-(void)backBtnClick {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)setupNav {
    self.title = @"意见反馈";
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
    
    UIBarButtonItem *saveBtn = [[UIBarButtonItem alloc]initWithTitle:@"提交" style:UIBarButtonItemStylePlain target:self action:@selector(saveData)];
    [saveBtn setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:15],NSFontAttributeName,nil] forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem = saveBtn;
    self.navigationItem.rightBarButtonItem.tintColor = [UIColor whiteColor];
}

///图片上传
-(void)picureUpload:(UIButton *)sender {
    UIImagePickerController *picker = [[UIImagePickerController alloc]init];
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    picker.mediaTypes = [UIImagePickerController availableMediaTypesForSourceType:picker.sourceType];
    picker.allowsEditing = YES;
    picker.delegate = self;
    [self presentViewController:picker animated:YES completion:nil];
}

//上传图片的协议与代理方法
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    UIImage *image=[info objectForKey:UIImagePickerControllerEditedImage];
    [self.photoArrayM addObject:image];
    //选取完图片之后关闭视图
    [self dismissViewControllerAnimated:YES completion:nil];
}

//button的frame
-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    
    self.tabBarController.hidesBottomBarWhenPushed = YES;
    
    if (self.photoArrayM.count < 5) {
        [self.collectionV reloadData];
        //_aView.frame = CGRectMake(20, 84, self.view.frame.size.width - 40, 180);
        _aView.frame = CGRectMake(0, 70, self.view.frame.size.width, 300);
        self.photoBtn.frame = CGRectMake(10 * (self.photoArrayM.count + 1) + (self.aView.frame.size.width - 60) / 5 * self.photoArrayM.count, self.aView.frame.size.height - 60, (self.aView.frame.size.width - 60) / 5, (self.aView.frame.size.width - 60) / 5 + 5);
    }
    else {
        [self.collectionV reloadData];
        self.photoBtn.frame = CGRectMake(0, 0, 0, 0);
    }
}

-(PlaceholderTextView *)textView {
    if (!_textView) {
        _textView = [[PlaceholderTextView alloc]initWithFrame:CGRectMake(0, 5, kWidthOfScreen, 190)];
        _textView.backgroundColor = [UIColor whiteColor];
        _textView.delegate = self;
        _textView.font = [UIFont systemFontOfSize:14.f];
        _textView.textColor = [UIColor blackColor];
        _textView.textAlignment = NSTextAlignmentLeft;
        _textView.editable = YES;
        //_textView.layer.cornerRadius = 4.0f;
        //_textView.layer.borderColor = kTextBorderColor.CGColor;
        //_textView.layer.borderWidth = 0.5;
        _textView.placeholderColor = RGBCOLOR(0x89, 0x89, 0x89);
        _textView.placeholder = @"写下你遇到的问题，或告诉我们你的宝贵意见~";
    }
    
    return _textView;
}

///填写意见
-(void)addLabelText {
    UILabel * labelText = [[UILabel alloc] init];
    labelText.text = @"问题截图(选填)";
    labelText.frame = CGRectMake(10, self.aView.frame.size.height - 80, kWidthOfScreen - 20, 20);
    labelText.font = [UIFont systemFontOfSize:14.f];
    labelText.textColor = _textView.placeholderColor;
    [_aView addSubview:labelText];
}

#pragma mark 上传图片UIcollectionView
-(void)addCollectionViewPicture {
    //创建一种布局
    UICollectionViewFlowLayout *flowL = [[UICollectionViewFlowLayout alloc]init];
    //设置每一个item的大小
    flowL.itemSize = CGSizeMake((self.aView.frame.size.width - 60) / 5 , (self.aView.frame.size.width - 60) / 5 );
    flowL.sectionInset = UIEdgeInsetsMake(5, 10, 5, 10);
    //列
    flowL.minimumInteritemSpacing = 10;
    //行
    flowL.minimumLineSpacing = 10;
    //创建集合视图
    self.collectionV = [[UICollectionView alloc]initWithFrame:CGRectMake(0, self.aView.frame.size.height - 60, self.aView.frame.size.width, (kWidthOfScreen - 60) / 5 + 10) collectionViewLayout:flowL];
    _collectionV.backgroundColor = [UIColor whiteColor];
    // NSLog(@"-----%f",([UIScreen mainScreen].bounds.size.width - 60) / 5);
    _collectionV.delegate = self;
    _collectionV.dataSource = self;
    //添加集合视图
    [self.aView addSubview:_collectionV];
    
    //注册对应的cell
}

#pragma mark CollectionView DataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (_photoArrayM.count == 0) {
        return 0;
    }
    else {
        return _photoArrayM.count;
    }
}

//返回每一个cell
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    PhotoCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    
    cell.photoV.image = self.photoArrayM[indexPath.item];
    return cell;
}

#pragma mark textField的字数限制

//在这个地方计算输入的字数
- (void)textViewDidChange:(UITextView *)textView {
    NSInteger wordCount = textView.text.length;
    self.wordCountLabel.text = [NSString stringWithFormat:@"%ld/300",(long)wordCount];
    [self wordLimit:textView];
}

#pragma mark 超过300字不能输入
-(BOOL)wordLimit:(UITextView *)text{
    if (text.text.length < 300) {
        //NSLog(@"%ld",(unsigned long)text.text.length);
        self.textView.editable = YES;
    }
    else{
        self.textView.editable = NO;
    }
    return false;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [_textView resignFirstResponder];
    [_textField resignFirstResponder];
}

-(void)saveData {
    //hsdcwUtils *utils = [[hsdcwUtils alloc]init];
    
    if(_textView.text.length <= 0) {
        [CustomHUD createHudCustomTime:1.0 showContent:@"请填写您的宝贵意见"];
    }
    else {
        [CustomHUD createHudCustomShowContent:@"正在提交中..."];
        [self performSelector:@selector(submit) withObject:nil afterDelay:1];
    }
}

-(void)submit {
    //hsdcwUtils *utils = [[hsdcwUtils alloc]init];
    NSString *chkuser = [NSString stringWithFormat:@"select * from t_user where loginstatus = '1' limit 1"];
    NSMutableArray *user_arr = [UserTool userWithSql:chkuser];
    User *u = user_arr[0];
    NSString *addp = u.name;
    NSString *uid = u.userID;
    NSString *uaccount = u.account;
    NSString *devcode = u.devicetoken;
    
    //修改密码
    NSDictionary *parameter = @{@"userid":uid,
                                @"username":addp,
                                @"uaccount":uaccount,
                                @"btype":@"1",
                                @"content":_textView.text,
                                @"devcode":devcode,
                                @"devtype":@"ios"
                                };
    [CKHttpCommunicate createRequest:sandinfo WithParam:parameter withMethod:POST success:^(id response) {
        //NSLog(@"%@",response);
        if (response) {
            NSString *result = response[@"code"];
            if ([result isEqualToString:@"200"]) {
                [CustomHUD createHudCustomTime:1.0 showContent:@"提交成功，感谢您的宝贵意见!"];
                //[CustomHUD stopHidden];
                [self.navigationController popViewControllerAnimated:YES];
            }
            else if ([result isEqualToString:@"400"]) {
                [CustomHUD createHudCustomTime:1.0 showContent:@"提交失败"];
            }
        }
    } failure:^(NSError *error) {
        [CustomHUD createHudCustomTime:1.0 showContent:@"提交失败"];
        
        NSLog(@"%@",error);
    } showHUD:self.view];
}

- (BOOL)prefersStatusBarHidden {
    return NO; //隐藏状态栏,是的,是的!
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:NO];
    self.tabBarController.hidesBottomBarWhenPushed = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
