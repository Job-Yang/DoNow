//
//  HomeViewController.m
//  Log_In
//
//  Created by 杨权 on 15/8/7.
//  Copyright (c) 2015年 Job-Yang. All rights reserved.
//

#import "HomeViewController.h"

@interface HomeViewController ()

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //设置 TableView代理
    self.PlanTableView.dataSource = self;
    self.PlanTableView.delegate = self;
    //隐藏 TableView自带行线
    self.PlanTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    //将头像按钮设置为圆形
    self.HeadButton.layer.cornerRadius = self.HeadButton.frame.size.width / 2;
    self.HeadButton.clipsToBounds = YES;
    //设置头像
    AppDelegate *del = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    if (del.HeadImage != nil) {
            [self.HeadButton setBackgroundImage:del.HeadImage forState:UIControlStateNormal];
    }
    //设置 TableView背景图
    self.PlanTableView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"HomeBg"]];
    //获得当前时间，并修改时间格式
    NSDate* now = [NSDate date];
    NSDateFormatter* fmt = [[NSDateFormatter alloc] init];
    fmt.dateFormat = @"yyyy年MM月dd日";
    NSString* dateString = [fmt stringFromDate:now];
    //设置日期框信息
    self.TimeLabel.text = dateString;
    //调用实例方法WeekFormTime，设置星期信息
    self.WeekLabel.text = [self WeekFormTime:self.TimeLabel.text];

    //初始化沙盒数据库路径
    self.path = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/FMDB.sqlite"];
    //创建FMDatabase对象,参数为沙盒路径
    //沙盒路径文件路径无需真实存在，如果不存在会自动创建。
    self.db = [FMDatabase databaseWithPath:self.path];
    //允许数据库缓存提升查询效率
    [self.db setShouldCacheStatements:YES];
    //打开所需数据库
    [self DBInitialization];
    
}

//初始化数据库
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
        //判断该用户安排表是否存在
        NSString *TableStr = [NSString stringWithFormat:@"PLAN_INFO_%@",self.User];
        if (self.User != NULL) {
            if (![self.db tableExists :TableStr]) {
                //创建该用户安排表
                NSString *Create1 = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS '%@' ( EVENTID INTEGER PRIMARY KEY AUTOINCREMENT, EVENT TEXT, AIM TEXT, TIME TEXT, DATE TEXT, IMPORT TEXT, HEAD1 TEXT, HEAD2 TEXT, HEAD3 TEXT, HEAD4 TEXT, HEAD5 TEXT);",TableStr];
                if ([self.db executeUpdate:Create1]) {
                    NSLog(@"创建‘PLAN_INFO_%@’表成功！",self.User);
                }
                else{
                    NSLog(@"创建‘PLAN_INFO_%@’表失败！",self.User);
                    
                }
            }
        }
        else{
            NSLog(@"打开数据库失败！");
        }
    }
}


//设置 tableView行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    //确定该账号下的安排数
    NSString *TableStr = [NSString stringWithFormat:@"PLAN_INFO_%@",self.User];
    NSString *Select1 = [NSString stringWithFormat:@"SELECT * FROM '%@';",TableStr];
    FMResultSet *resultSet1 = [self.db executeQuery:Select1];
    int EventCount = 0;
    while ([resultSet1 next]){
        EventCount++;
    }
    return EventCount;
}

//设置 tableView行高
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100;
}

//将日期转化为星期
- (NSString *)WeekFormTime:(NSString *)TimeStr{
    //将传进来的日期格式化
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc]init];
    [dateFormat setDateFormat:@"yyyy年MM月dd日"];
    NSDate *date=[dateFormat dateFromString:TimeStr];
    //初始化一个星期数组
    NSArray *weekdays = [NSArray arrayWithObjects: [NSNull null], @"星期日", @"星期一", @"星期二", @"星期三", @"星期四", @"星期五", @"星期六", nil];
    //初始化一个日历类对象
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    //设置时区为苏州
    NSTimeZone *timeZone = [[NSTimeZone alloc] initWithName:@"Asia/Suzhou"];
    [calendar setTimeZone: timeZone];
    NSCalendarUnit calendarUnit = NSCalendarUnitWeekday;
    NSDateComponents *theComponents = [calendar components:calendarUnit fromDate:date];
    return [weekdays objectAtIndex:theComponents.weekday];
    
}

