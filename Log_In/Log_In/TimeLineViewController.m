//
//  TimeLineViewController.m
//  Log_In
//
//  Created by 杨权 on 15/8/23.
//  Copyright (c) 2015年 Job-Yang. All rights reserved.
//

#import "TimeLineViewController.h"

@interface TimeLineViewController ()

@end

@implementation TimeLineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //设置代理
    self.TimeLineTableView.delegate = self;
    self.TimeLineTableView.dataSource = self;
    //隐藏 TableView自带行线
    self.TimeLineTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    //将头像设置为圆形
    self.HeadButton.layer.cornerRadius = self.HeadButton.frame.size.width / 2;
    self.HeadButton.clipsToBounds = YES;
    self.EventArray = [[NSMutableArray alloc]init];
    //初始化头像
    AppDelegate *del = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    if (del.HeadImage != nil) {
        [self.HeadButton setBackgroundImage:del.HeadImage forState:UIControlStateNormal];
    }

    //初始化沙盒数据库路径
    self.path = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/FMDB.sqlite"];
    //创建FMDatabase对象,参数为沙盒路径
    //沙盒路径文件路径无需真实存在，如果不存在会自动创建。
    self.db = [FMDatabase databaseWithPath:self.path];
    //允许数据库缓存提升查询效率
    [self.db setShouldCacheStatements:YES];
    //打开所需数据库
    [self DBInitialization];
    //设置时间信息
    [self SetLabel];
    //排序
    [self Sort];
    
}

//数据库初始化
- (void)DBInitialization {
    //打开数据库
    if ([self.db open]) {
        //确定登录的是哪个账号
        FMResultSet *resultSet = [self.db executeQuery:@"SELECT * FROM LOGIN_STATE"];
        //遍历登录状态数据
        while ([resultSet next]) {
            NSString *user = [resultSet stringForColumn:@"USER"];
            NSString *LOGIN = [resultSet stringForColumn:@"LOGIN"];
            //如果存在已登录
            if ([LOGIN isEqualToString:@"YES"]) {
                self.User = user;
                //停止遍历
                break;
            }
        }
    }
    else{
        NSLog(@"打开数据库失败！");
    }
}

//设置时间
- (void)SetLabel{
    //转换月份
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSString *DateString = [formatter stringFromDate:[NSDate date]];
    NSArray *dateArr = [DateString componentsSeparatedByString:@"-"];
    self.YearNumberLabel.text = [NSString stringWithFormat:@"%@ 年",dateArr[0]];
    int month = [dateArr[1] intValue];
    switch (month) {
        case 1:
            self.MonthLabel.text = @"一月";
            break;
        case 2:
            self.MonthLabel.text = @"二月";
            break;
        case 3:
            self.MonthLabel.text = @"三月";
            break;
        case 4:
            self.MonthLabel.text = @"四月";
            break;
        case 5:
            self.MonthLabel.text = @"五月";
            break;
        case 6:
            self.MonthLabel.text = @"六月";
            break;
        case 7:
            self.MonthLabel.text = @"七月";
            break;
        case 8:
            self.MonthLabel.text = @"八月";
            break;
        case 9:
            self.MonthLabel.text = @"九月";
            break;
        case 10:
            self.MonthLabel.text = @"十月";
            break;
        case 11:
            self.MonthLabel.text = @"十一月";
            break;
        case 12:
            self.MonthLabel.text = @"十二月";
            break;
        default:
            break;
    }
}

