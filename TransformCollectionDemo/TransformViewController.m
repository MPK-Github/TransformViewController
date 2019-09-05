//
//  TransformViewController.m
//  TransformCollectionDemo
//
//  Created by MaPengkun on 2019/9/4.
//  Copyright © 2019 MaPengkun. All rights reserved.
//

#import "TransformViewController.h"
#import "PosterCell.h"

static NSString * const kCellId = @"PosterCell";

@interface TransformViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UIScrollViewDelegate>
@property (nonatomic, strong) UICollectionView *collection;
@property (nonatomic, assign) CGFloat centerInset;
@property (nonatomic, strong) NSIndexPath *centerIndexPath;
@property (nonatomic, strong) NSMutableArray *dataList;

@end

@implementation TransformViewController

- (instancetype)init {
    self = [super init];
    if (self) {
        _centerInset = kScreenWidth *0.1;
        _centerIndexPath = [NSIndexPath indexPathForItem:0 inSection:0];
        _dataList = [NSMutableArray array];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Transfrom";
    self.view.backgroundColor = [UIColor whiteColor];
    [self initLeftButton];
    [self.dataList addObjectsFromArray:@[@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9"]];
    [self.view addSubview:self.collection];
}

- (void)initLeftButton {
    UIButton *back = [UIButton buttonWithType:UIButtonTypeCustom];
    back.frame = CGRectMake(0,0,34,34);
    back.backgroundColor = [UIColor yellowColor];
    [back setTitle:@"back" forState:UIControlStateNormal];
    [back setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
    back.titleLabel.font = [UIFont systemFontOfSize:17];
    [back addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:back];
    
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataList.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    PosterCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCellId forIndexPath:indexPath];
    [cell setNeedsLayout];
    return cell;
}

#pragma mark - UICollectionViewDelegate
//  选中单元格
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    //  判断当前选中的单元格  是不是 记录中的索引的单元格
    //  如果选中的是记录中的索引单元格，则就实现翻转效果(切换视图)
    if (_centerIndexPath.item == indexPath.item) {
        
        PosterCell *cell = (PosterCell *)[collectionView cellForItemAtIndexPath:indexPath];
        if (cell) {
            //此处可以做一些事情或者不做
        }
    }else{
        
        //  计算选中的单元格应该停靠的中间位置
        //        float cellCenter = -_centerInset +indexPath.item * (kScreenWidth*.8);
        //        //  将选中的单元格设置到中间的位置
        //        CGPoint point = CGPointMake( cellCenter, 0);
        //        //  设置到当前的单元格的中心位置
        //        [self.collection setContentOffset:point animated:YES];
        
        //  记录当前索引位置
        self.centerIndexPath = indexPath;
        
        UICollectionViewLayoutAttributes *attribute = [self.collection.collectionViewLayout layoutAttributesForItemAtIndexPath:self.centerIndexPath];
        
        if (attribute) {
            CGPoint centerPoint = CGPointMake(attribute.center.x - CGRectGetWidth(self.collection.bounds) / 2, 0);
            [self.collection setContentOffset:centerPoint animated:YES];
            
        }
        
        
    }
}


#pragma mark - UIScrollViewDelegate
- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView
                     withVelocity:(CGPoint)velocity
              targetContentOffset:(inout CGPoint *)targetContentOffset
{
    if (velocity.x > 0.3 ) {
        //  下滑到下一个单元格
        if (_centerIndexPath.item<_dataList.count-1) {
            self.centerIndexPath = [NSIndexPath indexPathForItem:_centerIndexPath.item+1 inSection:0];
        }
        
    }else if (velocity.x < -0.3)
    {
        if (_centerIndexPath.item>0) {
            self.centerIndexPath = [NSIndexPath indexPathForItem:_centerIndexPath.item-1 inSection:0];
        }
        
    }
    else{
        // 计算中间的Cell是第几个，存入到centerIndexPath中
        int centerIndexCell = (int)(scrollView.contentOffset.x + _centerInset + kScreenWidth*.4)/(kScreenWidth*.8);
        
        self.centerIndexPath = [NSIndexPath indexPathForItem:centerIndexCell inSection:0];
    }
    
    //  将视图滑动到指定的位置
    UICollectionViewLayoutAttributes *attribute = [self.collection.collectionViewLayout layoutAttributesForItemAtIndexPath:self.centerIndexPath];
    
    if (attribute) {
        targetContentOffset->x = attribute.center.x - CGRectGetWidth(self.collection.bounds) / 2;
    }
    NSLog(@"_centerInset:%f,targetContentOffset->x:%f",_centerInset,targetContentOffset->x);
    
}

//  滑动效果,时时调用哦
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    //  1.获取当前滑动视图中所有显示的item的索引集合
    NSArray *indexPaths = [self.collection indexPathsForVisibleItems];
    
    //  02.遍历所有的单元格
    for (NSIndexPath *indexPath in indexPaths) {
        // 计算当前单元格在中心位置时滑动的偏移量
        float cellCenter = indexPath.item * kScreenWidth *.8 - _centerInset;
        float distance = scrollView.contentOffset.x - cellCenter;
        
        //  获取当前单元格,根据偏移量可以做一些滑动效果
        PosterCell *cell = (PosterCell *)[self.collection cellForItemAtIndexPath:indexPath];
        
        //缩放效果
        NSLog(@"第%ld个cell距离中心位置为%f",indexPath.item,distance);
        //  设置缩放比例 1~0.7   0 ~ 264
        float scale = 1.0 - (ABS(distance) / (kScreenWidth * .8)) * .1;
        cell.contextSupView.transform = CGAffineTransformMakeScale(scale, scale);
        
        //  3d旋转效果
        // 264 ～ 0   M_PI_4 / 2 ~ 0
        
        //        float rotate = distance / (kScreenWidth * .8) * (M_PI_4 / 2.0);
        //
        //        CATransform3D transfromScale = CATransform3DMakeScale(1, 1, 1);
        //
        //        //  设置远近视差效果
        //        transfromScale.m34 = -0.003f;
        //
        //        //  设置旋转轴
        //        CATransform3D transform = CATransform3DRotate(transfromScale, rotate, 0, 1, 0);
        //        cell.contextSupView.layer.transform = transform;
        
    }
    
}
#pragma mark - event
- (void)backAction {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - getter and setter
- (UICollectionView *)collection {
    if (!_collection) {
        UICollectionViewFlowLayout *flowFlowLayout = [[UICollectionViewFlowLayout alloc] init];
        _collection = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 64+24, kScreenWidth, kScreenHeight - 64 - 24 - 34) collectionViewLayout:flowFlowLayout];
        _collection.backgroundColor = [UIColor whiteColor];
        flowFlowLayout.itemSize = CGSizeMake(kScreenWidth*.8, kScreenHeight - 64 - 24 - 34);
        //  设置行间距
        flowFlowLayout.minimumInteritemSpacing = 0;
        flowFlowLayout.minimumLineSpacing = 1;
        //  设置滑动方向
        flowFlowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _collection.dataSource = self;
        _collection.delegate = self;
        _collection.contentInset = UIEdgeInsetsMake(0, _centerInset, 0, _centerInset);
        _collection.decelerationRate = UIScrollViewDecelerationRateFast;
        [_collection registerClass:[PosterCell class] forCellWithReuseIdentifier:kCellId];
    }
    return _collection;
}


@end
