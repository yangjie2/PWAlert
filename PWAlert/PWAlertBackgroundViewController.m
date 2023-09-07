//
//  PWAlertBackgroundViewController.m
//  PWUIKitDemo
//
//  Created by yangjie on 2022/11/30.
//

#import "PWAlertBackgroundViewController.h"
#import "PWAlertUtil.h"

static CGFloat kPWAlertViewWidth = 280.f;
static CGFloat kPWAlertActionSheetViewWidth = 300.f;

@interface PWAlertBackgroundViewController ()<UIGestureRecognizerDelegate>
@property (nonatomic) PWAlertType alertType;
@property (nonatomic) UIInterfaceOrientation uiOrientation API_AVAILABLE(ios(16.0));

@end
@implementation PWAlertBackgroundViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _alertType = PWAlertTypeAlert;
        if (@available(iOS 16.0, *)) {
            UIWindowScene *activeWindow = (UIWindowScene *)[[[UIApplication sharedApplication] windows] firstObject];
            _uiOrientation = [activeWindow interfaceOrientation] ?: UIInterfaceOrientationPortrait;
        }
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor.blackColor colorWithAlphaComponent:0.34];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    if ([self.alertView respondsToSelector:@selector(alertType)]) {
        _alertType = [self.alertView alertType];
    }
    [self.view addSubview:self.alertView];
    CGFloat preferedWidth = kPWAlertViewWidth;
    if (_alertType == PWAlertTypeActionSheet) {
        BOOL isPortrait = UIInterfaceOrientationIsPortrait([UIApplication sharedApplication].statusBarOrientation);
        if (isPortrait && PWAlertDeviceIsIphone()) {
            preferedWidth = self.view.bounds.size.width*0.95;
        }else {
            preferedWidth = kPWAlertActionSheetViewWidth;
        }
    }
    CGSize contentSize = CGSizeZero;
    if ([self.alertView respondsToSelector:@selector(sizeThatFitContent:)]) {
        contentSize = [_alertView sizeThatFitContent:preferedWidth];
    }
    if (_alertType == PWAlertTypeActionSheet) {
        UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapOnBackgroundView:)];
        tapGes.delegate = self;
        [self.view addGestureRecognizer:tapGes];
        ///
        CGFloat height = contentSize.height;
        CGRect rect = self.view.bounds;
        if (height >= rect.size.height*0.9) {
            height = rect.size.height*0.9;
        }
        [UIView animateWithDuration:0.25 animations:^{
            self.alertView.transform = CGAffineTransformMakeTranslation(0, -height);
        }];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}

- (BOOL)shouldAutorotate {
    if ([self.alertView respondsToSelector:@selector(shouldAutorotate)]) {
        return self.alertView.shouldAutorotate;
    }
    return YES;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    if (@available(iOS 16.0, *)) {
        BOOL shouldAutorotate = YES;
        if ([self.alertView respondsToSelector:@selector(shouldAutorotate)]) {
            shouldAutorotate = self.alertView.shouldAutorotate;
        }
        if (shouldAutorotate) {
            return UIInterfaceOrientationMaskAll;
        }else {
            if (self.uiOrientation == UIInterfaceOrientationPortrait) {
                return UIInterfaceOrientationMaskPortrait;
            }
            if (self.uiOrientation == UIInterfaceOrientationPortraitUpsideDown) {
                return UIInterfaceOrientationMaskPortraitUpsideDown;
            }
            if (self.uiOrientation == UIInterfaceOrientationLandscapeLeft) {
                return UIInterfaceOrientationMaskLandscapeLeft;
            }
            if (self.uiOrientation == UIInterfaceOrientationLandscapeRight) {
                return UIInterfaceOrientationMaskLandscapeRight;
            }
            return UIInterfaceOrientationMaskAll;
        }
    }
    return UIInterfaceOrientationMaskAll;
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    CGRect rect = self.view.bounds;
    UIEdgeInsets safeInsets = self.view.safeAreaInsets;
    CGFloat preferedWidth = kPWAlertViewWidth;
    if (_alertType == PWAlertTypeActionSheet) {
        BOOL isPortrait = UIInterfaceOrientationIsPortrait([UIApplication sharedApplication].statusBarOrientation);
        if (isPortrait && PWAlertDeviceIsIphone()) {
            preferedWidth = self.view.bounds.size.width*0.95;
        }else {
            preferedWidth = kPWAlertActionSheetViewWidth;
        }
    }
    CGSize contentSize = CGSizeZero;
    if ([self.alertView respondsToSelector:@selector(sizeThatFitContent:)]) {
        contentSize = [self.alertView sizeThatFitContent:preferedWidth];
    }
    if (CGSizeEqualToSize(CGSizeZero, contentSize)) {
        ///没有实现 sizeThatFitContent 协议
        return;
    }
    CGFloat width = contentSize.width; CGFloat height = contentSize.height;
    if (width > rect.size.width) {
        width = rect.size.width;
    }
    if (height > rect.size.height*0.9) {
        height = rect.size.height*0.9;
    }
    if (_alertType == PWAlertTypeAlert) {
        _alertView.frame = CGRectMake((rect.size.width-width)/2.0, (rect.size.height-height)/2.0, width, height);
    }else {
        BOOL ignoreSafeArea = NO;
        if ([self.alertView respondsToSelector:@selector(ignoreSafeArea)]) {
            ignoreSafeArea = [self.alertView ignoreSafeArea];
        }
        CGFloat safeInsetsBottom = safeInsets.bottom;
        if (ignoreSafeArea) {
            safeInsetsBottom = 0;
        }
        _alertView.frame = CGRectMake((rect.size.width-width)/2.0, rect.size.height-height-safeInsetsBottom, width, height);
    }
}


#pragma mark - action
- (void)tapOnBackgroundView:(UITapGestureRecognizer *)tapGes {
    if (self.alertView.alertFinished) {
        self.alertView.alertFinished();
    }
}


#pragma mark - UIGestureRecognizerDelegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    if ([touch.view isDescendantOfView:self.alertView]) {
            return NO;
        }
        return YES;
}

@end

