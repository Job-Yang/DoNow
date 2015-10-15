//
//  SettingViewController.m
//  Log_In
//
//  Created by 杨权 on 15/8/20.
//  Copyright (c) 2015年 Job-Yang. All rights reserved.
//

#import "SettingViewController.h"

@interface SettingViewController ()

@end

@implementation SettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //设置代理
    self.UsernameTextField.delegate = self;
    self.PasswordTextField.delegate = self;
    self.EmailTextField.delegate = self;
    self.BrithdayTextField.delegate = self;
    self.GenderTextField.delegate = self;
    self.OldPasswordTextField.delegate = self;
    self.NewPasswordTextField.delegate = self;
    self.RealNameTextField.delegate = self;
    self.WorkTextField.delegate = self;
    self.CityTextField.delegate = self;
    self.alter.delegate = self;
    //初始化操作
    self.keyboardHeight = 0;
    self.SettingPasswordView.hidden = YES;
    self.DetailedInfoView.hidden = YES;
    CGRect ScreenSize = [[UIScreen mainScreen] bounds];
    self.BasicInfoDropDownView.frame = CGRectMake(0, 112.0/568.0*ScreenSize.size.height, ScreenSize.size.width, 266.0/568.0*ScreenSize.size.height);
    self.UsernameTextField.enabled = NO;
    self.PasswordTextField.enabled = NO;
    self.EmailTextField.enabled = NO;
    self.BrithdayTextField.enabled = NO;
    self.GenderTextField.enabled = NO;
    self.BasicInfoButton.selected = YES;
    //设置头像为圆形
    self.HeadImageButton.layer.cornerRadius = self.HeadImageButton.frame.size.width / 2;
    self.HeadImageButton.clipsToBounds = YES;
    //初始化头像
    AppDelegate *del = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    if (del.HeadImage != nil) {
        [self.HeadImageButton setBackgroundImage:del.HeadImage forState:UIControlStateNormal];
    }

    //初始化沙盒数据库路径
    self.path = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/FMDB.sqlite"];
    //创建FMDatabase对象,参数为沙盒路径
    //沙盒路径文件路径无需真实存在，如果不存在会自动创建。
    self.db = [FMDatabase databaseWithPath:self.path];
    //允许数据库缓存提升查询效率
    [self.db setShouldCacheStatements:YES];
    //打开所需数据库
    [self DBInitialization];
    //初始化文本框信息
    [self setTextlabelInfo];
    //注册键盘通知
    [self registerForKeyboardNotifications];
}

//数据库初始化
- (void)DBInitialization {
    //打开数据库
    if ([self.db open]) {
        //确定登录的是哪个账号
        FMResultSet *resultSet = [self.db executeQuery:@"SELECT * FROM LOGIN_STATE"];
        //遍历登录状态数据
        while ([resultSet next]) {
            NSString *user = [resultSet stringForColumn:@"USER"];
            NSString *LOGIN = [resultSet stringForColumn:@"LOGIN"];
            //如果存在已登录
            if ([LOGIN isEqualToString:@"YES"]) {
                self.User = user;
                //停止遍历
                break;
            }
        }
        //判断详细信息表是否存在
        if (self.User != NULL) {
            if (![self.db tableExists :@"DETAIL_INFO"]) {
                //创建登录状态表
                if ([self.db executeUpdate:@"CREATE TABLE IF NOT EXISTS DETAIL_INFO (USER TEXT PRIMARY KEY, RELNAME TEXT, WORK TEXT, CITY TEXT, PERSHOW TEXT);"]) {
                    NSLog(@"创建‘DETAIL_INFO’表成功！");
                }
                else{
                    NSLog(@"创建‘DETAIL_INFO’表失败！");
                }
            }
        }
    }
    else{
        NSLog(@"打开数据库失败！");
    }
}

//初始化文本框信息
- (void)setTextlabelInfo {
    //查询基本信息表的相关信息
    NSString *Select1 = [NSString stringWithFormat:@"SELECT * FROM BASIC_INFO WHERE USER = '%@';",self.User];
    FMResultSet *resultSet1 = [self.db executeQuery:Select1];
    //遍历基本信息表
    while ([resultSet1 next]) {
        //查询账号信息表中的密码
        NSString *Select2 = [NSString stringWithFormat:@"SELECT * FROM USER_INFO WHERE USER = '%@';",self.User];
        FMResultSet *resultSet2 = [self.db executeQuery:Select2];
        while ([resultSet2 next]) {
            //显示密码
            self.PasswordTextField.text = [resultSet2 stringForColumn:@"PASS"];
          }
            //显示账号,邮箱，生日，性别
            self.UsernameTextField.text = self.User;
            self.EmailTextField.text = [resultSet1 stringForColumn:@"EMAIL"];
            self.BrithdayTextField.text = [resultSet1 stringForColumn:@"BRITH"];
            self.GenderTextField.text = [resultSet1 stringForColumn:@"GEN"];
        //查询详细信息表
        NSString *Select3 = [NSString stringWithFormat:@"SELECT * FROM DETAIL_INFO WHERE USER = '%@';",self.User];
        FMResultSet *resultSet3 = [self.db executeQuery:Select3];
        while ([resultSet3 next]) {
            //显示真实姓名，工作，居住地，个人签名
            self.RealNameTextField.text = [resultSet3 stringForColumn:@"RELNAME"];
            self.WorkTextField.text = [resultSet3 stringForColumn:@"WORK"];
            self.CityTextField.text = [resultSet3 stringForColumn:@"CITY"];
            self.PersonalityShowTextView.text = [resultSet3 stringForColumn:@"PERSHOW"];
        }
    }
}

