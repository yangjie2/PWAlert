//
//  PWAlertStyle.m
//  HHBaseLibSDK
//
//  Created by 杨洁 on 2022/5/18.
//

#import "PWAlertStyle.h"

@implementation PWAlertStyle
- (instancetype)init {
    self = [super init];
    if (self) {
        _titleColor = UIColor.darkGrayColor;
        _titleFont = [UIFont systemFontOfSize:16 weight:UIFontWeightMedium];
        _messageColor = UIColor.systemGrayColor;
        _messageFont = [UIFont systemFontOfSize:14];
        _backgroundColor = UIColor.whiteColor;
        _cornerRadius = 12;
        _confirmButtonBackgroundColor = UIColor.whiteColor;
        _confirmButtonBackgroundColorHighlight = [UIColor colorWithWhite:0.9 alpha:0.6];
        _confirmButtonTitleColor = UIColor.systemYellowColor;
        _confirmButtonTitleColorHighlight = [UIColor.systemYellowColor colorWithAlphaComponent:0.6];
        _otherButtonBackgroundColor = UIColor.whiteColor;
        _otherButtonBackgroundColorHighlight = [UIColor colorWithWhite:0.9 alpha:0.6];
        _otherButtonTitleColor = UIColor.systemGrayColor;
        _otherButtonTitleColorHighlight = [UIColor.systemGrayColor colorWithAlphaComponent:0.6];
        _divideLineColor = [UIColor colorWithRed:210/255.0 green:210/255.0 blue:210/255.0 alpha:1];
    }
    return self;
}

- (void)setConfirmButtonBackgroundImage:(UIImage *)confirmButtonBackgroundImage {
    _confirmButtonBackgroundImage = [self resizableImage:confirmButtonBackgroundImage];
}

- (void)setConfirmButtonBackgroundImageHighlight:(UIImage *)confirmButtonBackgroundImageHighlight {
    _confirmButtonBackgroundImageHighlight = [self resizableImage:confirmButtonBackgroundImageHighlight];
}

- (void)setOtherButtonBackgroundImage:(UIImage *)otherButtonBackgroundImage {
    _otherButtonBackgroundImage = [self resizableImage:otherButtonBackgroundImage];
}

- (void)setOtherButtonBackgroundImageHighlight:(UIImage *)otherButtonBackgroundImageHighlight {
    _otherButtonBackgroundImageHighlight = [self resizableImage:otherButtonBackgroundImageHighlight];
}

- (UIImage *)resizableImage:(UIImage *)image {
    if (!image) {
        return [UIImage new];
    }
    CGSize size = image.size;
    if (size.width >= 1 && size.height >= 1) {
        UIEdgeInsets insets = UIEdgeInsetsMake(floor((size.height-1)/2.0), floor((size.width-1)/2.0), floor((size.height-1)/2.0), floor((size.width-1)/2.0));
        [image resizableImageWithCapInsets:insets resizingMode:UIImageResizingModeStretch];
    }
    return [image resizableImageWithCapInsets:UIEdgeInsetsZero resizingMode:UIImageResizingModeStretch];
}

@end
