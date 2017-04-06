//
//  OKAdvertiseView.m
//  OKAdvertiseView
//
//  Created by 雷祥 on 2017/4/6.
//  Copyright © 2017年 okdeer. All rights reserved.
//

#import "OKCycleView.h"
#import "OKAdvertiseCollectionViewCell.h"
#import "OkdeerTimer.h"

static NSInteger const kGroupNum = 5;     //数据的组数

@interface OKCycleView ()<UICollectionViewDataSource,UICollectionViewDelegate>@property (nonatomic, weak) UICollectionViewFlowLayout *flowLayout;
@property (nonatomic, strong, readwrite) UICollectionView *collectionView;     //内部的collectionView
//@property (nonatomic, strong) OkdeerTimer *timer;
@property (nonatomic, strong) dispatch_source_t timer;

@property (nonatomic, assign) BOOL timerIsPaused;       // 多次暂停无法重启定时器，没有找到判断gcd定时器的状态方法，暂时用外部变量标记定时器是否是暂停的状态
@property (nonatomic, strong) UIImageView *backgroundView;  //collectionView的背景view
@end


@implementation OKCycleView



- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _dataSourceCount = 0;
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.minimumLineSpacing = 0;
        flowLayout.minimumInteritemSpacing = 0;
        flowLayout.itemSize = frame.size;
        flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _flowLayout = flowLayout;

        UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:frame collectionViewLayout:flowLayout];
        [collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([OKAdvertiseCollectionViewCell class]) bundle:nil] forCellWithReuseIdentifier:@"cellId"];
        collectionView.delegate = self;
        collectionView.dataSource = self;
        collectionView.pagingEnabled = YES;
        collectionView.backgroundColor = [UIColor whiteColor];
        collectionView.showsHorizontalScrollIndicator = NO;
        collectionView.showsVerticalScrollIndicator = NO;
        collectionView.backgroundView = self.backgroundView;
        _collectionView = collectionView;
        [self addSubview:collectionView];

        _fillMode = UIViewContentModeScaleAspectFill;

    }
    _pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, self.frame.size.height - 20, self.frame.size.width, 20)];
    [self addSubview:_pageControl];

    return self;
}



- (instancetype)initWithFrame:(CGRect)frame direction:(UICollectionViewScrollDirection)direction defaultImage:(UIImage *)image{
    _scrollDirection = direction;
    _defaultImage = image;
    self = [self initWithFrame:frame];

    return self;
}

- (UIImageView *)backgroundView {
    if (!_backgroundView) {
        _backgroundView = [[UIImageView alloc] initWithFrame:self.bounds];
        _backgroundView.image = _defaultImage;
    }

    return _backgroundView;
}


- (dispatch_source_t)timer {
    if (!_timer) {
        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
        dispatch_source_set_event_handler(_timer, ^{
            //在这里执行事件
            NSLog(@"每秒执行test:%@",[NSThread currentThread]);
            dispatch_async(dispatch_get_main_queue(), ^{
                [self scrollView];
            });
        });
        
        dispatch_resume(_timer);
    }

    return _timer;
}



-(void) pauseTimer{
    NSLog(@"重新启动定时器(暂停):%@",_timer);
    if (_timerIsPaused == YES) {    //重复挂起无法重新启动
        return;
    }

    _timerIsPaused = YES;
    if(_timer){
        dispatch_suspend(_timer);
    }
}
-(void) resumeTimer{
    NSLog(@"重新启动定时器:%@",_timer);
    if (!_timerIsPaused) {
        return;
    }

    _timerIsPaused = NO;
    if(_timer){
        dispatch_resume(_timer);
    }
}
-(void) stopTimer{
    if(_timer){
        dispatch_source_cancel(_timer);
        _timer = nil;
    }
}


- (void)scrollView {

    NSLog(@"自动滚动的contentOffset:%@",NSStringFromCGPoint(self.collectionView.contentOffset));
    if (_scrollDirection == UICollectionViewScrollDirectionVertical) {
        [self.collectionView setContentOffset:CGPointMake(0, self.collectionView.contentOffset.y + self.collectionView.frame.size.height) animated:YES];
    }
    else {
        [self.collectionView setContentOffset:CGPointMake(self.collectionView.contentOffset.x + self.collectionView.frame.size.width, 0) animated:YES];
    }
    NSLog(@"自动滚动的contentOffset结束:%@",NSStringFromCGPoint(self.collectionView.contentOffset));
}

#pragma mark - 复写系统方法

- (void)layoutSubviews {
    [super layoutSubviews];
    _pageControl.frame = CGRectMake(0, self.frame.size.height - _pageControl.frame.size.height, self.frame.size.width, _pageControl.frame.size.height);
    _collectionView.frame = self.bounds;
}


- (void)setFrame:(CGRect)frame {
    [super setFrame:frame];
    _flowLayout.itemSize = frame.size;
}

#pragma mark - 设置外部数据

- (void)setPageControl:(UIPageControl *)pageControl {
    _pageControl = pageControl;
    [self addSubview:_pageControl];
    [self layoutSubviews];
}

