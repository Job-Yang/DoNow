//
//  NavigationViewController.h
//  Log_In
//
//  Created by 杨权 on 15/8/12.
//  Copyright (c) 2015年 Job-Yang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FMDB.h"
#import "AppDelegate.h"

@interface NavigationViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *HeadImageView;    //头像ImageView
@property (weak, nonatomic) IBOutlet UITableView *TableView;        //

@property (retain, nonatomic) NSMutableArray *NavNameArr;           //导航名数组
@property (retain, nonatomic) NSMutableArray *NavIconArr;           //导航图标数组


- (IBAction)ExitButtonAction:(id)sender;                            //回到主页事件
- (IBAction)BackButtonAction:(id)sender;                            //返回上级页面


@end
