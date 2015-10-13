//
//  OverviewViewController.m
//  Log_In
//
//  Created by 杨权 on 15/8/19.
//  Copyright (c) 2015年 Job-Yang. All rights reserved.
//

#import "OverviewViewController.h"

@interface OverviewViewController ()

@end

@implementation OverviewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //设置头像为圆形
    self.HeadImageView.layer.cornerRadius = self.HeadImageView.frame.size.width / 2;
    self.HeadImageView.clipsToBounds = YES;
    //初始化头像
    AppDelegate *del = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    if (del.HeadImage != nil) {
        self.HeadImageView.image = del.HeadImage;
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
    
    //设置姓名
    NSString *Select = [NSString stringWithFormat:@"SELECT * FROM DETAIL_INFO WHERE USER = '%@';",self.User];
    FMResultSet *resultSet = [self.db executeQuery:Select];
     while ([resultSet next]){
         NSString *name = [resultSet stringForColumn:@"RELNAME"];
         self.NameLabel.text = name;
     }
    
    //获取该账号安排总数
    NSString *Select1 = [NSString stringWithFormat:@"SELECT * FROM SELECTED_STATE_%@;",self.User];
    FMResultSet *resultSet1 = [self.db executeQuery:Select1];
    //安排总数
    float EventCount = 0;
    //完成数
    float CompletedEventCount = 0;
    while ([resultSet1 next]){
        NSString *Completed = [resultSet1 stringForColumn:@"SELECTED"];
        if ([Completed isEqualToString:@"YES"]) {
            CompletedEventCount ++;
        }
            EventCount ++;
    }
    
    //设置相关信息
    self.EventCountLabel.text = [NSString stringWithFormat:@"%.0f",EventCount];
    self.CompletedCountLabel.text = [NSString stringWithFormat:@"%.0f",CompletedEventCount];
    self.UnCompletedCountLabel.text = [NSString stringWithFormat:@"%.0f",EventCount - CompletedEventCount];
    self.PercentageCompleteLabel.text = [NSString stringWithFormat:@"%.0f",(CompletedEventCount / EventCount) * 100];
    
    //加载百分比圆环
    CGRect ScreenSize = [[UIScreen mainScreen] bounds];
    KDGoalBar *firstGoalBar = [[KDGoalBar alloc]initWithFrame:CGRectMake(71.5/320.0*ScreenSize.size.width, 360.0/568.0*ScreenSize.size.height, 177.0/320.0*ScreenSize.size.width, 177.0/320.0*ScreenSize.size.width)];
    [firstGoalBar setPercent:(CompletedEventCount / EventCount) * 100 animated:YES];
    [self.view addSubview:firstGoalBar];
    
    //关闭数据库
    if ([self.db close]) {
        NSLog(@"总览页面数据库已关闭");
    }
    else{
        NSLog(@"总览页面数据库关闭失败");
    }
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
        //判断选择状态表是否存在
        if (self.User != NULL) {
            //创建选择状态表
            NSString *TableStr = [NSString stringWithFormat:@"SELECTED_STATE_%@",self.User];
            if (![self.db tableExists :TableStr]) {
                NSString *Create = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS '%@' (EVENTID INTEGER PRIMARY KEY AUTOINCREMENT, SELECTED TEXT);",TableStr];
                if ([self.db executeUpdate:Create]) {
                    NSLog(@"创建‘SELECTED_STATE_%@’表成功！",self.User);
                }
                else{
                    NSLog(@"创建‘SELECTED_STATE_%@’表失败！",self.User);
                }
            }
            //判断详细信息表是否存在
                if (![self.db tableExists :@"DETAIL_INFO"]) {
                    //创建详细信息表
                    if ([self.db executeUpdate:@"CREATE TABLE IF NOT EXISTS DETAIL_INFO (USER TEXT PRIMARY KEY, RELNAME TEXT, WORK TEXT, CITY TEXT, PERSHOW TEXT);"]) {
                        NSLog(@"创建‘DETAIL_INFO’表成功！");
                    }
                    else{
                        NSLog(@"创建‘DETAIL_INFO’表失败！");
                    }
                }
            }
        }
    else{
        NSLog(@"打开数据库失败！");
    }
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

//跳转设置页面
- (IBAction)SettingButtonAction:(id)sender {
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
