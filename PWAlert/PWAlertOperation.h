//
//  PWAlertOperation.h
//  HHBaseLibSDK
//
//  Created by 杨洁 on 2022/5/18.
//

#import <Foundation/Foundation.h>
#import "PWAlertStyle.h"

NS_ASSUME_NONNULL_BEGIN

@interface PWAlertOperation : NSOperation
@property (nonatomic, weak, readonly) UINavigationController *navigationController;
@property (nonatomic, strong, readonly) UIView<PWAlertViewProtocol> *alertView;

- (instancetype)initWithTitle:(NSString *)title
              attributedTitle:(nullable NSAttributedString *)attributedTitle
                      message:(nullable NSString *)message
            attributedMessage:(nullable NSAttributedString *)attributedMessage
            confirmButtonTitle:(nullable NSString *)confirmBtnTitle
            otherButtonTitles:(nullable NSArray<NSString *> *)otherBtnTitles
                   alertStyle:(nullable PWAlertStyle *)alertStyle
                    alertType:(PWAlertType)alertType
           clickedButtonBlock:(void(^)(NSInteger index))block;

- (instancetype)initWithTitle:(NSString *)title
              attributedTitle:(nullable NSAttributedString *)attributedTitle
                      message:(nullable NSString *)message
            attributedMessage:(nullable NSAttributedString *)attributedMessage
            confirmButtonTitle:(nullable NSString *)confirmBtnTitle
            otherButtonTitles:(nullable NSArray<NSString *> *)otherBtnTitles
                   alertStyle:(nullable PWAlertStyle *)alertStyle
           clickedButtonBlock:(void(^)(NSInteger index))block;


//自定义alert内容视图 仅支持 PWAlertTypeAlert 类型
- (instancetype)initWithCustomView:(UIView<PWAlertViewProtocol> *)customView
                confirmButtonTitle:(nullable NSString *)confirmBtnTitle
                 otherButtonTitles:(nullable NSArray<NSString *> *)otherBtnTitles
                        alertStyle:(nullable PWAlertStyle *)alertStyle
                clickedButtonBlock:(void(^)(NSInteger index))block;



//完全自定义alert视图
- (instancetype)initWithCustomView:(UIView<PWAlertViewProtocol> *)view;

- (void)cancel;

@end

NS_ASSUME_NONNULL_END
