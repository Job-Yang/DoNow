//
//  AccountViewController.m
//  Log_In
//
//  Created by 杨权 on 15/8/4.
//  Copyright (c) 2015年 Job-Yang. All rights reserved.
//

#import "AccountViewController.h"

@interface AccountViewController ()

@end

@implementation AccountViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //设置TextField代理
    self.UesrnameTextField.delegate = self;
    self.PasswordTextField.delegate = self;
    self.EmailTextField.delegate = self;
    self.BrithdayTextField.delegate = self;
    self.GenderTextField.delegate = self;
    self.ShowPromptLabel.hidden = YES;
    
    //将图库按钮设置为圆形
    self.HeadButton.layer.cornerRadius = self.HeadButton.frame.size.width / 2;
    self.HeadButton.clipsToBounds = YES;
    
    //初始化键盘高度，键盘通知中心
    self.keyboardHeight = 0;
    [self registerForKeyboardNotifications];
    
    //初始化沙盒数据库路径
    self.path = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/FMDB.sqlite"];
    //创建FMDatabase对象,参数为沙盒路径
    //沙盒路径文件路径无需真实存在，如果不存在会自动创建。
    self.db = [FMDatabase databaseWithPath:self.path];
    //允许数据库缓存提升查询效率
    [self.db setShouldCacheStatements:YES];
    //打开所需数据库
    [self DBInitialization];

}

//数据库初始化
- (void)DBInitialization {
    //打开数据库
    if ([self.db open]) {
        //判断基本信息表是否存在
        if (![self.db tableExists :@"BASIC_INFO"]) {
            //创建基本信息表
            if ([self.db executeUpdate:@"CREATE TABLE IF NOT EXISTS BASIC_INFO (USER TEXT PRIMARY KEY,EMAIL TEXT, BRITH TEXT, GEN TEXT, HEAD TEXT);"]) {
                NSLog(@"创建“BASIC_INFO”表成功！");
            }
            else{
                NSLog(@"创建“BASIC_INFO”表失败！");
            }
        }
    //判断账号信息表是否存在
    if (![self.db tableExists :@"USER_INFO"]) {
        //创建账号信息表
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

//打开图库
- (IBAction)GetImage:(id)sender {
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
    //修改全局头像
    AppDelegate *del = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    del.HeadImage = image;
    [picker dismissViewControllerAnimated:YES completion:nil];
    //将图库按钮的背景图片修改为获得的图片
    [self.HeadButton setBackgroundImage:image forState:UIControlStateNormal];
    //获取点选图片时，获取图片名称
    NSURL *imageURL = [info objectForKey:UIImagePickerControllerReferenceURL];
    ALAssetsLibraryAssetForURLResultBlock resultblock = ^(ALAsset *myasset)
    {
        ALAssetRepresentation *representation = [myasset defaultRepresentation];
        self.HaedImageName = [representation filename];
        NSLog(@"fileName : %@",self.HaedImageName);
        //将图片的后缀名切除
        NSArray *arr = [self.HaedImageName componentsSeparatedByString:@"."];
        self.HaedImageName = arr[0];
        //将选择的图片放到沙盒中
        NSString *HeadPath = [NSHomeDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"Documents/%@",self.HaedImageName]];
        //将图片输出为png,并写入沙盒指定路径
        NSData *data = UIImagePNGRepresentation(image);
        [data writeToFile:HeadPath atomically:YES];
    };
    ALAssetsLibrary* assetslibrary = [[ALAssetsLibrary alloc] init];
    [assetslibrary assetForURL:imageURL
                   resultBlock:resultblock
                  failureBlock:nil];

}

//按Cancel回到图库
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    //返回上级控制器
    [self dismissViewControllerAnimated:YES completion:nil];
}


//确定事件
- (IBAction)OKAction:(id)sender {
    //如果账号密码不为空，则视为有效注册
    if (self.UesrnameTextField.text.length != 0 && self.PasswordTextField.text.length != 0) {
        //增加一条基本信息，信息包括（账号，邮箱，生日，性别，头像），头像存储的是在沙盒中的头像名
        NSString *InsertStr1 = [NSString stringWithFormat:@"INSERT INTO BASIC_INFO (USER, EMAIL, BRITH, GEN, HEAD) VALUES ('%@', '%@', '%@', '%@', '%@')",self.UesrnameTextField.text, self.EmailTextField.text, self.BrithdayTextField.text, self.GenderTextField.text,self.HaedImageName];
        [self.db executeUpdate:InsertStr1];
        
        //添加一条账号信息
        NSString *InsertStr2 = [NSString stringWithFormat:@"INSERT INTO USER_INFO (USER, PASS) VALUES ('%@', '%@')",self.UesrnameTextField.text,self.PasswordTextField.text];
        [self.db executeUpdate:InsertStr2];
        //显示成功提示框
        self.ShowPromptLabel.hidden = NO;
        //关闭数据库
        [self.db close];
        
    }
    else{
        self.ShowPromptLabel.text = @"注册失败";
        self.ShowPromptLabel.hidden = NO;
    }
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
    self.view.frame = CGRectMake(0, -190, 320, 568);
}

//取消焦点
- (IBAction)View_TouchDown:(id)sender {
    //发送resignFirstResponder消息，取消第一响应状态
   [[UIApplication sharedApplication]sendAction:@selector(resignFirstResponder) to:nil from:nil forEvent:nil];
     //恢复正常View
    self.view.frame = CGRectMake(0, 0, 320, 568);
}

//重写textFieldDelegate方法,Return换行
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    //按Return键光标聚焦在下一个文本框
    if (textField == self.UesrnameTextField)
    {
        [self.PasswordTextField becomeFirstResponder];
    }
    else if (textField == self.PasswordTextField){
        [self.EmailTextField becomeFirstResponder];
    }
    else if (textField == self.EmailTextField){
        [self.BrithdayTextField becomeFirstResponder];
    }
    else if (textField == self.BrithdayTextField){
        [self.GenderTextField becomeFirstResponder];
    }
    else{
        //最后一个文本框放弃焦点
        [self.GenderTextField resignFirstResponder];
        //恢复正常View 
        self.view.frame = CGRectMake(0, 0, 320, 568);
    }
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
