//
//  ListViewController.m
//  Log_In
//
//  Created by 杨权 on 15/8/17.
//  Copyright (c) 2015年 Job-Yang. All rights reserved.
//

#import "ListViewController.h"

@interface ListViewController ()

@end

@implementation ListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //设置代理
    self.EventTableView.delegate = self;
    self.EventTableView.dataSource = self;
    //隐藏 TableView自带行线
    self.EventTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.ClickCount = 0;
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
        //判断该账户安排表是否存在
        NSString *TableStr1 = [NSString stringWithFormat:@"PLAN_INFO_%@",self.User];
        if (self.User != NULL) {
            if (![self.db tableExists :TableStr1]) {
                //创建该账户安排表
                NSString *Create1 = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS '%@' (EVENTID INTEGER PRIMARY KEY AUTOINCREMENT, EVENT TEXT, AIM TEXT, TIME TEXT, DATE TEXT, IMPORT TEXT, HEAD1 TEXT, HEAD2 TEXT, HEAD3 TEXT, HEAD4 TEXT, HEAD5 TEXT, SORT TEXT);",TableStr1];
                if ([self.db executeUpdate:Create1]) {
                    NSLog(@"创建‘PLAN_INFO_%@’表成功！",self.User);
                }
                else{
                    NSLog(@"创建‘PLAN_INFO_%@’表失败！",self.User);
                }
            }
            //创建选择状态表
            NSString *TableStr2 = [NSString stringWithFormat:@"SELECTED_STATE_%@",self.User];
            if (![self.db tableExists :TableStr2]) {
            NSString *Create2 = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS '%@' (EVENTID INTEGER PRIMARY KEY AUTOINCREMENT, SELECTED TEXT);",TableStr2];
            if ([self.db executeUpdate:Create2]) {
                NSLog(@"创建‘SELECTED_STATE_%@’表成功！",self.User);
            }
            else{
                NSLog(@"创建‘SELECTED_STATE_%@’表失败！",self.User);
              }
            }
        }
      }
        else{
            NSLog(@"打开数据库失败！");
    }
}


//设置行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    //确定该账号下的安排数
    NSString *TableStr = [NSString stringWithFormat:@"PLAN_INFO_%@",self.User];
    NSString *Select1 = [NSString stringWithFormat:@"SELECT * FROM '%@';",TableStr];
    FMResultSet *resultSet1 = [self.db executeQuery:Select1];
    self.EventCount = 0;
    while ([resultSet1 next]){
        self.EventCount++;
    }
    return self.EventCount;
}

//设置 tableView行高
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 70;
}

