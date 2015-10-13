//
//  CalendarViewController.m
//  Log_In
//
//  Created by 杨权 on 15/8/16.
//  Copyright (c) 2015年 Job-Yang. All rights reserved.
//

#import "CalendarViewController.h"

@interface CalendarViewController ()

@end

@implementation CalendarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //初始化上下月增量为1
    self.LastCount = 1;
    self.NextCount = 1;
    //隐藏日期选择View
    self.DatePickerView.hidden = YES;
    //使用calendarView对象来创建日历内容
    self.calendarView = [[MyCalendarItem alloc] init];
    CGRect ScreenSize = [[UIScreen mainScreen] bounds];
    self.calendarView.frame = CGRectMake(10.0/320.0*ScreenSize.size.width, 100.0/568.0*ScreenSize.size.height, 300.0/320.0*ScreenSize.size.width, 340.0/568.0*ScreenSize.size.height);
    [self.view addSubview:self.calendarView];
    //设置当前日期
    self.calendarView.date = [NSDate date];
    NSString *dateStr = [NSString stringWithFormat:@"%@",self.calendarView.date];
    NSArray *dateArr = [dateStr componentsSeparatedByString:@"-"];
    self.HeadLabel.text = [NSString stringWithFormat:@"%@年%@月",dateArr[0],dateArr[1]];
    NSDateFormatter *format = [[NSDateFormatter alloc]init];
    [format setDateFormat:@"yyyy年MM月dd日"];
    //给字符串一个当前时间的初始值
    self.DateStr = [[NSMutableString alloc]initWithString:[format stringFromDate:[NSDate date]]];
    //此处应注意避免循环引用使用weakSelf
    //此处2种写法
    //1. __weak typeof(self) weakSelf = self;
    //2. __weak CalendarViewController *weakSelf = self;
    __weak CalendarViewController *weakSelf = self;
    self.calendarView.calendarBlock =  ^(NSInteger day, NSInteger month, NSInteger year){
    weakSelf.DateStr = [NSMutableString stringWithFormat:@"%li年%li月%li日", year,month,day];
    };
}

//上一月按钮事件
- (IBAction)LastMonthButtonAction:(id)sender {
    //先移除当前view上的日历
    [self.calendarView removeFromSuperview];
    //重新创建一个calendarView
    self.calendarView = [[MyCalendarItem alloc] init];
    CGRect ScreenSize = [[UIScreen mainScreen] bounds];
    self.calendarView.frame = CGRectMake(10.0/320.0*ScreenSize.size.width, 100.0/568.0*ScreenSize.size.height, 300.0/320.0*ScreenSize.size.width, 340.0/568.0*ScreenSize.size.height);
    [self.view addSubview:self.calendarView];
    //设置日历时间为 上下月增量的整月倍
    self.calendarView.date = [NSDate dateWithTimeIntervalSinceNow:-2592000 * (self.LastCount - self.NextCount + 1)];
    //同时改变上方日期框的时间显示
    NSString *dateStr = [NSString stringWithFormat:@"%@",self.calendarView.date];
    NSArray *dateArr = [dateStr componentsSeparatedByString:@"-"];
    self.HeadLabel.text = [NSString stringWithFormat:@"%@年%@月",dateArr[0],dateArr[1]];
    //上一月增量加一
    self.LastCount ++;
    
}

//下一月按钮事件
- (IBAction)NextMonthButtonAction:(id)sender {
    //先移除当前view上的日历
    [self.calendarView removeFromSuperview];
    //重新创建一个calendarView
    self.calendarView = [[MyCalendarItem alloc] init];
    CGRect ScreenSize = [[UIScreen mainScreen] bounds];
    self.calendarView.frame = CGRectMake(10.0/320.0*ScreenSize.size.width, 100.0/568.0*ScreenSize.size.height, 300.0/320.0*ScreenSize.size.width, 340.0/568.0*ScreenSize.size.height);
    [self.view addSubview:self.calendarView];
     //设置日历时间为 上下月增量的整月倍
    self.calendarView.date = [NSDate dateWithTimeIntervalSinceNow:2592000 * (self.NextCount - self.LastCount + 1)];
    NSString *dateStr = [NSString stringWithFormat:@"%@",self.calendarView.date];
    NSArray *dateArr = [dateStr componentsSeparatedByString:@"-"];
    self.HeadLabel.text = [NSString stringWithFormat:@"%@年%@月",dateArr[0],dateArr[1]];
    //下一月增量加一
    self.NextCount ++;
}

