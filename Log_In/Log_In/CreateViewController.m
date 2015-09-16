//
//  CreateViewController.m
//  Log_In
//
//  Created by 杨权 on 15/8/9.
//  Copyright (c) 2015年 Job-Yang. All rights reserved.
//

#import "CreateViewController.h"

@interface CreateViewController ()

@end

@implementation CreateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //设置各个文本框代理
    self.EventTextField.delegate = self;
    self.AimTextField.delegate = self;
    self.TimeWithYearTextField.delegate = self;
    self.TimeWithMonthTextField.delegate = self;
    self.TimeWithDayTextField.delegate = self;
    self.DateWithHourTextField.delegate = self;
    self.DateWithMinuteTextField.delegate = self;
    //初始化
    self.keyboardHeight = 0;
    self.TitleLabelView.text = @"添加安排";
    self.isAllDay = NO;
    self.isImportant = NO;
    //头像数组设置空字符串防止头像少于5个时下标越界
    self.HaedNameArr = [[NSMutableArray alloc]initWithObjects:@"",@"",@"",@"",@"", nil];
    //将5个头像按钮设置为圆形
    self.Together1Button.layer.cornerRadius = self.Together1Button.frame.size.width / 2;
    self.Together1Button.clipsToBounds = YES;
    self.Together2Button.layer.cornerRadius = self.Together2Button.frame.size.width / 2;
    self.Together2Button.clipsToBounds = YES;
    self.Together3Button.layer.cornerRadius = self.Together3Button.frame.size.width / 2;
    self.Together3Button.clipsToBounds = YES;
    self.Together4Button.layer.cornerRadius = self.Together4Button.frame.size.width / 2;
    self.Together4Button.clipsToBounds = YES;
    self.Together5Button.layer.cornerRadius = self.Together5Button.frame.size.width / 2;
    self.Together5Button.clipsToBounds = YES;
    
    //初始化沙盒数据库路径
    self.path = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/FMDB.sqlite"];
    //创建FMDatabase对象,参数为沙盒路径
    //沙盒路径文件路径无需真实存在，如果不存在会自动创建。
    self.db = [FMDatabase databaseWithPath:self.path];
    //允许数据库缓存提升查询效率
    [self.db setShouldCacheStatements:YES];
    //打开所需数据库
    [self DBInitialization];
    //键盘通知中心
    [self registerForKeyboardNotifications];
    
    //此处接受来自日历的传值
    if (self.DateStr != nil) {
        NSArray *TimeArrayYear = [self.DateStr componentsSeparatedByString:@"年"];
        self.TimeWithYearTextField.text = TimeArrayYear[0];
        NSArray *TimeArrayMonth = [TimeArrayYear[1] componentsSeparatedByString:@"月"];
        self.TimeWithMonthTextField.text = TimeArrayMonth[0];
        NSArray *TimeArrayDay = [TimeArrayMonth[1] componentsSeparatedByString:@"日"];
        self.TimeWithDayTextField.text = TimeArrayDay[0];
    }
}

- (void)DBInitialization {
    //打开数据库
    if ([self.db open]) {
        //确定登录的是哪个账号
        FMResultSet *resultSet = [self.db executeQuery:@"SELECT * FROM LOGIN_STATE"];
        //遍历登录状态数据
        while ([resultSet next]) {
            NSString *user = [resultSet stringForColumn:@"USER"];
            NSString *isLOGIN = [resultSet stringForColumn:@"LOGIN"];
            //如果存在已登录
            if ([isLOGIN isEqualToString:@"YES"]) {
                self.User = user;
                //停止遍历
                break;
            }
        }
        //判断登录状态表是否存在
        NSString *TableStr = [NSString stringWithFormat:@"PLAN_INFO_%@",self.User];
      if (self.User != NULL) {
        if (![self.db tableExists :TableStr]) {
            //创建登录状态表
            NSString *Create1 = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS '%@' ( EVENTID INTEGER PRIMARY KEY AUTOINCREMENT, EVENT TEXT, AIM TEXT, TIME TEXT, DATE TEXT, IMPORT TEXT, HEAD1 TEXT, HEAD2 TEXT, HEAD3 TEXT, HEAD4 TEXT, HEAD5 TEXT, SORT TEXT);",TableStr];
            if ([self.db executeUpdate:Create1]) {
                NSLog(@"创建‘PLAN_INFO_%@’表成功！",self.User);
            }
            else{
                NSLog(@"创建‘PLAN_INFO_%@’表失败！",self.User);

            }
        }
    }
}
    else{
        NSLog(@"打开数据库失败！");
    }
}