//跳转导航页面
- (IBAction)MenuButtonAction:(id)sender {
    NSString *subtypeString = kCATransitionFromLeft;
    [self transitionWithType:kCATransitionPush WithSubtype:subtypeString ForView:self.view.window];
}

// CATransition动画实现
- (void) transitionWithType:(NSString *) type WithSubtype:(NSString *) subtype ForView : (UIView *) view {
    //创建CATransition对象
    CATransition *animation = [CATransition animation];
    //设置运动时间
    animation.duration = 0.3;
    //设置运动type
    animation.type = type;
    if (subtype != nil) {
        //设置子类
        animation.subtype = subtype;
    }
    //设置运动速度
    animation.timingFunction = UIViewAnimationOptionCurveEaseInOut;
    [view.layer addAnimation:animation forKey:@"animation"];
}

//更多信息
- (IBAction)MoreButtonAction:(id)sender {
    //创建 UIAlertController
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    //取消按钮事件
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
    }];
    //版本信息按钮事件
    UIAlertAction *aboutAction = [UIAlertAction actionWithTitle:@"版本信息" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        //版本信息弹出框
        UIAlertView *alter = [[UIAlertView alloc] initWithTitle:@"版本信息" message:@"Version 1.1 for Job-Yang" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alter show];
        
    }];
    //退出登录按钮事件
    UIAlertAction *exitAction = [UIAlertAction actionWithTitle:@"退出登录" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        //退出登录弹出框
        self.alter = [[UIAlertView alloc] initWithTitle:@"退出登录" message:@"您是否要退出登陆?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [self.alter show];
        
    }];
    [alertController addAction:cancelAction];
    [alertController addAction:aboutAction];
    [alertController addAction:exitAction];
    
    [self presentViewController:alertController animated:YES completion:nil];
    
}


//退出登录代理事件
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1) {
        NSLog(@"退出登录成功！");
        //删除相应登陆信息
        NSString *delete1 = [NSString stringWithFormat:@"DELETE FROM LOGIN_STATE WHERE USER = '%@';", self.User];
        [self.db executeUpdate:delete1];
        //退出程序
        exit(2);
    }
}

//设置头像
- (IBAction)SettingHeadImageButtonAction:(id)sender {
    //使用UIImagePickerController进行相关操作
    UIImagePickerController * imagePicker = [[UIImagePickerController alloc]init];
    //设置UIImagePickerControllerDelegate和UINavigationControllerDelegate
    imagePicker.delegate = self;
    //设置来源类型为图片库
    imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    imagePicker.allowsEditing = YES;
    [self presentViewController:imagePicker animated:YES completion:nil];
    
}

//设置取得图片后的操作
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    //获取选择的图片类型为原图
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    AppDelegate *del = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    del.HeadImage = image;
    [picker dismissViewControllerAnimated:YES completion:nil];
    //将图库按钮的背景图片修改为获得的图片
    [self.HeadImageButton setBackgroundImage:image forState:UIControlStateNormal];
    //获取点选图片时，获取图片名称
    NSURL *imageURL = [info objectForKey:UIImagePickerControllerReferenceURL];
    ALAssetsLibraryAssetForURLResultBlock resultblock = ^(ALAsset *myasset)
    {
        ALAssetRepresentation *representation = [myasset defaultRepresentation];
        self.HaedImageName = [representation filename];
        //将图片的后缀名切除
        NSArray *arr = [self.HaedImageName componentsSeparatedByString:@"."];
        self.HaedImageName = arr[0];
        NSLog(@"fileName : %@",self.HaedImageName);
        //将选择的图片放到沙盒中
        NSString *HeadPath = [NSHomeDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"Documents/%@",self.HaedImageName]];
        //将图片输出为png,并写入沙盒指定路径
        NSData *data = UIImagePNGRepresentation(image);
        [data writeToFile:HeadPath atomically:YES];
        //修改基本信息中的头像名
        NSString *update1 = [NSString stringWithFormat:@"UPDATE BASIC_INFO SET HEAD = '%@' WHERE USER = '%@' ;", self.HaedImageName, self.User];
        [self.db executeUpdate:update1];
    };
    ALAssetsLibrary* assetslibrary = [[ALAssetsLibrary alloc] init];
    [assetslibrary assetForURL:imageURL
                   resultBlock:resultblock
                  failureBlock:nil];
}

