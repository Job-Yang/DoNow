//
//  SettingViewController.h
//  Log_In
//
//  Created by 杨权 on 15/8/20.
//  Copyright (c) 2015年 Job-Yang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AssetsLibrary/ALAsset.h>
#import <AssetsLibrary/ALAssetsLibrary.h>
#import <AssetsLibrary/ALAssetsGroup.h>
#import <AssetsLibrary/ALAssetRepresentation.h>
#import "FMDB.h"
#import "AppDelegate.h"

@interface SettingViewController : UIViewController <UITextFieldDelegate,UINavigationControllerDelegate,UIAlertViewDelegate,UIImagePickerControllerDelegate>

@property (weak, nonatomic) IBOutlet UIButton *HeadImageButton;             //头像按钮
@property (weak, nonatomic) IBOutlet UIButton *BasicInfoButton;             //基本信息按钮
@property (weak, nonatomic) IBOutlet UIButton *DetailedInfoButton;          //详细信息按钮
@property (weak, nonatomic) IBOutlet UITextField *UsernameTextField;        //用户名
@property (weak, nonatomic) IBOutlet UITextField *PasswordTextField;        //密码
@property (weak, nonatomic) IBOutlet UITextField *OldPasswordTextField;     //旧密码
@property (weak, nonatomic) IBOutlet UITextField *NewPasswordTextField;     //新密码
@property (weak, nonatomic) IBOutlet UITextField *EmailTextField;           //邮箱
@property (weak, nonatomic) IBOutlet UITextField *BrithdayTextField;        //生日
@property (weak, nonatomic) IBOutlet UITextField *GenderTextField;          //性别
@property (weak, nonatomic) IBOutlet UITextField *RealNameTextField;        //真实姓名
@property (weak, nonatomic) IBOutlet UITextField *WorkTextField;            //工作
@property (weak, nonatomic) IBOutlet UITextField *CityTextField;            //居住地
@property (weak, nonatomic) IBOutlet UITextView *PersonalityShowTextView;   //个人签名
@property (weak, nonatomic) IBOutlet UIButton *SettingEmailButton;          //修改邮箱按钮
@property (weak, nonatomic) IBOutlet UIButton *SettingBrithdayButton;       //修改生日按钮
@property (weak, nonatomic) IBOutlet UIButton *SettingGenderButton;         //修改性别按钮
@property (weak, nonatomic) IBOutlet UILabel *ChangePasswordInfoLabel;      //修改密码提示框
@property (weak, nonatomic) IBOutlet UIView *BasicInfoView;                 //基本信息view
@property (weak, nonatomic) IBOutlet UIView *BasicInfoDropDownView;         //基本信息下拉view
@property (weak, nonatomic) IBOutlet UIView *DetailedInfoView;              //详细信息view
@property (weak, nonatomic) IBOutlet UIView *SettingPasswordView;           //修改密码view


@property (assign,nonatomic) float keyboardHeight;                  //键盘高度
@property (copy,nonatomic) NSString *path;                          //沙盒路径
@property (retain,nonatomic) UIAlertView *alter;                    //弹出框
@property (retain, nonatomic) FMDatabase *db;                       //FMDB数据库对象
@property (copy, nonatomic) NSString *User;                         //登录账号
@property (copy,nonatomic) NSString *HaedImageName;                 //图库选择的图片名


- (IBAction)MenuButtonAction:(id)sender;                            //跳转导航页面
- (IBAction)MoreButtonAction:(id)sender;                            //更多选项
- (IBAction)SettingHeadImageButtonAction:(id)sender;                //修改头像按钮事件
- (IBAction)BasicInfoButtonAction:(id)sender;                       //基本信息按钮事件
- (IBAction)DetailedInfoButtonAction:(id)sender;                    //详细信息按钮事件
- (IBAction)SettingPasswordButtonAction:(id)sender;                 //修改密码按钮事件
- (IBAction)SettingEmailButtonAction:(id)sender;                    //修改邮箱按钮事件
- (IBAction)SettingBrithdayButtonAction:(id)sender;                 //修改生日按钮事件
- (IBAction)SettingGenderButtonAction:(id)sender;                   //修改性别按钮事件
- (IBAction)GoRightButtonAction:(id)sender;                         //向右按钮事件
- (IBAction)GoLeftButtonAction:(id)sender;                          //向左按钮事件
- (IBAction)OkSettingPasswordButtonAction:(id)sender;               //确定修改密码按钮事件
- (IBAction)View_TouchDown:(id)sender;                              //点击view事件

@end
