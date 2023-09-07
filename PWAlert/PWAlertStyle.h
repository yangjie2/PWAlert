//
//  PWAlertStyle.h
//  HHBaseLibSDK
//
//  Created by 杨洁 on 2022/5/18.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef NS_ENUM(NSUInteger, PWAlertType) {
    PWAlertTypeAlert = 0, //
    PWAlertTypeActionSheet = 1, //支持点击背景关闭弹窗
};

@protocol PWAlertViewProtocol <NSObject>
@required
//自定义视图弹窗结束显示, 自定义视图在关闭时需要调用该block
@property (nonatomic, copy) void(^alertFinished)(void);

/**
 返回弹窗size
 @params preferredWidth 参考(首选)宽度
*/
- (CGSize)sizeThatFitContent:(CGFloat)preferredWidth;

@optional
/**
 自动旋转，默认 YES
*/
@property (nonatomic) BOOL shouldAutorotate;
/**
 返回弹窗类型，可选，默认 PWAlertTypeAlert
*/
- (PWAlertType)alertType;
/**
 忽略安全区域. NO: 弹窗内容在安全区域内，不会被挡住，YES: 忽略安全区域，弹窗内容有可能被挡住. 默认 NO
*/
- (BOOL)ignoreSafeArea;

@end


@interface PWAlertStyle : NSObject
/**
 The background color. Default is `white`.
*/
@property (nonatomic, strong) UIColor *backgroundColor;
/**
 The alert cornerRadius. Default is `12`.
*/
@property (nonatomic) CGFloat cornerRadius;


//MARK: ========================================================
///以下属性，如果 PWAlertView 对象使用了 NSAttributedString，则以 NSAttributedString 为准
/**
 The title color. Default is `darkText`.
*/
@property (nonatomic, strong) UIColor *titleColor;
/**
 The title font. Default is `size16`.
*/
@property (nonatomic, strong) UIFont *titleFont;

/**
 The message color. Default is `darkText`.
*/
@property (nonatomic, strong) UIColor *messageColor;
/**
 The message font. Default is `size14`.
*/
@property (nonatomic, strong) UIFont *messageFont;

//MARK: ========================================================




/**
 The confirm  button background color. Default is `white`.
*/
@property (nonatomic, strong) UIColor *confirmButtonBackgroundColor;
@property (nonatomic, strong) UIColor *confirmButtonBackgroundColorHighlight;

/**
 The confirm  button title color. Default is `systemYellowColor`.
*/
@property (nonatomic, strong) UIColor *confirmButtonTitleColor;
@property (nonatomic, strong) UIColor *confirmButtonTitleColorHighlight;

/**
 The confirm  button background image normal. Default is `nil`.
*/
@property (nonatomic, strong) UIImage *confirmButtonBackgroundImage;
/**
 The confirm  button background image Highlight. Default is `nil`.
*/
@property (nonatomic, strong) UIImage *confirmButtonBackgroundImageHighlight;

/**
 The other  button background color. Default is `white`.
*/
@property (nonatomic, strong) UIColor *otherButtonBackgroundColor;
@property (nonatomic, strong) UIColor *otherButtonBackgroundColorHighlight;

/**
 Default is `lightGrayColor`.
*/
@property (nonatomic, strong) UIColor *otherButtonTitleColor;
@property (nonatomic, strong) UIColor *otherButtonTitleColorHighlight;

/**
 The other  button background image. Default is `nil`.
*/
@property (nonatomic, strong) UIImage *otherButtonBackgroundImage;
/**
 The other  button background image Highlight. Default is `nil`.
*/
@property (nonatomic, strong) UIImage *otherButtonBackgroundImageHighlight;

/**
 divide line color. default rgba(217, 217, 217, 1)
*/
@property (nonatomic, strong) UIColor *divideLineColor;


@end

NS_ASSUME_NONNULL_END
