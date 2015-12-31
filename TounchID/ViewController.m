//
//  ViewController.m
//  TounchID
//
//  Created by 邢现庆 on 15-5-6.
//  Copyright (c) 2015年 邢现庆. All rights reserved.
//

#import "ViewController.h"
#import "TouchID.h"

@interface ViewController ()<UITextFieldDelegate>
@property(nonatomic,weak) IBOutlet UILabel *stateLable;//显示状态的标签
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}
//检测touchID是否可用
- (IBAction)isTouchIDAvailable:(UIButton *)sender {
    
    TouchIDStatus status = [TouchID isTouchIDAvailable];
    
    switch (status) {
            
        case TouchIDStatusAvailable:
            [self.stateLable setText:@"可用"];
            break;
            
        case TouchIDStatusNoTouchID:
            [self.stateLable setText:@"没有设置指纹"];
            break;
            
        case TouchIDStatusNoAvailable:
            [self.stateLable setText:@"不可用"];
            break;
            
        default:
            break;
    }
}

- (IBAction)verify:(id)sender {
    
    [TouchID isTouchIDAvailableAndCallBack:^(TouchIDStatus status) {
        dispatch_async(dispatch_get_main_queue(), ^{
            switch (status) {
                    //验证成功
                case TouchIDStatusVerifySuccess:
                    //......
                    break;
                    //点击取消按钮 -2
                case TouchIDStatusClickCancel:
                    //......
                    break;
                    //点击输入密码按钮 -3
                case TouchIDStatusClickInputPassword:
                    //......
                    break;
                    //验证失败
                case TouchIDStatusVerifyFail:
                    //......
                    break;
                default:
                    break;
            }
        });

    }];
}


/*
 指纹验证失败结果  其中的几种
 
 1. 连续三次指纹识别错误的运行结果：
 
 抱歉，您未能通过Touch ID指纹验证！
 Error Domain=com.apple.LocalAuthentication Code=-1 "Aplication retry limit exceeded." UserInfo=0x1740797c0 {NSLocalizedDescription=Aplication retry limit exceeded.}
 
 
 2. Touch ID功能被锁定，下一次需要输入系统密码时的运行结果：
 

 抱歉，您未能通过Touch ID指纹验证！
 Error Domain=com.apple.LocalAuthentication Code=-1 "Biometry is locked out." UserInfo=0x17407dc00 {NSLocalizedDescription=Biometry is locked out.}
 
 3. 用户在Touch ID对话框中点击了取消按钮：

 抱歉，您未能通过Touch ID指纹验证！
 Error Domain=com.apple.LocalAuthentication Code=-2 "Canceled by user." UserInfo=0x17006c780 {NSLocalizedDescription=Canceled by user.}
 
 4. 在Touch ID对话框显示过程中，背系统取消，例如按下电源键：

 抱歉，您未能通过Touch ID指纹验证！
 Error Domain=com.apple.LocalAuthentication Code=-4 "UI canceled by system." UserInfo=0x170065900 {NSLocalizedDescription=UI canceled by system.}
 
 
 5. 用户在Touch ID对话框中点击输入密码按钮：
 
 抱歉，您未能通过Touch ID指纹验证！
 Error Domain=com.apple.LocalAuthentication Code=-3 "Fallback authentication mechanism selected." UserInfo=0x17407e040 {NSLocalizedDescription=Fallback authentication mechanism selected.}
 
 */


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
