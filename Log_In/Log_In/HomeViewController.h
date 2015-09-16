//
//  HomeViewController.h
//  Log_In
//
//  Created by 杨权 on 15/8/7.
//  Copyright (c) 2015年 Job-Yang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FMDB.h"
#import "AppDelegate.h"

@interface HomeViewController : UIViewController <UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UILabel *WeekLabel;            //显示星期
@property (weak, nonatomic) IBOutlet UILabel *TimeLabel;            //显示日期
@property (weak, nonatomic) IBOutlet UIButton *MenuButton;          //跳转Navigation
@property (weak, nonatomic) IBOutlet UIButton *HeadButton;          //显示右上头像
@property (weak, nonatomic) IBOutlet UIButton *AddButton;           //添加安排
@property (weak, nonatomic) IBOutlet UITableView *PlanTableView;    //安排列表


@property (retain,nonatomic) FMDatabase *db;                        //FMDB数据库对象
@property (copy,nonatomic) NSString *User;                          //登录账号
@property (copy,nonatomic) NSString *path;                        //沙盒文件路径


- (IBAction)MenuAction:(id)sender;                                  //跳转NavigationViewController按钮事件


@end
