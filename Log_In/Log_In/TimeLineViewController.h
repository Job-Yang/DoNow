//
//  TimeLineViewController.h
//  Log_In
//
//  Created by 杨权 on 15/8/23.
//  Copyright (c) 2015年 Job-Yang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FMDB.h"
#import "AppDelegate.h"

@interface TimeLineViewController : UIViewController <UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UIButton *HeadButton;              //头像按钮
@property (weak, nonatomic) IBOutlet UILabel *MonthLabel;               //月份
@property (weak, nonatomic) IBOutlet UILabel *YearNumberLabel;          //年份
@property (weak, nonatomic) IBOutlet UITableView *TimeLineTableView;    //时间轴TableView

@property (retain, nonatomic) NSMutableArray *EventArray;               //原安排数组
@property (retain, nonatomic) NSArray *sortedEventArray;                //排序后的安排数组
@property (copy, nonatomic) NSString *path;                             //沙盒路径
@property (retain, nonatomic) FMDatabase *db;                           //FMDB数据库对象
@property (copy, nonatomic) NSString *User;                             //登录账号

- (IBAction)HeadButtonAction:(id)sender;                                //头像按钮事件
- (IBAction)MenuButtonAction:(id)sender;                                //跳转导航页面

@end
