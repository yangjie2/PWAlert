//
//  PWAlert.m
//  HHBaseLibSDK
//
//  Created by 杨洁 on 2022/5/18.
//

#import "PWAlert.h"
#import "PWAlertOperation.h"

@interface PWAlert ()
{
    PWAlertStyle *_alertStyle;
    NSOperationQueue *_queue;
    BOOL _isQueueEnabled;
}

@end
@implementation PWAlert
+ (instancetype)shared {
    static PWAlert *_instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[PWAlert alloc] initPrivate];
    });
    return _instance;
}

- (instancetype)initPrivate {
    self = [super init];
    if (self) {
        _alertStyle = [[PWAlertStyle alloc] init];
        _isQueueEnabled = YES;
        _queue = [[NSOperationQueue alloc] init];
        _queue.maxConcurrentOperationCount = 1;
    }
    return self;
}


#pragma mark - public
+ (void)setIsQueueEnabled:(BOOL)isQueueEnabled {
    [PWAlert shared]->_isQueueEnabled = isQueueEnabled;
}

+ (PWAlertOperation *)showAlertWithTitle:(NSString *)title message:(NSString *)message confirmButtonTitle:(NSString *)confirmBtnTitle confirmButtonAction:(void(^)(void))block {
    PWAlertOperation *alert = [[PWAlertOperation alloc] initWithTitle:title attributedTitle:nil message:message attributedMessage:nil confirmButtonTitle:confirmBtnTitle otherButtonTitles:nil alertStyle:[PWAlert shared]->_alertStyle clickedButtonBlock:^(NSInteger index) {
        if (block) {
            block();
        }
    }];
    [[PWAlert shared] addAlert:alert];
    return alert;
}

+ (PWAlertOperation *)showAlertWithAttributedTitle:(NSAttributedString *)attributedTitle
                   attributedMessage:(nullable NSAttributedString *)attributedMessage
                  confirmButtonTitle:(NSString *)confirmBtnTitle
                 confirmButtonAction:(nullable void(^)(void))block {
    PWAlertOperation *alert = [[PWAlertOperation alloc] initWithTitle:@"" attributedTitle:attributedTitle message:nil attributedMessage:attributedMessage confirmButtonTitle:confirmBtnTitle otherButtonTitles:nil alertStyle:[PWAlert shared]->_alertStyle clickedButtonBlock:^(NSInteger index) {
        if (block) {
            block();
        }
    }];
    [[PWAlert shared] addAlert:alert];
    return alert;
}

+ (PWAlertOperation *)showAlertWithTitle:(NSString *)title
                   message:(NSString *)message
         cancelButtonTitle:(NSString *)cancelBtnTitle
        cancelButtonAction:(void(^)(void))cancelBlock 
        confirmButtonTitle:(NSString *)confirmBtnTitle
       confirmButtonAction:(void(^)(void))confirmBlock
{
    PWAlertOperation *alert = [[PWAlertOperation alloc] initWithTitle:title attributedTitle:nil message:message attributedMessage:nil confirmButtonTitle:confirmBtnTitle otherButtonTitles:@[cancelBtnTitle] alertStyle:[PWAlert shared]->_alertStyle clickedButtonBlock:^(NSInteger index) {
        if (index == 0) {
            if (cancelBlock) {
                cancelBlock();
            }
        }else if (index == 1) {
            if (confirmBlock) {
                confirmBlock();
            }
        }
    }];
    [[PWAlert shared] addAlert:alert];
    return alert;
}

+ (PWAlertOperation *)showAlertWithAttributedTitle:(NSAttributedString *)attributedTitle
                   attributedMessage:(nullable NSAttributedString *)attributedMessage
                   cancelButtonTitle:(NSString *)cancelBtnTitle
                  cancelButtonAction:(nullable void(^)(void))cancelBlock
                  confirmButtonTitle:(NSString *)confirmBtnTitle
                 confirmButtonAction:(nullable void(^)(void))confirmBlock {
    PWAlertOperation *alert = [[PWAlertOperation alloc] initWithTitle:@"" attributedTitle:attributedTitle message:nil attributedMessage:attributedMessage confirmButtonTitle:confirmBtnTitle otherButtonTitles:@[cancelBtnTitle] alertStyle:[PWAlert shared]->_alertStyle clickedButtonBlock:^(NSInteger index) {
        if (index == 0) {
            if (cancelBlock) {
                cancelBlock();
            }
        }else if (index == 1) {
            if (confirmBlock) {
                confirmBlock();
            }
        }
    }];
    [[PWAlert shared] addAlert:alert];
    return alert;
}

+ (PWAlertOperation *)showAlertWithTitle:(NSString *)title
                   message:(nullable NSString *)message
        confirmButtonTitle:(nullable NSString *)confirmBtnTitle
         otherButtonTitles:(NSArray<NSString *> *)otherTitles
              buttonAction:(nullable void(^)(NSInteger index))actionBlock {
    PWAlertOperation *alert = [[PWAlertOperation alloc] initWithTitle:title attributedTitle:nil message:message attributedMessage:nil confirmButtonTitle:confirmBtnTitle otherButtonTitles:otherTitles alertStyle:[PWAlert shared]->_alertStyle clickedButtonBlock:^(NSInteger index) {
        if (actionBlock) {
            actionBlock(index);
        }
    }];
    [[PWAlert shared] addAlert:alert];
    return alert;
}

