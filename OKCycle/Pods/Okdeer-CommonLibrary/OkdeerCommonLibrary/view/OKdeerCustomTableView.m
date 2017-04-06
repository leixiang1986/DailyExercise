//
//  OKdeerCustomTableView.m
//  OkdeerCommonLibrary
//
//  Created by zichen0422 on 2017/3/15.
//  Copyright © 2017年 OKDeer. All rights reserved.
//

#import "OKdeerCustomTableView.h"
#import <MJRefresh.h>
#import "OkdeerCommDefine.h"
#import "OKdeerMJRefreshGifHeader.h"
#import "OKdeerMJRefreshBackNormalFooter.h"
#import "OKdeerMJRefreshNormalHeader.h"
#import "OkdeerBundleHelp.h"

#define kTopBtnWidth 45
#define kTopBtnHeight 45
#define kTopBtnRight 12
#define kTopBtnBottom 60

#define kObservingKey @"contentOffset"
#define kObservingContext @"topBtn"
#define kShowTopKeyValue 2

@interface OKdeerCustomTableView ()

@property (nonatomic, weak) OKdeerMJRefreshBackNormalFooter *footerView;       /**<  */
@property (nonatomic, copy) ResultBlock resultBlock;
@property (nonatomic, copy) normalHeaderRefreshBlock normalheaderBlock;
@property (nonatomic, copy) gifHeaderRefreshBlock gifheaderBlock;
@property (nonatomic, copy) FooterRefreshBlock footerRefreshBlock;

@property (nonatomic, strong) OKdeerTbvMoreView *moreView; /**< 更多的 */

@end

@implementation OKdeerCustomTableView

#pragma mark - /*** 生命周期 ***/
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [self initWithFrame:frame style:UITableViewStylePlain];
    if (self) {
        
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style{
    self = [super initWithFrame:frame style:style];
    if (self) {
        [self initData];
    }
    return self;
}

- (void)dealloc
{
    [self.mj_header endRefreshing];
    [self.mj_footer endRefreshing];
    self.mj_header = nil;
    self.mj_footer = nil;
    
    //清除相关block
    if (_resultBlock) {
        _resultBlock = nil;
    }
    if (_normalheaderBlock) {
        _normalheaderBlock = nil;
    }
    if (_footerRefreshBlock) {
        _footerRefreshBlock = nil;
    }
    if (_gifheaderBlock) {
        _gifheaderBlock = nil;
    }

    [_moreView removeFromSuperview];
    _moreView = nil;
}

#pragma mark - /*** Action ***/
- (void)initData
{
    _currentPage = 1;
    _totalPage = 1000;
    self.mj_header.backgroundColor = [UIColor clearColor];
    self.mj_footer.backgroundColor = [UIColor clearColor];
    self.showsVerticalScrollIndicator = NO;
}

- (void)handleTbvNoMoreDataView:(NSString *)noMoreTips
{
    /**
     *  处理流程
     *  如果是暂无数据,就展示暂无数据, 可以用self.mj_footer来判断
     *  如果是当前页超过后台的页数就展示无更多数据...
     */
    if (!self.mj_footer) {
        return ;
    }
    // 不需要展示没有更多数据的view return
    if (!self.isShowNoMoreView) {
        return;
    }
    
    //没有更多数据...
    if (self.currentPage >= self.totalPage) {
        [self stopTableViewRefreshing];
        self.mj_footer = nil;
        [self.tableFooterView removeFromSuperview];
        self.moreView.frame = CGRectMake(0, 0, CGRectGetWidth(self.frame), 58);
        self.tableFooterView = self.moreView;
        self.moreView.hidden = NO;
        [self.moreView startImageAnimation];
        [self reloadData];
    }
    else {
        [self hideNoMoreDataView];
        //有展示更多数据的问题..
        if (self.tableFooterView) {
            self.tableFooterView = [UIView new];
        }
    }
}

/**
 * 隐藏没有更多数据的view
 */
- (void)hideNoMoreDataView{
    [_moreView stopImageAnimation];
    _moreView.hidden = YES;
    if (!self.mj_footer) {
        self.mj_footer = self.footerView;
    }
}

// 当前页
- (void)setCurrentPage:(NSInteger)currentPage{
    _currentPage = currentPage;
    if (_currentPage <= 1 ) {
        self.totalPage = 1000;
    }
    [self handleTbvNoMoreDataView:@"没有更多数据"];
}

// --- 总页数
- (void)setTotalPage:(NSInteger)totalPage{
    _totalPage = totalPage;
    [self handleTbvNoMoreDataView:@"没有更多数据"];
}

// 没有更多数据
- (OKdeerTbvMoreView *)moreView{
    if (!_moreView) {
        _moreView = [[OKdeerTbvMoreView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.frame), 58)];
    }
    return _moreView;
}

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
               actionBlock:(void(^)())block
{
    _noDataView = [OKdeerNoDataView initWithText:tipsTxt image:image inSuperView:self show:NO];
    if (actionTips && actionTips.length && block) {
        // 后期再处理这个..
    }
}

