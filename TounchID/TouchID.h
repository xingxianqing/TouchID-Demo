//
//  TouchIDViewController.h
//  91qianbao
//
//  Created by 邢现庆 on 15/9/7.
//  Copyright (c) 2015年 91金融科技有限公司. All rights reserved.
//

#import "TouchID.h"
#import <LocalAuthentication/LocalAuthentication.h>
typedef enum{
    TouchIDStatusAvailable = 1,//可用
    TouchIDStatusVerifyFail = -1,//三次验证失败
    TouchIDStatusClickCancel = -2,//取消
    TouchIDStatusClickInputPassword = -3,//输入密码
    TouchIDStatusCanceledBySystem = -4,//系统取消
    TouchIDStatusNoAvailable = -5,//不可用
    TouchIDStatusVerifySuccess = -6,//验证成功
    TouchIDStatusNoTouchID = -7,//没有指纹
} TouchIDStatus;

typedef void (^TouchIDStatusBlock) (TouchIDStatus status);

@interface TouchID : NSObject
/**
 *  检测TouchID是否可用
 */
+ (TouchIDStatus)isTouchIDAvailable;
/**
 *  检测TouchID
 *
 *  @param callback 返回TouchID状态
 */
+ (void)isTouchIDAvailableAndCallBack:(TouchIDStatusBlock)callback;
@end
