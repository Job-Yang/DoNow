//
//  ListViewController.h
//  Log_In
//
//  Created by 杨权 on 15/8/17.
//  Copyright (c) 2015年 Job-Yang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FMDB.h"
#import "AppDelegate.h"

@interface ListViewController : UIViewController <UITableViewDataSource,UITableViewDelegate>


@property (weak, nonatomic) IBOutlet UITableView *EventTableView;   //安排完成情况列表


@property (copy, nonatomic) NSString *path;                  //沙盒路径
@property (retain, nonatomic) FMDatabase *db;                //FMDB数据库对象
@property (copy, nonatomic) NSString *User;                  //登录账号
@property (assign, nonatomic) int EventCount;                //安排总数数
@property (assign, nonatomic) int ClickCount;                //点击次数


- (IBAction)BackButtonAction:(id)sender;                     //跳转导航页
- (IBAction)SearchButtonAction:(id)sender;                   //跳转总览页

@end
