//
//  OKAdvertiseCollectionViewCell.m
//  OKAdvertiseView
//
//  Created by 雷祥 on 2017/4/6.
//  Copyright © 2017年 okdeer. All rights reserved.
//

#import "OKAdvertiseCollectionViewCell.h"

@interface OKAdvertiseCollectionViewCell ()
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@end

@implementation OKAdvertiseCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    _imageView.clipsToBounds = YES;

}


- (void)setFillMode:(UIViewContentMode )fillMode {
    _fillMode = fillMode;
    _imageView.contentMode = fillMode;
}

- (void)setImage:(UIImage *)image {
    _image = image;
    _imageView.image = image;
}

- (void)setImage:(UIImage *)image withDefaultImage:(UIImage *)defaultImage {
    _image = image;
    if (!image) {
        self.imageView.image = defaultImage;
    }
    else {
        self.imageView.image = image;
    }
}

- (void)setImageName:(NSString *)imageName withDefaultImage:(UIImage *)defaultImage {
    _imageName = [imageName copy];
    NSURL *url = [NSURL URLWithString:imageName];
    if ([self isRequestUrl:url]) {
        [self.imageView sd_setImageWithURL:url placeholderImage:defaultImage];
    }
    else {
        UIImage *image = [UIImage imageNamed:imageName];
        if (image) {
            [self.imageView setImage:image];
        }
        else {
            [self.imageView setImage:defaultImage];
        }
    }
}


- (BOOL)isRequestUrl:(NSURL *)url {
    if (![url isKindOfClass:[NSURL class]]) {
        return NO;
    }

    if (url.scheme) {
        return YES;
    }

    return NO;
}


@end
