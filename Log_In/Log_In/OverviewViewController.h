//
//  OverviewViewController.h
//  Log_In
//
//  Created by 杨权 on 15/8/19.
//  Copyright (c) 2015年 Job-Yang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FMDB.h"
#import "KDGoalBar.h"
#import "AppDelegate.h"

@interface OverviewViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIImageView *HeadImageView;        //头像
@property (weak, nonatomic) IBOutlet UILabel *NameLabel;                //姓名
@property (weak, nonatomic) IBOutlet UILabel *CompletedCountLabel;      //完成数
@property (weak, nonatomic) IBOutlet UILabel *UnCompletedCountLabel;    //未完成数
@property (weak, nonatomic) IBOutlet UILabel *EventCountLabel;          //总数


@property (copy ,nonatomic) NSString *path;                 //沙盒路径
@property (retain, nonatomic) FMDatabase *db;               //FMDB数据库对象
@property (copy, nonatomic) NSString *User;                 //登录账号

- (IBAction)MenuButtonAction:(id)sender;                    //跳转导航页面
- (IBAction)SettingButtonAction:(id)sender;                 //跳转设置页面

@end