//当页面即将要出现时，刷新数据
- (void)viewWillAppear:(BOOL)animated{
    [self.PlanTableView reloadData];
}

//关联 TableView的cell值
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    //设置静态字符串标记cell
    static NSString *cellID = @"cellID";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    
    //关联cell中的控件
    UILabel *eventLabel = (UILabel *)[cell viewWithTag:101];
    UILabel *aimLabel = (UILabel *)[cell viewWithTag:102];
    UILabel *dateLabel = (UILabel *)[cell viewWithTag:103];
    UIImageView *headImage1 = (UIImageView *)[cell viewWithTag:104];
    UIImageView *headImage2 = (UIImageView *)[cell viewWithTag:105];
    UIImageView *headImage3 = (UIImageView *)[cell viewWithTag:106];
    UIImageView *headImage4 = (UIImageView *)[cell viewWithTag:107];
    UIImageView *headImage5 = (UIImageView *)[cell viewWithTag:108];
    
    //将5个头像 UIImageView设置为圆形
    headImage1.layer.cornerRadius = headImage1.frame.size.width / 2;
    headImage1.clipsToBounds = YES;
    headImage2.layer.cornerRadius = headImage2.frame.size.width / 2;
    headImage2.clipsToBounds = YES;
    headImage3.layer.cornerRadius = headImage3.frame.size.width / 2;
    headImage3.clipsToBounds = YES;
    headImage4.layer.cornerRadius = headImage4.frame.size.width / 2;
    headImage4.clipsToBounds = YES;
    headImage5.layer.cornerRadius = headImage5.frame.size.width / 2;
    headImage5.clipsToBounds = YES;
    
    //自定义行线
    UIImageView *line = (UIImageView *)[cell viewWithTag:109];
    line.image = [UIImage imageNamed:@"TableViewLine"];
    
    //设置cell的背景图，使用与TableView一样的图，以达到透明的目的
    if ((indexPath.row + 1) % 4 == 1) {
       cell.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"HomeCell1"]];
    }
    else if ((indexPath.row + 1) % 4 == 2) {
       cell.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"HomeCell2"]];
    }
    else if ((indexPath.row + 1) % 4 == 3) {
       cell.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"HomeCell3"]];
    }
    else if ((indexPath.row + 1) % 4 == 0) {
       cell.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"HomeCell4"]];
    }

    
    //取出该账号安排表
    NSString *TableStr = [NSString stringWithFormat:@"PLAN_INFO_%@",self.User];
    NSString *Select2 = [NSString stringWithFormat:@"SELECT * FROM '%@';",TableStr];
    FMResultSet *resultSet1 = [self.db executeQuery:Select2];
    //遍历该账号安排表
    while ([resultSet1 next]) {
        //将表中自增字段 EVENTID与 TableView的行关联
        int EvnetId = [resultSet1 intForColumn:@"EVENTID"];
        if (EvnetId == indexPath.row + 1) {
            //取出该行相关数据
            eventLabel.text = [resultSet1 stringForColumn:@"EVENT"];
            aimLabel.text = [resultSet1 stringForColumn:@"AIM"];
            dateLabel.text = [resultSet1 stringForColumn:@"DATE"];
            //取出头像名，从沙盒中取出头像图片
            NSString *Head1Path = [NSHomeDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"Documents/%@",[resultSet1 stringForColumn:@"HEAD1"]]];
            NSString *Head2Path = [NSHomeDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"Documents/%@",[resultSet1 stringForColumn:@"HEAD2"]]];
            NSString *Head3Path = [NSHomeDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"Documents/%@",[resultSet1 stringForColumn:@"HEAD3"]]];
            NSString *Head4Path = [NSHomeDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"Documents/%@",[resultSet1 stringForColumn:@"HEAD4"]]];
            NSString *Head5Path = [NSHomeDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"Documents/%@",[resultSet1 stringForColumn:@"HEAD5"]]];
            headImage1.image = [UIImage imageWithContentsOfFile:Head1Path];
            headImage2.image = [UIImage imageWithContentsOfFile:Head2Path];
            headImage3.image = [UIImage imageWithContentsOfFile:Head3Path];
            headImage4.image = [UIImage imageWithContentsOfFile:Head4Path];
            headImage5.image = [UIImage imageWithContentsOfFile:Head5Path];
            //设置完停止遍历
            break;
        }
    }
    
    return cell;
}

