//
//  Test2TableViewCell.m
//  AutoLayoutTest
//
//  Created by 雷祥 on 17/2/7.
//  Copyright © 2017年 leixiang. All rights reserved.
//

#import "Test2TableViewCell.h"

@interface Test2TableViewCell ()
{
    UIView *snapView;   //快照,动画操作是对快照的操作。
}
@property (weak, nonatomic) IBOutlet UIView *shadowView;

@end

@implementation Test2TableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    _shadowView.layer.shadowColor = [UIColor grayColor].CGColor;
    _shadowView.layer.shadowOffset = CGSizeMake(3.0, 3.0);
    _shadowView.layer.shadowOpacity = YES;
    _shadowView.layer.shadowRadius = 5.0;

//    [_shadowView snapshotViewAfterScreenUpdates:NO];

    UILongPressGestureRecognizer *longGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longGesture:)];
    [self.contentView addGestureRecognizer:longGesture];

}


- (void)longGesture:(UILongPressGestureRecognizer *)gesture {
    CGPoint statePoint = CGPointZero;
    switch (gesture.state) {
        case UIGestureRecognizerStateBegan:
        {
            snapView = [_shadowView snapshotViewAfterScreenUpdates:NO];
            snapView.frame = _shadowView.frame;
            snapView.transform = CGAffineTransformMakeRotation(M_PI / 30.0);
            [self.contentView addSubview:snapView];
            
            _shadowView.hidden = YES;
            break;
        }

        case UIGestureRecognizerStateChanged:
        {
            CGPoint changedPoint = [gesture locationInView:self.contentView];
            snapView.center = changedPoint;
            break;
        }

        case UIGestureRecognizerStateEnded:
        {
            CGPoint endPoint = [gesture locationInView:self.contentView];
            if (ABS(endPoint.x) > self.contentView.bounds.size.width - 50) {
                if (self.cellBlock) {
                    self.cellBlock(YES,_indexPath);
                }
            }else {
                if (self.cellBlock) {
                    self.cellBlock(NO,_indexPath);
                }
            }

            [snapView removeFromSuperview];
            self.shadowView.hidden = NO;

            break;
        }

        default:
            break;
    }


}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
