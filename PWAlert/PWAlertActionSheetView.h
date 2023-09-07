//
//  PWAlertActionSheetView.h
//  PWUIKitDemo
//
//  Created by yangjie on 2022/12/7.
//

#import <UIKit/UIKit.h>
#import "PWAlertStyle.h"

NS_ASSUME_NONNULL_BEGIN

@interface PWAlertActionSheetView : UIView<PWAlertViewProtocol>
@property (nonatomic, copy) void(^alertFinished)(void);

///confirmBtnTitle 传入nil，则不展示底部 confirm 类型按钮.
- (instancetype)initWithTitle:(NSString *)title
              attributedTitle:(nullable NSAttributedString *)attributedTitle
                      message:(nullable NSString *)message
            attributedMessage:(nullable NSAttributedString *)attributedMessage
           confirmButtonTitle:(nullable NSString *)confirmBtnTitle
                   alertStyle:(PWAlertStyle *)alertStyle
            otherButtonTitles:(nullable NSArray<NSString *> *)otherBtnTitles
highlightedButtonTitleIndexes:(nullable NSArray*)indexes
           clickedButtonBlock:(void(^)(NSInteger index))block;




///NS_UNAVAILABLE
- (instancetype)initWithFrame:(CGRect)frame NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithCoder:(NSCoder *)coder NS_UNAVAILABLE;
@end

NS_ASSUME_NONNULL_END