//tableView为可编辑状态
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}

//删除cell
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    //如果编辑类型为删除
    if (editingStyle == UITableViewCellEditingStyleDelete) {
    //在数据库删除所选行的信息
    NSString *TableStr = [NSString stringWithFormat:@"PLAN_INFO_%@",self.User];
    NSString *deleteSql = [NSString stringWithFormat:@"DELETE FROM '%@' WHERE EVENTID = %lu",TableStr, indexPath.row + 1];
    [self.db executeUpdate:deleteSql];
    //在 tableView中删除所选行
    [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath, nil] withRowAnimation:UITableViewRowAnimationTop];
    //统计该用户的安排总数
    NSString *Select1 = [NSString stringWithFormat:@"SELECT * FROM '%@';",TableStr];
    FMResultSet *resultSet1 = [self.db executeQuery:Select1];
    NSInteger EventCount = 0;
       while ([resultSet1 next]){
         EventCount++;
     }
        
    //以下操作是为了在删除一列后，自增列EVENTID仍然连续
    //indexPath.row + 1 对应数据库中EVENTID
    //indexPath.row + 2 对象所选行(删除行)的下一行数据
    //EventCount + 1  为删除前的安排总数，同时是EVENTID的最大值
    // i 对应每一行的EVENTID值
    NSInteger i;
    for (i = indexPath.row + 2; i <= EventCount + 1; i++) {
        //取出所选行(删除行)下一行的数据
        NSString *Select2 = [NSString stringWithFormat:@"SELECT * FROM '%@' WHERE EVENTID = %lu;",TableStr,i];
        FMResultSet *resultSet2 = [self.db executeQuery:Select2];
        //将所选行(删除行)下一行的数据放入一个数组中，以便将它进行移位
        NSArray *arr = [[NSArray alloc]init];
        while ([resultSet2 next]) {
        arr = [NSArray arrayWithObjects:[resultSet2 stringForColumn:@"EVENT"],
                                        [resultSet2 stringForColumn:@"AIM"],
                                        [resultSet2 stringForColumn:@"TIME"],
                                        [resultSet2 stringForColumn:@"DATE"],
                                        [resultSet2 stringForColumn:@"IMPORT"],
                                        [resultSet2 stringForColumn:@"HEAD1"],
                                        [resultSet2 stringForColumn:@"HEAD2"],
                                        [resultSet2 stringForColumn:@"HEAD3"],
                                        [resultSet2 stringForColumn:@"HEAD4"],
                                        [resultSet2 stringForColumn:@"HEAD5"],nil];
        }
        //删除数据库中所选行(删除行)下一行的数据
        NSString *deleteSql2 = [NSString stringWithFormat:@"DELETE FROM '%@' WHERE EVENTID = %lu",TableStr, i];
        [self.db executeUpdate:deleteSql2];
        //将该用户安排信息自增列EVENTID的起点设置为删除列减一，保证下次自增连续
        NSString *update = [NSString stringWithFormat:@"UPDATE sqlite_sequence SET seq = %lu where name = '%@';", i - 2, TableStr];
        [self.db executeUpdate:update];
        //将数组中的信息插入到删除列所在位置
        NSString *InsertStr2 = [NSString stringWithFormat:@"INSERT INTO '%@' (EVENT, AIM, TIME, DATE, IMPORT, HEAD1, HEAD2, HEAD3, HEAD4, HEAD5) VALUES ('%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@');",TableStr, arr[0], arr[1], arr[2], arr[3], arr[4], arr[5], arr[6], arr[7], arr[8], arr[9]];
        [self.db executeUpdate:InsertStr2];
      }
   }   
}

//设置可编辑时的动画
- (void)setEditing:(BOOL)editing animated:(BOOL)animated{
    [super setEditing:editing animated:animated];
    [self.PlanTableView setEditing:editing animated:animated];
}


//跳转NavigationViewController
- (IBAction)MenuAction:(id)sender {
    //启用 CATransition 类中的Push动画
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
