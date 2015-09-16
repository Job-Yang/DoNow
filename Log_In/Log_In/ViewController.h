//
//  ViewController.h
//  Log_In
//
//  Created by 杨权 on 15/8/3.
//  Copyright (c) 2015年 Job-Yang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "FMDB.h"

@interface ViewController : UIViewController <UITextFieldDelegate>

@property (assign,nonatomic) float keyboardHeight;          //键盘高度
@property (copy,nonatomic) NSString *path;                  //沙盒数据库路径
@property (retain,nonatomic) FMDatabase *db;                //FMDB数据库对象
@property (copy,nonatomic) NSString *User;                  //登录账号

@property (weak, nonatomic) IBOutlet UITextField *UsernameTextField;        //账号TextField
@property (weak, nonatomic) IBOutlet UITextField *PasswordTextField;        //密码TextField
@property (weak, nonatomic) IBOutlet UIButton *SignInButton;                //登陆Button
@property (weak, nonatomic) IBOutlet UIButton *CreateAccountButton;         //注册Button
@property (weak, nonatomic) IBOutlet UIButton *ForgotPasswordButton;        //忘记密码Button
@property (weak, nonatomic) IBOutlet UILabel *ShowPromptLabel;              //登陆提示Label


- (IBAction)SignInAction:(id)sender;                        //登陆
- (IBAction)CreateAccountAction:(id)sender;                 //注册
- (IBAction)ForgotPasswordAction:(id)sender;                //忘记密码
- (IBAction)View_TouchDown:(id)sender;                      //取消焦点


@end

