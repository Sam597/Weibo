//
//  UserModel.m
//  DoubanMovie
//
//  Created by 阿满 on 14-7-25.
//  Copyright (c) 2014年 man_sam. All rights reserved.
//

#import "UserModel.h"
/*
 @property(nonatomic,copy)NSString           *name;//用户名称
 @property(nonatomic,copy)NSString           *profile_image_url;//头像url
 @property(nonatomic,copy)NSString           *screen_name;//用户昵称
 @property(nonatomic,retain)NSNumber         *statuses_count;//微博数
 @property(nonatomic,retain)NSNumber         *followers_count;//粉丝数
 @property(nonatomic,retain)NSNumber         *friends_count;//关注数
 @property(nonatomic,retain)NSNumber         *favourites_count;//收藏数
 @property(nonatomic,copy)NSString           *gender;//性别
 @property(nonatomic,retain)NSString         *verified;              //是否是微博认证用户，加V true 是 false 否
 @property(nonatomic,copy)NSString           *location;                //用户所在地
 */
@implementation UserModel
//字典在键值映射关系
-(NSDictionary *)attributeMapDictionary
{
    NSDictionary *mapAttr = @{
                              
                              @"name": @"name",
                              @"profile_image_url": @"profile_image_url",
                              @"screen_name": @"screen_name",
                              @"statuses_count": @"statuses_count",
                              @"followers_count": @"followers_count",
                              @"friends_count": @"friends_count",
                              @"favourites_count": @"favourites_count",
                              @"gender": @"gender",
                              @"verified": @"verified",
                              @"location": @"location",
                              @"url": @"url",
                              @"description": @"description"
                              
                              
                              };
    return mapAttr;
}
@end
