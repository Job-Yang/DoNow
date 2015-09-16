//
//  AccountViewController.h
//  Log_In
//
//  Created by 杨权 on 15/8/4.
//  Copyright (c) 2015年 Job-Yang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AssetsLibrary/ALAsset.h>
#import <AssetsLibrary/ALAssetsLibrary.h>
#import <AssetsLibrary/ALAssetsGroup.h>
#import <AssetsLibrary/ALAssetRepresentation.h>
#import "FMDB.h"
#import "AppDelegate.h"

@interface AccountViewController : UIViewController <UITextFieldDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@property (assign,nonatomic) float keyboardHeight;                          //键盘高度
@property (copy,nonatomic) NSString *path;                                  //沙盒数据库文件路径
@property (copy,nonatomic) NSString *HaedImageName;                         //图库选择的图片名
@property (retain,nonatomic) FMDatabase *db;                                //FMDB数据库对象

@property (weak, nonatomic) IBOutlet UIButton *HeadButton;                  //头像按钮
@property (weak, nonatomic) IBOutlet UITextField *UesrnameTextField;        //账号TextField
@property (weak, nonatomic) IBOutlet UITextField *PasswordTextField;        //密码TextField
@property (weak, nonatomic) IBOutlet UITextField *EmailTextField;           //邮箱TextField
@property (weak, nonatomic) IBOutlet UITextField *BrithdayTextField;        //生日TextField
@property (weak, nonatomic) IBOutlet UITextField *GenderTextField;          //性别TextField
@property (weak, nonatomic) IBOutlet UILabel *ShowPromptLabel;              //提示Label
@property (weak, nonatomic) IBOutlet UIButton *PhotoAction;                 //图库按钮


- (IBAction)GetImage:(id)sender;                                //打开图库
- (IBAction)OKAction:(id)sender;                                //确定
- (IBAction)View_TouchDown:(id)sender;                          //取消焦点


@end
