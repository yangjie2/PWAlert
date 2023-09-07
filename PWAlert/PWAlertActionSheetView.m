//
//  PWAlertActionSheetView.m
//  PWUIKitDemo
//
//  Created by yangjie on 2022/12/7.
//

#import "PWAlertActionSheetView.h"

static CGFloat kPWAlertActionSheetButtonHeight = 52.f;
static CGFloat kPWAlertActionSheetLeadingMargin = 18.f;
static CGFloat kPWAlertActionSheetTitleTopMargin = 10.f;
static CGFloat kPWAlertActionSheetMsgTopMargin = 4.f;
static CGFloat kPWAlertActionSheetOtherButtonTopMargin = 20.f;
static CGFloat kPWAlertActionSheetConfirmButtonTopMargin = 8.f;
static CGFloat kPWAlertActionSheetSeparateLineSize = 0.5f;

static CGFloat kPWAlertActionSheetSpacer = 8.0f;

@interface PWAlertActionSheetView ()
@property (nonatomic, strong) UIView *topContentView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIScrollView *msgScrollView;
@property (nonatomic, strong) UILabel *messageLabel;
@property (nonatomic, strong) UIScrollView *buttonScrollView;
@property (nonatomic, copy) NSArray<UIButton *> *buttonsArr;
@property (nonatomic, copy) void(^buttonClickedBlock)(NSInteger index);


//内容和按钮的分隔线
@property (nonatomic, strong) UIView *messageBtnSeparateLine;
///按钮之间的分隔线
@property (nonatomic, strong) NSMutableArray<UIView *> *separateLines;

///底部确认按钮
@property (nonatomic, strong) UIButton *confirmButton;

@end
@implementation PWAlertActionSheetView
@synthesize shouldAutorotate = _shouldAutorotate;

- (instancetype)initWithTitle:(NSString *)title
              attributedTitle:(nullable NSAttributedString *)attributedTitle
                      message:(nullable NSString *)message
            attributedMessage:(nullable NSAttributedString *)attributedMessage
           confirmButtonTitle:(nullable NSString *)confirmBtnTitle
                   alertStyle:(PWAlertStyle *)alertStyle
            otherButtonTitles:(nullable NSArray<NSString *> *)otherBtnTitles
