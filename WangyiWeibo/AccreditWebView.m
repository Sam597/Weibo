//
//  accreditWevView.m
//  WangyiWeibo
//
//  Created by 阿满 on 14-10-15.
//  Copyright (c) 2014年 man_sam. All rights reserved.
//

#import "AccreditWebView.h"
#import "RegexKitLite.h"
#import "AppDelegate.h"
#import "HomeViewController.h"


@interface AccreditWebView ()

@end

@implementation AccreditWebView
@synthesize oauthToken;
@synthesize isVerifing;
@synthesize stringOauthTokenSecret;


- (void)viewDidLoad {
    self.title = @"绑定微博";
    [super viewDidLoad];
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    self.weiboApi = appDelegate.weiboApi;
    self.home = [[HomeViewController alloc] init];
    self.home.delegate = self;
    self.weiboApi.delegate = self.home;
    
    
    NSString *url = [NSString stringWithFormat:@"%@%@", @"http://api.t.163.com/oauth/authorize?oauth_token=", self.oauthToken];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    
    [self.webView loadRequest:request];
    
    

    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark UIWebViewDelegate
- (void)webViewDidStartLoad:(UIWebView *)webView
{
    [self showActivityIndicator];
    
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [self hideActivityIndicator];
    if (!self.isVerifing) {
        NSString *htmlstr = [self.webView stringByEvaluatingJavaScriptFromString:
                             @"document.getElementsByTagName('html')[0].outerHTML"];
        //        NSLog(@"%@", htmlstr);
        NSString *verifier = [self getVeriferFromHtml:htmlstr];
        if (verifier) {
            self.textFieldVerify.text = verifier;
            [self buttonSubmitVerifyClicked:nil];
        }
    }
}


- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    
    NSString *query = [[request URL] query];
    if (query == nil ) {
//        [self showInputVerifyView];
    }
    NSString *verifier = [self valueForKey:@"oauth_verifier" ofQuery:query];
    if (verifier && ![verifier isEqualToString:@""]) {
        self.textFieldVerify.text = verifier;
        [self buttonSubmitVerifyClicked:nil];
    }
    return YES;
}
//用规则获取webView 中得授权码
- (NSString *)getVeriferFromHtml:(NSString *)htmlStr
{
    
    NSString *str = [htmlStr stringByMatching:@"<span class=\"pin\" id=\"verifier\">([0-9]*)</span>" capture:1];
    
    return str;
}

#pragma mark 按钮函数

//授权按钮
- (IBAction)buttonSubmitVerifyClicked:(id)sender {
    if ([self.textFieldVerify.text length] == 0 && !self.isVerifing) {
        return;
    }
    self.isVerifing = YES;
    [self.textFieldVerify resignFirstResponder];
    [self.weiboApi getAccessTokenWithOauthToken:self.oauthToken andOauthTokenSecret:self.stringOauthTokenSecret andVerifier:self.textFieldVerify.text];
}


- (void)showActivityIndicator
{
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
}

- (void)hideActivityIndicator
{
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
}

-(NSString*) valueForKey:(NSString *)key ofQuery:(NSString*)query
{
    NSArray *pairs = [query componentsSeparatedByString:@"&"];
    for(NSString *aPair in pairs){
        NSArray *keyAndValue = [aPair componentsSeparatedByString:@"="];
        if([keyAndValue count] != 2) continue;
        if([[keyAndValue objectAtIndex:0] isEqualToString:key]){
            return [keyAndValue objectAtIndex:1];
        }
    }
    return nil;
}
#pragma mark homeContrllerDelegate
-(void)oauthFinsh
{
    NSLog(@"home delegate");
    [self dismissViewControllerAnimated:YES completion:nil];
//    [self presentViewController:self.home animated:YES completion:nil];
    //1.取得通知中心
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    //2.发送广播
    [nc postNotificationName:@"refreshHomeWeibo" object:self userInfo:nil];
}
@end