//按Cancel回到图库
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [self dismissViewControllerAnimated:YES completion:nil];
}

//基本信息按钮事件
- (IBAction)BasicInfoButtonAction:(id)sender {
    self.BasicInfoView.hidden = NO;
    self.DetailedInfoView.hidden = YES;
    self.BasicInfoButton.selected = YES;
    self.DetailedInfoButton.selected = NO;
}

//详细信息按钮事件
- (IBAction)DetailedInfoButtonAction:(id)sender {
    self.BasicInfoView.hidden = YES;
    self.DetailedInfoView.hidden = NO;
    self.BasicInfoButton.selected = NO;
    self.DetailedInfoButton.selected = YES;
}

//修改密码事件
- (IBAction)SettingPasswordButtonAction:(id)sender {
    //显示设置密码view，并将下拉view下移
    if (self.SettingPasswordView.hidden == YES) {
        self.SettingPasswordView.hidden = NO;
        CGRect ScreenSize = [[UIScreen mainScreen] bounds];
        self.BasicInfoDropDownView.frame = CGRectMake(0, 227.0/568.0*ScreenSize.size.height, ScreenSize.size.width, 266.0/568.0*ScreenSize.size.height);
    }
    else{
        //隐藏设置密码view，恢复正常view
        self.SettingPasswordView.hidden = YES;
        CGRect ScreenSize = [[UIScreen mainScreen] bounds];
        self.BasicInfoDropDownView.frame = CGRectMake(0, 112.0/568.0*ScreenSize.size.height, ScreenSize.size.width, 266.0/568.0*ScreenSize.size.height);
    }
}

//确定修改密码
- (IBAction)OkSettingPasswordButtonAction:(id)sender {
    self.ChangePasswordInfoLabel.text = @"";
    //验证密码
    NSString *Select3 = [NSString stringWithFormat:@"SELECT * FROM USER_INFO WHERE USER = '%@';",self.User];
    FMResultSet *resultSet3 = [self.db executeQuery:Select3];
    while ([resultSet3 next]) {
    if ([self.OldPasswordTextField.text isEqualToString:[resultSet3 stringForColumn:@"PASS"]]) {
        if (self.NewPasswordTextField.text.length > 0) {
        NSString *update1 = [NSString stringWithFormat:@"UPDATE USER_INFO SET PASS = '%@' WHERE USER = '%@' ;", self.NewPasswordTextField.text, self.User];
        [self.db executeUpdate:update1];
        self.ChangePasswordInfoLabel.text = @"修改成功!";
        }
    }
    else{
        if (self.OldPasswordTextField.text.length > 0){
        self.ChangePasswordInfoLabel.text = @"密码错误!";
        }
     }
  }
}

//修改邮箱事件
- (IBAction)SettingEmailButtonAction:(id)sender {
    if (self.EmailTextField.enabled == NO) {
        self.EmailTextField.enabled = YES;
        [self.SettingEmailButton setTitle:@"保存" forState:UIControlStateNormal];
    }
    else{
        self.EmailTextField.enabled = NO;
        if (self.EmailTextField.text.length > 0){
           NSString *update2 = [NSString stringWithFormat:@"UPDATE BASIC_INFO SET EMAIL = '%@' WHERE  USER = '%@' ;", self.EmailTextField.text, self.User];
           [self.db executeUpdate:update2];
        }
        [self.SettingEmailButton setTitle:@"修改" forState:UIControlStateNormal];
    }
    CGRect ScreenSize = [[UIScreen mainScreen] bounds];
    self.view.frame = CGRectMake(0, 0, ScreenSize.size.width, ScreenSize.size.height);
}

//修改生日事件
- (IBAction)SettingBrithdayButtonAction:(id)sender {
    if (self.BrithdayTextField.enabled == NO) {
        self.BrithdayTextField.enabled = YES;
        [self.SettingBrithdayButton setTitle:@"保存" forState:UIControlStateNormal];
    }
    else{
        self.BrithdayTextField.enabled = NO;
        if (self.BrithdayTextField.text.length > 0){
            NSString *update3 = [NSString stringWithFormat:@"UPDATE BASIC_INFO SET BRITH = '%@' WHERE  USER = '%@' ;", self.BrithdayTextField.text, self.User];
            [self.db executeUpdate:update3];
        }
        [self.SettingBrithdayButton setTitle:@"修改" forState:UIControlStateNormal];
    }
    CGRect ScreenSize = [[UIScreen mainScreen] bounds];
    self.view.frame = CGRectMake(0, 0, ScreenSize.size.width, ScreenSize.size.height);
}

