//
//  ViewController.m
//  OKAdvertiseView
//
//  Created by 雷祥 on 2017/4/6.
//  Copyright © 2017年 okdeer. All rights reserved.
//

#import "ViewController.h"
#import "OKCycleView.h"
#import "OKAdvertiseCollectionViewCell.h"

@interface ViewController ()
@property (nonatomic,strong) OKCycleView *advertiseView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.

    OKCycleView *advertiseView = [[OKCycleView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 150) direction:(UICollectionViewScrollDirectionHorizontal) defaultImage:[UIImage imageNamed:@"start004_480"]];
    _advertiseView = advertiseView;
    _advertiseView.canCycle = YES;
    _advertiseView.timeInterval = 4;
    [_advertiseView.collectionView registerNib:[UINib nibWithNibName:@"OKAdvertiseCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"cellId"];
    _advertiseView.selectBlock = ^(OKCycleView *cycleView,NSInteger index){
        NSLog(@"点击了%ld",index);
    };
    [self.view addSubview:advertiseView];
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
//    if (_advertiseView.scrollDirection == UICollectionViewScrollDirectionVertical) {
        _advertiseView.scrollDirection = UICollectionViewScrollDirectionHorizontal;
//    }
//    else {
//        _advertiseView.scrollDirection = UICollectionViewScrollDirectionVertical;
//    }

    static int i = 0;
    i++;
    NSArray *imageNames = @[@"start001_480",@"start002_480",@"start003_480",@"start004_480"];
    self.advertiseView.cellAtIndexPathBlock = ^UICollectionViewCell *(OKCycleView *cycleView,NSIndexPath *indexPath){
        OKAdvertiseCollectionViewCell *cell = [cycleView.collectionView dequeueReusableCellWithReuseIdentifier:@"cellId" forIndexPath:indexPath];
        [cell setImageName:imageNames[indexPath.item] withDefaultImage:[UIImage imageNamed:@"start001_480"]];
        return cell;
    };

    self.advertiseView.dataSourceCount = imageNames.count;
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
