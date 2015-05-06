//
//  ViewController.m
//  TounchID
//
//  Created by 邢现庆 on 15-5-6.
//  Copyright (c) 2015年 邢现庆. All rights reserved.
//

#import "ViewController.h"
#import <LocalAuthentication/LocalAuthentication.h>

//设备高度
#define ScreenHeight  [UIScreen mainScreen].bounds.size.height
//设备宽度
#define ScreenWidth  [UIScreen mainScreen].bounds.size.width
//颜色
#define COLOR(R, G, B, A)  [UIColor colorWithRed:R/255.0 green:G/255.0 blue:B/255.0 alpha:A]

@interface ViewController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UILabel *stateLable;//显示状态的标签
@property(nonatomic,strong)UIView* backView;
@property(nonatomic,strong)NSMutableArray* array;
@property(nonatomic,copy)NSString* password;
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
                    //点击取消按钮  code = -2
                    if(error.code == -2){
                        self.stateLable.text = @"";
                        return;
                    }
                    //点击输入密码按钮   code = -3
                    if (error.code == -3) {
                        self.stateLable.text = @"";
                        //输入密码弹窗
                        [self CreatPopupViewAction];
                        return;
                    }
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
//弹出视图
-(void)CreatPopupViewAction{
    self.array=[NSMutableArray array];
    self.backView=[[UIView alloc]initWithFrame:self.view.bounds];
    self.backView.backgroundColor=COLOR(0, 0, 0, 0.6);
    [self.view addSubview:self.backView];
    
    
    UIView * view=[[UIView alloc]initWithFrame:CGRectMake(ScreenWidth/2-140, ScreenHeight/2-140, 280, 140)];
    view.layer.cornerRadius=8;
    view.layer.borderWidth=1;
    view.layer.borderColor=COLOR(153, 153, 153, 1.0).CGColor;
    view.backgroundColor=[UIColor whiteColor];
    
    UILabel* title=[[UILabel alloc]initWithFrame:CGRectMake(10, 5, view.frame.size.width-20, 30)];
    [title setText:@"请输入密码"];
    [view addSubview:title];
    
    UILabel* borderLable=[[UILabel alloc]initWithFrame:CGRectMake(0, 40, view.frame.size.width, 0.5)];
    borderLable.backgroundColor=COLOR(153, 153, 153, 0.3);
    [view addSubview:borderLable];
    
    UIView * contentView=[[UIView alloc]initWithFrame:CGRectMake(view.frame.size.width/2-120,view.frame.size.height-70, 240, 40)];
    contentView.layer.borderWidth=1;
    contentView.layer.borderColor=COLOR(153, 153, 153, 1.0).CGColor;
    contentView.userInteractionEnabled=NO;
    
    UITextField* textField=[[UITextField alloc]initWithFrame:CGRectMake(0, 0, 240, 40)];
    textField.delegate=self;
    [textField addTarget:self action:@selector(valueChanged:) forControlEvents:UIControlEventEditingChanged];
    textField.textColor=[UIColor clearColor];
    textField.keyboardType=UIKeyboardTypeNumberPad;
    textField.secureTextEntry=YES;
    textField.tintColor=[UIColor clearColor];
    textField.textAlignment=NSTextAlignmentCenter;
    [contentView addSubview:textField];
    
    for (int i=0; i<6; i++) {
        if (i>0) {
            UILabel* lable=[[UILabel  alloc]initWithFrame:CGRectMake(i*40, 0, 0.5, contentView.frame.size.height)];
            lable.backgroundColor=COLOR(153, 153, 153, 0.5);
            [contentView addSubview:lable];
        }
        UITextField* textField=[[UITextField alloc]initWithFrame:CGRectMake(i*40, 0, 40, 40)];
        textField.delegate=self;
        textField.tag=i;
        [textField setFont:[UIFont systemFontOfSize:22]];
        textField.keyboardType=UIKeyboardTypeNumberPad;
        textField.secureTextEntry=YES;
        textField.tintColor=[UIColor clearColor];
        textField.textAlignment=NSTextAlignmentCenter;
        [self.array addObject:textField];
        [contentView addSubview:textField];
    }
    [textField becomeFirstResponder];
    [view addSubview:contentView];
    [self.backView addSubview:view];
    
}
//密码框事件
- (void)valueChanged:(UITextField *)textField{
    
    if (textField.text.length<=6) {
        
        self.password=textField.text;
        for (int i = 0; i<6; i++) {
            UITextField* text = self.array[i];
            text.text=@"";
        }
        for (int i = 0; i<self.password.length; i++) {
            UITextField* text = self.array[i];
            text.text=@"*";
        }
        
        if (self.password.length==6) {
            
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                sleep(1);
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (self.password.length==6) {
                        [textField resignFirstResponder];
                        [self.backView removeFromSuperview];
                        //[self.popupView removeFromSuperview];
                        self.backView=nil;
                        //self.popupView=nil;
                        
                    }
                });
            });
        }
    }else {
        textField.text = [textField.text substringToIndex:6];
    }
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
