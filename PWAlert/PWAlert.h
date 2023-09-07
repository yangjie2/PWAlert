//
//  PWAlert.h
//  HHBaseLibSDK
//
//  Created by 杨洁 on 2022/5/18.
//

#import <Foundation/Foundation.h>
#import "PWAlertOperation.h"

NS_ASSUME_NONNULL_BEGIN

@interface PWAlert : NSObject
- (instancetype)init NS_UNAVAILABLE;

#pragma mark - Global UI Config
/**
 配置全局样式
*/
+ (void)configGlobalAlertStyle:(PWAlertStyle *)alertStyle;



#pragma mark - Alert
/**
 弹出 Alert
*/
+ (PWAlertOperation *)showAlertWithTitle:(NSString *)title
                            message:(nullable NSString *)message
                 confirmButtonTitle:(NSString *)confirmBtnTitle
                confirmButtonAction:(nullable void(^)(void))block;

+ (PWAlertOperation *)showAlertWithAttributedTitle:(NSAttributedString *)attributedTitle
                            attributedMessage:(nullable NSAttributedString *)attributedMessage
                           confirmButtonTitle:(NSString *)confirmBtnTitle
                          confirmButtonAction:(nullable void(^)(void))block;


+ (PWAlertOperation *)showAlertWithTitle:(NSString *)title
                            message:(nullable NSString *)message
                  cancelButtonTitle:(NSString *)cancelBtnTitle
                 cancelButtonAction:(nullable void(^)(void))cancelBlock
                 confirmButtonTitle:(NSString *)confirmBtnTitle
                confirmButtonAction:(nullable void(^)(void))confirmBlock;

+ (PWAlertOperation *)showAlertWithAttributedTitle:(NSAttributedString *)attributedTitle
                            attributedMessage:(nullable NSAttributedString *)attributedMessage
                            cancelButtonTitle:(NSString *)cancelBtnTitle
                           cancelButtonAction:(nullable void(^)(void))cancelBlock
                           confirmButtonTitle:(NSString *)confirmBtnTitle
                          confirmButtonAction:(nullable void(^)(void))confirmBlock;

+ (PWAlertOperation *)showAlertWithTitle:(NSString *)title
                            message:(nullable NSString *)message
                 confirmButtonTitle:(nullable NSString *)confirmBtnTitle
                  otherButtonTitles:(NSArray<NSString *> *)otherTitles
                       buttonAction:(nullable void(^)(NSInteger index))actionBlock;

+ (PWAlertOperation *)showAlertWithAttributedTitle:(NSAttributedString *)attributedTitle
                            attributedMessage:(nullable NSAttributedString *)attributedMessage
                           confirmButtonTitle:(nullable NSString *)confirmBtnTitle
                            otherButtonTitles:(NSArray<NSString *> *)otherTitles
                                 buttonAction:(nullable void(^)(NSInteger index))actionBlock;


///自定义alert内容视图（底部带按钮）
+ (PWAlertOperation *)showAlertWithCustomView:(UIView<PWAlertViewProtocol> *)customView
                      confirmButtonTitle:(NSString *)confirmBtnTitle
                     confirmButtonAction:(nullable void(^)(void))confirmBlock;


+ (PWAlertOperation *)showAlertWithCustomView:(UIView<PWAlertViewProtocol> *)customView
                       cancelButtonTitle:(NSString *)cancelBtnTitle
                      cancelButtonAction:(nullable void(^)(void))cancelBlock
                      confirmButtonTitle:(NSString *)confirmBtnTitle
                     confirmButtonAction:(nullable void(^)(void))confirmBlock;

+ (PWAlertOperation *)showAlertWithCustomView:(UIView<PWAlertViewProtocol> *)customView
                      confirmButtonTitle:(nullable NSString *)confirmBtnTitle
                       otherButtonTitles:(NSArray<NSString *> *)otherTitles
                            buttonAction:(nullable void(^)(NSInteger index))actionBlock;


#pragma mark - Action Sheet
/**
 弹出 ActionSheet
*/
+ (PWAlertOperation *)showActionSheetWithTitle:(nullable NSString *)title
                                       message:(nullable NSString *)message
                            confirmButtonTitle:(nullable NSString *)confirmBtnTitle
                             otherButtonTitles:(nullable NSArray<NSString *> *)otherBtnTitles
                                  buttonAction:(void(^)(NSInteger index))block;



#pragma mark - custom

/**
 完全自定义alert视图
*/
+ (PWAlertOperation *)showCustomView:(UIView<PWAlertViewProtocol> *)customView;



#pragma mark - other

/**
 Enables or disables queueing behavior for alert views. When `true`,
 alert view will appear one after the other. When `false`,
 only the last requested alert will be shown. Default is `true`.
*/
+ (void)setIsQueueEnabled:(BOOL)isQueueEnabled;

/**
 取消所有还没弹出的alert
*/
+ (void)cancelAll;


@end

NS_ASSUME_NONNULL_END
