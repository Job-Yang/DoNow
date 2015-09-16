//
//  AppDelegate.h
//  Log_In
//
//  Created by 杨权 on 15/8/3.
//  Copyright (c) 2015年 Job-Yang. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (retain ,nonatomic) UIImage *HeadImage;      //用于存储图像图片
@property (retain,nonatomic) UIImage *DefaultAvatar;   //用于存储搭档缺省头像图像，在比较是否是默认头像时可直接比较。


@end

