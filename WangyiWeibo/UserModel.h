//
//  UserModel.h
//  DoubanMovie
//
//  Created by 阿满 on 14-7-25.
//  Copyright (c) 2014年 man_sam. All rights reserved.
//

#import "WXBaseModel.h"

@interface UserModel : WXBaseModel
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
//@property(nonatomic,copy)NSString           *description;       //简介
@property(nonatomic,copy)NSString           *url;//微博地址
@end
