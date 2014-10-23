//
//  accreditWevView.h
//  WangyiWeibo
//
//  Created by 阿满 on 14-10-15.
//  Copyright (c) 2014年 man_sam. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WeiboCommonAPI.h"
#import "HomeViewController.h"


@interface AccreditWebView : UIViewController<UIWebViewDelegate,HomeContrllerDelegate>
@property (strong, nonatomic) IBOutlet UIWebView *webView;

@property (strong, nonatomic) IBOutlet UITextField *textFieldVerify;
- (IBAction)buttonSubmitVerifyClicked:(id)sender;

//授权所用外部传入

@property (nonatomic, retain) NSString *oauthToken;
@property (nonatomic, retain) NSString *stringOauthTokenSecret;
@property (nonatomic, assign) BOOL isVerifing;
@property (nonatomic, retain) WeiboCommonAPI *weiboApi;
@property (nonatomic, retain) HomeViewController *home;
@end