//修改性别事件
- (IBAction)SettingGenderButtonAction:(id)sender {
    if (self.GenderTextField.enabled == NO) {
        self.GenderTextField.enabled = YES;
        [self.SettingGenderButton setTitle:@"保存" forState:UIControlStateNormal];
    }
    else{
        self.GenderTextField.enabled = NO;
        if (self.GenderTextField.text.length > 0){
            NSString *update3 = [NSString stringWithFormat:@"UPDATE BASIC_INFO SET GEN = '%@' WHERE  USER = '%@' ;", self.GenderTextField.text, self.User];
            [self.db executeUpdate:update3];
        }
        [self.SettingGenderButton setTitle:@"修改" forState:UIControlStateNormal];
    }
    CGRect ScreenSize = [[UIScreen mainScreen] bounds];
    self.view.frame = CGRectMake(0, 0, ScreenSize.size.width, ScreenSize.size.height);
}

//向右按钮事件
- (IBAction)GoRightButtonAction:(id)sender {
    self.BasicInfoView.hidden = YES;
    self.DetailedInfoView.hidden = NO;
    self.BasicInfoButton.selected = NO;
    self.DetailedInfoButton.selected = YES;
}

//向左按钮事件
- (IBAction)GoLeftButtonAction:(id)sender {
    //如果详细信息不为空，为更新数据库
    if (self.RealNameTextField.text.length != 0 && self.WorkTextField.text.length != 0 && self.CityTextField.text.length != 0 && self.PersonalityShowTextView.text.length != 0) {
        NSString *Select4 = [NSString stringWithFormat:@"SELECT * FROM DETAIL_INFO WHERE USER = '%@';",self.User];
        FMResultSet *resultSet4 = [self.db executeQuery:Select4];
        if ([resultSet4 next]) {
            NSString *update4 = [NSString stringWithFormat:@"UPDATE DETAIL_INFO SET RELNAME = '%@', WORK = '%@',CITY = '%@', PERSHOW = '%@' WHERE USER = '%@';", self.RealNameTextField.text, self.WorkTextField.text, self.CityTextField.text, self.PersonalityShowTextView.text, self.User];
            [self.db executeUpdate:update4];
        }
        else{
            NSString *InsertStr4 = [NSString stringWithFormat:@"INSERT INTO DETAIL_INFO (USER, RELNAME ,WORK, CITY, PERSHOW) VALUES ('%@','%@','%@','%@','%@');", self.User, self.RealNameTextField.text, self.WorkTextField.text, self.CityTextField.text, self.PersonalityShowTextView.text];
            [self.db executeUpdate:InsertStr4];
        }
    }
    self.BasicInfoView.hidden = NO;
    self.DetailedInfoView.hidden = YES;
    self.BasicInfoButton.selected = YES;
    self.DetailedInfoButton.selected = NO;
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
    //将view向上移动一个密码键盘的高度(145)
    CGRect ScreenSize = [[UIScreen mainScreen] bounds];
    self.view.frame = CGRectMake(0, -145, ScreenSize.size.width, ScreenSize.size.height);
}

//重写textFieldDelegate方法,Return换行
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    //按Return键光标聚焦在下一个文本框
    if (textField == self.OldPasswordTextField)
    {
        [self.NewPasswordTextField becomeFirstResponder];
    }
    else if (textField == self.NewPasswordTextField) {
        //最后一个文本框放弃焦点
        [self.NewPasswordTextField resignFirstResponder];
        //恢复正常View
        CGRect ScreenSize = [[UIScreen mainScreen] bounds];
        self.view.frame = CGRectMake(0, 0, ScreenSize.size.width, ScreenSize.size.height);
    }
    else if (textField == self.EmailTextField){
        [self.BrithdayTextField becomeFirstResponder];
    }
    else if (textField == self.BrithdayTextField){
        [self.GenderTextField becomeFirstResponder];
    }
    else if (textField == self.GenderTextField) {
        //最后一个文本框放弃焦点
        [self.GenderTextField resignFirstResponder];
        //恢复正常View
        CGRect ScreenSize = [[UIScreen mainScreen] bounds];
        self.view.frame = CGRectMake(0, 0, ScreenSize.size.width, ScreenSize.size.height);
    }
    else if (textField == self.RealNameTextField)
    {
        [self.WorkTextField becomeFirstResponder];
    }
    else if (textField == self.WorkTextField){
        [self.CityTextField becomeFirstResponder];
    }
    else if (textField == self.CityTextField){
        [self.PersonalityShowTextView becomeFirstResponder];
    }
    return YES;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
@end
