//
//  OKdeerCustomTableView.h
//  OkdeerCommonLibrary
//
//  Created by zichen0422 on 2017/3/15.
//  Copyright © 2017年 OKDeer. All rights reserved.
//

/**
 *  UITableView+OKRequestExtension 提供的Tableview使用还需要讨论下细节
 *  暂时先使用下面的继承类
 *
 */

#import <UIKit/UIKit.h>
#import "OKdeerNoDataView.h"

@class OKdeerCustomTableView;

//返回请求成功还是失败的block
typedef void (^ResultBlock)(BOOL);
// 普通自定义头部刷新block
typedef void (^normalHeaderRefreshBlock)(OKdeerCustomTableView *tableView, NSInteger currentPage);
// gif头部刷新block
typedef void (^gifHeaderRefreshBlock)(OKdeerCustomTableView *tableView, NSInteger currentPage);
// 底部刷新block
typedef void (^FooterRefreshBlock)(OKdeerCustomTableView *tableView, NSInteger index, ResultBlock resultBlock);

@interface OKdeerCustomTableView : UITableView

/**
 *  总页数,默认为1000
 */
@property (nonatomic, assign) NSInteger totalPage;

/**
 *  当前页数,默认为1
 */
@property (nonatomic, assign) __block NSInteger currentPage;

/**
 *  是否展示没有更多的数据view
 */
@property (nonatomic, assign) BOOL isShowNoMoreView;

/**
 *  暂无相关数据对象
 */
@property (nonatomic, strong) OKdeerNoDataView *noDataView;

/**
 *  暂无相关数据 相关处理
 *  @param image 图片UIImage对象
 *  @param tipsTxt 暂无数据内容提示
 *  @param actionTips 操作提示内容
 *  @param block  操作block
 */
- (void)addNoDataViewImage:(UIImage *)image
                   tipsTxt:(NSString *)tipsTxt
                actionTips:(NSString *)actionTips
               actionBlock:(void(^)())block;

/**
 *  没有更多数据...
 *  处理有无更多数据的view展示
 *  @param noMoreTips 无更多数据文字提示
 */
- (void)handleTbvNoMoreDataView:(NSString *)noMoreTips;
/**
 * 隐藏没有更多数据的view
 */
- (void)hideNoMoreDataView;

/**
 *  停止上拉下拉刷新
 */
- (void)stopTableViewRefreshing;

/**
 * 自定义头部 底部刷新
 * normalHeaderRefreshBlock 头部刷新block
 * FooterRefreshBlock 底部刷新block
 */
- (void)addNormalHeaderRefreshblock:(normalHeaderRefreshBlock)headerblock
                 footerRefreshBlock:(FooterRefreshBlock)footerblock;

/**
 * GIF头部 底部刷新
 * gifHeaderRefreshBlock 头部刷新block
 * FooterRefreshBlock 底部刷新block
 */
- (void)addGIFHeaderRefreshblock:(gifHeaderRefreshBlock)headerblock
              footerRefreshBlock:(FooterRefreshBlock)footerblock;


@end


#pragma mark - /*** OKdeerTbvMoreView ***/
@interface OKdeerTbvMoreView : UIView
/**
 * 开始动画
 */
- (void)startImageAnimation;
/**
 * 结束动画
 */
- (void)stopImageAnimation;

@end