#pragma mark - /*** method相关 ***/
/**
 *  头部刷新
 */
- (void)headerRefreshing
{
    self.currentPage = 1;
    
    /**********************************************
     *  下拉刷新时,把上拉刷新加载进去..
     *  是为了解决在暂无数据页面,下拉刷新有数据之后的情况..
     *  modify by chenzl, fix me ^_^
     **********************************************/
    if (!self.mj_footer) {
        self.mj_footer = self.footerView;
    }
    //有展示更多数据的问题..
    if (self.tableFooterView) {
        [self hideNoMoreDataView];
        self.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.frame), 1)];
    }
    
    //block
    if (self.normalheaderBlock) {
        self.normalheaderBlock(self,self.currentPage);
    }
    //block
    if (self.gifheaderBlock) {
        self.gifheaderBlock(self, self.currentPage);
    }
}

/**
 *  底部刷新block回调
 */
-(void)footerRefreshingWithResult:(ResultBlock)resultBlock
{
    _resultBlock = resultBlock;
    _currentPage++;
    if (self.currentPage <= self.totalPage) {
        if (self.footerRefreshBlock) {
            self.footerRefreshBlock(self,self.currentPage, resultBlock);
        }
    }
    else {
        _currentPage -- ;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            if ([self.mj_footer isRefreshing]) {
                [self.mj_footer endRefreshing];
            }
        });
    }
}

/**
 *  停止上拉下拉刷新
 */
- (void)stopTableViewRefreshing
{
    if ([self.mj_header isRefreshing]) {
        [self.mj_header endRefreshing];
    }
    if ([self.mj_footer isRefreshing]) {
        [self.mj_footer endRefreshing];
    }
}




/**
 * 自定义头部 底部刷新
 * @param normalHeaderRefreshBlock 头部刷新block
 * @param FooterRefreshBlock 底部刷新block
 */
- (void)addNormalHeaderRefreshblock:(normalHeaderRefreshBlock)headerblock
                 footerRefreshBlock:(FooterRefreshBlock)footerblock
{
    WEAKSELF(weakSelf)
    if (headerblock) {
        _normalheaderBlock = headerblock;
        if (headerblock) {
            self.mj_header = [OKdeerMJRefreshNormalHeader headerWithRefreshingBlock:^{    //下拉刷新
                STRONGSELF(strongSelf)
                if (strongSelf) {
                    if ([self.mj_footer isRefreshing]) {
                        [self.mj_footer endRefreshing];
                    }
                    [strongSelf headerRefreshing];
                }
            }];
        }
        else {
            self.mj_header = nil;
        }
    }
    
    if (footerblock) {
        _footerRefreshBlock = footerblock;
        if (_footerRefreshBlock) {
            OKdeerMJRefreshBackNormalFooter *footerView = [OKdeerMJRefreshBackNormalFooter footerWithRefreshingBlock:^{ //上拉加载更多
                STRONGSELF(strongSelf)
                if (strongSelf) {
                    if ([self.mj_header isRefreshing]) {
                        [self.mj_header endRefreshing];
                    }
                    [strongSelf footerRefreshingWithResult:^(BOOL result) { //上拉加载之行的事件，调用自定义的方法－>调用设置的footerRefreshBlock
                        if (!result) {
                            strongSelf.currentPage --;
                        }
                        [strongSelf stopTableViewRefreshing];
                    }];
                }
            }];
            self.mj_footer = footerView;
            _footerView = footerView;
        }else{
            self.mj_footer = nil; 
        }
    }
}

