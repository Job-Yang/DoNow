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
    
    //将头像ImageView设置为圆形
    self.HeadImageView.layer.cornerRadius = self.HeadImageView.frame.size.width / 2;
    self.HeadImageView.clipsToBounds = YES;
    //初始化头像
    AppDelegate *del = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    self.HeadImageView.image = del.HeadImage;
    
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

//跳转对应页面
- (IBAction)GoViewButtonsAction:(id)sender {
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