//关联数据
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    //静态标记
    static NSString *cellID1 = @"cellID1";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID1];
    //关联cell中的控件
    UIButton *finishButton = (UIButton *)[cell viewWithTag:200];
    UILabel *eventLabel = (UILabel *)[cell viewWithTag:201];
    UILabel *dateLabel = (UILabel *)[cell viewWithTag:202];
    UIImageView *WarningImage = (UIImageView *)[cell viewWithTag:203];
    UIImageView *line = (UIImageView *)[cell viewWithTag:204];
    //每行添加一个自定义的行线
    line.image = [UIImage imageNamed:@"line"];
    
    //给cell中的finishButton注册一个事件
    [finishButton addTarget:self action:@selector(finishButton:) forControlEvents:UIControlEventTouchDown];
    //查找该行所对应的安排数据的选择状态
    NSString *select1 = [NSString stringWithFormat:@"SELECT * FROM SELECTED_STATE_%@ WHERE EVENTID = %lu",self.User, indexPath.row + 1];
    FMResultSet *resultSet1 = [self.db executeQuery:select1];
    //遍历该行选择状态数据
    while ([resultSet1 next]) {
        NSString *isSelection = [resultSet1 stringForColumn:@"SELECTED"];
        //设置初始化的选择状态
        //初始化时设置所有的状态 ClickCount < EventCount 视为初始化时
        if ([isSelection isEqualToString:@"YES"] && self.ClickCount < self.EventCount) {
            finishButton.selected = YES;
            self.ClickCount ++;
        }
    }
    
    //选择状态时 设置字体为灰色，半透明
    if (finishButton.selected == YES) {
        eventLabel.textColor = [UIColor grayColor];
        eventLabel.alpha = 0.5;
        dateLabel.textColor = [UIColor grayColor];
        dateLabel.alpha = 0.5;
        WarningImage.alpha = 0.4;

        //将选择状态与数据库同步
        NSString *update1 = [NSString stringWithFormat:@"UPDATE SELECTED_STATE_%@ SET SELECTED = '%@' WHERE EVENTID = %lu ;",self.User, @"YES", indexPath.row + 1];
        [self.db executeUpdate:update1];
    }
    else{
        //未选择状态时 设置字体为黑色，不透明
        eventLabel.textColor = [UIColor blackColor];
        eventLabel.alpha = 1;
        dateLabel.textColor = [UIColor blackColor];
        dateLabel.alpha = 1;
        WarningImage.alpha = 1;
        //获取选择状态表自增列的增值
        NSString *TableStr3 = [NSString stringWithFormat:@"SELECTED_STATE_%@",self.User];
        NSString *select3 = [NSString stringWithFormat:@"SELECT * FROM sqlite_sequence WHERE name = '%@';",TableStr3];
        FMResultSet *resultSet3 = [self.db executeQuery:select3];
        //如果该账号的登录状态不为空
        if ([resultSet3 next]) {
            int seq = [resultSet3 intForColumn:@"seq"];
            //此时选择状态表是与安排信息表同步的
            //修改对应数据库登录状态
            if (indexPath.row + 1 <= seq) {
                NSString *update2 = [NSString stringWithFormat:@"UPDATE SELECTED_STATE_%@ SET SELECTED = '%@' WHERE EVENTID = %lu ;",self.User, @"NO", indexPath.row + 1];
                [self.db executeUpdate:update2];
            }
            else{
                //此时选择状态表是与安排信息表不同步的，可能新增了安排还未来的及同步
                //同步登录状态表
                NSString *insert1 = [NSString stringWithFormat:@"INSERT INTO SELECTED_STATE_%@ (SELECTED) VALUES ('%@');",self.User, @"NO"];
                [self.db executeUpdate:insert1];
            }
        }
        else{
            //如果该账号的登录状态表为空，即刚创建表还未对对应安排添加选择状态信息
            //添加对应的登录状态信息
            for (int i = 0; i < self.EventCount; i++) {
                NSString *insert2 = [NSString stringWithFormat:@"INSERT INTO SELECTED_STATE_%@ (SELECTED) VALUES ('%@');",self.User, @"NO"];
                [self.db executeUpdate:insert2];
            }
        }
    }
    //查找该账号下的安排信息
    NSString *TableStr = [NSString stringWithFormat:@"PLAN_INFO_%@",self.User];
    NSString *Select2 = [NSString stringWithFormat:@"SELECT * FROM '%@';",TableStr];
    //通过账号取出相对应的数据
    FMResultSet *resultSet2 = [self.db executeQuery:Select2];
    //先取出安排，目标，日期等数据
    NSString *timeStr = [[NSString alloc]init];
    while ([resultSet2 next]) {
        int EvnetId = [resultSet2 intForColumn:@"EVENTID"];
        if (EvnetId == indexPath.row + 1) {
            //取出该行数据
            eventLabel.text = [resultSet2 stringForColumn:@"EVENT"];
            dateLabel.text = [resultSet2 stringForColumn:@"DATE"];
            timeStr = [resultSet2 stringForColumn:@"TIME"];
        }
    }
    //取得系统当前时间，并设置日期格式
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc]init];
    [dateFormat setDateFormat: @"yyyy年MM月dd日"];
    NSDate *date = [dateFormat dateFromString:timeStr];
    NSDate *now = [NSDate date];
    //在系统当前时间的一天之外，视为过期安排
    //这样做是为了防止在同一天的安排可能被视为过期安排
    if ([date timeIntervalSinceDate:now] < -86400) {
        WarningImage.hidden = NO;
    }
    else{
        WarningImage.hidden = YES;
    }

    return cell;
}
//选择状态按钮
- (void)finishButton:(UIButton *)btn {
    if (btn.selected == NO) {
        btn.selected = YES;
    }
    else{
        btn.selected = NO;
    }
    [self.EventTableView reloadData];
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
        NSLog(@"%lu",indexPath.row);
        [self.db executeUpdate:deleteSql];
        //在 tableView中删除所选行
        NSString *Select1 = [NSString stringWithFormat:@"SELECT * FROM '%@';",TableStr];
        FMResultSet *resultSet1 = [self.db executeQuery:Select1];
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath, nil] withRowAnimation:UITableViewRowAnimationTop];
        //统计该用户的安排总数
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

//跳转到导航页面
- (IBAction)BackButtonAction:(id)sender {
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

//跳转总览页面
- (IBAction)SearchButtonAction:(id)sender {
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
