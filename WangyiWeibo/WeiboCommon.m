//
//  WeiboCommon.m
//  WangyiWeibo
//
//  Created by 阿满 on 14-10-10.
//  Copyright (c) 2014年 man_sam. All rights reserved.
//
#import "AppDelegate.h"
#import "WeiboCommon.h"

#define KeyNetEaseWeibo @"KeyUserDefaultNetEaseWeibo"



@interface WeiboCommon()
+ (NSDictionary*)getStaticDictionary;
@end

#define FileName_Netease    @"NeteaseUser"
static NSDictionary* staticNeteaseInfo;

@implementation WeiboCommon


+ (NSString *)getUserDefaultString
{
    return KeyNetEaseWeibo;
}
//设置userdefault中得bool类型的值值为yes key：KeyUserDefaultNetEaseWeibo
+ (void)initialize
{
    NSUserDefaults *userdefault = [NSUserDefaults standardUserDefaults];
    [userdefault setBool:YES forKey:[WeiboCommon getUserDefaultString]];
}

//设置一个 path路径 path 为：FileName_Netease    @"NeteaseUser" 并返回
+ (NSString *)getInfoFilePath
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *fileName = nil;
    NSString *infoFile=nil;

    fileName = FileName_Netease;

    infoFile = [[paths objectAtIndex:0] stringByAppendingPathComponent:fileName];
    return infoFile;
}
//字典parars 写入 文件
+ (void)saveWeiboInfo:(NSDictionary *)parars
{
    NSString *infoFile = [WeiboCommon getInfoFilePath];
    [parars writeToFile:infoFile atomically:YES];
}
//把 name这个参数和值 保存到NeteaseUser
+ (void)saveWeiboName:(NSString *)name
{
    if (name == nil) {
        return;
    }
    NSDictionary *dict = [WeiboCommon getBlogInfo];
    if (dict == nil) {
        return;
    }
    NSMutableDictionary *dict2 = [NSMutableDictionary dictionaryWithDictionary:dict];
    [dict2 setObject:name forKey:@"name"];
    [WeiboCommon saveWeiboInfo:dict2];
}

+ (void)deleteWeiboInfo
{
    NSLog(@"已清除");
    NSString *infoFile = [WeiboCommon getInfoFilePath];
    [[NSFileManager defaultManager] removeItemAtPath:infoFile error:nil];
}
//获取字典
+ (NSDictionary*)getStaticDictionary
{
    return staticNeteaseInfo;
}
//验证绑定
+ (BOOL)checkHasBinding
{
    NSString *infoFile = [WeiboCommon getInfoFilePath];
    if ([[NSFileManager defaultManager] fileExistsAtPath:infoFile] == NO) {
        return NO;
    }
    return YES;
}
//获得路径里的值 以字典形式返回
+ (NSDictionary*)getBlogInfo
{
    NSDictionary *dict;
    //文件路径
    NSString *infoFile = [WeiboCommon getInfoFilePath];
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:infoFile] == NO) {
        return nil;
    }
    //转为字典输出
    dict = [NSDictionary dictionaryWithContentsOfFile:infoFile];
    return dict;
}

+ (NSString *)getUserName
{
    NSString *name = nil;
    NSDictionary *param = [WeiboCommon getBlogInfo];
    if (param != nil) {
        name = [param objectForKey:@"name"];
        if (name == nil) {
            name = [param objectForKey:@"oauth_key"];
        }
    }
    return name;
}
//获取KeyUserDefaultNetEaseWeibo  bool值
+ (BOOL)getWeiboEnabled
{
    return [[NSUserDefaults standardUserDefaults] boolForKey:[WeiboCommon getUserDefaultString]];
}
//设置KeyUserDefaultNetEaseWeibo bool值
+ (void)setWeiboEnableWithStatus:(BOOL)isEnabled
{
    [[NSUserDefaults standardUserDefaults] setBool:isEnabled forKey:[WeiboCommon getUserDefaultString]];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (NSArray*)loadWeiboInfo
{
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:4];

        NSString *name = [WeiboCommon getUserName];
        NSObject *nameValue = name;
        if (name == nil) {
            nameValue = [NSNull null];
        }
        BOOL isEnabled = [WeiboCommon getWeiboEnabled];
        NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:nameValue, @"name",[NSNumber numberWithBool:isEnabled], @"enable", nil];
        [array addObject:dict];
    
    return array;
}

+ (NSArray*)loadAuthorizedWeiboInfo
{
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:4];

        NSString *name = [WeiboCommon getUserName];
        NSObject *nameValue = name;
        if (name != nil) {
            //nameValue = [NSNull null];
            BOOL isEnabled = [WeiboCommon getWeiboEnabled];
            if (isEnabled) {
                NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:nameValue, @"name", nil];
                [array addObject:dict];
            }
        }
    
    return array;
}


@end
