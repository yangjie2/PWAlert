//
//  PWAlertOperation.m
//  HHBaseLibSDK
//
//  Created by 杨洁 on 2022/5/18.
//

#import "PWAlertOperation.h"
#import "PWAlertBackgroundViewController.h"
#import "PWAlertView.h"
#import "PWAlertActionSheetView.h"
#import "PWAlert.h"

@interface PWAlertNavigationController : UINavigationController

@end
@implementation PWAlertNavigationController
- (BOOL)shouldAutorotate {
    return self.topViewController.shouldAutorotate;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return self.topViewController.supportedInterfaceOrientations;
}

@end

@interface PWAlertOperation ()<CAAnimationDelegate>
{
    BOOL _executing;
    BOOL _finished;
    PWAlertType _alertType;
}
@property (nonatomic, strong) UIWindow *alertWindow;
@property (nonatomic, weak) UINavigationController *navigationController;
@property (nonatomic, strong) UIView<PWAlertViewProtocol> *alertView;

@end
@implementation PWAlertOperation

- (instancetype)initWithTitle:(NSString *)title
              attributedTitle:(nullable NSAttributedString *)attributedTitle
                      message:(nullable NSString *)message
            attributedMessage:(nullable NSAttributedString *)attributedMessage
           confirmButtonTitle:(nullable NSString *)confirmBtnTitle
            otherButtonTitles:(nullable NSArray<NSString *> *)otherBtnTitles
                   alertStyle:(nullable PWAlertStyle *)alertStyle
                    alertType:(PWAlertType)alertType
           clickedButtonBlock:(void(^)(NSInteger index))block {
    self = [super init];
    if (self) {
        _executing = NO;
        _finished = NO;
        PWAlertStyle *style = alertStyle?:[[PWAlertStyle alloc] init];
        if (alertType == PWAlertTypeAlert) {
            _alertView = [[PWAlertView alloc] initWithTitle:title attributedTitle:attributedTitle message:message attributedMessage:attributedMessage confirmButtonTitle:confirmBtnTitle otherButtonTitles:otherBtnTitles alertStyle:style clickedButtonBlock:block];
        }else {
            _alertView = [[PWAlertActionSheetView alloc] initWithTitle:title attributedTitle:attributedTitle message:message attributedMessage:attributedMessage confirmButtonTitle:confirmBtnTitle alertStyle:style otherButtonTitles:otherBtnTitles highlightedButtonTitleIndexes:nil clickedButtonBlock:block];
        }
        _alertType = alertType;
        __weak typeof(self) weakself = self;
        _alertView.alertFinished = ^{
            [weakself removeAlertWindow];
        };
    }
    return self;
}

- (instancetype)initWithTitle:(NSString *)title
              attributedTitle:(nullable NSAttributedString *)attributedTitle
                      message:(nullable NSString *)message
            attributedMessage:(nullable NSAttributedString *)attributedMessage
            confirmButtonTitle:(nullable NSString *)confirmBtnTitle
            otherButtonTitles:(nullable NSArray<NSString *> *)otherBtnTitles
                   alertStyle:(nullable PWAlertStyle *)alertStyle
           clickedButtonBlock:(void(^)(NSInteger index))block {
    return [self initWithTitle:title attributedTitle:attributedTitle message:message attributedMessage:attributedMessage confirmButtonTitle:confirmBtnTitle otherButtonTitles:otherBtnTitles alertStyle:alertStyle alertType:PWAlertTypeAlert clickedButtonBlock:block];
}

- (instancetype)initWithCustomView:(UIView<PWAlertViewProtocol> *)customView
                confirmButtonTitle:(nullable NSString *)confirmBtnTitle
                 otherButtonTitles:(nullable NSArray<NSString *> *)otherBtnTitles
                        alertStyle:(PWAlertStyle *)alertStyle
                clickedButtonBlock:(void(^)(NSInteger index))block {
    self = [super init];
    if (self) {
        _executing = NO;
        _finished = NO;
        _alertType = PWAlertTypeAlert;
        PWAlertStyle *style = alertStyle?:[[PWAlertStyle alloc] init];
        _alertView = [[PWAlertView alloc] initWithCustomView:customView confirmButtonTitle:confirmBtnTitle otherButtonTitles:otherBtnTitles alertStyle:style clickedButtonBlock:block];
        __weak typeof(self) weakself = self;
        _alertView.alertFinished = ^{
            [weakself removeAlertWindow];
        };
    }
    return self;
}

