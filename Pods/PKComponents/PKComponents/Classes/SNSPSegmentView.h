//
//  SNSPSegmentView.h
//  PKProject1
//
//  Created by mpk on 2019/4/22.
//  Copyright © 2019年 马鹏坤. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^SNSPSegmentViewSelectedBlock)(NSInteger index);

@interface SNSPSegmentView : UIView
/**item背景色*/
@property (nonatomic, strong) UIColor *backGroundNormalColor;
/**item选中背景色*/
@property (nonatomic, strong) UIColor *backGroundSelectedColor;
/**描边width*/
@property (nonatomic, assign) CGFloat borderWidth;
/**描边圆角大小*/
@property (nonatomic, assign) CGFloat borderRadius;
/**描边颜色*/
@property (nonatomic, strong) UIColor *borderNormalColor;
/**描边选中颜色*/
@property (nonatomic, strong) UIColor *borderSelectedColor;
/**item标题字体颜色*/
@property (nonatomic, strong) UIColor *titleNormalColor;
/**item标题字体选中颜色*/
@property (nonatomic, strong) UIColor *titleSelectedColor;
/**item标题字体大小*/
@property (nonatomic, assign) CGFloat titleNormalFont;
/**item标题选中字体大小*/
@property (nonatomic, assign) CGFloat titleSelectedFont;
/**字体距边框的间距*/
@property (nonatomic, assign) CGFloat titleHorizonPading;

@property (nonatomic, copy) SNSPSegmentViewSelectedBlock selectedBlock;

/**
 * 函数说明：初始化方法
 * 参数说明：frame 大小
 * 参数说明：titleArray 标题字符串数组
 * 参数说明：currentIndex 默认选中索引
 *
 *  返回值：SNSPSegmentView
 */
- (instancetype)initWithFrame:(CGRect)frame titleArray:(NSArray *)titleArray currentSelectedIndex:(NSInteger)currentIndex;

/**
 * 函数说明：开始布局子视图
 *
 *  返回值： 无
 */
- (void)drawView;


@end
