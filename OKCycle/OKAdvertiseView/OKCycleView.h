//
//  OKAdvertiseView.h
//  OKAdvertiseView
//
//  Created by 雷祥 on 2017/4/6.
//  Copyright © 2017年 okdeer. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger,OKCycleDirection) {
    OKCycleDirectionH,      //水平
    OKCycleDirectionV       //竖直
};

@interface OKCycleView : UIView
@property (nonatomic, strong, readonly) UICollectionView *collectionView;   //用于循环的collectionView,需要注册cell
@property (nonatomic, assign) BOOL canCycle;                                //是否能够循环,如果设置了自动滚动的时间，默认是能够循环
@property (nonatomic, strong) UIImage *defaultImage;                        //默认图
@property (nonatomic, strong) UIPageControl *pageControl;                   //如需定制，外部实例化一个PageControl的子类传入
@property (nonatomic, assign) UIViewContentMode fillMode;                   //图片填充模式,默认UIViewContentModeScaleAspectFill
@property (nonatomic, assign) UICollectionViewScrollDirection scrollDirection;  //循环方向,默认水平
@property (nonatomic, assign) NSTimeInterval timeInterval;                  //循环间距,默认不循环
@property (nonatomic, assign) NSInteger dataSourceCount;                    //数据源的个数


@property (nonatomic, copy) UICollectionViewCell *(^cellAtIndexPathBlock)(OKCycleView *cycleView,NSIndexPath *indexPath);  //根据index返回对应的带有数据的UICollectionViewCell,获取之前应用collectionView注册对应的cell
@property (nonatomic, copy) void (^selectBlock)(OKCycleView *cycleView,NSInteger index);   //选中的index

- (instancetype)initWithFrame:(CGRect)frame direction:(UICollectionViewScrollDirection)direction defaultImage:(UIImage *)image;



@end
