//
//  OKdeerMJRefreshGifHeader.m
//  OkdeerCommonLibrary
//
//  Created by zichen0422 on 2017/3/14.
//  Copyright © 2017年 OKDeer. All rights reserved.
//

#import "OKdeerMJRefreshGifHeader.h"
#import "MJRefreshConst.h"
#import "OkdeerBundleHelp.h"

@implementation OKdeerMJRefreshGifHeader

#pragma mark - 重写方法
#pragma mark 基本设置
- (void)prepare
{
    [super prepare];
    
    self.lastUpdatedTimeLabel.hidden = YES;
    self.stateLabel.hidden = YES;
    
//    // 初始化文字
//    [self setTitle:@"下拉实现刷新" forState:MJRefreshStateIdle];
//    [self setTitle:@"松手立即刷新" forState:MJRefreshStatePulling];
//    [self setTitle:@"更新数据中" forState:MJRefreshStateRefreshing];
    
    // 设置普通状态的动画图片
    NSMutableArray *idleImages = [NSMutableArray array];
    for (NSUInteger i = 1; i<=2; i++) {
        NSString *imageName = [NSString stringWithFormat:@"homeRefresh0%zd@2x",i];
        if (imageName.length) {
            UIImage *image = GetImagefrombundle(@"view", nil, imageName);
            if (image) {
                [idleImages addObject:image];
            }
        }
    }
    [self setImages:idleImages forState:MJRefreshStateIdle];
    
    // 设置即将刷新状态的动画图片（一松开就会刷新的状态）
    NSMutableArray *refreshingImages = [NSMutableArray array];
    for (NSUInteger i = 1; i<=2; i++) {
        NSString *imageName = [NSString stringWithFormat:@"homeRefresh0%zd@2x",i];
        if (imageName.length) {
            UIImage *image = GetImagefrombundle(@"view", nil, imageName);
            if (image) {
                [refreshingImages addObject:image];
            }
        }
    }
    [self setImages:refreshingImages forState:MJRefreshStatePulling];
    
    // 设置正在刷新状态的动画图片
    [self setImages:refreshingImages forState:MJRefreshStateRefreshing];
}

- (void)placeSubviews
{
    [super placeSubviews];
    
    self.lastUpdatedTimeLabel.hidden = YES;
    self.stateLabel.hidden = YES;
}

@end
