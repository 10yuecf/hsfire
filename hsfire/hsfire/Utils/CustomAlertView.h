//
//  CustomAlertView.h
//  Test
//
//  Created by zzl on 15/8/31.
//  Copyright (c) 2015年 zzl. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#define KSCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width)
#define KSCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)
#define KTOASTRECT CGRectMake((KSCREEN_WIDTH - 200)/2, (KSCREEN_HEIGHT - 200)/2, 200, 50)
#define activityViewTag          0x401
#define aViewTag                0x402
@interface CustomAlertView : NSObject
@property (nonatomic,strong) UIImageView * toastView;
+ (void)showCustomAlertViewWithContent:(NSString *)content andRect:(CGRect)rect andTime:(float)time andObject:(UIViewController *)selfController;
+ (void)showCustomAlertViewWithContent:(NSString *)content andRect:(CGRect)rect andTime:(float)time andObject:(UIViewController *)selfController andHightNoLimited:(BOOL)limited;
+ (void)showCustomAlertViewWithContent:(UIImage *)image andTitle:(NSString *)title andRect:(CGRect)rect andTime:(float)time andObject:(UIViewController *)selfController andStatus:(BOOL)isUploading;
+ (void)removeCustomAlertView:(id)sender;
@end
//对UIView的延展  加载时的菊花旋转
@interface UIView (UIViewUtils)
- (void)showActivityViewAtCenter;
- (void)showActivityViewOnJubaoPineAtCenter;
- (void)hideActivityViewAtCenter;
- (void)createActivityViewAtCenter:(UIActivityIndicatorViewStyle)style;
- (UIActivityIndicatorView*)getActivityViewAtCenter;
@end