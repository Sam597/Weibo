//
//  RelWeiboModel.h
//  DoubanMovie
//
//  Created by 阿满 on 14-8-5.
//  Copyright (c) 2014年 man_sam. All rights reserved.
//

#import "WXBaseModel.h"

@interface RelWeiboModel : WXBaseModel

@property (nonatomic,copy)NSString                              *root_in_reply_to_screen_name;//转发原微博用户昵称
@property (nonatomic,retain)NSNumber                            *root_in_reply_to_status_id;      //转发原微博用户id
@property (nonatomic,copy)NSString                              *text;  //转发原微博内容
@property (nonatomic,retain)NSNumber                            *root_in_reply_to_user_id;          //转发原微博用户id
@property (nonatomic,copy)NSString                              *root_in_reply_to_user_name;      //转发原微博用户名
@property (nonatomic,copy)NSString                              *root_in_reply_to_videoInfos;    //转发原微博视频信息
@property (nonatomic,copy)NSString                              *root_in_reply_to_songInfos;      //转发原微博音乐信息
@property (nonatomic,retain)NSNumber                            *retweet_count;                      //转发原微博转发总数
@property (nonatomic,retain)NSNumber                            *comments_count;                     //转发原微博评论总数
@end
