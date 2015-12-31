//
//  TouchIDViewController.m
//  91qianbao
//
//  Created by 邢现庆 on 15/9/7.
//  Copyright (c) 2015年 91金融科技有限公司. All rights reserved.
//

#import "TouchID.h"

@interface TouchID ()

@end

@implementation TouchID

/**
 *  检测TouchID是否可用
 */
+ (TouchIDStatus)isTouchIDAvailable{
    /*
     创建了一个LAContext实例，用于执行认证策略
     */
    LAContext* context    = [[LAContext alloc]init];

    NSError* errorMessage = nil;
    /*
     然后在该对象上调用canEvaluatePolicy方法执行某个指定的认证策略 canEvaluatePolicy方法返回的是Bool值，表示指定的认证策略是否允许执行。当方法返回false时，可以通过error对象来获取详细的失败原因。失败的情况可能是设备本身不支持，例如旧版本的iPhone与iPad；运行在模拟器上；或者用户未开启Touch ID功能等
     LAPolicy枚举目前只有一个枚举值.DeviceOwnerAuthenticationWithBiometrics，即使用指纹生物识别方式来认证设备机主。
     */
    BOOL isAvailable      = [context canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics
                                            error:&errorMessage];
    
    //TouchID 可用
    if (isAvailable) {
        return TouchIDStatusAvailable;
    }else{//不可用
        switch (errorMessage.code) {
                //没有注册指纹-7
            case TouchIDStatusNoTouchID:
                return TouchIDStatusNoTouchID ;
                break;
                //不可用
            default:
                return TouchIDStatusNoAvailable ;
                break;
        }
    }
    return TouchIDStatusNoAvailable;
}
/**
 *  检测TouchID
 *
 *  @param callback 返回TouchID状态
 */
+(void)isTouchIDAvailableAndCallBack:(TouchIDStatusBlock)callback{

    LAContext* context    = [[LAContext alloc]init];

    context.localizedFallbackTitle = @"验证登录密码";
    
    NSError* errorMessage = nil;

    BOOL isAvailable      = [context canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics
                                            error:&errorMessage];

    //TouchID 可用
    if (isAvailable) {
        //获取验证结果
        /*
         调用该方法将弹出系统调用Touch ID的对话框，其中的localizedReason参数用于在对话框中提示用户详细的理由和原因
         reply参数是一个Block，其中的Bool类型参数success表示指纹验证是否通过，当失败时error参数包含了具体的失败信息
         */
        [context evaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics
                localizedReason:@"通过Home键验证已有手机指纹"
                          reply:^(BOOL success, NSError *error) {
                              
            dispatch_async(dispatch_get_main_queue(), ^{
                //验证成功
                if (success) {
                    
                    callback(TouchIDStatusVerifySuccess);
                    
                }else{
                    
                    switch (error.code) {
                            
                        //点击取消按钮 -2
                        case TouchIDStatusClickCancel:
                            callback(TouchIDStatusClickCancel);
                            break;
                            
                        //点击输入密码按钮-3
                        case TouchIDStatusClickInputPassword:
                            callback(TouchIDStatusClickInputPassword);
                            break;
                            
                        //验证失败
                        default:
                            callback(TouchIDStatusVerifyFail);
                            break;
                    }
                }
            });
        }];
    }else{
        //不可用
        callback(TouchIDStatusNoAvailable);
    }
}




@end
