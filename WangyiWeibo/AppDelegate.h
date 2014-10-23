//
//  AppDelegate.h
//  WangyiWeibo
//
//  Created by 阿满 on 14-9-24.
//  Copyright (c) 2014年 man_sam. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WeiboCommonAPI.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, retain) WeiboCommonAPI *weiboApi;

@end

