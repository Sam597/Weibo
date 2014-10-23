//
//  RelWeiboModel.m
//  DoubanMovie
//
//  Created by 阿满 on 14-8-5.
//  Copyright (c) 2014年 man_sam. All rights reserved.
//

#import "RelWeiboModel.h"

@implementation RelWeiboModel
//字典在键值映射关系
-(NSDictionary *)attributeMapDictionary
{
    /*
     root_in_reply_to_screen_name" = 2556032246;
     "root_in_reply_to_songInfos" = "<null>";
     "root_in_reply_to_status_id" = "-4799998549100676573";
     "root_in_reply_to_status_text" = "http://126.fm/1KOBE \U6211\U753b\U7684[\U98de\U543b]";
     "root_in_reply_to_user_id" = 5116053140016257540;
     "root_in_reply_to_user_name" = hanqm1314;
     "root_in_reply_to_videoInfos" = "<null>";
     "root_retweet_count" = 1;
     
     */
    NSDictionary *mapAttr = @{
                              @"root_in_reply_to_screen_name":@"root_in_reply_to_screen_name",  //转发原微博用户昵称
                              @"root_in_reply_to_status_id":@"root_in_reply_to_status_id",      //转发原微博用户id
                              @"text":@"root_in_reply_to_status_text",  //转发原微博内容
                              @"root_in_reply_to_user_id":@"root_in_reply_to_user_id",          //转发原微博用户id
                              @"root_in_reply_to_user_name":@"root_in_reply_to_user_name",      //转发原微博用户名
                              @"root_in_reply_to_videoInfos":@"root_in_reply_to_videoInfos",    //转发原微博视频信息
                              @"root_in_reply_to_songInfos":@"root_in_reply_to_songInfos",      //转发原微博音乐信息
                              @"retweet_count":@"root_retweet_count",                      //转发原微博转发总数
                              @"comments_count":@"root_comments_count"                     //转发原微博评论总数
                              };
    return mapAttr;
}
@end
