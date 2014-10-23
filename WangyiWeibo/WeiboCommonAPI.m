
//  WeiboCommonAPI.m
//  WangyiWeibo
//
//  Created by 阿满 on 14-10-10.
//  Copyright (c) 2014年 man_sam. All rights reserved.
//


enum RequestId {
    GettingOauthToken,
    GettingAccessToken,
    GettingUserInfo,
    PublishMessage,
    GetHomeWeiboData,
    GetHomeRereshWeiboData
};



#include "ifaddrs.h"
#include "arpa/inet.h"
#import "WeiboCommon.h"
#import "WeiboCommonAPI.h"
#import "NSURL+Additions.h"
#import "JSON.h"
//#import "WeiboWrapper.h"

#import "ASIHTTPRequest.h"
#import "WeiboModel.h"

@interface WeiboCommonAPI()
//- (NSInteger)getNextSendingId;
@end

@implementation WeiboCommonAPI
@synthesize oauthKey;
@synthesize connectionWeibo,AsiConnectionWeibo, dataReceive, currentWeiboId, delegate, numerousPublish;
@synthesize stringFilePath, stringSendingContent, stringImageUrl;
@synthesize userData,weiboModel,weiboListData,weiboRereshListData;

- (id)init
{
    self = [super init];
    if (self) {
        MicroBlogOauthKey *key = [[MicroBlogOauthKey alloc] init];
        self.oauthKey = key;
//        [key release];
    }
    return self;
}
//初始化 授权信息
- (void)initAccessToken
{
    NSDictionary *info = [WeiboCommon getBlogInfo];
    oauthKey.tokenKey = [info objectForKey:@"oauth_token"];
    oauthKey.tokenSecret = [info objectForKey:@"oauth_token_secret"];
    oauthKey.callbackUrl = nil;

    oauthKey.consumerKey = KEY_NETEASE;
    oauthKey.consumerSecret = SECRETKEY_NETEASE;
    
}

//得到IP地址
- (NSString *)getIPAddress {
    
    NSString *address = @"202.206.0.48";
    struct ifaddrs *interfaces = NULL;
    struct ifaddrs *temp_addr = NULL;
    int success = 0;
    // retrieve the current interfaces - returns 0 on success
    success = getifaddrs(&interfaces);
    if (success == 0) {
        // Loop through linked list of interfaces
        temp_addr = interfaces;
        while(temp_addr != NULL) {
            if(temp_addr->ifa_addr->sa_family == AF_INET) {
                // Check if interface is en0 which is the wifi connection on the iPhone
                if([[NSString stringWithUTF8String:temp_addr->ifa_name] isEqualToString:@"en0"]) {
                    // Get NSString from C String
                    address = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_addr)->sin_addr)];
                    
                }
                
            }
            
            temp_addr = temp_addr->ifa_next;
        }
    }
    // Free memory
    freeifaddrs(interfaces);
    return address;
}


#pragma mark 得到OauthToken部分
- (void)getOauthToken
{
    currentRequestId = GettingOauthToken;

    NSString *url = nil;
    NSString *method = @"GET";
    
    [self initAccessToken];

    url = @"http://api.t.163.com/oauth/request_token";

    
    self.AsiConnectionWeibo = [MicroBlogRequest asiAsyncRequestWithUrl:url httpMethod:method oauthKey:oauthKey parameters:nil files:nil delegate:self];
}


//获取OauthToken 失败
- (void)notifyGetOauthTokenFailed
{
    if (delegate && [delegate respondsToSelector:@selector(getOauthTokenFailed:)]) {
        [delegate getOauthTokenFailed:self];
    }
}
//获取OauthToken成功
- (void)notifyGetOauthTokenSuccessWithOauthToken:(NSString *)oauthToken andOauthTokenSecret:(NSString *)oauthTokenSecret
{
    if (self && [delegate respondsToSelector:@selector(getOauthTokenSuccess:andOauthToken:andOauthTokenSecret:)]) {
        [delegate getOauthTokenSuccess:self andOauthToken:oauthToken andOauthTokenSecret:oauthTokenSecret];
    }
}

/*
 处理得到的OauthToken数据
 */
