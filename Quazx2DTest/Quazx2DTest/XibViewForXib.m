//
//  XibViewForXib.m
//  Quazx2DTest
//
//  Created by 雷祥 on 16/12/30.
//  Copyright © 2016年 leixiang. All rights reserved.
//

#import "XibViewForXib.h"
#import "masonry.h"

@implementation XibViewForXib

- (void)awakeFromNib {
    [super awakeFromNib];
    [[NSBundle mainBundle] loadNibNamed:@"XibViewForXib" owner:self options:nil];
    [self addSubview:self.contentView];
    self.translatesAutoresizingMaskIntoConstraints = NO;
    self.contentView.translatesAutoresizingMaskIntoConstraints = NO;
    NSLayoutConstraint *left = [NSLayoutConstraint constraintWithItem:self.contentView attribute:(NSLayoutAttributeLeading) relatedBy:(NSLayoutRelationEqual) toItem:self attribute:NSLayoutAttributeLeading multiplier:1 constant:0];
    NSLayoutConstraint *right = [NSLayoutConstraint constraintWithItem:self.contentView attribute:(NSLayoutAttributeTrailing) relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTrailing multiplier:1 constant:0];
    NSLayoutConstraint *top = [NSLayoutConstraint constraintWithItem:self.contentView attribute:(NSLayoutAttributeTop) relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1 constant:0];
    NSLayoutConstraint *bottom = [NSLayoutConstraint constraintWithItem:self.contentView attribute:(NSLayoutAttributeBottom) relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBottom multiplier:1 constant:0];

    [self addConstraints:@[left,right,top,bottom]];
    [self setNeedsUpdateConstraints];


}

@end