//跳转导航页面
- (IBAction)MenuButtonAction:(id)sender {
    //为跳转加CATransition 类的向左的Push动画
    NSString *subtypeString = kCATransitionFromLeft;
    [self transitionWithType:kCATransitionPush WithSubtype:subtypeString ForView:self.view.window];
}

//CATransition动画实现
- (void) transitionWithType:(NSString *) type WithSubtype:(NSString *) subtype ForView : (UIView *) view {
    //创建CATransition对象
    CATransition *animation = [CATransition animation];
    //设置运动时间
    animation.duration = 0.3;
    //设置运动type
    animation.type = type;
    if (subtype != nil) {
        //设置子类
        animation.subtype = subtype;
    }
    //设置运动速度
    animation.timingFunction = UIViewAnimationOptionCurveEaseInOut;
    [view.layer addAnimation:animation forKey:@"animation"];
}

//打开时间选择器
- (IBAction)SearchDateButtonAction:(id)sender {
    //移除当前页面上的日历
    [self.calendarView removeFromSuperview];
    //显示日期选择器
    self.DatePickerView.hidden = NO;
    //为日期选择器注册一个事件，当它的值改变时触发
    [self.DatePicker addTarget:self action:@selector(DatePickerChanged) forControlEvents:UIControlEventValueChanged];
}

//当日期选择器值改变时触发该事件
- (void)DatePickerChanged {
    //修改日期选择器所在View中的日期框
    NSDateFormatter *dateformat = [[NSDateFormatter alloc]init];
    [dateformat setDateFormat:@"yyyy年MM月"];
    NSString *dateStr = [dateformat stringFromDate:self.DatePicker.date];
    self.DateLabel.text = dateStr;
}

//回到今天按钮事件
- (IBAction)BackNowButtonAction:(id)sender {
    //隐藏日期选择器
    self.DatePickerView.hidden = YES;
    //以当前时间为基准创建日历
    self.calendarView = [[MyCalendarItem alloc] init];
    CGRect ScreenSize = [[UIScreen mainScreen] bounds];
    self.calendarView.frame = CGRectMake(10.0/320.0*ScreenSize.size.width, 100.0/568.0*ScreenSize.size.height, 300.0/320.0*ScreenSize.size.width, 340.0/568.0*ScreenSize.size.height);
    self.calendarView.date = [NSDate date];
    [self.view addSubview:self.calendarView];
}

//确定选择时间按钮事件
- (IBAction)OKButtonAction:(id)sender {
    //隐藏日期选择器
    self.DatePickerView.hidden = YES;
    //以日期选择器选择的事件创建日历
    self.calendarView = [[MyCalendarItem alloc] init];
    CGRect ScreenSize = [[UIScreen mainScreen] bounds];
    self.calendarView.frame = CGRectMake(10.0/320.0*ScreenSize.size.width, 100.0/568.0*ScreenSize.size.height, 300.0/320.0*ScreenSize.size.width, 340.0/568.0*ScreenSize.size.height);
    self.calendarView.date = self.DatePicker.date;
    NSDateFormatter *dateformat = [[NSDateFormatter alloc]init];
    [dateformat setDateFormat:@"yyyy年MM月"];
    NSString *dateStr = [dateformat stringFromDate:self.DatePicker.date];
    //设置上方日期框
    self.HeadLabel.text = dateStr;
    [self.view addSubview:self.calendarView];
}

//跳转新增安排页面
- (IBAction)AddButtonAction:(id)sender {
}

//跳转事件
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    //跳转时将选择的日期传值到新增安排页面
    if ([segue.identifier isEqual:@"GoCreate"]) {
        CreateViewController *GoCreate = [[CreateViewController alloc]initWithNibName:@"CreateViewController" bundle:nil];
        GoCreate = segue.destinationViewController;
        GoCreate.DateStr = [[NSString alloc]init];
        GoCreate.DateStr = self.DateStr;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