//排序
- (void)Sort{
    //查询安排信息
    NSString *TableStr = [NSString stringWithFormat:@"PLAN_INFO_%@",self.User];
    NSString *Select1 = [NSString stringWithFormat:@"SELECT * FROM '%@';",TableStr];
    FMResultSet *resultSet1 = [self.db executeQuery:Select1];
    while ([resultSet1 next]){
        //取出安排，目标，日期信息
        int evnetID = [resultSet1 intForColumn:@"EVENTID"];
        NSString *event = [resultSet1 stringForColumn:@"EVENT"];
        NSString *aim = [resultSet1 stringForColumn:@"AIM"];
        NSString *time = [resultSet1 stringForColumn:@"TIME"];
        //查找对应选择状态
        NSString *Select2 = [NSString stringWithFormat:@"SELECT * FROM SELECTED_STATE_%@ WHERE EVENTID = %d;",self.User,evnetID];
        FMResultSet *resultSet2 = [self.db executeQuery:Select2];
        NSString *selected = [[NSString alloc]init];
        while ([resultSet2 next]){
            selected = [resultSet2 stringForColumn:@"SELECTED"];
        }
        //将安排，目标，日期，选择状态 加入数组
        NSArray *arr  = [NSArray arrayWithObjects: event, aim, time, selected, nil];
        [self.EventArray addObject:arr];
    }
    
   //使用数组的自定义排序方法
   //排序标准：
   //1.把月和日连接成一个float的数据，月为整数位,日为小数位,判断该浮点数的大小排序
   self.sortedEventArray = [self.EventArray sortedArrayUsingComparator: ^(NSArray *obj1,  NSArray *obj2) {
        //obj1的浮点数
        NSArray *TimeArrayYear1 = [obj1[2] componentsSeparatedByString:@"年"];
        NSArray *TimeArrayMonth1 = [TimeArrayYear1[1] componentsSeparatedByString:@"月"];
        NSString *month1 = TimeArrayMonth1[0];
        NSArray *TimeArrayDay1 = [TimeArrayMonth1[1] componentsSeparatedByString:@"日"];
        NSString *day1 = TimeArrayDay1[0];
        NSString *Str1 = [NSString stringWithFormat:@"%@.%@",month1,day1];
        float floatStr1 = [Str1 floatValue];
        //obj2的浮点数
        NSArray *TimeArrayYear2 = [obj1[2] componentsSeparatedByString:@"年"];
        NSArray *TimeArrayMonth2 = [TimeArrayYear2[1] componentsSeparatedByString:@"月"];
        NSString *month2 = TimeArrayMonth2[0];
        NSArray *TimeArrayDay2 = [TimeArrayMonth2[1] componentsSeparatedByString:@"日"];
        NSString *day2 = TimeArrayDay2[0];
        NSString *Str2 = [NSString stringWithFormat:@"%@.%@",month2,day2];
       float floatStr2 = [Str2 floatValue];
       //比较大小
        if (floatStr1 < floatStr2) {
            return (NSComparisonResult)NSOrderedAscending;
        }
        if (floatStr1 > floatStr2) {
            return (NSComparisonResult)NSOrderedDescending;
        }
        return (NSComparisonResult)NSOrderedSame;
    }];
}

//刷新 TableView
- (void)viewWillAppear:(BOOL)animated{
    [self.TimeLineTableView reloadData];
}

//tableView行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.EventArray.count;
}

//设置 tableView行高
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}

//关联数据
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    //静态标记
    static NSString *cellID2 = @"cellID2";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID2];
    //与排序后数组关联
    NSArray *arr = self.sortedEventArray[indexPath.row];
    //关联cell中的控件
    UILabel *eventLabel = (UILabel *)[cell viewWithTag:300];
    UILabel *aimLabel = (UILabel *)[cell viewWithTag:301];
    UILabel *dateLabel = (UILabel *)[cell viewWithTag:302];
    UIImageView *TimeLine = (UIImageView *)[cell viewWithTag:303];
    //设置控件中的值
    eventLabel.text = arr[0];
    aimLabel.text = arr[1];
    //将日期字符串进行切割,得到年月日三个数字进行设置
    NSArray *TimeArrayYear = [arr[2] componentsSeparatedByString:@"年"];
    NSArray *TimeArrayMonth = [TimeArrayYear[1] componentsSeparatedByString:@"月"];
    NSString *month = TimeArrayMonth[0];
    NSArray *TimeArrayDay = [TimeArrayMonth[1] componentsSeparatedByString:@"日"];
    NSString *day = TimeArrayDay[0];
    dateLabel.text = [NSString stringWithFormat:@"%@.%@",month,day];
    if ([arr[3] isEqualToString:@"YES"]) {
        TimeLine.image = [UIImage imageNamed:@"completedLine"];
    }
    else{
        TimeLine.image = [UIImage imageNamed:@"overdueLine"];
    }
    return cell;
}

//跳转设置页面
- (IBAction)HeadButtonAction:(id)sender {
}

//跳转导航页面
- (IBAction)MenuButtonAction:(id)sender {
    NSString *subtypeString = kCATransitionFromLeft;
    [self transitionWithType:kCATransitionPush WithSubtype:subtypeString ForView:self.view.window];
}

// CATransition动画实现
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
