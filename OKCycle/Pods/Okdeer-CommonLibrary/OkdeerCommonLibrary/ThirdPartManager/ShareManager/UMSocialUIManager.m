//
//  UMSocialUIManager.m
//  UMSocialSDK
//
//  Created by umeng on 16/8/10.
//  Copyright © 2016年 dongjianxiong. All rights reserved.
//

#import "UMSocialUIManager.h"

@interface UMSocialUIManager ()

@property (nonatomic, strong) UMShareMenuSelectionView *shareMenuView;

@end

@implementation UMSocialUIManager

+ (UMSocialUIManager *)defaultManager
{
    static UMSocialUIManager *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!instance) {
            instance = [[self alloc] init];
        }
    });
    return instance;
}

+ (void)showShareMenuViewInWindowWithPlatformSelectionBlock:(UMSocialSharePlatformSelectionBlock)sharePlatformSelectionBlock
{
    UMSocialUIManager *uiManager = [UMSocialUIManager defaultManager];
    [uiManager showShareMenuViewInWindowWithPlatformSelectionBlock:sharePlatformSelectionBlock];
}

/**
 * 增加一个方法  传多一个分享的平台
 */
+ (void)showShareMenuViewInWindowWithPlatformTypeArray:(NSArray *)platformTypeArray  platformSelectionBlock:(UMSocialSharePlatformSelectionBlock)sharePlatformSelectionBlock dismissBlock:(void (^)())dismissBlock{
     UMSocialUIManager *uiManager = [UMSocialUIManager defaultManager];
    [uiManager showShareMenuViewInWindowWithPlatformTypeArray:platformTypeArray platformSelectionBlock:sharePlatformSelectionBlock dismissBlock:dismissBlock];
}

- (void)showShareMenuViewInWindowWithPlatformSelectionBlock:(UMSocialSharePlatformSelectionBlock)sharePlatformSelectionBlock
{
    if (!self.shareMenuView) {
        [self creatShareSelectionView];
    }
    self.shareMenuView.shareSelectionBlock = ^(UMShareMenuSelectionView *shareSelectionView,UMSocialPlatformType platformType){
        if (sharePlatformSelectionBlock) {
            sharePlatformSelectionBlock(shareSelectionView, platformType);
        }
    };

    [self.shareMenuView show];
}

- (void)showShareMenuViewInWindowWithPlatformTypeArray:(NSArray *)platformTypeArray  platformSelectionBlock:(UMSocialSharePlatformSelectionBlock)sharePlatformSelectionBlock dismissBlock:(void (^)())dismissBlock{
    if (!self.shareMenuView) {
        [self creatShareSelectionView];
    }
    self.shareMenuView.customPlatformTypeArray = platformTypeArray;
    self.shareMenuView.shareSelectionBlock = ^(UMShareMenuSelectionView *shareSelectionView,UMSocialPlatformType platformType){
        if (sharePlatformSelectionBlock) {
            sharePlatformSelectionBlock(shareSelectionView, platformType);
        }
    };
    self.shareMenuView.dismissBlock = ^(){
        if (dismissBlock) {
            dismissBlock();
        }
    };
    [self.shareMenuView show];
}


- (void)creatShareSelectionView
{
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;

    UMShareMenuSelectionView *selectionView = [[UMShareMenuSelectionView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    self.shareMenuView = selectionView;
}




@end
