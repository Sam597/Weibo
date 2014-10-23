//
//  MainTabBarController.m
//  WangyiWeibo
//
//  Created by 阿满 on 14-9-30.
//  Copyright (c) 2014年 man_sam. All rights reserved.
//

#import "MainTabBarController.h"
#import "HomeViewController.h"
#import "HotViewController.h"
#import "ReleaseViewController.h"
#import "MessageViewController.h"
#import "AboutMeViewController.h"
#import "BaseNavgationController.h"


//获取设备的物理高度
#define ScreenHeight [UIScreen mainScreen].bounds.size.height
//获取设备的物理宽度
#define ScreenWidth [UIScreen mainScreen].bounds.size.width

@implementation MainTabBarController

-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self.tabBar setHidden:NO]; //隐藏或显示默认tabbar
    }
    return self;
}


-(void)viewDidLoad{
    [super viewDidLoad];
    [self _initViewController];
    [self _inittabBarView];
}

//初始化子控制器
-(void)_initViewController
{
    HomeViewController *homeVC = [[HomeViewController alloc] init];
    HotViewController *hotVC = [[HotViewController alloc] init];
    ReleaseViewController *releaseVC = [[ReleaseViewController alloc] init];
    MessageViewController *messageVC = [[MessageViewController alloc] init];
    AboutMeViewController *aboutMeVC = [[AboutMeViewController alloc] init];
    
    NSArray *views = @[homeVC,hotVC,releaseVC,messageVC,aboutMeVC];
    
    NSMutableArray *viewControllers = [NSMutableArray arrayWithCapacity:5];
    
    for (UIViewController *viewContrller in views) {
        BaseNavgationController *nav = [[BaseNavgationController alloc] initWithRootViewController:viewContrller];
        [viewControllers addObject:nav];
        //        [nav release];
    }
    
    self.viewControllers = viewControllers;
}

//初始化 工具栏 tarbar
-(void)_inittabBarView
{
    _tabBarView = [[UIView alloc] initWithFrame:CGRectMake(0, ScreenHeight-49, ScreenWidth, 49)];
      _tabBarView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_tabBarView];
    
    NSArray *backgroud = @[@"tarbar_home.png",@"tarbar_discore.png",@"tarbar_more.png",@"tarbar_message.png",@"tarbar_profile.png"];
    
    NSArray *highBackgroud = @[@"tarbar_home_high.png",@"tarbar_discover_high.png",@"tarbar_more_high.png",@"tarbar_message_high.png",@"tarbar_profile_high.png"];
    
    //循环设置tabbar 图片
    for (int i=0; i < backgroud.count; i++) {
        NSString *backImage = backgroud[i];
        NSString *highBackImage = highBackgroud[i];
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake((64-30)/2+(i*64), (49-30)/2, 30, 30);
        button.tag = i;
        
        [button setImage:[UIImage imageNamed:backImage] forState:UIControlStateNormal];
        
        [button setImage:[UIImage imageNamed:highBackImage] forState:UIControlStateHighlighted];
        [button addTarget:self action:@selector(selectedTab:) forControlEvents:UIControlEventTouchUpInside];
        [_tabBarView addSubview:button];
    }
    
}

-(void)selectedTab:(UIButton *)button
{
    self.selectedIndex = button.tag;
}


@end
