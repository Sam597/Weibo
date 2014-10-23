//
//  HomeViewController.h
//  WangyiWeibo
//
//  Created by 阿满 on 14-9-30.
//  Copyright (c) 2014年 man_sam. All rights reserved.
//

#import "BaseViewCotroller.h"
#import "WeiboCommonAPI.h"

@class AppDelegate;
@class AccreditWebView;
@class WeiboCell;
@protocol HomeContrllerDelegate <NSObject>
//设置home自己的代理
@optional
-(void)oauthFinsh;
@end
@interface HomeViewController : BaseViewCotroller<WeiboCommonAPIDelegate,UITableViewDataSource,UITableViewDelegate>
{
    
    
    BOOL isVerifing;//是否正在进行验证码确认，避免重复确认
    WeiboCell *_weiboCell;
    
}
//登录按钮
@property(nonatomic,retain) UIBarButtonItem *rightBar;
//获取accessToken所用webView

@property (nonatomic, retain) WeiboCommonAPI *weiboApi;
@property (nonatomic,retain)AppDelegate *appDelegate;
/*
 存放授权时得到的OauthToken和OauthTokenSecret
 */
@property (nonatomic, retain) NSString *stringOauthToken;
@property (nonatomic, retain) NSString *stringOauthTokenSecret;
@property (nonatomic, retain) AccreditWebView *aWebView;
/*
 发送请求时的oauthKey，包括本地的key和accesstoken
 */
@property (nonatomic, retain) MicroBlogOauthKey *oauthKey;
/*
 Delegate
 */
@property (nonatomic, assign) id<HomeContrllerDelegate> delegate;
/*
 微博数据
 */
@property (nonatomic,retain) NSMutableArray  *weiboModels;
@property (nonatomic,retain) UITableView *weiboTableView;


@end
