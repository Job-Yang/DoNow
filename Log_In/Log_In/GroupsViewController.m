//
//  GroupsViewController.m
//  Log_In
//
//  Created by 杨权 on 15/8/23.
//  Copyright (c) 2015年 Job-Yang. All rights reserved.
//

#import "GroupsViewController.h"

@interface GroupsViewController ()

@end

@implementation GroupsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //设置代理
    self.ListTableView.delegate = self;
    self.ListTableView.dataSource = self;
    self.TableButton.selected = YES;
    self.ListTableView.hidden = YES;
    //隐藏 TableView自带行线
    self.ListTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    //将头像设置为圆形
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
    //将安排分类
    [self classify];

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

//安排分类
- (void)classify {
    //初始化安排分类数组
    self.ImportantAndEmergencyEventArr = [[NSMutableArray alloc]init];
    self.ImportantAndNormalEventArr = [[NSMutableArray alloc]init];
    self.UnimportantAndEmergencyEventArr = [[NSMutableArray alloc]init];
    self.UnimportantAndNormalEventArr = [[NSMutableArray alloc]init];
    //查询该账号的安排信息表
    NSString *TableStr = [NSString stringWithFormat:@"PLAN_INFO_%@",self.User];
    NSString *Select2 = [NSString stringWithFormat:@"SELECT * FROM '%@';",TableStr];
    //通过账号取出相对应的数据
    FMResultSet *resultSet2 = [self.db executeQuery:Select2];
    int eventID = 0;
    NSString *timeStr = [[NSString alloc]init];
    NSString *isImport = [[NSString alloc]init];
    while ([resultSet2 next]) {
        //提取时间与是否重要作为分类的标准
        eventID = [resultSet2 intForColumn:@"EVENTID"];
        timeStr = [resultSet2 stringForColumn:@"TIME"];
        isImport = [resultSet2 stringForColumn:@"IMPORT"];
        //获取系统当前时间
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc]init];
        [dateFormat setDateFormat: @"yyyy年MM月dd日"];
        NSDate *date = [dateFormat dateFromString:timeStr];
        NSDate *now = [NSDate date];
        
        //分类标准：
        //1.重要紧急：重要安排，且在当前时间3天之内
        //2.重要非紧急：重要安排，且在当前时间3天之外
        //3.非重要紧急：非重要安排，且在当前时间1天之内
        //4.非重要非紧急：非重要安排，且在当前时间1天之外
        if ([isImport isEqualToString:@"YES"]) {
            if ([date timeIntervalSinceDate:now] < 259200 && [date timeIntervalSinceDate:now] > -86400) {
                //将安排与目标存入相应数组
                NSString *evnet = [resultSet2 stringForColumn:@"EVENT"];
                [self.ImportantAndEmergencyEventArr addObject:evnet];
                NSString *aim = [resultSet2 stringForColumn:@"AIM"];
                [self.ImportantAndEmergencyEventArr addObject:aim];

                
            }
            else{
                //将安排与目标存入相应数组
                NSString *evnet = [resultSet2 stringForColumn:@"EVENT"];
                [self.ImportantAndNormalEventArr addObject:evnet];
                NSString *aim = [resultSet2 stringForColumn:@"AIM"];
                [self.ImportantAndNormalEventArr addObject:aim];

            }
        }
        else{
            if ([date timeIntervalSinceDate:now] < 86400) {
                //将安排与目标存入相应数组
                NSString *evnet = [resultSet2 stringForColumn:@"EVENT"];
                [self.UnimportantAndEmergencyEventArr addObject:evnet];
                NSString *aim = [resultSet2 stringForColumn:@"AIM"];
                [self.UnimportantAndEmergencyEventArr addObject:aim];

            }
            else{
                //将安排与目标存入相应数组
                NSString *evnet = [resultSet2 stringForColumn:@"EVENT"];
                [self.UnimportantAndNormalEventArr addObject:evnet];
                NSString *aim = [resultSet2 stringForColumn:@"AIM"];
                [self.UnimportantAndNormalEventArr addObject:aim];
            }
        }
    }
    
   //由于每个安排由安排与目标组成，故数量为count值的一半
   self.ImportantAndEmergencyEventNumberLabel.text = [NSString stringWithFormat:@"%lu 件安排",self.ImportantAndEmergencyEventArr.count / 2];
   self.ImportantAndNormalEventNumberLabel.text = [NSString stringWithFormat:@"%lu 件安排",self.ImportantAndNormalEventArr.count / 2];
   self.UnimportantAndEmergencyEventNumberLabel.text = [NSString stringWithFormat:@"%lu 件安排",self.UnimportantAndEmergencyEventArr.count / 2];
   self.UnimportantAndNormalEventNumberLabel.text = [NSString stringWithFormat:@"%lu 件安排",self.UnimportantAndNormalEventArr.count / 2];
    
    //设置分类安排数组的键值，作为列表每个Section的标题
    self.EventDic = [[NSDictionary alloc]initWithObjectsAndKeys:
                     self.ImportantAndEmergencyEventArr,@"重要-紧急",
                     self.ImportantAndNormalEventArr,@"重要-非紧急",
                     self.UnimportantAndEmergencyEventArr,@"非重要-紧急",
                     self.UnimportantAndNormalEventArr,@"非重要-非紧急", nil];
    self.EventDicKey = [self.EventDic allKeys];
}

