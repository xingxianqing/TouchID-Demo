//
//  ViewController.m
//  TounchID
//
//  Created by 邢现庆 on 15-5-6.
//  Copyright (c) 2015年 邢现庆. All rights reserved.
//

#import "ViewController.h"
#import <LocalAuthentication/LocalAuthentication.h>
@interface ViewController ()
@property (weak, nonatomic) IBOutlet UILabel *stateLable;//显示状态的标签

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}
//检测touchID是否可用
- (IBAction)isTouchIDAvailable:(UIButton *)sender {
    /*
     创建了一个LAContext实例，用于执行认证策略
     */
    LAContext* context = [[LAContext alloc]init];
    
    NSError* errorMessage = nil;
    /*
     然后在该对象上调用canEvaluatePolicy方法执行某个指定的认证策略 canEvaluatePolicy方法返回的是Bool值，表示指定的认证策略是否允许执行。当方法返回false时，可以通过error对象来获取详细的失败原因。失败的情况可能是设备本身不支持，例如旧版本的iPhone与iPad；运行在模拟器上；或者用户未开启Touch ID功能等
     LAPolicy枚举目前只有一个枚举值.DeviceOwnerAuthenticationWithBiometrics，即使用指纹生物识别方式来认证设备机主。
     */
    BOOL isAvailable = [context canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:&errorMessage];
    
    if (isAvailable) {
        NSLog(@"TouchID 可用 ");
        self.stateLable.text = @"TouchID 可用";
        
        //获取验证结果
        /*
         调用该方法将弹出系统调用Touch ID的对话框，其中的localizedReason参数用于在对话框中提示用户详细的理由和原因
         reply参数是一个Block，其中的Bool类型参数success表示指纹验证是否通过，当失败时error参数包含了具体的失败信息
         */
        [context evaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics localizedReason:@"需要验证你的指纹来确认您的身份信息" reply:^(BOOL success, NSError *error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (success) {
                    NSLog(@"TouchID 验证成功");
                    self.stateLable.text = @"TouchID 验证成功";
                }else{
                    self.stateLable.text = @"";
                    [self showAlert:[NSString stringWithFormat:@"TouchID  验证失败   error:%@",error]];
                }

            });
        }];
        
    }else{
        self.stateLable.text = @"";
        [self showAlert:[NSString stringWithFormat:@"TouchID 不可用   error:%@",errorMessage]];
       
    }
    
}

-(void)showAlert:(NSString*)message{
    UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@" " message:message delegate:nil cancelButtonTitle:@"好" otherButtonTitles:nil, nil];
    [alert show];
}

/*
 验证失败结果  其中的几种
 
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