//取消按钮事件，返回上一页面
- (IBAction)CancelButtonAction:(id)sender {
}

//确定按钮事件，返回主页
- (IBAction)OKButtonAction:(id)sender {
    //设置表名，日期
    NSString *TableStr = [NSString stringWithFormat:@"PLAN_INFO_%@",self.User];
    NSString *timeString = [NSString stringWithFormat:@"%@年%@月%@日",self.TimeWithYearTextField.text ,self.TimeWithMonthTextField.text ,self.TimeWithDayTextField.text];
    //如果全天按钮被激活，则直接设置日期为‘全天’
    NSString *dateString = [[NSString alloc]init];
        if (self.isAllDay == YES) {
            dateString = @"全天";
        }
        else{
            //设置时间框值，连接字符串
            dateString = [NSString stringWithFormat:@"%@:%@",self.DateWithHourTextField.text ,self.DateWithMinuteTextField.text];
       }
    //是否为重要安排
    NSString *Important = [[NSString alloc]init];
        if (self.isImportant == YES) {
            Important = @"YES";
        }
        else{
            Important = @"NO";
        }
    //在数据库添加一条安排
    NSString *InsertStr1 = [NSString stringWithFormat:@"INSERT INTO '%@' (EVENT, AIM, TIME, DATE, IMPORT, HEAD1, HEAD2, HEAD3, HEAD4, HEAD5) VALUES ('%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@');",TableStr, self.EventTextField.text, self.AimTextField.text, timeString, dateString, Important, self.HaedNameArr[0], self.HaedNameArr[1], self.HaedNameArr[2], self.HaedNameArr[3], self.HaedNameArr[4]];
    [self.db executeUpdate:InsertStr1];
    //关闭数据库
    if ([self.db close]) {
        NSLog(@"页面4数据库已关闭");
    }
    else{
        NSLog(@"页面4数据库关闭失败");
    }
}

//自定义全天开关
- (IBAction)AllDaySwitchButtonAction:(id)sender {
    if (self.isAllDay == NO) {
        self.AllDaySwitchButton.selected = YES;
        self.isAllDay = YES;
    }else{
        self.AllDaySwitchButton.selected = NO;
        self.isAllDay = NO;
    }
}

//自定义重要安排开关
- (IBAction)RepeatSwitchButtonAction:(id)sender {
    if (self.isImportant == NO) {
        self.RepeatSwitchButton.selected = YES;
        self.isImportant = YES;
    }else{
        self.RepeatSwitchButton.selected = NO;
        self.isImportant = NO;
    }
}

//当安排文本框输入完成时，将安排显示到安排label上
- (IBAction)EventTextField_EditingDidEnd:(id)sender {
    self.EventLabelView.text = self.EventTextField.text;
}
//当目标文本框输入完成时，将目标显示到安排label上
- (IBAction)AimTextField_EditingDidEnd:(id)sender {
    self.AimLabelView.text = self.AimTextField.text;
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
    self.view.frame = CGRectMake(0, -150, 320, 568);
}

//取消焦点
- (IBAction)View_TouchDown:(id)sender {
    //发送resignFirstResponder消息，取消第一响应状态
    [[UIApplication sharedApplication]sendAction:@selector(resignFirstResponder) to:nil from:nil forEvent:nil];
    //恢复正常View
    self.view.frame = CGRectMake(0, 0, 320, 568);
}


//重写textFieldselfegate方法,Return换行
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    //按Return键光标聚焦在下一个文本框
    if (textField == self.EventTextField)
    {
        [self.AimTextField becomeFirstResponder];
    }
    else if (textField == self.AimTextField){
        [self.TimeWithYearTextField becomeFirstResponder];
    }
    else if (textField == self.TimeWithYearTextField){
        [self.TimeWithMonthTextField becomeFirstResponder];
    }
    else if (textField == self.TimeWithMonthTextField){
        [self.TimeWithDayTextField becomeFirstResponder];
    }
    else if (textField == self.TimeWithDayTextField){
        [self.DateWithHourTextField becomeFirstResponder];
    }
    else if (textField == self.DateWithHourTextField){
        [self.DateWithMinuteTextField becomeFirstResponder];
    }
    else{
        //最后一个文本框放弃焦点
        [self.DateWithMinuteTextField resignFirstResponder];
        //恢复正常View
        self.view.frame = CGRectMake(0, 0, 320, 568);
    }
    return YES;
}