/**
 * GIF头部 底部刷新
 * @param gifHeaderRefreshBlock 头部刷新block
 * @param FooterRefreshBlock 底部刷新block
 */
- (void)addGIFHeaderRefreshblock:(gifHeaderRefreshBlock)headerblock
              footerRefreshBlock:(FooterRefreshBlock)footerblock
{
    WEAKSELF(weakSelf)
    if (headerblock) {
        _gifheaderBlock = headerblock;
        if (headerblock) {
            self.mj_header = [OKdeerMJRefreshGifHeader headerWithRefreshingBlock:^{    //下拉刷新
                STRONGSELF(strongSelf)
                if (strongSelf) {
                    [strongSelf stopTableViewRefreshing];
                    [strongSelf headerRefreshing];
                }
            }];
        }
        else {
            self.mj_header = nil;
        }
    }
    
    if (footerblock) {
        _footerRefreshBlock = footerblock;
        if (_footerRefreshBlock) {
            OKdeerMJRefreshBackNormalFooter *footerView = [OKdeerMJRefreshBackNormalFooter footerWithRefreshingBlock:^{ //上拉加载更多
                STRONGSELF(strongSelf)
                if (strongSelf) {
                    [strongSelf stopTableViewRefreshing];
                    [strongSelf footerRefreshingWithResult:^(BOOL result) { //上拉加载之行的事件，调用自定义的方法－>调用设置的footerRefreshBlock
                        if (!result) {
                            strongSelf.currentPage --;
                        }
                        [strongSelf stopTableViewRefreshing];
                    }];
                }
            }];
            self.mj_footer = footerView;
            _footerView = footerView;
        }else{
            self.mj_footer = nil;
        }
    }
}

@end


#pragma mark - /*** OKdeerTbvMoreView ***/
@interface OKdeerTbvMoreView ()

@property (nonatomic,strong) UIImageView *imageView;
@property (nonatomic,strong) UILabel *titleLabel;

@end

@implementation OKdeerTbvMoreView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self imageView];
        [self titleLabel];
    }
    return self;
}
/**
 * 开始动画
 */
- (void)startImageAnimation{
    if (![self.imageView isAnimating]) {
        [self.imageView startAnimating];
    }
}
/**
 * 结束动画
 */
- (void)stopImageAnimation{
    if ([self.imageView isAnimating]) {
        [self.imageView stopAnimating];
    }
}
- (UIImageView *)imageView{
    if (!_imageView) {
        _imageView = [[UIImageView alloc] init];
        NSMutableArray *imageArray = [[NSMutableArray alloc] init];
        for (NSInteger i = 1; i < 8; i ++ ) {
            NSString *imageName = [NSString stringWithFormat:@"TableViewMore0%zd@2x",i];
            if (imageName.length) {
                UIImage *image = GetImagefrombundle(@"view", nil, imageName);
                if (image)[imageArray addObject:image];
            }
        }
        _imageView.animationImages = imageArray;
        _imageView.animationDuration = 14/30.0f;
        [self addSubview:_imageView];
        [self addConstraintToImageView];
    }
    return _imageView;
}

- (void)addConstraintToImageView{
    _imageView.translatesAutoresizingMaskIntoConstraints = false;
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_imageView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_imageView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:40]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_imageView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:40]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_imageView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:-20]];
}

- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.text = @"到底啦~~~";
        _titleLabel.font = [UIFont systemFontOfSize:12];
        [self addSubview:_titleLabel];
        [self addConstraintToTitleLabel];
    }
    return _titleLabel;
}

- (void)addConstraintToTitleLabel{
    _titleLabel.translatesAutoresizingMaskIntoConstraints = false;
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_titleLabel attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBottom multiplier:1.0 constant:-8]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_titleLabel attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.imageView attribute:NSLayoutAttributeRight multiplier:1.0 constant:5]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_titleLabel attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeRight multiplier:1.0 constant:-5]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_titleLabel attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:13]];
}

- (void)dealloc{
    [self stopImageAnimation];
    [_imageView removeFromSuperview];
    _imageView = nil;
    [_titleLabel removeFromSuperview];
    _titleLabel = nil;
}

@end
