//
//  WeiboModel.h
//  DoubanMovie
//
//  Created by 阿满 on 14-7-24.
//  Copyright (c) 2014年 man_sam. All rights reserved.
//

#import "WXBaseModel.h"
#import "UserModel.h"
#import "RelWeiboModel.h"

@interface WeiboModel : WXBaseModel

//创建字典对象参数
@property (nonatomic,copy)NSString                          *created_at;    //微博创建时间
@property (nonatomic,retain)NSNumber                        *comments_count;//回复总数
@property (nonatomic,copy)NSString                          *geo;//地理位置
@property (nonatomic,retain)NSNumber                        *retweet_count;//转发总数
@property (nonatomic,copy)NSString                          *source;//来源
@property (nonatomic,copy)NSString                          *text;//微博内容
@property (nonatomic,retain)UserModel                       *user;//微博作者
//@property (nonatomic,retain)RelWeiboModel                   *relModel;//转发微博数据
@property(nonatomic,copy)NSString                           *thumbnailImage;//头像url
@property(nonatomic,copy)NSString                               *retweet_user_name;//转发微博名称
@property (nonatomic,copy)NSString                              *root_in_reply_to_screen_name;//转发原微博用户昵称
@property (nonatomic,retain)NSNumber                            *root_in_reply_to_status_id;      //转发原微博用户id
@property (nonatomic,copy)NSString                              *root_in_reply_to_status_text;  //转发原微博内容
@property (nonatomic,retain)NSNumber                            *root_in_reply_to_user_id;          //转发原微博用户id
@property (nonatomic,copy)NSString                              *root_in_reply_to_user_name;      //转发原微博用户名
@property (nonatomic,copy)NSString                              *root_in_reply_to_videoInfos;    //转发原微博视频信息
@property (nonatomic,copy)NSString                              *root_in_reply_to_songInfos;      //转发原微博音乐信息
@property (nonatomic,retain)NSNumber                            *root_retweet_count;                      //转发原微博转发总数
@property (nonatomic,retain)NSNumber                            *root_comments_count;                     //转发原微博评论总数
@property (nonatomic,copy)NSString                              *flag;           //是否为转发微博数据
@property (nonatomic,copy)NSString                              *cursor_id; //微博位置id 上拉 下拉刷新用
@end