- (IBAction)SelectFriendButtonAction:(id)sender {
    //使用UIImagePickerController进行相关操作
    UIImagePickerController * imagePicker = [[UIImagePickerController alloc]init];
    //设置UIImagePickerControllerDelegate和UINavigationControllerDelegate
    imagePicker.delegate = self;
    //设置来源类型为图片库
    imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    imagePicker.allowsEditing = YES;
    [self presentViewController:imagePicker animated:YES completion:nil];
    //取得当前按钮信息
    self.button = sender;
    
}

//搭档栏5个头像按钮事件
- (IBAction)TogetherButtonAction:(id)sender {
    //调用打开图库方法，将按当前按钮信息作为参数传递过去
    [self SelectFriendButtonAction:sender];
    //取得当前按钮信息
     self.button = sender;
}

//设置取得图片后的操作
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    AppDelegate *del = [[UIApplication sharedApplication]delegate];
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    [picker dismissViewControllerAnimated:YES completion:nil];
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
        //将头像插入数组头部，防止下标越界
        //这样做的后果是在主页中显示的头像序列是倒序的
        [self.HaedNameArr insertObject:self.HaedImageName atIndex:0];
    };
    ALAssetsLibrary* assetslibrary = [[ALAssetsLibrary alloc] init];
    [assetslibrary assetForURL:imageURL resultBlock:resultblock failureBlock:nil];

    //取得图片后，根据按钮tag值判断是哪个按钮触发了图库事件
    if (self.button.tag == 6) {
        //如果是选择搭档按钮，则按钮1-5的顺序分别设置头像按钮背景图片
        if (self.Together1Button.currentBackgroundImage == del.DefaultAvatar || self.Together1Button.currentBackgroundImage == nil) {
            [self.Together1Button setBackgroundImage:[info objectForKey:UIImagePickerControllerOriginalImage] forState:UIControlStateNormal];
            self.FriendWarnLabel.hidden = YES;
        }
        else if (self.Together2Button.currentBackgroundImage == del.DefaultAvatar || self.Together2Button.currentBackgroundImage == nil) {
            [self.Together2Button setBackgroundImage:[info objectForKey:UIImagePickerControllerOriginalImage] forState:UIControlStateNormal];
        }
        else if (self.Together3Button.currentBackgroundImage == del.DefaultAvatar || self.Together3Button.currentBackgroundImage == nil) {
            [self.Together3Button setBackgroundImage:[info objectForKey:UIImagePickerControllerOriginalImage] forState:UIControlStateNormal];
        }
        else if (self.Together4Button.currentBackgroundImage == del.DefaultAvatar || self.Together4Button.currentBackgroundImage == nil) {
            [self.Together4Button setBackgroundImage:[info objectForKey:UIImagePickerControllerOriginalImage] forState:UIControlStateNormal];
        }
        else if (self.Together5Button.currentBackgroundImage == del.DefaultAvatar || self.Together5Button.currentBackgroundImage == nil) {
            [self.Together5Button setBackgroundImage:[info objectForKey:UIImagePickerControllerOriginalImage] forState:UIControlStateNormal];
        }
    }
    else{
        //如果是5个头像按钮触发的图库的事件，则修改相对应的图像按钮背景图片
        if (self.button.tag == 1) {
          [self.Together1Button setBackgroundImage:[info objectForKey:UIImagePickerControllerOriginalImage] forState:UIControlStateNormal];
        }
        else if (self.button.tag == 2){
          [self.Together2Button setBackgroundImage:[info objectForKey:UIImagePickerControllerOriginalImage] forState:UIControlStateNormal];
        }
        else if (self.button.tag == 3){
            [self.Together3Button setBackgroundImage:[info objectForKey:UIImagePickerControllerOriginalImage] forState:UIControlStateNormal];
        }
        else if (self.button.tag == 4){
            [self.Together4Button setBackgroundImage:[info objectForKey:UIImagePickerControllerOriginalImage] forState:UIControlStateNormal];
        }
        else {
            [self.Together5Button setBackgroundImage:[info objectForKey:UIImagePickerControllerOriginalImage] forState:UIControlStateNormal];
        }
    }
}

//按Cancel回到图库
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
