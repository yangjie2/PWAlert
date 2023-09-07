//
//  PWAlertView.m
//  HHBaseLibSDK
//
//  Created by 杨洁 on 2022/5/18.
//

#import "PWAlertView.h"
#import "PWAlertStyle.h"

static CGFloat kPWAlertViewButtonHeight = 48.f;
static CGFloat kPWAlertViewLeadingMargin = 18.f;
static CGFloat kPWAlertViewTitleTopMargin = 18.f;
static CGFloat kPWAlertViewMsgTopMargin = 8.f;
static CGFloat kPWAlertViewActionButtonTopMargin = 20.f;
static CGFloat kPWAlertViewSeparateLineSize = 0.5f;

@interface PWAlertView ()
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIScrollView *contentScrollView;
@property (nonatomic, strong) UILabel *messageLabel;
@property (nonatomic, strong) UIScrollView *buttonScrollView;
@property (nonatomic, copy) NSArray<UIButton *> *buttonsArr;
@property (nonatomic, copy) void(^buttonClickedBlock)(NSInteger index);
@property (nonatomic, strong) UIView<PWAlertViewProtocol> *customView;

//分隔线
@property (nonatomic, strong) UIView *contentBtnSeparateLine; //内容和按钮的分隔线
@property (nonatomic, strong) NSMutableArray<UIView *> *separateLines; //按钮之间的分隔线

@end

@implementation PWAlertView
@synthesize shouldAutorotate = _shouldAutorotate;

