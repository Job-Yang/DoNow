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
@interface NavigationViewController : UIViewController


@property (weak, nonatomic) IBOutlet UIImageView *HeadImageView;    //头像ImageView

- (IBAction)ExitButtonAction:(id)sender;                            //回到主页事件
- (IBAction)BackButtonAction:(id)sender;                            //返回上级页面
- (IBAction)GoViewButtonsAction:(id)sender;                         //跳转对应页面


@end
