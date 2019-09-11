//
//  SNSPSegmentView.m
//  PKProject1
//
//  Created by mpk on 2019/4/22.
//  Copyright © 2019年 马鹏坤. All rights reserved.
//

#import "SNSPSegmentView.h"

@interface SNSPSegmentView ()
@property (nonatomic, strong) NSArray *titleArray;
@property (nonatomic, strong) NSMutableArray *btArray;
@property (nonatomic, assign) NSInteger currentIndex;

@end

@implementation SNSPSegmentView
#pragma mark - life cycle

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initDefaultStyle];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame titleArray:(NSArray *)titleArray currentSelectedIndex:(NSInteger)currentIndex {
    self.titleArray = titleArray;
    self.currentIndex = currentIndex;
    return [self initWithFrame:frame];
}

- (void)initDefaultStyle {
    _backGroundNormalColor = [self colorWithHexString:@"ffffff"];
    _backGroundSelectedColor = [self colorWithHexString:@"dcfaeb"];
    _borderWidth = 1;
    _borderNormalColor = [self colorWithHexString:@"999999"];
    _borderSelectedColor= [self colorWithHexString:@"15b374"];
    _titleNormalColor = [self colorWithHexString:@"999999"];
    _titleSelectedColor = [self colorWithHexString:@"0e8c5a"];
    _titleNormalFont = 13.0;
    _titleSelectedFont = 13.0;
    _borderRadius = 4;
    _titleHorizonPading = 15;
    if (_currentIndex < 0 || _currentIndex > self.titleArray.count - 1) {
        _currentIndex = 0;
    }
}

- (void)initSubViews {
    if (self.titleArray.count == 0) {
        return;
    }
    CGFloat beginX = 0;
    for (int i = 0; i < self.titleArray.count; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.tag = i + 2000;
        NSString *title = self.titleArray[i];
        CGFloat width = [self widthForTitle:title];
        btn.frame = CGRectMake(beginX, 0, width, CGRectGetHeight(self.frame));
        [btn setTitle:title forState:UIControlStateNormal];
        [btn setTitleColor:self.titleNormalColor forState:UIControlStateNormal];
        [btn setTitleColor:self.titleSelectedColor forState:UIControlStateSelected];
        btn.titleLabel.font = [UIFont systemFontOfSize:self.titleNormalFont];
        btn.layer.borderWidth = self.borderWidth;
        btn.layer.borderColor = self.borderNormalColor.CGColor;
        btn.clipsToBounds = YES;
        if (i == 0) {
            [self setButtonCorner:UIRectCornerTopLeft|UIRectCornerBottomLeft button:btn];
        }else if (i == self.titleArray.count - 1) {
            [self setButtonCorner:UIRectCornerTopRight|UIRectCornerBottomRight button:btn];
        }else {
        }
        
        if (i == _currentIndex) {
            btn.selected = YES;
            [btn setBackgroundColor:self.backGroundSelectedColor];
            btn.layer.borderColor = self.borderSelectedColor.CGColor;
        }
        
        [btn addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btn];
        [self.btArray addObject:btn];
        
         beginX = CGRectGetMaxX(btn.frame) - self.borderWidth;
        
    }
    CGRect originFrame = self.frame;
    originFrame.size.width = beginX;
    self.frame = originFrame;
}
#pragma mark - public method
- (void)drawView {
     [self initSubViews];
}
#pragma mark - event
- (void)click:(UIButton *)btn {
    [self bringSubviewToFront:btn];
    
    if (_currentIndex == btn.tag - 2000) {
        return;
    }
    btn.selected = YES;
    [btn setBackgroundColor:self.backGroundSelectedColor];
    btn.layer.borderColor = self.borderSelectedColor.CGColor;
    
    for (UIButton *sender in self.btArray) {
        if (sender != btn) {
            sender.selected = NO;
            [sender setBackgroundColor:self.backGroundNormalColor];
            sender.layer.borderColor = self.borderNormalColor.CGColor;
        }
    }
    _currentIndex = btn.tag - 2000;
    if (self.selectedBlock) {
        self.selectedBlock(_currentIndex);
    }
}

#pragma mark - tools
- (void)setButtonCorner:(UIRectCorner)corner button:(UIButton *)button{
    
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:button.bounds byRoundingCorners:corner cornerRadii:CGSizeMake(_borderRadius, _borderRadius)];
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    maskLayer.frame = button.bounds;
    maskLayer.path = path.CGPath;
    maskLayer.strokeColor = self.borderNormalColor.CGColor;
    button.layer.mask = maskLayer;
}

- (CGFloat)widthForTitle:(NSString *)title
{
    NSDictionary *attributes = @{NSFontAttributeName : [UIFont systemFontOfSize:self.titleNormalFont]};
    CGSize size = [title boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size;
    size.width = ceil(size.width) + self.titleHorizonPading * 2;
    
    return size.width;
}

#pragma mark - getter and setter
- (NSMutableArray *)btArray {
    if (!_btArray) {
        _btArray = [NSMutableArray array];
    }
    return _btArray;
}


- (UIColor *)colorWithHexString:(NSString *)stringToConvert {
    NSScanner *scanner = [NSScanner scannerWithString:stringToConvert];
    unsigned hexNum;
    if (![scanner scanHexInt:&hexNum]) return nil;
    return [self colorWithRGBHex:hexNum];
}
- (UIColor *)colorWithRGBHex:(UInt32)hex {
    int r = (hex >> 16) & 0xFF;
    int g = (hex >> 8) & 0xFF;
    int b = (hex) & 0xFF;
    
    return [UIColor colorWithRed:r / 255.0f
                           green:g / 255.0f
                            blue:b / 255.0f
                           alpha:1.0f];
}
@end
