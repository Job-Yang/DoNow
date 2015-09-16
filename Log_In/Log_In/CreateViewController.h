//
//  CreateViewController.h
//  Log_In
//
//  Created by 杨权 on 15/8/9.
//  Copyright (c) 2015年 Job-Yang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AssetsLibrary/ALAsset.h>
#import <AssetsLibrary/ALAssetsLibrary.h>
#import <AssetsLibrary/ALAssetsGroup.h>
#import <AssetsLibrary/ALAssetRepresentation.h>
#import "FMDB.h"
#import "AppDelegate.h"

@interface CreateViewController : UIViewController <UITextFieldDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@property (weak, nonatomic) IBOutlet UILabel *TitleLabelView;               //标题
@property (weak, nonatomic) IBOutlet UILabel *EventLabelView;               //安排
@property (weak, nonatomic) IBOutlet UILabel *AimLabelView;                 //目标，目标地
@property (weak, nonatomic) IBOutlet UITextField *EventTextField;           //标题框
@property (weak, nonatomic) IBOutlet UITextField *AimTextField;             //安排框
@property (weak, nonatomic) IBOutlet UITextField *TimeWithYearTextField;    //日期框-年
@property (weak, nonatomic) IBOutlet UITextField *TimeWithMonthTextField;   //日期框-月
@property (weak, nonatomic) IBOutlet UITextField *TimeWithDayTextField;     //日期框-日
@property (weak, nonatomic) IBOutlet UITextField *DateWithHourTextField;    //时间框-时
@property (weak, nonatomic) IBOutlet UITextField *DateWithMinuteTextField;  //时间框-分
@property (weak, nonatomic) IBOutlet UIButton *AllDaySwitchButton;          //全天开关
@property (weak, nonatomic) IBOutlet UIButton *RepeatSwitchButton;          //重要开关
@property (weak, nonatomic) IBOutlet UIButton *BackButton;                  //返回按钮
@property (weak, nonatomic) IBOutlet UILabel *FriendWarnLabel;              //搭档栏提示框
@property (weak, nonatomic) IBOutlet UIButton *Together1Button;             //定义五个搭档按钮
@property (weak, nonatomic) IBOutlet UIButton *Together2Button;             //通过更换按钮背景图
@property (weak, nonatomic) IBOutlet UIButton *Together3Button;             //实现头像的功能
@property (weak, nonatomic) IBOutlet UIButton *Together4Button;             //再点击每个头像时
@property (weak, nonatomic) IBOutlet UIButton *Together5Button;             //可以继续更换对应头像


@property (retain,nonatomic) FMDatabase *db;                    //FMDB数据库对象
@property (copy,nonatomic) NSString *path;                    //沙盒plist文件路径
@property (copy,nonatomic) NSString *User;                      //登录账号
@property (copy,nonatomic) NSString *HaedImageName;             //图库选择的图片名
@property (retain,nonatomic) NSMutableArray *HaedNameArr;       //头像名数组
@property (copy, nonatomic) NSString *DateStr;                  //日期默认值
@property (assign,nonatomic) float keyboardHeight;              //键盘高度
@property (assign,nonatomic) BOOL isAllDay;                     //是否全天
@property (assign,nonatomic) BOOL isImportant;                  //是否重要
@property (retain,nonatomic) UIButton *button;                  //用于判断搭档栏是哪个按钮打开的图库



- (IBAction)CancelButtonAction:(id)sender;                      //取消
- (IBAction)OKButtonAction:(id)sender;                          //确定
- (IBAction)AllDaySwitchButtonAction:(id)sender;                //全天
- (IBAction)RepeatSwitchButtonAction:(id)sender;                //重要
- (IBAction)View_TouchDown:(id)sender;                          //点击屏幕隐藏键盘
- (IBAction)EventTextField_EditingDidEnd:(id)sender;            //安排框输入完毕触发该方法
- (IBAction)AimTextField_EditingDidEnd:(id)sender;              //目的框输入完毕触发该方法
- (IBAction)SelectFriendButtonAction:(id)sender;                //选择搭档
- (IBAction)TogetherButtonAction:(id)sender;                    //搭档栏5个头像按钮事件

@end
