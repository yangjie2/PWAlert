//
//  PWAlertBackgroundViewController.h
//  PWUIKitDemo
//
//  Created by yangjie on 2022/11/30.
//

#import <UIKit/UIKit.h>
#import "PWAlertStyle.h"

NS_ASSUME_NONNULL_BEGIN

@interface PWAlertBackgroundViewController : UIViewController
@property (nonatomic, weak) UIView<PWAlertViewProtocol> *alertView;

@end

NS_ASSUME_NONNULL_END
