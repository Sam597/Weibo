//
//  MicroBlogOauthKey.h
//  NetEaseMicroBlog
//
//  Created by wuzhikun on 11-4-15.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface MicroBlogOauthKey : NSObject {
	NSString *consumerKey;
	NSString *consumerSecret;
	NSString *tokenKey;
	NSString *tokenSecret;
	NSString *verify;
	NSString *callbackUrl;
}

@property (nonatomic, retain) NSString *consumerKey;        //用户key
@property (nonatomic, retain) NSString *consumerSecret;     //用户秘钥
@property (nonatomic, retain) NSString *tokenKey;           //
@property (nonatomic, retain) NSString *tokenSecret;        //token加密
@property (nonatomic, retain) NSString *verify;             //查证
@property (nonatomic, retain) NSString *callbackUrl;        //回调url

@end
