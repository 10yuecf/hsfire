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