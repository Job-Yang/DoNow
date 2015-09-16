//
//  GroupsViewController.h
//  Log_In
//
//  Created by 杨权 on 15/8/23.
//  Copyright (c) 2015年 Job-Yang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FMDB.h"
#import "AppDelegate.h"

@interface GroupsViewController : UIViewController <UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UIButton *TableButton;                            //表格视图按钮
@property (weak, nonatomic) IBOutlet UIButton *ListButton;                             //列表视图按钮
@property (weak, nonatomic) IBOutlet UIImageView *HeadImageView;                       //头像
@property (weak, nonatomic) IBOutlet UILabel *ImportantAndEmergencyEventNumberLabel;   //重要紧急安排
@property (weak, nonatomic) IBOutlet UILabel *ImportantAndNormalEventNumberLabel;      //重要非紧急安排
@property (weak, nonatomic) IBOutlet UILabel *UnimportantAndEmergencyEventNumberLabel; //非重要紧急安排
@property (weak, nonatomic) IBOutlet UILabel *UnimportantAndNormalEventNumberLabel;    //非重要非紧急安排
@property (weak, nonatomic) IBOutlet UIView *FormView;                                 //表格view
@property (weak, nonatomic) IBOutlet UITableView *ListTableView;                       //列表

@property (copy, nonatomic) NSString *path;                                     //沙盒路径
@property (retain, nonatomic) FMDatabase *db;                                   //FMDB数据库对象
@property (copy, nonatomic) NSString *User;                                     //登录账号
@property (retain, nonatomic) NSDictionary *EventDic;                           //安排字典
@property (retain, nonatomic) NSArray *EventDicKey;                             //列表头
@property (retain, nonatomic) NSMutableArray *ImportantAndEmergencyEventArr;    //重要紧急安排数组
@property (retain, nonatomic) NSMutableArray *ImportantAndNormalEventArr;       //重要非紧急安排数组
@property (retain, nonatomic) NSMutableArray *UnimportantAndEmergencyEventArr;  //非重要紧急安排数组
@property (retain, nonatomic) NSMutableArray *UnimportantAndNormalEventArr;     //非重要非紧急安排数组

- (IBAction)TableButtonAction:(id)sender;                   //表格视图按钮事件
- (IBAction)ListButtonAction:(id)sender;                    //列表视图按钮事件
- (IBAction)MenuButtonAction:(id)sender;                    //跳转导航页面


@end