- (void)processOauthTokenData
{
    NSString *string = [[NSString alloc ] initWithData:dataReceive encoding:NSUTF8StringEncoding];
//    NSLog(@"%@", string);
    NSDictionary *params = [NSURL parseURLQueryString:string];
    NSString *oauthToken = [params objectForKey:@"oauth_token"];
    NSString *oauthTokenSecret = [params objectForKey:@"oauth_token_secret"];
    if (oauthToken && oauthTokenSecret) {
        [self notifyGetOauthTokenSuccessWithOauthToken:oauthToken andOauthTokenSecret:oauthTokenSecret];
    }else{
        [self notifyGetOauthTokenFailed];
    }
//    [string release];
}



#pragma mark 得到AccessToken和AccessTokenSecret
- (void)getAccessTokenWithOauthToken:(NSString *)oauthToken andOauthTokenSecret:(NSString *)oauthTokenSecret andVerifier:(NSString*)verifier
{
    currentRequestId = GettingAccessToken;

    NSString *url = nil;
    NSString *method = @"GET";

    url = @"http://api.t.163.com/oauth/access_token";

    
    [self initAccessToken];
    oauthKey.tokenKey = oauthToken;
    oauthKey.tokenSecret = oauthTokenSecret;
    oauthKey.verify = verifier;
    

    self.AsiConnectionWeibo = [MicroBlogRequest asiAsyncRequestWithUrl:url httpMethod:method oauthKey:oauthKey parameters:nil files:nil delegate:self];;
}

- (void)notifyGetAccessTokenFailed
{
    if (delegate && [delegate respondsToSelector:@selector(getAccessTokenFailed:)]) {
        [delegate getAccessTokenFailed:self];
    }
}

- (void)notifyGetAccessTokenSuccess
{
    if (delegate && [delegate respondsToSelector:@selector(getaccesstokenSuccess:)]) {
        [delegate getaccesstokenSuccess:self];
    }
}
//处理accessToken
- (void)processAccessTokenData
{
    NSString *string = [[NSString alloc ] initWithData:dataReceive encoding:NSUTF8StringEncoding];
//    NSLog(@"processAccessTokenData:%@", string);
    NSDictionary *params = [NSURL parseURLQueryString:string];
    if ([params objectForKey:@"oauth_token"]==nil || [params objectForKey:@"oauth_token_secret"]==nil) {
        [self notifyGetAccessTokenFailed];
    }else{
        [WeiboCommon saveWeiboInfo:params];
        [self notifyGetAccessTokenSuccess];
    }
//    [string release];
}


#pragma mark 获取用户信息
- (void)getUserInfo
{
    currentRequestId = GettingUserInfo;

    NSString *url = nil;
    NSString *method = @"GET";
    
    [self initAccessToken];
    url = [[NSString alloc]initWithFormat:@"http://api.t.163.com/users/show.json"];
    
    self.AsiConnectionWeibo = [MicroBlogRequest asiAsyncRequestWithUrl:url httpMethod:method oauthKey:oauthKey parameters:nil files:nil delegate:self];
    
}

//实现代理方法
- (void)notifyGetUserInfoFailed
{
    if (delegate && [delegate respondsToSelector:@selector(getUserInfoFailed:)]) {
        [delegate getUserInfoFailed:self];
    }
}

- (void)notifyGetuserInfoSuccess:(NSString *)userName
{
    if (delegate && [delegate respondsToSelector:@selector(getUserInfoSuccess:andUserName:)]) {
        [delegate getUserInfoSuccess:self andUserName:userName];
    }
}
//处理得到的用户数据
- (void)processGetUserInfoData
{
    NSString *string = [[NSString alloc ] initWithData:dataReceive encoding:NSUTF8StringEncoding];
//    NSLog(@"processGetUserInfoData:%@", string);
    SBJsonParser *parser = [[SBJsonParser alloc] init];
    NSDictionary *dict = [parser objectWithString:string];
    NSString *name = nil;
 
    name = [dict objectForKey:@"name"];
    
    if (name){
        [WeiboCommon saveWeiboName:name];
        [self notifyGetuserInfoSuccess:name];
    }else{
        [self notifyGetUserInfoFailed];
    }
//    [parser release];
//    [string release];
}
#pragma mark 发布消息

#pragma mark ASIHttpRequest delegate

//请求发起时
- (void)requestStarted:(ASIHTTPRequest *)request
{
    self.dataReceive = nil;
    dataReceive = [[NSMutableData alloc] init];
}


