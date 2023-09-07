//
//  PWAlertUtil.m
//  PWUIKitDemo
//
//  Created by yangjie on 2022/12/8.
//

#import "PWAlertUtil.h"
#import <UIKit/UIKit.h>

BOOL PWAlertDeviceIsIpad(void) {
    NSString *deviceType = [UIDevice currentDevice].model;
    if([deviceType isEqualToString:@"iPad"]) {
        //iPad
        return YES;
    }
    return NO;
}

BOOL PWAlertDeviceIsIphone(void) {
    NSString *deviceType = [UIDevice currentDevice].model;
    if([deviceType isEqualToString:@"iPhone"]) {
        //iPad
        return YES;
    }
    return NO;
}
