//
//  CustomAlertView.m
//  Test
//
//  Created by zzl on 15/8/31.
//  Copyright (c) 2015年 zzl. All rights reserved.
//

#import "CustomAlertView.h"
#import <QuartzCore/QuartzCore.h>
@implementation CustomAlertView
- (id)init {
    self = [super init];
    if (self) {
        
    }
    return self;
}

+ (void)showCustomAlertViewWithContent:(NSString *)content andRect:(CGRect)rect andTime:(float)time andObject:(UIViewController *)selfController {
    
    if ([selfController.view viewWithTag:1234554321]) {
        UIView * tView = [selfController.view viewWithTag:1234554321];
        [tView removeFromSuperview];
    }
    
    UIImageView * CustomAlertView = [[UIImageView alloc] initWithFrame:rect];
    [CustomAlertView setBackgroundColor:[[UIColor blackColor] colorWithAlphaComponent:0.75f]];
    [CustomAlertView.layer setCornerRadius:5.0f];
    [CustomAlertView.layer setMasksToBounds:YES];
    [CustomAlertView setAlpha:1.0f];
    [CustomAlertView setTag:1234554321];
    [selfController.view addSubview:CustomAlertView];
    
    CGSize labelSize = CGSizeMake(rect.size.width ,MAXFLOAT);
    CGSize realSize = [content boundingRectWithSize:labelSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17.0f]} context:nil].size;
    
    if (realSize.height > rect.size.height) {
        [CustomAlertView setFrame:CGRectMake(CustomAlertView.frame.origin.x, (KSCREEN_HEIGHT - 44 * 2- realSize.height)/2, CustomAlertView.frame.size.width, realSize.height)];
    }
    UILabel * contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, CustomAlertView.frame.size.width - 20, CustomAlertView.frame.size.height - 20)];
    [contentLabel setText:content];
    [contentLabel setTextColor:[UIColor whiteColor]];
    [contentLabel setFont:[UIFont systemFontOfSize:14.0f]];
    contentLabel.textAlignment = NSTextAlignmentCenter;
    [contentLabel setBackgroundColor:[UIColor clearColor]];
    [contentLabel setNumberOfLines:0];
    contentLabel.lineBreakMode = NSLineBreakByWordWrapping;
    [CustomAlertView addSubview:contentLabel];
    if (time>0.01) {
        [self performSelector:@selector(removeCustomAlertView:) withObject:selfController afterDelay:time];
    }
}

+ (void)showCustomAlertViewWithContent:(NSString *)content andRect:(CGRect)rect andTime:(float)time andObject:(UIViewController *)selfController andHightNoLimited:(BOOL)limited {
    if ([selfController.view viewWithTag:1234554321]) {
        UIView * tView = [selfController.view viewWithTag:1234554321];
        [tView removeFromSuperview];
    }
    UIImageView * CustomAlertView = [[UIImageView alloc] initWithFrame:rect];
    if ([UIImage imageNamed:@"1"]) {
        [CustomAlertView setImage:[[UIImage imageNamed:@"2"] stretchableImageWithLeftCapWidth:10 topCapHeight:10]];
    }else{
        [CustomAlertView setBackgroundColor:[UIColor blackColor]];
    }
    [CustomAlertView.layer setCornerRadius:5.0f];
    [CustomAlertView.layer setMasksToBounds:YES];
    [CustomAlertView setAlpha:1.0f];
    [CustomAlertView setTag:1234554321];
    [selfController.view addSubview:CustomAlertView];
    CGSize labelSize = CGSizeMake(rect.size.width ,MAXFLOAT);
    CGSize realSize = [content boundingRectWithSize:labelSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17.0f]} context:nil].size;
    if (realSize.height > rect.size.height) {
        [CustomAlertView setFrame:CGRectMake(CustomAlertView.frame.origin.x, (KSCREEN_HEIGHT - 44 * 2- realSize.height)/2, CustomAlertView.frame.size.width, realSize.height)];
    }
    
    UILabel * contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, CustomAlertView.frame.size.width - 20, CustomAlertView.frame.size.height)];
    [contentLabel setText:content];
    [contentLabel setTextColor:[UIColor whiteColor]];
    contentLabel.textAlignment = NSTextAlignmentCenter;
    [contentLabel setBackgroundColor:[UIColor clearColor]];
    contentLabel.numberOfLines = 0;
    [CustomAlertView addSubview:contentLabel];
    [self performSelector:@selector(removeCustomAlertView:) withObject:selfController afterDelay:time];
    
}

