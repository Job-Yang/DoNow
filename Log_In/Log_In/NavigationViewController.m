//
//  NavigationViewController.m
//  Log_In
//
//  Created by 杨权 on 15/8/12.
//  Copyright (c) 2015年 Job-Yang. All rights reserved.
//

#import "NavigationViewController.h"

@interface NavigationViewController ()

@end

@implementation NavigationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //代理
    self.TableView.dataSource = self;
    self.TableView.delegate = self;
    
    //将头像ImageView设置为圆形
    self.HeadImageView.layer.cornerRadius = self.HeadImageView.frame.size.width / 2;
    self.HeadImageView.clipsToBounds = YES;
    //初始化头像
    AppDelegate *del = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    self.HeadImageView.image = del.HeadImage;
    
    //设置 TableView背景图
    self.TableView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg"]];
    //隐藏 TableView自带行线
    self.TableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    //初始化数组
    self.NavNameArr = [[NSMutableArray alloc]initWithObjects:@"主页", @"日历", @"总览", @"分组", @"列表", @"时间轴", @"设置", nil];
    self.NavIconArr = [[NSMutableArray alloc]initWithObjects:@"home", @"calendar", @"overview", @"groups", @"lists", @"timeline", @"settings", nil];
    //判断设备是否是 4S
    CGRect ScreenSize = [[UIScreen mainScreen] bounds];
    if (ScreenSize.size.width * ScreenSize.size.height == 320 * 480) {
        self.HeadImageView.hidden = YES;
    }
    
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.NavNameArr.count;
}

//设置 tableView行高
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return self.TableView.frame.size.height / 7;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    //静态标记
    static NSString *cellID = @"cellID";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    //设置 cell背景图
    cell.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg"]];

    //关联cell中的控件
    UIImageView *NavIcon = (UIImageView *)[cell viewWithTag:100];
    UILabel *NavName = (UILabel *)[cell viewWithTag:101];
    UIImageView *line = (UIImageView *)[cell viewWithTag:102];

    //设置控件中的值
    NavIcon.image = [UIImage imageNamed:self.NavIconArr[indexPath.row]];
    NavName.text = self.NavNameArr[indexPath.row];
    line.image = [UIImage imageNamed:@"line-1"];

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        [self performSegueWithIdentifier:@"GoOne" sender:self];
    }
    else if (indexPath.row == 1) {
        [self performSegueWithIdentifier:@"GoTwo" sender:self];
    }
    else if (indexPath.row == 2) {
        [self performSegueWithIdentifier:@"GoThree" sender:self];
    }
    else if (indexPath.row == 3) {
        [self performSegueWithIdentifier:@"GoFour" sender:self];
    }
    else if (indexPath.row == 4) {
        [self performSegueWithIdentifier:@"GoFive" sender:self];
    }
    else if (indexPath.row == 5) {
        [self performSegueWithIdentifier:@"GoSix" sender:self];
    }
    else if (indexPath.row == 6) {
        [self performSegueWithIdentifier:@"GoSeven" sender:self];
    }
}


//回到主界面
- (IBAction)ExitButtonAction:(id)sender {
}

//返回上级界面
- (IBAction)BackButtonAction:(id)sender {
    //加 CATransition的向右Push动画
    NSString *subtypeString = kCATransitionFromRight;
    [self transitionWithType:kCATransitionPush WithSubtype:subtypeString ForView:self.view.window];
    [self dismissViewControllerAnimated:NO completion:nil];
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
