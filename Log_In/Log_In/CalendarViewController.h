//
//  CalendarViewController.h
//  Log_In
//
//  Created by 杨权 on 15/8/16.
//  Copyright (c) 2015年 Job-Yang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyCalendarItem.h"
#import "CreateViewController.h"


@interface CalendarViewController : UIViewController


@property (weak, nonatomic) IBOutlet UILabel *HeadLabel;            //最上方日期框
@property (weak, nonatomic) IBOutlet UIView *DatePickerView;        //日期选择器所在的View
@property (weak, nonatomic) IBOutlet UIDatePicker *DatePicker;      //日期选择器
@property (weak, nonatomic) IBOutlet UILabel *DateLabel;            //日期选择器上的日期框

@property (copy, nonatomic) NSMutableString *DateStr;               //处理日期字符串
@property (nonatomic) MyCalendarItem *calendarView;                 //创建一个MyCalendarItem库的对象
@property (assign,nonatomic) double LastCount;                      //上月增量
@property (assign,nonatomic) double NextCount;                      //下月增量


- (IBAction)LastMonthButtonAction:(id)sender;           //上一月按钮事件
- (IBAction)NextMonthButtonAction:(id)sender;           //下一月按钮事件
- (IBAction)MenuButtonAction:(id)sender;                //跳转导航页面按钮事件
- (IBAction)SearchDateButtonAction:(id)sender;          //显示日期选择器
- (IBAction)BackNowButtonAction:(id)sender;             //回到今天按钮事件
- (IBAction)OKButtonAction:(id)sender;                  //确定选择时间按钮事件
- (IBAction)AddButtonAction:(id)sender;                 //新增安排按钮


@end