+ (void)showCustomAlertViewWithContent:(UIImage *)image andTitle:(NSString *)title andRect:(CGRect)rect andTime:(float)time andObject:(UIViewController *)selfController andStatus:(BOOL)isUploading
{
    if ([selfController.view viewWithTag:1234554321]) {
        UIView * tView = [selfController.view viewWithTag:1234554321];
        [tView removeFromSuperview];
    }
    CGFloat  ox =0;
    CGFloat  oy =0;
    CGFloat  width = 0;
    CGFloat  height=0;
    
    UIImageView * CustomAlertView = [[UIImageView alloc] initWithFrame:rect];
    
    CGSize labelSize = CGSizeMake(rect.size.width ,MAXFLOAT);
    CGSize realSize = [title boundingRectWithSize:labelSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17.0f]} context:nil].size;
    
    if(isUploading==YES){
        width = rect.size.width/12;
        height = width;
        ox =(rect.size.width-10)/2.0;
        oy = (rect.size.height-10-realSize.height)/2.0;
        UIActivityIndicatorView * activityView = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        activityView.frame = CGRectMake(ox, oy, width, height);
        [CustomAlertView addSubview:activityView];
        [activityView startAnimating];
        
    }else{
        width = rect.size.width*5/12;
        height =width*image.size.height/image.size.width;
        ox =(rect.size.width-50)/2.0;
        oy =(rect.size.height-50*image.size.height/image.size.width-realSize.height)/2.0;
        UIImageView *completeImage = [[UIImageView alloc]initWithFrame:CGRectMake(ox,oy,width,height)];
        completeImage.image =image;
        completeImage.backgroundColor = [UIColor clearColor];
        [CustomAlertView addSubview:completeImage];
    }

    [CustomAlertView setBackgroundColor:[[UIColor blackColor] colorWithAlphaComponent:0.85f]];
    [CustomAlertView.layer setCornerRadius:5.0f];
    [CustomAlertView.layer setMasksToBounds:YES];
    [CustomAlertView setAlpha:1.0f];
    [CustomAlertView setTag:1234554321];
    [selfController.view addSubview:CustomAlertView];
    if (labelSize.height > rect.size.height) {
        [CustomAlertView setFrame:CGRectMake(rect.origin.x, rect.origin.y, rect.size.width, labelSize.height)];
    }
    ox = 10;
    oy = rect.size.height-labelSize.height-10;
    width = rect.size.width -20;
    height = labelSize.height;
    UILabel * contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(ox , oy, width, height)];
    [contentLabel setText:title];
    [contentLabel setTextColor:[UIColor whiteColor]];
    [contentLabel setFont:[UIFont systemFontOfSize:15.0f]];
     contentLabel.textAlignment = NSTextAlignmentCenter;
    [contentLabel setBackgroundColor:[UIColor clearColor]];
    [contentLabel setNumberOfLines:0];
    contentLabel.lineBreakMode = NSLineBreakByWordWrapping;
    [CustomAlertView addSubview:contentLabel];
    if(time>0){
       [self performSelector:@selector(removeCustomAlertView:) withObject:selfController afterDelay:time];
    }
    
}
+ (void)removeCustomAlertView:(id)sender
{
    UIViewController * selfController = (UIViewController *)sender;
    UIView * CustomAlertView = [selfController.view viewWithTag:1234554321];
    [CustomAlertView removeFromSuperview];
    CustomAlertView = nil;
}
@end



@implementation UIView (UIViewUtils)
//有待封装成一个动态改变位置和提示语text的方法，有空完善
- (void)createActivityViewAtCenter:(UIActivityIndicatorViewStyle)style
{
    static int size = 30;
    UIView* aView = [[UIView alloc] init];
    aView.frame = CGRectMake([UIScreen mainScreen].bounds.size.width/2 - 50/2, ([UIScreen mainScreen].bounds.size.height-113) /2 - 50/2, 50, 50);
    aView.backgroundColor = [UIColor blackColor];
    aView.layer.cornerRadius = 5;
    aView.layer.masksToBounds = YES;
    aView.tag = aViewTag;
    UIActivityIndicatorView* activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:style];
    activityView.frame = CGRectMake(10, 10, size, size);
    activityView.tag = activityViewTag;
    [aView addSubview:activityView];
    
    //增加提示语
//    UILabel * lable = [[UILabel alloc] initWithFrame:CGRectMake(0,30,50,10)];
//    lable.textColor = [UIColor whiteColor];
//    lable.font = [UIFont systemFontOfSize:8];
//    lable.text = @"正在加载....";
//    [aView addSubview:lable];
    
    [self addSubview:aView];
    [self bringSubviewToFront: aView];
    
    
}
- (void)createActivityViewOnJubaoPineAtCenter:(UIActivityIndicatorViewStyle)style
{
    static int size = 30;
    UIView* aView = [[UIView alloc] init];
    aView.frame = CGRectMake([UIScreen mainScreen].bounds.size.width/2 - 50/2, 290/2 - 25, 50, 50);
    aView.backgroundColor = [UIColor blackColor];
    aView.layer.cornerRadius = 5;
    aView.layer.masksToBounds = YES;
    aView.tag = aViewTag;
    UIActivityIndicatorView* activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:style];
    activityView.frame = CGRectMake(10, 10, size, size);
    activityView.tag = activityViewTag;
    [aView addSubview:activityView];
    
    [self addSubview:aView];
    [self bringSubviewToFront: aView];
    
    
}
- (UIActivityIndicatorView*)getActivityViewAtCenter
{
    for (UIView *view in [self subviews]) {
        if (view.tag == aViewTag) {
            [self bringSubviewToFront:view];
            for (UIView *inview in [view subviews])
            {
                if (inview != nil && [inview isKindOfClass:[UIActivityIndicatorView class]]){
                    return (UIActivityIndicatorView*)inview;
                }
                
            }
        }
        
        
    }
    return nil;
}

- (void)showActivityViewAtCenter
{
    UIActivityIndicatorView* activityView = [self getActivityViewAtCenter];
    if (activityView == nil){
        [self createActivityViewAtCenter:UIActivityIndicatorViewStyleWhiteLarge];
        activityView = [self getActivityViewAtCenter];
    }
    
    [activityView startAnimating];
}
- (void)showActivityViewOnJubaoPineAtCenter
{
    UIActivityIndicatorView* activityView = [self getActivityViewAtCenter];
    if (activityView == nil){
        [self createActivityViewOnJubaoPineAtCenter:UIActivityIndicatorViewStyleWhiteLarge];
        activityView = [self getActivityViewAtCenter];
    }
    
    [activityView startAnimating];
}

- (void)hideActivityViewAtCenter
{
    UIActivityIndicatorView* activityView = [self getActivityViewAtCenter];
    if (activityView != nil){
        [activityView stopAnimating];
    }
    for (UIView *view in [self subviews]) {
        if (view != nil && view.tag == aViewTag){
            [view removeFromSuperview];
            return;
        }
    }
    
}
@end