- (instancetype)initWithCustomView:(UIView<PWAlertViewProtocol> *)view {
    self = [super init];
    if (self) {
        _executing = NO;
        _finished = NO;
        _alertView = view;
        if ([view respondsToSelector:@selector(alertType)]) {
            _alertType = [view alertType];
        }else {
            _alertType = PWAlertTypeAlert;
        }
        __weak typeof(self) weakself = self;
        _alertView.alertFinished = ^{
            [weakself removeAlertWindow];
        };
    }
    return self;
}

- (void)cancel {
    [super cancel];
    if (_executing) {
        //移除window alert
        [self performInMainThread:^{
            [self removeAlertWindow];
        }];
    }
}


#pragma mark - Override
- (void)start {
    BOOL isRunnable = !self.isFinished && !self.isCancelled && !self.isExecuting;
    if (!isRunnable || !_alertView) {
        [self setIsFinished:YES];
        return;
    }
    [self main];
}

- (void)main {
    [self setIsExecuting:YES];
    [self performInMainThread:^{
        if (!self.alertWindow) {
            self.alertWindow = [[UIWindow alloc] initWithFrame:UIScreen.mainScreen.bounds];
            self.alertWindow.windowLevel = UIWindowLevelStatusBar + 1;
        }
        PWAlertBackgroundViewController *bgvc = [[PWAlertBackgroundViewController alloc] init];
        bgvc.alertView = self.alertView;
        self.alertWindow.alpha = 0;
        PWAlertNavigationController *nav = [[PWAlertNavigationController alloc] initWithRootViewController:bgvc];
        self.alertWindow.rootViewController = nav;
        self.navigationController = nav;
        [self.alertWindow makeKeyAndVisible];
        [UIView animateWithDuration:0.25 animations:^{
            self.alertWindow.alpha = 1;
        }];
    }];
}


#pragma mark - getter/setter
- (BOOL)isExecuting {
    return _executing;
}

- (void)setIsExecuting:(BOOL)executing {
    [self willChangeValueForKey:@"isExecuting"];
    _executing = executing;
    [self didChangeValueForKey:@"isExecuting"];
}

- (BOOL)isFinished {
    return _finished;
}

- (void)setIsFinished:(BOOL)finished {
    [self willChangeValueForKey:@"isFinished"];
    _finished = finished;
    [self didChangeValueForKey:@"isFinished"];
}


#pragma mark - private
- (void)removeAlertWindow {
    if (_alertType == PWAlertTypeActionSheet) {
        CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"position.y"];
        //setFromValue不设置,默认以当前状态为准
        CGFloat p = self.alertView.layer.position.y+self.alertView.layer.bounds.size.height+self.alertWindow.safeAreaInsets.bottom;
        [animation setToValue:@(p)];
        [animation setDelegate:self];//代理回调
        [animation setDuration:0.25];//设置动画时间，单次动画时间
        [animation setRemovedOnCompletion:YES];
        [self.alertView.layer addAnimation:animation forKey:@"baseanimation"];
    }
    [UIView animateWithDuration:0.25 animations:^{
        self.alertWindow.alpha = 0;
    } completion:^(BOOL finished) {
        [self doFinish];
    }];
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag{
    [self doFinish];
}

- (void)doFinish {
    if (_finished) {
        return;
    }
    [self setIsFinished:YES];
    [self setIsExecuting:NO];
    [self.alertView removeFromSuperview];
    self.alertView = nil;
    self.alertWindow.hidden = YES;
    self.alertWindow.rootViewController = nil;
    self.alertWindow = nil;
    [[UIApplication sharedApplication].delegate.window makeKeyAndVisible];
}

- (void)performInMainThread:(dispatch_block_t)block {
    if ([NSThread isMainThread]) {
        block();
    }else {
        dispatch_sync(dispatch_get_main_queue(), ^{
            block();
        });
    }
}

@end