//请求成功时
- (void)requestFinished:(ASIHTTPRequest *)request
{
    //把取回的数据放到dataReceive里面
    [self.dataReceive appendData:[request responseData]];
    
    switch (currentRequestId) {
        case GettingOauthToken:
            [self performSelectorOnMainThread:@selector(processOauthTokenData) withObject:nil waitUntilDone:NO];
            break;
        case GettingAccessToken:
            [self performSelectorOnMainThread:@selector(processAccessTokenData) withObject:nil waitUntilDone:NO];
            break;
        case GettingUserInfo:
            [self performSelectorOnMainThread:@selector(processGetUserInfoData) withObject:nil waitUntilDone:NO];
            break;
        case GetHomeWeiboData:
            [self performSelectorOnMainThread:@selector(processGetHomeWeiboData)  withObject:nil waitUntilDone:NO];
            break;;
        case GetHomeRereshWeiboData:
            [self performSelectorOnMainThread:@selector(processGetHomeRereshWeiboData) withObject:nil waitUntilDone:NO];
        default:
            break;
    }
}

//请求失败时
- (void)requestFailed:(ASIHTTPRequest *)request
{
    NSLog(@"error： %@",[request error]);
    switch (currentRequestId) {
        case GettingOauthToken:
            [self notifyGetOauthTokenFailed];
            break;
        case GettingAccessToken:
            [self notifyGetAccessTokenFailed];
            break;
        case GettingUserInfo:
            [self notifyGetUserInfoFailed];
            break;
        case GetHomeWeiboData:
            [self notifyGetHomeWeiboDataFailed];
            break;
        case GetHomeRereshWeiboData:
            [self notifyGetHomeRereshWeiboDataFailed];
        default:
            break;
    }
}

#pragma mark 公用函数
//data转换
-(id)NSDataToNSDictionaryOrNSArray:(NSData *)requestData
{
    NSLog(@"data /n:%@",requestData);
    NSError *error = nil;
    id jsonObject = [NSJSONSerialization JSONObjectWithData:requestData options:NSJSONReadingAllowFragments error:&error];
    if (jsonObject != nil && error == nil)
    {
        NSLog(@"Successfully deserialized...");
        if ([jsonObject isKindOfClass:[NSDictionary class]])
        {
            NSDictionary *deserializedDictionary = (NSDictionary *)jsonObject;
            // NSLog(@"Dersialized JSON Dictionary = %@", deserializedDictionary);
            return deserializedDictionary;
        }
        else if ([jsonObject isKindOfClass:[NSArray class]])
        {
            NSArray *deserializedArray = (NSArray *)jsonObject;
            //            NSLog(@"Dersialized JSON Array = %@", deserializedArray);
            return deserializedArray;
        }
        else
        {
            NSLog(@"An error happened while deserializing the JSON data.");
        }
    }
    //    [requestData release];
    return nil;
}
#pragma mark 获取home页面微博数据
//获取微博home页面的微博数据
-(void)getHomeWeiboData {
    currentRequestId = GetHomeWeiboData;
    //////////api 请求/////////////
    [self initAccessToken];
    //请求api url
//        NSString *urlss = @"http://api.t.163.com/statuses/home_timeline.json";
    NSString *urlss = @"http://api.t.163.com/statuses/user_timeline.json";
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    //传递参数
    [parameters setObject:@"10" forKey:@"count"];
    [parameters setObject:@"hanqm1314" forKey:@"name"];
    
    //returnData就是返回得到的数据
    NSString *method = @"GET";
    
    //发送请求 附带参数
    self.AsiConnectionWeibo = [MicroBlogRequest asiAsyncRequestWithUrl:urlss httpMethod:method oauthKey:self.oauthKey parameters:parameters files:nil delegate:self];
    /////////api 请求结束///////
}

//实现代理方法
- (void)notifyGetHomeWeiboDataFailed
{
    if (delegate && [delegate respondsToSelector:@selector(getHomeWeiboDataFailed:)]) {
        [delegate getHomeWeiboDataFailed:self];
    }
}