//TableView的总行数
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
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

//TableView的section数量
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSString *key = [self.EventDicKey objectAtIndex:section];
    return [[self.EventDic objectForKey:key] count] / 2;
}

//关联数据
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    //静态标记
    static NSString *cellID3 = @"cellID3";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID3];
    //与TableView的row与section关联
    NSString *key = [self.EventDicKey objectAtIndex:indexPath.section];
    NSArray *arr = [self.EventDic objectForKey:key];

    //关联cell中的控件
    UILabel *eventLabel = (UILabel *)[cell viewWithTag:400];
    UILabel *aimLabel = (UILabel *)[cell viewWithTag:401];
    UIImageView *classifyImageView = (UIImageView *)[cell viewWithTag:402];
    UIImageView *line = (UIImageView *)[cell viewWithTag:403];
    line.image = [UIImage imageNamed:@"line"];
    //每组数组的第一个为安排，第二个为目标
    eventLabel.text = arr[indexPath.row * 2];
    aimLabel.text = arr[indexPath.row * 2 + 1];
    //判断key设置分类图标
    if ([key isEqualToString:@"重要-紧急"]) {
        classifyImageView.image = [UIImage imageNamed:@"category5"];
    }
    else if ([key isEqualToString:@"重要-非紧急"]){
        classifyImageView.image = [UIImage imageNamed:@"category4"];
    }
    else if ([key isEqualToString:@"非重要-紧急"]){
        classifyImageView.image = [UIImage imageNamed:@"category3"];
    }
    else{
        classifyImageView.image = [UIImage imageNamed:@"category1"];
    }
    //每行添加一个自定义的行线
    line.image = [UIImage imageNamed:@"line"];
    return cell;
}

//设置section标题
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    NSString *key = [self.EventDicKey objectAtIndex:section];
    if ([[self.EventDic objectForKey:key] count] != 0) {
       return [self.EventDicKey objectAtIndex:section];
    }
    else{
       return @"";
    }
}

//设置section高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    NSString *key = [self.EventDicKey objectAtIndex:section];
    if ([[self.EventDic objectForKey:key] count] != 0) {
        return 40;
    }
    else{
        return 0;
    }
    
}

//表格视图按钮事件
- (IBAction)TableButtonAction:(id)sender {
    self.FormView.hidden = NO;
    self.ListTableView.hidden = YES;
    self.TableButton.selected = YES;
    self.ListButton.selected = NO;
}

//列表视图按钮事件
- (IBAction)ListButtonAction:(id)sender {
    self.FormView.hidden = YES;
    self.ListTableView.hidden = NO;
    self.TableButton.selected = NO;
    self.ListButton.selected = YES;
}

//跳转导航页面事件
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
    // Dispose of any resources that can be recreated.
}

@end
