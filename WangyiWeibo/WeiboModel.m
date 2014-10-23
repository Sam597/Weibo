//
//  WeiboModel.m
//  DoubanMovie
//
//  Created by 阿满 on 14-7-24.
//  Copyright (c) 2014年 man_sam. All rights reserved.
//

#import "WeiboModel.h"

@implementation WeiboModel
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
                              @"created_at": @"created_at",             // 微博发布时间
                              @"comments_count": @"comments_count",     //评论总数
                              @"geo": @"geo",                           //地理位置
                              @"retweet_count": @"retweet_count",       //转发总数
                              @"source": @"source",                     //微博来源
                              @"text": @"text",                         //内容
                              @"retweet_user_name":@"retweet_user_name",//转发微博用户名
                              @"root_in_reply_to_screen_name":@"root_in_reply_to_screen_name",  //转发原微博用户昵称
                              @"root_in_reply_to_status_id":@"root_in_reply_to_status_id",      //转发原微博用户id
                              @"root_in_reply_to_status_text":@"root_in_reply_to_status_text",  //转发原微博内容
                              @"root_in_reply_to_user_id":@"root_in_reply_to_user_id",          //转发原微博用户id
                              @"root_in_reply_to_user_name":@"root_in_reply_to_user_name",      //转发原微博用户名
                              @"root_in_reply_to_videoInfos":@"root_in_reply_to_videoInfos",    //转发原微博视频信息
                              @"root_in_reply_to_songInfos":@"root_in_reply_to_songInfos",      //转发原微博音乐信息
                              @"root_retweet_count":@"root_retweet_count",                      //转发原微博转发总数
                              @"root_comments_count":@"root_comments_count",                     //转发原微博评论总数
                              @"flag":@"flag",
                              @"cursor_id":@"cursor_id"                                          //微博位置id 上拉 下拉刷新用
                              };
    return mapAttr;
}

//数值付给当前对象
-(void)setAttributes:(NSDictionary *)dataDic
{
    //将字典数据根据映射关系填充到当前对象的属性
    [super setAttributes:dataDic];
    NSDictionary *userDic = [dataDic objectForKey:@"user"];
    if (userDic != nil) {
        UserModel *userData = [[UserModel alloc] initWithDataDic:userDic];
        self.user = userData;
//        [userData release];
    }

//    NSMutableDictionary *relDic = [NSMutableDictionary dictionary];
//    [relDic setValue:[dataDic objectForKey:@"root_in_reply_to_screen_name"] forKey:@"root_in_reply_to_screen_name"];
//    [relDic setValue:[dataDic objectForKey:@"root_in_reply_to_status_id"] forKey:@"root_in_reply_to_status_id"];
//    [relDic setValue:[dataDic objectForKey:@"root_in_reply_to_status_text"] forKey:@"root_in_reply_to_status_text"];
//    [relDic setValue:[dataDic objectForKey:@"root_in_reply_to_user_id"] forKey:@"root_in_reply_to_user_id"];
//    [relDic setValue:[dataDic objectForKey:@"root_in_reply_to_user_name"] forKey:@"root_in_reply_to_user_name"];
//    [relDic setValue:[dataDic objectForKey:@"root_in_reply_to_videoInfos"] forKey:@"root_in_reply_to_videoInfos"];
//    [relDic setValue:[dataDic objectForKey:@"root_in_reply_to_songInfos"] forKey:@"root_in_reply_to_songInfos"];
//    [relDic setValue:[dataDic objectForKey:@"root_retweet_count"] forKey:@"root_retweet_count"];
//    [relDic setValue:[dataDic objectForKey:@"root_comments_count"] forKey:@"root_comments_count"];
//    if (relDic != nil) {
//        RelWeiboModel *relData = [[RelWeiboModel alloc] initWithDataDic:relDic];
//        self.relModel = relData;
//        [relData release];
//    }
}

@end
