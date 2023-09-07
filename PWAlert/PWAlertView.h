//
//  PWAlertView.h
//  HHBaseLibSDK
//
//  Created by 杨洁 on 2022/5/18.
//

#import <UIKit/UIKit.h>
#import "PWAlertStyle.h"

NS_ASSUME_NONNULL_BEGIN

@interface PWAlertView : UIView<PWAlertViewProtocol>
@property (nonatomic, copy) void(^alertFinished)(void);

///confirmBtnTitle 传入nil，则不展示 confirm 类型按钮
- (instancetype)initWithTitle:(NSString *)title
              attributedTitle:(nullable NSAttributedString *)attributedTitle
                      message:(nullable NSString *)message
              attributedMessage:(nullable NSAttributedString *)attributedMessage
           confirmButtonTitle:(nullable NSString *)confirmBtnTitle
            otherButtonTitles:(nullable NSArray<NSString *> *)otherBtnTitles
                   alertStyle:(PWAlertStyle *)alertStyle
           clickedButtonBlock:(void(^)(NSInteger index))block;

///confirmBtnTitle 传入nil，则不展示 confirm 类型按钮
- (instancetype)initWithCustomView:(UIView<PWAlertViewProtocol> *)customView
                confirmButtonTitle:(nullable NSString *)confirmBtnTitle
                 otherButtonTitles:(nullable NSArray<NSString *> *)otherBtnTitles
                        alertStyle:(PWAlertStyle *)alertStyle
                clickedButtonBlock:(void(^)(NSInteger index))block;




///NS_UNAVAILABLE
- (instancetype)initWithFrame:(CGRect)frame NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithCoder:(NSCoder *)coder NS_UNAVAILABLE;

@end

NS_ASSUME_NONNULL_END