highlightedButtonTitleIndexes:(nullable NSArray*)indexes
           clickedButtonBlock:(void(^)(NSInteger index))block {
    self = [super initWithFrame:CGRectZero];
    if (self) {
        self.backgroundColor = UIColor.clearColor;
        _shouldAutorotate = YES;
        _topContentView = [[UIView alloc] init];
        _topContentView.backgroundColor = UIColor.whiteColor;
        _topContentView.layer.cornerRadius = alertStyle.cornerRadius;
        _topContentView.layer.masksToBounds = YES;
        [self addSubview:_topContentView];
        _msgScrollView = [[UIScrollView alloc] init];
        _msgScrollView.showsVerticalScrollIndicator = YES;
        _msgScrollView.showsHorizontalScrollIndicator = NO;
        
        [_topContentView addSubview:_msgScrollView];
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.numberOfLines = 0;
        if (attributedTitle.length > 0) {
            _titleLabel.attributedText = attributedTitle;
        }else {
            _titleLabel.text = title;
            _titleLabel.textAlignment = NSTextAlignmentCenter;
            _titleLabel.textColor = alertStyle.titleColor;
            _titleLabel.font = [UIFont systemFontOfSize:13 weight:UIFontWeightMedium];
            _titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        }
        [_msgScrollView addSubview:_titleLabel];
        _messageLabel = [[UILabel alloc] init];
        _messageLabel.numberOfLines = 0;
        if (attributedMessage.length > 0) {
            _messageLabel.attributedText = attributedMessage;
        }else {
            _messageLabel.text = message;
            _messageLabel.textAlignment = NSTextAlignmentCenter;
            _messageLabel.textColor = alertStyle.messageColor;
            _messageLabel.font = [UIFont systemFontOfSize:13];
        }
        [_msgScrollView addSubview:_messageLabel];
        
        //按钮
        _buttonScrollView = [[UIScrollView alloc] init];
        _buttonScrollView.backgroundColor = UIColor.whiteColor;
        _buttonScrollView.showsVerticalScrollIndicator = YES;
        _buttonScrollView.showsHorizontalScrollIndicator = NO;
        [_topContentView addSubview:_buttonScrollView];
        //添加内容和按钮分隔线
        if (otherBtnTitles.count > 0) {
            if (title.length > 0 || attributedTitle.length > 0 || message.length >0 || attributedMessage.length > 0) {
                //添加内容和按钮分隔线
                _messageBtnSeparateLine = [[UIView alloc] init];
                _messageBtnSeparateLine.backgroundColor = alertStyle.divideLineColor;
                [_topContentView addSubview:_messageBtnSeparateLine];
            }
            
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
                if (index > 0) {
                    UIView *line = [[UIView alloc] init];
                    line.backgroundColor = alertStyle.divideLineColor;
                    [_buttonScrollView addSubview:line];
                    [self.separateLines addObject:line];
                }
                index++;
            }
            self.buttonsArr = btnArr;
        }
        if (confirmBtnTitle) {
            _confirmButton = [UIButton buttonWithType:UIButtonTypeCustom];
            _confirmButton.layer.cornerRadius = alertStyle.cornerRadius;
            _confirmButton.layer.masksToBounds = YES;
            _confirmButton.tag = -1; ///action sheet 取消按钮index默认-1
            if (alertStyle.confirmButtonBackgroundImage) {
                [_confirmButton setBackgroundImage:alertStyle.confirmButtonBackgroundImage forState:UIControlStateNormal];
                [_confirmButton setBackgroundImage:alertStyle.confirmButtonBackgroundImageHighlight forState:UIControlStateHighlighted];
            }else {
                [_confirmButton setBackgroundImage:[self imageWithColor:alertStyle.confirmButtonBackgroundColor] forState:UIControlStateNormal];
                [_confirmButton setBackgroundImage:[self imageWithColor:alertStyle.confirmButtonBackgroundColorHighlight] forState:UIControlStateHighlighted];
            }
            [_confirmButton setTitleColor:alertStyle.confirmButtonTitleColor forState:UIControlStateNormal];
            [_confirmButton setTitleColor:alertStyle.confirmButtonTitleColorHighlight forState:UIControlStateHighlighted];
            [_confirmButton addTarget:self action:@selector(confirmButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
            [_confirmButton setTitle:confirmBtnTitle forState:UIControlStateNormal];
            [_confirmButton.titleLabel setFont:[UIFont systemFontOfSize:16 weight:UIFontWeightRegular]];
            [self addSubview:_confirmButton];
        }
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
    if (_titleLabel.text.length > 0 || _titleLabel.attributedText.length > 0) {
        y = y+kPWAlertActionSheetTitleTopMargin;
        CGFloat titlex = kPWAlertActionSheetLeadingMargin;
        CGFloat titleWidth = rect.size.width-2*titlex;
        CGSize titleSize = [_titleLabel sizeThatFits:CGSizeMake(titleWidth, CGFLOAT_MAX)];
        _titleLabel.frame = CGRectMake(titlex, y, titleWidth, titleSize.height+2);
        y = y+titleSize.height+2;
    }
    if (_messageLabel.attributedText.length > 0 || _messageLabel.text.length > 0) {
        y=y+kPWAlertActionSheetMsgTopMargin;
        CGFloat messagex = kPWAlertActionSheetLeadingMargin;
        CGFloat messageWidth = rect.size.width-2*messagex;
        CGSize messageSize = [self boundingSizeWithSize:CGSizeMake(messageWidth, CGFLOAT_MAX) label:_messageLabel];
        _messageLabel.frame = CGRectMake(messagex, y, messageWidth, messageSize.height);
        y=y+messageSize.height;
    }
    
    NSInteger btnCount = self.buttonsArr.count;
    CGFloat otherButtonHeight = 0;
    if (btnCount > 0) {
        if (y > 0) {
            y = y+kPWAlertActionSheetOtherButtonTopMargin+kPWAlertActionSheetSeparateLineSize;
        }
        otherButtonHeight = kPWAlertActionSheetButtonHeight*btnCount + (btnCount-1)*kPWAlertActionSheetSeparateLineSize;
    }
    CGFloat totalAlertHeight = y+otherButtonHeight;
    CGFloat totalButtonHeight = otherButtonHeight;
    CGFloat bottomButtonHeight = 0;
    if (_confirmButton) {
        bottomButtonHeight = kPWAlertActionSheetConfirmButtonTopMargin + kPWAlertActionSheetButtonHeight;
        totalAlertHeight = totalAlertHeight + bottomButtonHeight;
        totalButtonHeight = totalButtonHeight + bottomButtonHeight;
    }
    if (totalAlertHeight <= rect.size.height) {
        _msgScrollView.frame = CGRectMake(0, 0, rect.size.width, y);
        _msgScrollView.contentSize = _msgScrollView.bounds.size;
        if (btnCount > 0) {
            _messageBtnSeparateLine.frame = CGRectMake(0, _msgScrollView.frame.origin.y+_msgScrollView.frame.size.height, rect.size.width, kPWAlertActionSheetSeparateLineSize);
            _buttonScrollView.frame = CGRectMake(0, _messageBtnSeparateLine.frame.origin.y+_messageBtnSeparateLine.frame.size.height, rect.size.width, otherButtonHeight);
        }else {
            _buttonScrollView.frame = CGRectMake(0, _msgScrollView.frame.origin.y+_msgScrollView.frame.size.height, rect.size.width, 0);
        }
        _buttonScrollView.contentSize = _buttonScrollView.bounds.size;
        int index = 0;
        for (UIButton *btn in self.buttonsArr) {
            btn.frame = CGRectMake(0, index*(kPWAlertActionSheetButtonHeight+kPWAlertActionSheetSeparateLineSize), _buttonScrollView.frame.size.width, kPWAlertActionSheetButtonHeight);
            if (index > 0) {
                UIView *line = self.separateLines[index-1];
                line.frame = CGRectMake(0, index*kPWAlertActionSheetButtonHeight+(index-1)*kPWAlertActionSheetSeparateLineSize, rect.size.width, kPWAlertActionSheetSeparateLineSize);
            }
            index++;
        }
        _topContentView.frame = CGRectMake(0, 0, rect.size.width, _msgScrollView.bounds.size.height+_buttonScrollView.bounds.size.height);
        if (_confirmButton) {
            _confirmButton.frame = CGRectMake(0, _buttonScrollView.frame.origin.y+_buttonScrollView.frame.size.height+kPWAlertActionSheetConfirmButtonTopMargin, rect.size.width, kPWAlertActionSheetButtonHeight);
        }
    }else {
        ///按钮少，内容多
        if (btnCount <= 2) {
            _msgScrollView.frame = CGRectMake(0, 0, rect.size.width, rect.size.height-totalButtonHeight);
            _msgScrollView.contentSize = CGSizeMake(rect.size.width, y);
            if (btnCount > 0) {
                _messageBtnSeparateLine.frame = CGRectMake(0, _msgScrollView.frame.origin.y+_msgScrollView.frame.size.height, rect.size.width, kPWAlertActionSheetSeparateLineSize);
                _buttonScrollView.frame = CGRectMake(0, _messageBtnSeparateLine.frame.origin.y+_messageBtnSeparateLine.frame.size.height, rect.size.width, otherButtonHeight);
                _buttonScrollView.contentSize = _buttonScrollView.frame.size;
            }else {
                _buttonScrollView.frame = CGRectMake(0, _msgScrollView.frame.origin.y+_msgScrollView.frame.size.height, rect.size.width, 0);
            }
            int index = 0;
            for (UIButton *btn in self.buttonsArr) {
                btn.frame = CGRectMake(0, index*(kPWAlertActionSheetButtonHeight+kPWAlertActionSheetSeparateLineSize), _buttonScrollView.frame.size.width, kPWAlertActionSheetButtonHeight);
                if (index > 0) {
                    UIView *line = self.separateLines[index-1];
                    line.frame = CGRectMake(0, index*kPWAlertActionSheetButtonHeight+(index-1)*kPWAlertActionSheetSeparateLineSize, rect.size.width, kPWAlertActionSheetSeparateLineSize);
                }
                index++;
            }
            _topContentView.frame = CGRectMake(0, 0, rect.size.width, _msgScrollView.bounds.size.height+_buttonScrollView.bounds.size.height);
            if (_confirmButton) {
                _confirmButton.frame = CGRectMake(0, _buttonScrollView.frame.origin.y+_buttonScrollView.frame.size.height+kPWAlertActionSheetConfirmButtonTopMargin, rect.size.width, kPWAlertActionSheetButtonHeight);
            }
        }else { //other按钮数量 >= 3
            CGFloat maxTotalButtonHeight = 2*kPWAlertActionSheetButtonHeight+kPWAlertActionSheetSeparateLineSize+bottomButtonHeight;
            
            //内容高度过高
            if (y >= rect.size.height-maxTotalButtonHeight) {
                _msgScrollView.frame = CGRectMake(0, 0, rect.size.width, rect.size.height-maxTotalButtonHeight);
                _msgScrollView.contentSize = CGSizeMake(rect.size.width, y);
                _messageBtnSeparateLine.frame = CGRectMake(0, _msgScrollView.frame.origin.y+_msgScrollView.frame.size.height, rect.size.width, kPWAlertActionSheetSeparateLineSize);
                _buttonScrollView.frame = CGRectMake(0, _messageBtnSeparateLine.frame.origin.y+_messageBtnSeparateLine.frame.size.height, rect.size.width, 2*kPWAlertActionSheetButtonHeight+kPWAlertActionSheetSpacer);
                _buttonScrollView.contentSize = CGSizeMake(_buttonScrollView.frame.size.width, otherButtonHeight);
                int index = 0;
                for (UIButton *btn in self.buttonsArr) {
                    btn.frame = CGRectMake(0, index*(kPWAlertActionSheetButtonHeight+kPWAlertActionSheetSeparateLineSize), _buttonScrollView.frame.size.width, kPWAlertActionSheetButtonHeight);
                    if (index > 0) {
                        UIView *line = self.separateLines[index-1];
                        line.frame = CGRectMake(0, index*kPWAlertActionSheetButtonHeight+(index-1)*kPWAlertActionSheetSeparateLineSize, rect.size.width, kPWAlertActionSheetSeparateLineSize);
                    }
                    index++;
                }
                if (_confirmButton) {
                    _confirmButton.frame = CGRectMake(0, _buttonScrollView.frame.origin.y+_buttonScrollView.frame.size.height+kPWAlertActionSheetConfirmButtonTopMargin, rect.size.width, kPWAlertActionSheetButtonHeight);
                }
            }else {
                _msgScrollView.frame = CGRectMake(0, 0, rect.size.width, y);
                _msgScrollView.contentSize = _msgScrollView.frame.size;
                _messageBtnSeparateLine.frame = CGRectMake(0, _msgScrollView.frame.origin.y+_msgScrollView.frame.size.height, rect.size.width, kPWAlertActionSheetSeparateLineSize);
                _buttonScrollView.frame = CGRectMake(0, _messageBtnSeparateLine.frame.origin.y+_messageBtnSeparateLine.frame.size.height, rect.size.width, rect.size.height-y-bottomButtonHeight);
                _buttonScrollView.contentSize = CGSizeMake(_buttonScrollView.frame.size.width, otherButtonHeight);
                int index = 0;
                for (UIButton *btn in self.buttonsArr) {
                    btn.frame = CGRectMake(0, index*(kPWAlertActionSheetButtonHeight+kPWAlertActionSheetSeparateLineSize), _buttonScrollView.frame.size.width, kPWAlertActionSheetButtonHeight);
                    if (index > 0) {
                        UIView *line = self.separateLines[index-1];
                        line.frame = CGRectMake(0, index*kPWAlertActionSheetButtonHeight+(index-1)*kPWAlertActionSheetSeparateLineSize, rect.size.width, kPWAlertActionSheetSeparateLineSize);
                    }
                    index++;
                }
                if (_confirmButton) {
                    _confirmButton.frame = CGRectMake(0, _buttonScrollView.frame.origin.y+_buttonScrollView.frame.size.height+kPWAlertActionSheetConfirmButtonTopMargin, rect.size.width, kPWAlertActionSheetButtonHeight);
                }
            }
            _topContentView.frame = CGRectMake(0, 0, rect.size.width, _msgScrollView.bounds.size.height+_buttonScrollView.bounds.size.height);
        }
    }
}


#pragma mark - PWAlertViewProtocol
- (CGSize)sizeThatFitContent:(CGFloat)preferredWidth {
    CGFloat y = 0; CGFloat width = preferredWidth;
    if (_titleLabel.attributedText.length > 0 || _titleLabel.text.length > 0) {
        y = y+kPWAlertActionSheetTitleTopMargin;
        CGFloat titlex = kPWAlertActionSheetLeadingMargin;
        CGFloat titleWidth = width-2*titlex;
        CGSize titleSize = [_titleLabel sizeThatFits:CGSizeMake(titleWidth, CGFLOAT_MAX)];
        y = y+titleSize.height+2;
    }
    if (_messageLabel.attributedText.length > 0 || _messageLabel.text.length > 0) {
        y=y+kPWAlertActionSheetMsgTopMargin;
        CGFloat messagex = kPWAlertActionSheetLeadingMargin;
        CGFloat messageWidth = width-2*messagex;
        CGSize messageSize = [self boundingSizeWithSize:CGSizeMake(messageWidth, CGFLOAT_MAX) label:_messageLabel];
        y=y+messageSize.height;
    }
    NSInteger btnCount = self.buttonsArr.count;
    CGFloat otherButtonHeight = 0;
    if (btnCount > 0) {
        if (y>0) {
            y = y+kPWAlertActionSheetOtherButtonTopMargin+kPWAlertActionSheetSeparateLineSize;
        }
        otherButtonHeight = kPWAlertActionSheetButtonHeight*btnCount + (btnCount-1)*kPWAlertActionSheetSeparateLineSize;
    }
    
    CGFloat totalAlertHeight = y+otherButtonHeight;
    CGFloat bottomButtonHeight = 0;
    if (_confirmButton) {
        bottomButtonHeight = kPWAlertActionSheetConfirmButtonTopMargin + kPWAlertActionSheetButtonHeight;
        totalAlertHeight = totalAlertHeight + bottomButtonHeight;
    }
    return CGSizeMake(width, totalAlertHeight);
}

- (PWAlertType)alertType {
    return PWAlertTypeActionSheet;
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
    if (!color) return nil;
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
