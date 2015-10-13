//
//  ViewController.m
//  Log_In
//
//  Created by 杨权 on 15/8/3.
//  Copyright (c) 2015年 Job-Yang. All rights reserved.
//

#import "ViewController.h"


@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //设置账号密码TextField的代理
    self.UsernameTextField.delegate = self;
    self.PasswordTextField.delegate = self;
    
    //初始化沙盒路径,并将命名文件名为FMDB
    self.path = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/FMDB.sqlite"];
    NSLog(@"%@",self.path);
    
    //创建FMDatabase对象,参数为沙盒路径
    //沙盒路径文件路径无需真实存在，如果不存在会自动创建。
    self.db = [FMDatabase databaseWithPath:self.path];
    //允许数据库缓存提升查询效率
    [self.db setShouldCacheStatements:YES];
    //打开所需数据库
    [self DBInitialization];
    
    //初始化键盘高度为0
    self.keyboardHeight = 0;
    [self registerForKeyboardNotifications];
    //隐藏登陆提示Label
    self.ShowPromptLabel.hidden = YES;
    
    
}

//数据库初始化
- (void)DBInitialization {
    //打开数据库
    if ([self.db open]) {
        //判断登录状态表是否存在
        if (![self.db tableExists :@"LOGIN_STATE"]) {
            //创建登录状态表
            if ([self.db executeUpdate:@"CREATE TABLE IF NOT EXISTS LOGIN_STATE (USER TEXT PRIMARY KEY, LOGIN TEXT NOT NULL);"]) {
                NSLog(@"创建“LOGIN_STATE”表成功！");
            }
            else{
                NSLog(@"创建“LOGIN_STATE”表失败！");
            }
        }
          //判断账号信息表是否存在
        if (![self.db tableExists :@"USER_INFO"]) {
            //创建账号信息表
            //SQL语句不区分大小写, 字符串需要加""或''
            if ([self.db executeUpdate:@"CREATE TABLE IF NOT EXISTS USER_INFO (USER TEXT PRIMARY KEY, PASS TEXT NOT NULL);"]) {
                NSLog(@"创建“USER_INFO”表成功！");
            }
            else{
                NSLog(@"创建“USER_INFO”表失败！");
            }
        }
    }
    else{
        NSLog(@"打开数据库失败！");
    }
}


//实现自动登录
- (void)viewDidAppear:(BOOL)animated {
    //查询所有的登录信息
    FMResultSet *resultSet = [self.db executeQuery:@"SELECT * FROM LOGIN_STATE"];
    //遍历登录状态数据
    while ([resultSet next]) {
        NSString *user = [resultSet stringForColumn:@"USER"];
        NSString *isLOGIN = [resultSet stringForColumn:@"LOGIN"];
        //如果存在已登录
        if ([isLOGIN isEqualToString:@"YES"]) {
            //为该用户设置全局头像
            self.User = user;
            NSString *Select1 = [NSString stringWithFormat:@"SELECT * FROM BASIC_INFO WHERE USER = '%@';",self.User];
            FMResultSet *resultSet2 = [self.db executeQuery:Select1];
            while ([resultSet2 next]) {
                NSString *headPath = [NSHomeDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"Documents/%@",[resultSet2 stringForColumn:@"HEAD"]]];
                UIImage *headImage = [UIImage imageWithContentsOfFile:headPath];
                AppDelegate *del = (AppDelegate *)[[UIApplication sharedApplication]delegate];
                del.HeadImage = headImage;
            }
          //提示登录成功
          self.ShowPromptLabel.hidden = NO;
          self.ShowPromptLabel.text = @"自动登陆成功!";
            
            if ([self.db close]) {
                NSLog(@"登录页面数据库已关闭");
             }
            else{
                NSLog(@"登录页面数据库关闭失败");
             }
          //直接跳过登录
          [self performSegueWithIdentifier:@"GoHome" sender:self];
          //停止遍历
          break;
        }
    }
}

//登录
- (IBAction)SignInAction:(id)sender {
    //根据账号查询密码
    FMResultSet *resultSet1 = [self.db executeQuery:@"SELECT * FROM USER_INFO"];
        //遍历账号信息表
        while ([resultSet1 next]) {
        NSString *User = [resultSet1 stringForColumn:@"USER"];
        NSString *pass = [resultSet1 stringForColumn:@"PASS"];
        //账号存在
        if ([self.UsernameTextField.text isEqualToString:User]) {
        //判断密码
        if ([self.PasswordTextField.text isEqualToString:pass]) {
            //提示登陆成功
            self.ShowPromptLabel.text = @"登陆成功!";
            self.ShowPromptLabel.hidden = NO;
            //修改该账号的登录状态为YES
            NSString *insertSql1 = [NSString stringWithFormat:@"INSERT INTO LOGIN_STATE (USER, LOGIN) VALUES ('%@', '%@')",self.UsernameTextField.text, @"YES"];
            [self.db executeUpdate:insertSql1];
            if ([self.db close]) {
                NSLog(@"页面1数据库已关闭");
            }
            else{
                NSLog(@"页面1数据库关闭失败");
            }
            //登录成功
            [self performSegueWithIdentifier:@"GoHome" sender:self];
            break;
       }
        else{
            //提示账号不存在或者密码错误
            self.ShowPromptLabel.text = @"账号不存在或者密码错误 !";
            self.ShowPromptLabel.hidden = NO;
      }
   }
  }
}

//注册
- (IBAction)CreateAccountAction:(id)sender {
  //跳转 AccountViewController
}

//忘记密码
- (IBAction)ForgotPasswordAction:(id)sender {
    
}

//取消焦点
- (IBAction)View_TouchDown:(id)sender {
    //发送resignFirstResponder消息，取消第一响应状态
    [[UIApplication sharedApplication]sendAction:@selector(resignFirstResponder) to:nil from:nil forEvent:nil];
    //恢复正常View
     CGRect ScreenSize = [[UIScreen mainScreen] bounds];
     self.view.frame = CGRectMake(0, 0, ScreenSize.size.width, ScreenSize.size.height);
}

//注册键盘通知
- (void) registerForKeyboardNotifications
{
    //发送keyboardWasShown消息
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWasShown:) name:UIKeyboardDidShowNotification object:nil];
}

//键盘显示状态
- (void) keyboardWasShown:(NSNotification *) notif
{
    NSDictionary *info = [notif userInfo];
    NSValue *value = [info objectForKey:UIKeyboardFrameBeginUserInfoKey];
    //获取键盘尺寸
    CGSize keyboardSize = [value CGRectValue].size;
    //获取键盘的高度
    self.keyboardHeight = keyboardSize.height;
    //将view向上移动一个密码键盘的高度(216)
    CGRect ScreenSize = [[UIScreen mainScreen] bounds];
    self.view.frame = CGRectMake(0, -216, ScreenSize.size.width, ScreenSize.size.height);
}

//重写textFieldDelegate方法,Return换行
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    //按Return键光标聚焦在下一个文本框
    if (textField == self.UsernameTextField)
    {
        [self.PasswordTextField becomeFirstResponder];
    }
    else{
        //最后一个文本框放弃焦点
        [self.PasswordTextField resignFirstResponder];
        //恢复正常View
        CGRect ScreenSize = [[UIScreen mainScreen] bounds];
        self.view.frame = CGRectMake(0, 0, ScreenSize.size.width, ScreenSize.size.height);
    }
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
