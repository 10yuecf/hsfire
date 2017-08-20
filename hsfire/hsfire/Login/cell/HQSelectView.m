//
//  HQSelectView.m
//  SelectButton
//
//  Created by alan on 16/9/9.
//  Copyright © 2016年 com.maober. All rights reserved.
//

#import "HQSelectView.h"

@interface HQSelectView ()

@end

@implementation HQSelectView

-(void)checkButtonClicked:(UIButton *)sender {
    sender.selected = !sender.selected;
    _block(sender.selected);
}

#pragma mark ---- 设置属性 ---- 
-(void)setSelectedImage:(UIImage *)selectedImage {
    _selectedImage = selectedImage;
    [self.selectedBtn setImage:selectedImage forState:UIControlStateSelected];
}

-(void)setNomalImage:(UIImage *)nomalImage {
    _nomalImage = nomalImage;
    [self.selectedBtn setImage:nomalImage forState:UIControlStateNormal];
}

#pragma mark ----- 设置 ----
-(void)setup{
    self.nomalImage = [UIImage imageNamed:@"unchecked_checkbox@2x"];
    self.selectedImage = [UIImage imageNamed:@"checked_checkbox@2x"];
    if (_selectedBtn == nil) {
        UIButton *selectedBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        selectedBtn.frame = self.bounds;
        [selectedBtn setTitleColor :[UIColor colorWithWhite:0.2 alpha:1] forState:UIControlStateNormal];
        selectedBtn.titleLabel.numberOfLines = 0;
        selectedBtn.titleLabel.lineBreakMode = NSLineBreakByCharWrapping;
        [selectedBtn addTarget:self action:@selector(checkButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:selectedBtn];
        _selectedBtn = selectedBtn;
        [_selectedBtn setImage:self.nomalImage forState:UIControlStateNormal];
        [_selectedBtn setImage:self.selectedImage forState:UIControlStateSelected];
    }
}

-(void)awakeFromNib {
    [self setup];
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}


@end