- (instancetype)initWithTitle:(NSString *)title
              attributedTitle:(NSAttributedString *)attributedTitle
                      message:(NSString *)message
            attributedMessage:(NSAttributedString *)attributedMessage
           confirmButtonTitle:(nullable NSString *)confirmBtnTitle
            otherButtonTitles:(nullable NSArray<NSString *> *)otherBtnTitles
                   alertStyle:(PWAlertStyle *)alertStyle
           clickedButtonBlock:(void (^)(NSInteger))block {
    self = [super initWithFrame:CGRectZero];
    if (self) {
        self.backgroundColor = alertStyle.backgroundColor;
        self.layer.cornerRadius = alertStyle.cornerRadius;
        self.clipsToBounds = YES;
        _shouldAutorotate = YES;
        _contentScrollView = [[UIScrollView alloc] init];
        _contentScrollView.showsVerticalScrollIndicator = YES;
        _contentScrollView.showsHorizontalScrollIndicator = NO;
        [self addSubview:_contentScrollView];
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.numberOfLines = 0;
        if (attributedTitle.length > 0) {
            _titleLabel.attributedText = attributedTitle;
        }else {
            _titleLabel.text = title;
            _titleLabel.textAlignment = NSTextAlignmentCenter;
            _titleLabel.textColor = alertStyle.titleColor;
            _titleLabel.font = alertStyle.titleFont;
            _titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        }
        [_contentScrollView addSubview:_titleLabel];
        _messageLabel = [[UILabel alloc] init];
        _messageLabel.numberOfLines = 0;
        if (attributedMessage.length > 0) {
            _messageLabel.attributedText = attributedMessage;
        }else {
            _messageLabel.text = message;
            _messageLabel.textAlignment = NSTextAlignmentCenter;
            _messageLabel.textColor = alertStyle.messageColor;
            _messageLabel.font = alertStyle.messageFont;
        }
        [_contentScrollView addSubview:_messageLabel];
        //添加内容和按钮分隔线
        _contentBtnSeparateLine = [[UIView alloc] init];
        _contentBtnSeparateLine.backgroundColor = alertStyle.divideLineColor;
        [self addSubview:_contentBtnSeparateLine];
        
        //按钮
        _buttonScrollView = [[UIScrollView alloc] init];
        _buttonScrollView.showsVerticalScrollIndicator = YES;
        _buttonScrollView.showsHorizontalScrollIndicator = NO;
        [self addSubview:_buttonScrollView];
        NSMutableArray *btnArr = [NSMutableArray array];
        NSInteger index = 0;
        for (NSString *title in otherBtnTitles) {
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            if (alertStyle.otherButtonBackgroundImage) {
                [button setBackgroundImage:alertStyle.otherButtonBackgroundImage forState:UIControlStateNormal];
                [button setBackgroundImage:alertStyle.otherButtonBackgroundImageHighlight forState:UIControlStateHighlighted];
            }else {
                [button setBackgroundImage:[self imageWithColor:alertStyle.otherButtonBackgroundColor] forState:UIControlStateNormal];
                [button setBackgroundImage:[self imageWithColor:alertStyle.otherButtonBackgroundColorHighlight] forState:UIControlStateHighlighted];
            }
            [button setTitleColor:alertStyle.otherButtonTitleColor forState:UIControlStateNormal];
            [button setTitleColor:alertStyle.otherButtonTitleColorHighlight forState:UIControlStateHighlighted];
            button.tag = index;
            [button setTitle:title forState:UIControlStateNormal];
            [button.titleLabel setFont:[UIFont systemFontOfSize:16 weight:UIFontWeightRegular]];
            [button addTarget:self action:@selector(otherButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
            [btnArr addObject:button];
            [_buttonScrollView addSubview:button];
            UIView *line = [[UIView alloc] init];
            line.backgroundColor = alertStyle.divideLineColor;
            [_buttonScrollView addSubview:line];
            [self.separateLines addObject:line];
            index++;
        }
        if (confirmBtnTitle) {
            UIButton *confirmBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            confirmBtn.tag = index;
            if (alertStyle.confirmButtonBackgroundImage) {
                [confirmBtn setBackgroundImage:alertStyle.confirmButtonBackgroundImage forState:UIControlStateNormal];
                [confirmBtn setBackgroundImage:alertStyle.confirmButtonBackgroundImageHighlight forState:UIControlStateHighlighted];
            }else {
                [confirmBtn setBackgroundImage:[self imageWithColor:alertStyle.confirmButtonBackgroundColor] forState:UIControlStateNormal];
                [confirmBtn setBackgroundImage:[self imageWithColor:alertStyle.confirmButtonBackgroundColorHighlight] forState:UIControlStateHighlighted];
            }
            [confirmBtn setTitleColor:alertStyle.confirmButtonTitleColor forState:UIControlStateNormal];
            [confirmBtn setTitleColor:alertStyle.confirmButtonTitleColorHighlight forState:UIControlStateHighlighted];
            [confirmBtn addTarget:self action:@selector(confirmButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
            [confirmBtn setTitle:confirmBtnTitle forState:UIControlStateNormal];
            [confirmBtn.titleLabel setFont:[UIFont systemFontOfSize:16 weight:UIFontWeightRegular]];
            [btnArr addObject:confirmBtn];
            [_buttonScrollView addSubview:confirmBtn];
        }
        self.buttonsArr = btnArr;
        //block
        self.buttonClickedBlock = block;
    }
    return self;
}

- (instancetype)initWithCustomView:(UIView<PWAlertViewProtocol> *)customView
                confirmButtonTitle:(nullable NSString *)confirmBtnTitle
                 otherButtonTitles:(nullable NSArray<NSString *> *)otherBtnTitles
                        alertStyle:(PWAlertStyle *)alertStyle
                clickedButtonBlock:(void(^)(NSInteger index))block {
    self = [super initWithFrame:CGRectZero];
    if (self) {
        self.backgroundColor = alertStyle.backgroundColor;
        self.layer.cornerRadius = alertStyle.cornerRadius;
        self.clipsToBounds = YES;
        _shouldAutorotate = YES;
        _contentScrollView = [[UIScrollView alloc] init];
        _contentScrollView.showsVerticalScrollIndicator = YES;
        _contentScrollView.showsHorizontalScrollIndicator = NO;
        [self addSubview:_contentScrollView];
        if (customView) {
            customView.alertFinished = ^{
                if (self.alertFinished) {
                    self.alertFinished();
                }
            };
        }else {
            customView = (id)[UIView new];
        }
        _customView = customView;
        [_contentScrollView addSubview:customView];
        //添加内容和按钮分隔线
        _contentBtnSeparateLine = [[UIView alloc] init];
        _contentBtnSeparateLine.backgroundColor = alertStyle.divideLineColor;
        [self addSubview:_contentBtnSeparateLine];
        
        //按钮
        _buttonScrollView = [[UIScrollView alloc] init];
        _buttonScrollView.showsVerticalScrollIndicator = YES;
        _buttonScrollView.showsHorizontalScrollIndicator = NO;
        [self addSubview:_buttonScrollView];
        NSMutableArray *btnArr = [NSMutableArray array];
        NSInteger index = 0;
        for (NSString *title in otherBtnTitles) {
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            if (alertStyle.otherButtonBackgroundImage) {
                [button setBackgroundImage:alertStyle.otherButtonBackgroundImage forState:UIControlStateNormal];
                [button setBackgroundImage:alertStyle.otherButtonBackgroundImageHighlight forState:UIControlStateHighlighted];
            }else {
                [button setBackgroundImage:[self imageWithColor:alertStyle.otherButtonBackgroundColor] forState:UIControlStateNormal];
                [button setBackgroundImage:[self imageWithColor:alertStyle.otherButtonBackgroundColorHighlight] forState:UIControlStateHighlighted];
            }
            [button setTitleColor:alertStyle.otherButtonTitleColor forState:UIControlStateNormal];
            [button setTitleColor:alertStyle.otherButtonTitleColorHighlight forState:UIControlStateHighlighted];
            button.tag = index;
            [button setTitle:title forState:UIControlStateNormal];
            [button.titleLabel setFont:[UIFont systemFontOfSize:16 weight:UIFontWeightRegular]];
            [button addTarget:self action:@selector(otherButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
            [btnArr addObject:button];
            [_buttonScrollView addSubview:button];
            UIView *line = [[UIView alloc] init];
            line.backgroundColor = alertStyle.divideLineColor;
            [_buttonScrollView addSubview:line];
            [self.separateLines addObject:line];
            index++;
        }
        if (confirmBtnTitle) {
            UIButton *confirmBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            confirmBtn.tag = index;
            if (alertStyle.confirmButtonBackgroundImage) {
                [confirmBtn setBackgroundImage:alertStyle.confirmButtonBackgroundImage forState:UIControlStateNormal];
                [confirmBtn setBackgroundImage:alertStyle.confirmButtonBackgroundImageHighlight forState:UIControlStateHighlighted];
            }else {
                [confirmBtn setBackgroundImage:[self imageWithColor:alertStyle.confirmButtonBackgroundColor] forState:UIControlStateNormal];
                [confirmBtn setBackgroundImage:[self imageWithColor:alertStyle.confirmButtonBackgroundColorHighlight] forState:UIControlStateHighlighted];
            }
            [confirmBtn setTitleColor:alertStyle.confirmButtonTitleColor forState:UIControlStateNormal];
            [confirmBtn setTitleColor:alertStyle.confirmButtonTitleColorHighlight forState:UIControlStateHighlighted];
            [confirmBtn addTarget:self action:@selector(confirmButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
            [confirmBtn setTitle:confirmBtnTitle forState:UIControlStateNormal];
            [confirmBtn.titleLabel setFont:[UIFont systemFontOfSize:16 weight:UIFontWeightRegular]];
            [btnArr addObject:confirmBtn];
            [_buttonScrollView addSubview:confirmBtn];
        }
        self.buttonsArr = btnArr;
        //block
        self.buttonClickedBlock = block;
    }
    return self;
}

#pragma mark - layout
- (void)layoutSubviews {
    [super layoutSubviews];
    CGRect rect = self.bounds;
    if (CGRectEqualToRect(CGRectZero, rect)) {
        return;
    }
    CGFloat y = 0;
    
    if (_customView) {
        CGSize customSize = CGSizeMake(rect.size.width, 20);
        if ([_customView respondsToSelector:@selector(sizeThatFitContent:)]) {
            customSize = [_customView sizeThatFitContent:rect.size.width];
        }
        _customView.frame = CGRectMake((rect.size.width-customSize.width)/2.0, 0, customSize.width, customSize.height);
        y=y+customSize.height;
    }else {
        if (_titleLabel.attributedText.length > 0 || _titleLabel.text.length > 0) {
            y = y+kPWAlertViewTitleTopMargin;
            CGFloat titlex = kPWAlertViewLeadingMargin;
            CGFloat titleWidth = rect.size.width-2*titlex;
            CGSize titleSize = [_titleLabel sizeThatFits:CGSizeMake(titleWidth, CGFLOAT_MAX)];
            _titleLabel.frame = CGRectMake(titlex, y, titleWidth, titleSize.height+2);
            y = y+titleSize.height+2;
        }
        if (_messageLabel.attributedText.length > 0 || _messageLabel.text.length > 0) {
            y=y+kPWAlertViewMsgTopMargin;
            CGFloat messagex = kPWAlertViewLeadingMargin;
            CGFloat messageWidth = rect.size.width-2*messagex;
            CGSize messageSize = [self boundingSizeWithSize:CGSizeMake(messageWidth, CGFLOAT_MAX) label:_messageLabel];
            _messageLabel.frame = CGRectMake(messagex, y, messageWidth, messageSize.height);
            y=y+messageSize.height;
        }
    }
    y = y+kPWAlertViewActionButtonTopMargin;
    NSInteger btnCount = self.buttonsArr.count;
    CGFloat totalButtonHeight = kPWAlertViewButtonHeight+kPWAlertViewSeparateLineSize;
    if (btnCount > 2) {
        totalButtonHeight = kPWAlertViewSeparateLineSize*btnCount+kPWAlertViewButtonHeight*btnCount;
    }else if (btnCount == 0) {
        totalButtonHeight = 0;
    }
    CGFloat totalAlertHeight = y+totalButtonHeight;
    if (totalAlertHeight <= rect.size.height) {
        _contentScrollView.frame = CGRectMake(0, 0, rect.size.width, y);
        _contentScrollView.contentSize = _contentScrollView.bounds.size;
        _contentBtnSeparateLine.frame = CGRectMake(0, _contentScrollView.frame.origin.y+_contentScrollView.frame.size.height, rect.size.width, kPWAlertViewSeparateLineSize);
        _buttonScrollView.frame = CGRectMake(0, _contentBtnSeparateLine.frame.origin.y+_contentBtnSeparateLine.frame.size.height, rect.size.width, totalButtonHeight);
        _buttonScrollView.contentSize = _buttonScrollView.bounds.size;
        if (btnCount <= 2) {
            if (btnCount == 1) {
                self.buttonsArr.firstObject.frame = CGRectMake(0, 0, rect.size.width, kPWAlertViewButtonHeight);
            }else if (btnCount == 2) { ///btnCount == 2
                CGFloat buttonWidth = (rect.size.width-kPWAlertViewSeparateLineSize)/btnCount;
                UIButton *btn0 = self.buttonsArr[0];
                btn0.frame = CGRectMake(0, 0, buttonWidth, kPWAlertViewButtonHeight);
                UIView *line = self.separateLines[0];
                line.frame = CGRectMake(btn0.frame.origin.x+buttonWidth, 0, kPWAlertViewSeparateLineSize, kPWAlertViewButtonHeight);
                UIButton *btn1 = self.buttonsArr[1];
                btn1.frame = CGRectMake(line.frame.origin.x+kPWAlertViewSeparateLineSize, 0, buttonWidth, kPWAlertViewButtonHeight);
            }else { /////btnCount == 0
                _contentBtnSeparateLine.frame = CGRectZero;
                _buttonScrollView.frame = CGRectZero;
            }
        }else {
            int index = 0;
            for (UIButton *btn in self.buttonsArr) {
                btn.frame = CGRectMake(0, index*(kPWAlertViewButtonHeight+kPWAlertViewSeparateLineSize), _buttonScrollView.frame.size.width, kPWAlertViewButtonHeight);
                if (index > 0) {
                    UIView *line = self.separateLines[index-1];
                    line.frame = CGRectMake(0, index*kPWAlertViewButtonHeight+(index-1)*kPWAlertViewSeparateLineSize, rect.size.width, kPWAlertViewSeparateLineSize);
                }
                index++;
            }
        }
    }else {
        if (btnCount <= 2) {
            _contentScrollView.frame = CGRectMake(0, 0, rect.size.width, rect.size.height-totalButtonHeight);
            _contentScrollView.contentSize = CGSizeMake(rect.size.width, y);
            _contentBtnSeparateLine.frame = CGRectMake(0, _contentScrollView.frame.origin.y+_contentScrollView.frame.size.height, rect.size.width, kPWAlertViewSeparateLineSize);
            _buttonScrollView.frame = CGRectMake(0, _contentBtnSeparateLine.frame.origin.y+_contentBtnSeparateLine.frame.size.height, rect.size.width, kPWAlertViewButtonHeight);
            if (btnCount == 1) {
                self.buttonsArr.firstObject.frame = CGRectMake(0, 0, rect.size.width, kPWAlertViewButtonHeight);
            }else if (btnCount == 2){ ///btnCount == 2
                CGFloat buttonWidth = (rect.size.width-kPWAlertViewSeparateLineSize)/btnCount;
                UIButton *btn0 = self.buttonsArr[0];
                btn0.frame = CGRectMake(0, 0, buttonWidth, kPWAlertViewButtonHeight);
                UIView *line = self.separateLines[0];
                line.frame = CGRectMake(btn0.frame.origin.x+buttonWidth, 0, kPWAlertViewSeparateLineSize, kPWAlertViewButtonHeight);
                UIButton *btn1 = self.buttonsArr[1];
                btn1.frame = CGRectMake(line.frame.origin.x+kPWAlertViewSeparateLineSize, 0, buttonWidth, kPWAlertViewButtonHeight);
            }else { ///btnCount == 0
                _contentBtnSeparateLine.frame = CGRectZero;
                _buttonScrollView.frame = CGRectZero;
            }
        }else { //按钮数量 >= 3
            //内容高度过高
            CGFloat maxButtonHeight = 3*kPWAlertViewButtonHeight;
            if (y >= rect.size.height-maxButtonHeight) {
                _contentScrollView.frame = CGRectMake(0, 0, rect.size.width, rect.size.height-3*kPWAlertViewButtonHeight);
                _contentScrollView.contentSize = CGSizeMake(rect.size.width, y);
                _contentBtnSeparateLine.frame = CGRectMake(0, _contentScrollView.frame.origin.y+_contentScrollView.frame.size.height, rect.size.width, kPWAlertViewSeparateLineSize);
                _buttonScrollView.frame = CGRectMake(0, _contentBtnSeparateLine.frame.origin.y+_contentBtnSeparateLine.frame.size.height, rect.size.width, maxButtonHeight);
                _buttonScrollView.contentSize = CGSizeMake(_buttonScrollView.frame.size.width, totalButtonHeight);
                int index = 0;
                for (UIButton *btn in self.buttonsArr) {
                    btn.frame = CGRectMake(0, index*(kPWAlertViewButtonHeight+kPWAlertViewSeparateLineSize), _buttonScrollView.frame.size.width, kPWAlertViewButtonHeight);
                    if (index > 0) {
                        UIView *line = self.separateLines[index-1];
                        line.frame = CGRectMake(0, index*kPWAlertViewButtonHeight+(index-1)*kPWAlertViewSeparateLineSize, rect.size.width, kPWAlertViewSeparateLineSize);
                    }
                    index++;
                }
            }else {
                _contentScrollView.frame = CGRectMake(0, 0, rect.size.width, y);
                _contentScrollView.contentSize = _contentScrollView.frame.size;
                _contentBtnSeparateLine.frame = CGRectMake(0, _contentScrollView.frame.origin.y+_contentScrollView.frame.size.height, rect.size.width, kPWAlertViewSeparateLineSize);
                _buttonScrollView.frame = CGRectMake(0, _contentBtnSeparateLine.frame.origin.y+_contentBtnSeparateLine.frame.size.height, rect.size.width, rect.size.height-y);
                _buttonScrollView.contentSize = CGSizeMake(_buttonScrollView.frame.size.width, totalButtonHeight);
                int index = 0;
                for (UIButton *btn in self.buttonsArr) {
                    btn.frame = CGRectMake(0, index*(kPWAlertViewButtonHeight+kPWAlertViewSeparateLineSize), _buttonScrollView.frame.size.width, kPWAlertViewButtonHeight);
                    if (index > 0) {
                        UIView *line = self.separateLines[index-1];
                        line.frame = CGRectMake(0, index*kPWAlertViewButtonHeight+(index-1)*kPWAlertViewSeparateLineSize, rect.size.width, kPWAlertViewSeparateLineSize);
                    }
                    index++;
                }
            }
        }
    }
}



#pragma mark - PWAlertViewProtocol
- (CGSize)sizeThatFitContent:(CGFloat)preferredWidth {
    CGFloat y = 0; CGFloat width = preferredWidth;
    if (_customView) {
        if ([_customView respondsToSelector:@selector(sizeThatFitContent:)]) {
            CGSize customSize = [_customView sizeThatFitContent:preferredWidth];
            y = y + customSize.height;
            width = customSize.width;
        }else {
            y = y + 20;
        }
    }else {
        if (_titleLabel.attributedText.length > 0 || _titleLabel.text.length > 0) {
            y = y+kPWAlertViewTitleTopMargin;
            CGFloat titlex = kPWAlertViewLeadingMargin;
            CGFloat titleWidth = width-2*titlex;
            CGSize titleSize = [_titleLabel sizeThatFits:CGSizeMake(titleWidth, CGFLOAT_MAX)];
            y = y+titleSize.height+2;
        }
        if (_messageLabel.attributedText.length > 0 || _messageLabel.text.length > 0) {
            y=y+kPWAlertViewMsgTopMargin;
            CGFloat messagex = kPWAlertViewLeadingMargin;
            CGFloat messageWidth = width-2*messagex;
            CGSize messageSize = [self boundingSizeWithSize:CGSizeMake(messageWidth, CGFLOAT_MAX) label:_messageLabel];
            y=y+messageSize.height;
        }
    }
    y = y+kPWAlertViewActionButtonTopMargin;
    NSInteger btnCount = self.buttonsArr.count;
    CGFloat totalButtonHeight = kPWAlertViewButtonHeight+kPWAlertViewSeparateLineSize;
    if (btnCount > 2) {
        totalButtonHeight = kPWAlertViewSeparateLineSize*btnCount+kPWAlertViewButtonHeight*btnCount;
    }else if (btnCount == 0) {
        totalButtonHeight = 0;
    }
    return CGSizeMake(width, y + totalButtonHeight);
}

- (PWAlertType)alertType {
    return PWAlertTypeAlert;
}


#pragma mark - action
- (void)confirmButtonClicked:(UIButton *)sender {
    if (self.buttonClickedBlock) {
        self.buttonClickedBlock(sender.tag);
    }
    if (self.alertFinished) {
        self.alertFinished();
    }
}

- (void)otherButtonClicked:(UIButton *)sender {
    if (self.buttonClickedBlock) {
        self.buttonClickedBlock(sender.tag);
    }
    if (self.alertFinished) {
        self.alertFinished();
    }
}



#pragma mark - getter
- (NSMutableArray<UIView *> *)separateLines {
    if (!_separateLines) {
        _separateLines = [NSMutableArray array];
    }
    return _separateLines;
}


#pragma mark - private
- (UIImage *)imageWithColor:(UIColor *)color {
    CGSize size = CGSizeMake(1.0, 1.0);
    CGRect rect = CGRectMake(0.0f, 0.0f, size.width, size.height);
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, 0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, color.CGColor);
    CGContextFillRect(context, rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

- (CGSize)boundingSizeWithSize:(CGSize)size label:(UILabel *)label {
    CGSize result = [label sizeThatFits:size];
    return result;
//    NSMutableParagraphStyle *style = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
//    style.lineBreakMode = label.lineBreakMode;
//    style.alignment = label.textAlignment;
//    if (label.text.length > 0) {
//        CGSize tempSize = [label.text boundingRectWithSize:CGSizeMake(size.width, size.height) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:label.font, NSParagraphStyleAttributeName:style} context:nil].size;
//        return CGSizeMake(tempSize.width, tempSize.height + 2);
//    }else if (label.attributedText.length > 0) {
//        CGSize tempSize = [label.attributedText boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading context:nil].size;
//        return CGSizeMake(tempSize.width, tempSize.height + 2);
//    }
//    return CGSizeZero;
}


@end