- (void)setDefaultImage:(UIImage *)defaultImage {
    _defaultImage = defaultImage;
    self.backgroundView.image = defaultImage;
    [self.collectionView reloadData];
}


- (void)setFillMode:(UIViewContentMode)fillMode {
    _fillMode = fillMode;
    [self.collectionView reloadData];
}




- (void)setDataSourceCount:(NSInteger)dataSourceCount {
    _dataSourceCount = dataSourceCount;
    [self stopTimer];   //先停止上一次
    if (!_dataSourceCount) {  //没有数据显示背景图
        self.collectionView.backgroundView = self.backgroundView;
    }
    else {
        self.collectionView.backgroundView = nil;
        if (_timeInterval > 0) {
            [self timer];
            dispatch_source_set_timer(_timer, dispatch_walltime(NULL, 0), _timeInterval * NSEC_PER_SEC, 0);

        }
    }
    _pageControl.numberOfPages = dataSourceCount;
    [self.collectionView reloadData];
}


- (void)setCanCycle:(BOOL)canCycle {
    _canCycle = canCycle;
    [self.collectionView reloadData];
}


- (void)setTimeInterval:(NSTimeInterval)timeInterval {
    _timeInterval = timeInterval;
    if (_timeInterval >= 0) {
        [self stopTimer];   //先停止上一次
        if (_dataSourceCount > 0) {
            [self timer];
            dispatch_source_set_timer(_timer, dispatch_walltime(NULL, 0), _timeInterval * NSEC_PER_SEC, 0);

        }
    }
    else {
        [self stopTimer];
    }
}

- (void)setScrollDirection:(UICollectionViewScrollDirection)scrollDirection {
    _scrollDirection = scrollDirection;
    if (scrollDirection == UICollectionViewScrollDirectionVertical) {
        _pageControl.hidden = YES;
    }
    else {
        _pageControl.hidden = NO;
    }
    _flowLayout.scrollDirection = scrollDirection;
}

#pragma mark - 代理方法
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.cellAtIndexPathBlock) {
        NSIndexPath *index = [NSIndexPath indexPathForItem:indexPath.item % _dataSourceCount inSection:0];
        UICollectionViewCell *cell = self.cellAtIndexPathBlock(self,index);
        return cell;
    }
    else {
        return nil;
    }
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (_canCycle) {
        return _dataSourceCount * kGroupNum;
    }
    else {
        return _dataSourceCount;
    }
}

/**
 * 处理循环
 */
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [self resumeTimer];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {

    if (_canCycle) {
        if (_scrollDirection == UICollectionViewScrollDirectionHorizontal) {
            dispatch_async(dispatch_get_global_queue(0, 0), ^{
                NSInteger scrollViewContentOffsetX = (NSInteger)(scrollView.contentOffset.x);
                NSInteger groupWidth = (NSInteger)scrollView.frame.size.width * _dataSourceCount;
                NSInteger offsetX = scrollViewContentOffsetX % groupWidth;  //在该组内的偏移量
                NSInteger page = offsetX / scrollView.frame.size.width; //该组的页数
                NSInteger groupCount = scrollView.contentOffset.x / (scrollView.frame.size.width * _dataSourceCount);  //第几组数据
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (groupCount != kGroupNum/2) {   //判断是不是中间一组数据,不是中间一组，偏移到中间
                        CGFloat middleOffSetX = kGroupNum/2 * _dataSourceCount * scrollView.frame.size.width + offsetX;
                        [scrollView setContentOffset:CGPointMake(middleOffSetX, 0) animated:NO];
                    }
                    if (_pageControl) {
                        _pageControl.currentPage = page;
                    }
                });

            });

        }
        else if (_scrollDirection == UICollectionViewScrollDirectionVertical) { //竖直滚动
            dispatch_async(dispatch_get_global_queue(0, 0), ^{
                NSInteger scrollViewContentOffsetY = (NSInteger)(scrollView.contentOffset.y);
                NSInteger groupHeight = (NSInteger)scrollView.frame.size.height * _dataSourceCount;
                NSInteger offsetY = scrollViewContentOffsetY % groupHeight; //在该组内的偏移量
                NSInteger page = offsetY / scrollView.frame.size.height;    //该组的页数
                NSInteger count = scrollView.contentOffset.y / (scrollView.frame.size.height * _dataSourceCount);  //第几组数据
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (count != kGroupNum/2) {   //判断是不是中间一组数据,不是中间一组，偏移到中间
                        CGFloat middleOffSetY = (kGroupNum / 2) * _dataSourceCount * scrollView.frame.size.height + offsetY;
                        [scrollView setContentOffset:CGPointMake(0, middleOffSetY) animated:NO];
                    }
                    if (_pageControl) {
                        _pageControl.currentPage = page;
                    }
                });
            });
        }
    }
}


- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self pauseTimer];  //手动滚动后又自动滚动
}





- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger index = indexPath.item % _dataSourceCount;
    if (self.selectBlock) {
        self.selectBlock(self,index);
        NSLog(@"%ld===",index);
    }
}



@end
