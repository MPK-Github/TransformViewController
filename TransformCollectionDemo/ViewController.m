//
//  ViewController.m
//  TransformCollectionDemo
//
//  Created by MaPengkun on 2019/9/4.
//  Copyright © 2019 MaPengkun. All rights reserved.
//

#import "ViewController.h"
#import "TransformViewController.h"

@interface ViewController ()
@property (nonatomic, copy) NSString *aaa;
@property (nonatomic, strong) NSNumber *bbb;
@property (nonatomic, assign) NSInteger ccc;
@property (nonatomic, copy) dispatch_block_t ddd;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(30,100,150,40);
    btn.backgroundColor = [UIColor orangeColor];
    [btn setTitle:@"push" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor yellowColor] forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:18];
    [btn addTarget:self action:@selector(pushAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
}
#pragma mark -event
- (void)pushAction {
    TransformViewController *transVC = [[TransformViewController alloc] init];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:transVC];
    
    [self presentViewController:nav animated:YES completion:nil];
}

@end