- (void)notifyGetHomeWeiboDataSuccessWithWeiboModel:(NSMutableArray *)weiboModels
{
    if (delegate && [delegate respondsToSelector:@selector(getHomeWeiboDataSuccess:andWeiboModel:)]) {
        [delegate getHomeWeiboDataSuccess:self andWeiboModel:weiboModels];
    }//如果可以运行这个方法
}
//处理api返回的数据 homeWeiboData
-(void)processGetHomeWeiboData{
    //获取的微博的nsdata转换为 dictionary类型的数据
    NSString *string = [[NSString alloc ] initWithData:dataReceive encoding:NSUTF8StringEncoding];
    SBJsonParser *parser = [[SBJsonParser alloc] init];
    NSDictionary *dict = [parser objectWithString:string];
    
    
    //创建一个可变数组 存放请求返回的数据
    self.weiboListData = [NSMutableArray arrayWithCapacity:dict.count];
    for (NSDictionary *dic in dict) {
        //创建微博的model 数据模型 必须先实例化创建内存空间 model
        self.weiboModel = [[WeiboModel alloc] initWithDataDic:dic];
        //插入多个微博数据模型model到 可变数组中
        [self.weiboListData addObject:weiboModel];
    }
    if (self.weiboListData) {
        [self notifyGetHomeWeiboDataSuccessWithWeiboModel:self.weiboListData];
    }else{
        [self notifyGetHomeWeiboDataFailed];
    }
    
    
    
    
}
#pragma mark 获取home页面刷新微博数据
//获取微博home页面的微博数据
-(void)getHomeRereshWeiboDataWithCursorId:(NSString *)cursor_id andType:(NSString *)type {
    currentRequestId = GetHomeRereshWeiboData;
    //////////api 请求/////////////
    [self initAccessToken];
    //请求api url
//        NSString *urlss = @"http://api.t.163.com/statuses/home_timeline.json";
    NSString *urlss = @"http://api.t.163.com/statuses/user_timeline.json";
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    //传递参数
    [parameters setObject:@"10" forKey:@"count"];
    [parameters setObject:@"hanqm1314" forKey:@"name"];
    if ([type isEqualToString:@"since_id"]) {
        [parameters setObject:cursor_id forKey:@"since_id"];
    }else {
        [parameters setObject:cursor_id forKey:@"max_id"];
    }
    
    
    rereshType = type;
    //returnData就是返回得到的数据
    NSString *method = @"GET";
    
    //发送请求 附带参数
    self.AsiConnectionWeibo = [MicroBlogRequest asiAsyncRequestWithUrl:urlss httpMethod:method oauthKey:self.oauthKey parameters:parameters files:nil delegate:self];
    /////////api 请求结束///////
}

//实现代理方法
- (void)notifyGetHomeRereshWeiboDataFailed
{
    if (delegate && [delegate respondsToSelector:@selector(getHomeRereshWeiboDataFailed:)]) {
        [delegate getHomeRereshWeiboDataFailed:self];
    }
}

- (void)notifyGetHomeRereshWeiboDataSuccessWithWeiboModel:(NSMutableArray *)weiboModels
{
    if (delegate && [delegate respondsToSelector:@selector(getHomeRereshWeiboDataSuccess:andWeiboModel:)]) {
        [delegate getHomeRereshWeiboDataSuccess:self andWeiboModel:weiboModels];
    }//如果可以运行这个方法
}
//处理api返回的数据 homeWeiboData
-(void)processGetHomeRereshWeiboData{
    //获取的微博的nsdata转换为 dictionary类型的数据
    NSString *string = [[NSString alloc ] initWithData:dataReceive encoding:NSUTF8StringEncoding];
    SBJsonParser *parser = [[SBJsonParser alloc] init];
    NSDictionary *dict = [parser objectWithString:string];
    
    //创建一个可变数组 存放请求返回的数据
    self.weiboRereshListData = [NSMutableArray arrayWithCapacity:dict.count];
    for (NSDictionary *dic in dict) {
        //创建微博的model 数据模型 必须先实例化创建内存空间 model
        self.weiboModel = [[WeiboModel alloc] initWithDataDic:dic];
        //插入多个微博数据模型model到 可变数组中
        if ([rereshType isEqualToString:@"max_id"]) {
//            [self.weiboListData insertObjects:self.weiboRereshListData atIndexes:0
            [self.weiboListData insertObject:self.weiboModel atIndex:0];
            
        }else{
//            [self.weiboListData addObjectsFromArray:self.weiboRereshListData];
            [self.weiboListData addObject:self.weiboModel];
        }
    }
   
    
    if (self.weiboListData) {
        [self notifyGetHomeRereshWeiboDataSuccessWithWeiboModel:self.weiboListData];
    }else{
        [self notifyGetHomeRereshWeiboDataFailed];
    }
    
    
    
    
}



@end
