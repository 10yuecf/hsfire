//
//  Macro.h
//  JHCellConfigDemo
//
//  Created by JC_Hu on 15/3/9.
//  Copyright (c) 2015年 JCHu. All rights reserved.
//

#ifndef JHCellConfigDemo_Macro_h
#define JHCellConfigDemo_Macro_h

#endif
/****************************** 颜色 ********************************/
#define RGBColor(r,g,b,a) ([UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a])
/** tableView 边框颜色 */
#define TABLEVIEW_BORDER_COLOR  RGBColor(230, 230, 230, 1)
/**所有控制的背景色 */
#define VIEW_BGCOLOR    RGBColor(240, 240, 240, 1)
#define cellBlackColor RGBColor(235, 235, 245, 0.7)

#define kWidth [UIScreen mainScreen].bounds.size.width //获取设备的物理宽度
#define kHeight [UIScreen mainScreen].bounds.size.height //获取设备的物理高度

#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width //获取设备的物理宽度
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height //获取设备的物理高度

#define CCWidth  [UIScreen mainScreen].bounds.size.width
#define CCHeight [UIScreen mainScreen].bounds.size.height

#define kWidthOfScreen [UIScreen mainScreen].bounds.size.width
#define kHeightOfScreen [UIScreen mainScreen].bounds.size.height

#define URL_IMG @"http://10yue.hsdcw.com/fireyun/"

#define RGBACOLOR(r, g, b, a)   [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:(a)]
#define RGBCOLOR(r, g, b)       [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:1]