+ (PWAlertOperation *)showAlertWithAttributedTitle:(NSAttributedString *)attributedTitle
                   attributedMessage:(nullable NSAttributedString *)attributedMessage
                  confirmButtonTitle:(nullable NSString *)confirmBtnTitle
                   otherButtonTitles:(NSArray<NSString *> *)otherTitles
                        buttonAction:(nullable void(^)(NSInteger index))actionBlock {
    PWAlertOperation *alert = [[PWAlertOperation alloc] initWithTitle:@"" attributedTitle:attributedTitle message:nil attributedMessage:attributedMessage confirmButtonTitle:confirmBtnTitle otherButtonTitles:otherTitles alertStyle:[PWAlert shared]->_alertStyle clickedButtonBlock:^(NSInteger index) {
        if (actionBlock) {
            actionBlock(index);
        }
    }];
    [[PWAlert shared] addAlert:alert];
    return alert;
}

+ (PWAlertOperation *)showAlertWithCustomView:(UIView<PWAlertViewProtocol> *)customView
              cancelButtonTitle:(NSString *)cancelBtnTitle
             cancelButtonAction:(nullable void(^)(void))cancelBlock
             confirmButtonTitle:(NSString *)confirmBtnTitle
            confirmButtonAction:(nullable void(^)(void))confirmBlock {
    PWAlertOperation *alert = [[PWAlertOperation alloc] initWithCustomView:customView confirmButtonTitle:confirmBtnTitle otherButtonTitles:@[cancelBtnTitle] alertStyle:[PWAlert shared]->_alertStyle clickedButtonBlock:^(NSInteger index) {
        if (index == 0) {
            if (cancelBlock) {
                cancelBlock();
            }
        }else if (index == 1) {
            if (confirmBlock) {
                confirmBlock();
            }
        }
    }];
    [[PWAlert shared] addAlert:alert];
    return alert;
}

+ (PWAlertOperation *)showAlertWithCustomView:(UIView<PWAlertViewProtocol> *)customView
             confirmButtonTitle:(NSString *)confirmBtnTitle
            confirmButtonAction:(nullable void(^)(void))confirmBlock {
    PWAlertOperation *alert = [[PWAlertOperation alloc] initWithCustomView:customView confirmButtonTitle:confirmBtnTitle otherButtonTitles:nil alertStyle:[PWAlert shared]->_alertStyle clickedButtonBlock:^(NSInteger index) {
        if (confirmBlock) {
            confirmBlock();
        }
    }];
    [[PWAlert shared] addAlert:alert];
    return alert;
}

+ (PWAlertOperation *)showAlertWithCustomView:(UIView<PWAlertViewProtocol> *)customView
             confirmButtonTitle:(nullable NSString *)confirmBtnTitle
              otherButtonTitles:(NSArray<NSString *> *)otherTitles
                   buttonAction:(nullable void(^)(NSInteger index))actionBlock {
    PWAlertOperation *alert = [[PWAlertOperation alloc] initWithCustomView:customView confirmButtonTitle:confirmBtnTitle otherButtonTitles:otherTitles alertStyle:[PWAlert shared]->_alertStyle clickedButtonBlock:^(NSInteger index) {
        if (actionBlock) {
            actionBlock(index);
        }
    }];
    [[PWAlert shared] addAlert:alert];
    return alert;
}



#pragma mark - actionSheet
+ (PWAlertOperation *)showActionSheetWithTitle:(nullable NSString *)title
                                       message:(nullable NSString *)message
                            confirmButtonTitle:(nullable NSString *)confirmBtnTitle
                             otherButtonTitles:(nullable NSArray<NSString *> *)otherBtnTitles
                                  buttonAction:(void(^)(NSInteger index))block {
    PWAlertOperation *alert = [[PWAlertOperation alloc] initWithTitle:title attributedTitle:nil message:message attributedMessage:nil confirmButtonTitle:confirmBtnTitle otherButtonTitles:otherBtnTitles alertStyle:[PWAlert shared]->_alertStyle alertType:PWAlertTypeActionSheet clickedButtonBlock:^(NSInteger index) {
        if (block) {
            block(index);
        }
    }];
    [[PWAlert shared] addAlert:alert];
    return alert;
}


+ (PWAlertOperation *)showCustomView:(UIView<PWAlertViewProtocol> *)customView {
    if (!customView) {
        return nil;
    }
    PWAlertOperation *alert = [[PWAlertOperation alloc] initWithCustomView:customView];
    [[PWAlert shared] addAlert:alert];
    return alert;
}

+ (void)configGlobalAlertStyle:(PWAlertStyle *)alertStyle {
    [PWAlert shared]->_alertStyle = alertStyle;
}

+ (void)cancelAll {
    [[PWAlert shared]->_queue cancelAllOperations];
}



#pragma mark - private
- (void)addAlert:(PWAlertOperation *)alert {
    if (!_isQueueEnabled) {
        [self.class cancelAll];
    }
    if (alert.isCancelled||alert.isFinished) {
        return;
    }
    [_queue addOperation:(PWAlertOperation *)alert];
}


@end
