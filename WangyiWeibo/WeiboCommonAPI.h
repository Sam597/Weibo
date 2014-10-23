//
//  WeiboCommonAPI.h
//  WangyiWeibo
//
//  Created by 阿满 on 14-10-10.
//  Copyright (c) 2014年 man_sam. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MicroBlogOauth.h"
#import "MicroBlogOauthKey.h"
#import "MicroBlogRequest.h"
#import "WeiboCommon.h"


@class WeiboCommonAPI;
@class WeiboModel;
@protocol WeiboCommonAPIDelegate <NSObject>
@optional
- (void)getOauthTokenSuccess:(WeiboCommonAPI*)api andOauthToken:(NSString *)oauthToken andOauthTokenSecret:(NSString *)oauthTokenSecret;
- (void)getOauthTokenFailed:(WeiboCommonAPI*)api;
- (void)getAccessTokenFailed:(WeiboCommonAPI*)api;
- (void)getaccesstokenSuccess:(WeiboCommonAPI*)api;
- (void)getUserInfoSuccess:(WeiboCommonAPI*)api andUserName:(NSString *)userName;
- (void)getUserInfoFailed:(WeiboCommonAPI*)api;
- (void)publishMessageSuccess:(WeiboCommonAPI*)api;
- (void)publishMessageFailed:(WeiboCommonAPI*)api;
- (void)getHomeWeiboDataSuccess:(WeiboCommonAPI*)api andWeiboModel:(NSMutableArray *)weiboListModel;
- (void)getHomeWeiboDataFailed:(WeiboCommonAPI*)api;
- (void)getHomeRereshWeiboDataSuccess:(WeiboCommonAPI*)api andWeiboModel:(NSMutableArray *)weiboListModel;
- (void)getHomeRereshWeiboDataFailed:(WeiboCommonAPI*)api;
@end

//处理API公用的方法
@interface WeiboCommonAPI : NSObject{
    /*
     当前请求的标志
     */
    NSInteger currentRequestId;
    NSInteger currentWeiboId;
    NSString *rereshType;
    
}

/*
 发送请求时的oauthKey，包括本地的key和accesstoken
 */
@property (nonatomic, retain) MicroBlogOauthKey *oauthKey;
/*
 与服务器连接的connection
 */
@property (nonatomic, retain) NSURLConnection *connectionWeibo;
@property (nonatomic, retain) ASIHTTPRequest *AsiConnectionWeibo;
/*
 数据的缓存
 */
@property (nonatomic, retain) NSMutableData *dataReceive;

/*
 当前正在请求的微博的ID
 */
@property (nonatomic, assign) NSInteger currentWeiboId;
/*
 Delegate
 */
@property (nonatomic, assign) id<WeiboCommonAPIDelegate> delegate;
/*
 发送的内容
 */
@property (nonatomic, retain) NSString *stringSendingContent;
@property (nonatomic, retain) NSString *stringFilePath;
//在发送网易微博时使用
@property (nonatomic, retain) NSString *stringImageUrl;
/*
 是否发送多个？
 */
@property (nonatomic, assign) BOOL numerousPublish;
/*
 用户的个人数据
 */
@property (nonatomic, assign) NSInteger userData;
/*  
    微博数据Model
 */
@property(nonatomic,retain)WeiboModel *weiboModel;
@property(nonatomic ,retain) NSMutableArray *weiboListData;
@property(nonatomic,retain) NSMutableArray *weiboRereshListData;
/*
 根据weiboId初始化它的key信息，包括本地的key和accesstoken
 */
- (void)initAccessToken;

/*
 获取oauth_token
 */
- (void)getOauthToken;
/*
 由OauthToken、OauthTokenSecret、Verify换取AccessToken和AccessTokenSecret
 */
- (void)getAccessTokenWithOauthToken:(NSString *)oauthToken andOauthTokenSecret:(NSString*)oauthTokenSecret andVerifier:(NSString*)verifier;
/*
 获取用户信息
 */
- (void)getUserInfo;
/*
 发送微博
 */
//- (void)publishMessageWithContent:(NSString *)content;
/*
 发送带图片的微博
 */
//- (void)publishMessageWithContent:(NSString *)content andImagePath:(NSString *)filePath;

/*
 向已绑定并打开的微博里发送微博
 */
//- (BOOL)publishMessageWithContent:(NSString*)content andImagePath:(NSString *)imagePath;


-(void)getHomeWeiboData;                                    //获取微博home页面的微博数据
-(void)getHomeRereshWeiboDataWithCursorId:(NSString *)cursor_id andType:(NSString *)type;     //首页微博列表刷新获取微博数据


@end
