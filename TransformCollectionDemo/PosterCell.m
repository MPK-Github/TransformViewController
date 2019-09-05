//
//  PosterCell.m
//  TransformCollectionDemo
//
//  Created by MaPengkun on 2019/9/4.
//  Copyright © 2019 MaPengkun. All rights reserved.
//

#import "PosterCell.h"
@interface PosterCell ()

@end

@implementation PosterCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // 设置主视图
        float width = kScreenWidth * .8;
        float height = frame.size.height;
        _contextSupView = [[UIView alloc] init];
        _contextSupView.frame =CGRectMake(width*.05, height*.05, width*.9, height*.9);
        self.backgroundColor = [UIColor cyanColor];
        _contextSupView.backgroundColor = [UIColor redColor];
        [self.contentView addSubview:_contextSupView];

    }
    return self;
}

@end
