

#import "MicroBlogAsyncHttp.h"
#import "MicroBlogMutableURLRequest.h"
#import "ASIHTTPRequest.h"
#import "NSURL+Additions.h"
#import "NSString+Additions.h"

@implementation MicroBlogAsyncHttp
- (NSURLConnection *)httpGet:(NSString *)aUrl queryString:(NSString *)aQueryString delegate:(id)aDelegare {
	
	NSMutableURLRequest *request = [MicroBlogMutableURLRequest requestGet:aUrl queryString:aQueryString];
	return [NSURLConnection connectionWithRequest:request delegate:aDelegare];

	
}

- (NSURLConnection *)httpPost:(NSString *)aUrl queryString:(NSString *)aQueryString delegate:(id)aDelegare {
	
	NSMutableURLRequest *request = [MicroBlogMutableURLRequest requestPost:aUrl queryString:aQueryString];
	return [NSURLConnection connectionWithRequest:request delegate:aDelegare];
}

- (NSURLConnection *)httpPostWithFile:(NSDictionary *)files url:(NSString *)aUrl queryString:(NSString *)aQueryString delegate:(id)aDelegare {
	
	NSMutableURLRequest *request = [MicroBlogMutableURLRequest requestPostWithFile:files url:aUrl queryString:aQueryString];
	return [NSURLConnection connectionWithRequest:request delegate:aDelegare];
}

+ (NSURLConnection *)httpPostWithData:(NSData *)data url:(NSString *)aUrl queryString:(NSString *)aQueryString delegate:(id)aDelegare {
	
	NSMutableURLRequest *request = [MicroBlogMutableURLRequest requestPostWithData:data url:aUrl queryString:aQueryString];
	return [NSURLConnection connectionWithRequest:request delegate:aDelegare];
}

+ (NSURLConnection *)httpPostWithImageData:(NSData *)imageData url:(NSString *)aUrl queryString:(NSString *)aQueryString delegate:(id)aDelegare {
	
	NSMutableURLRequest *request = [MicroBlogMutableURLRequest requestPostWithImageData:imageData url:aUrl queryString:aQueryString];
	return [NSURLConnection connectionWithRequest:request delegate:aDelegare];
}

/*
+ (NSURLConnection *)httpPostWithDataAutoGzip:(NSData *)data url:(NSString *)aUrl queryString:(NSString *)aQueryString delegate:(id)aDelegare
{
    NSMutableURLRequest *request = [MicroBlogMutableURLRequest requestPostWithDataAutoGzip:data url:aUrl queryString:aQueryString];
	return [NSURLConnection connectionWithRequest:request delegate:aDelegare];
}
*/

/*********************************使用ASIHttpRequest 请求数据********************************/
 
//get请求方式
- (ASIHTTPRequest *)ASIHttpGet:(NSString *)aUrl queryString:(NSString *)aQueryString delegate:(id)aDelegare {
    NSMutableString *burl = [[NSMutableString alloc] initWithString:aUrl];
    if (aQueryString) {
        [burl appendFormat:@"?%@", aQueryString];
    }
    
    NSURL *url = [NSURL URLWithString:burl];
    
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
    
    [request setDelegate:aDelegare];
    
    [request startAsynchronous];
    
    return request;
}

- (ASIHTTPRequest *)ASIHttpPost:(NSString *)aUrl queryString:(NSString *)aQueryString delegate:(id)aDelegare {
    
    NSURL *url = [NSURL URLWithString:aUrl];
    
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
    
    [request setDelegate:aDelegare];
    
    [request startAsynchronous];
    
    return request;
}

- (ASIHTTPRequest *)ASIHttpPostWithFile:(NSDictionary *)files url:(NSString *)aUrl queryString:(NSString *)aQueryString delegate:(id)aDelegare {
    
    NSURL *url = [NSURL URLWithString:aUrl];
    
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
    
    [request setDelegate:aDelegare];
    
    [request startAsynchronous];
    
    return request;
}
@end
