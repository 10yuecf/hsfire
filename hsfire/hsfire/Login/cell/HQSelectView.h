//
//  HQSelectView.h
//  SelectButton
//
//  Created by alan on 16/9/9.
//  Copyright © 2016年 com.maober. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^BACKBUTTONSTATE)(BOOL btn_selectedState);

@interface HQSelectView : UIView

@property (nonatomic,strong) UIImage *nomalImage;

@property (nonatomic,strong) UIImage *selectedImage;

@property (nonatomic,strong) UIImage *backgroundImage;

@property (nonatomic,strong) UIButton *selectedBtn;

@property (nonatomic,strong) BACKBUTTONSTATE block;

@end
