//
//  WeiboCommon.h
//  WangyiWeibo
//
//  Created by 阿满 on 14-10-10.
//  Copyright (c) 2014年 man_sam. All rights reserved.
//

#import <Foundation/Foundation.h>

#define KEY_NETEASE @"LfKhGQPLddhix6ci"
#define SECRETKEY_NETEASE  @"Sq7qonRG4RHCnQyoCT8nV9FeY5NTgReW"

//处理公共用到的方法
@interface WeiboCommon : NSObject

/*
 保存字典信息
 */
+ (void)saveWeiboInfo:(NSDictionary *)parars;
/*
 保存username，以方便授权成功时获取个人信息和每次发微博时更新姓名
 */
+ (void)saveWeiboName:(NSString *)name;
/*
 删除的信息
 */
+ (void)deleteWeiboInfo;
/*
 检查该微博是否已绑定
 */
+ (BOOL)checkHasBinding;
/*
 得到微博的所有保存信息，包括oauth_key、oauth_secret、可能存在name
 */
+ (NSDictionary*)getBlogInfo;
/*
 得到微博对应的姓名，如果存在，返回姓名。不存在返回oauth_key（因为后面有用姓名来判断是否已绑定的逻辑）
 */
+ (NSString *)getUserName;
/*
 设置微博是否开启
 */
+ (void)setWeiboEnableWithStatus:(BOOL)isEnabled;
/*
 得到微博是否开启
 */
+ (BOOL)getWeiboEnabled;
/*
 加载微博信息，该数组里保存的是字典，内容包括name 和 enable
 */
+ (NSArray*)loadWeiboInfo;
/*
 加载已绑定的微博信息，该数组内容是字典，包括name和weiboid
 */
+ (NSArray*)loadAuthorizedWeiboInfo;

@end
