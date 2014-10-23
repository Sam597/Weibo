//
//  HomeViewController.m
//  WangyiWeibo
//
//  Created by 阿满 on 14-9-30.
//  Copyright (c) 2014年 man_sam. All rights reserved.
//

#import "HomeViewController.h"
#import "AppDelegate.h"
#import "ASIHTTPRequest.h"
#import "AccreditWebView.h"
#import "MJRefresh.h" //tableview 上拉 下拉 刷新
#import "WeiboCell.h"
#import "WeiboView.h"
#import "WeiboModel.h"

NSString *const MJTableViewCellIdentifier = @"Cell";

@interface HomeViewController ()

@end

@implementation HomeViewController
@synthesize weiboApi;
@synthesize stringOauthToken, stringOauthTokenSecret,weiboModels;
@synthesize rightBar;
@synthesize aWebView;
@synthesize delegate;
@synthesize oauthKey;
@synthesize weiboTableView;

//获取设备的物理高度
#define ScreenHeight [UIScreen mainScreen].bounds.size.height
//获取设备的物理宽度
#define ScreenWidth [UIScreen mainScreen].bounds.size.width
#define WEIBO_OTHER_MARGIN  90.0f

-(id)init
{
    self = [super init];
    if (self) {
        //头部呼出左侧页面按钮
        UIBarButtonItem *leftBar = [[UIBarButtonItem alloc] initWithTitle:@"三" style:UIBarButtonItemStylePlain target:self action:nil];
        self.navigationItem.leftBarButtonItem = leftBar;
        //首页右部按钮
        self.navigationItem.rightBarButtonItem = rightBar;
        
    }
    return self;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"首页";
    self.appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    self.weiboApi = self.appDelegate.weiboApi;
    //设置asi代理
    weiboApi.delegate = self;
    self.rightBar = [[UIBarButtonItem alloc] initWithTitle:@"刷新" style:UIBarButtonItemStylePlain target:self action:@selector(ReloadWeibo)];
    //判断是否已经绑定微博账号
    if (![WeiboCommon checkHasBinding]) {
        [self Login];
        
    }else {
        //获取微博数据
        [weiboApi getHomeWeiboData];
    }
    
    
    
    self.navigationItem.rightBarButtonItem = rightBar;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
//登录
-(void)Login {
    NSLog(@"Login");
    [self showActivityIndicator];
   //创建同步ASI请求
    [weiboApi getOauthToken];
}

//刷新微博列表
-(void)ReloadWeibo
{
    NSLog(@"刷新微博列表");
    [self.weiboTableView headerBeginRefreshing];
}

#pragma mark 公用函数
- (void)showActivityIndicator
{
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
}

- (void)hideActivityIndicator
{
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
}

- (void)showOauthTokenError
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"增加失败，请稍后重试" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
    [alert show];
//    [alert release];
}

#pragma mark 获取微博列表数据
-(void)requestHomeTimeline{
    [weiboApi getHomeWeiboData];
}

#pragma mark weiboCommonApi delegate
//oauth token获取成功
- (void)getOauthTokenSuccess:(WeiboCommonAPI*)api andOauthToken:(NSString *)oauthToken andOauthTokenSecret:(NSString *)oauthTokenSecret{
    //获取oauth_token后 用token获取access_token
    [self hideActivityIndicator];
    self.stringOauthToken = oauthToken;
    self.stringOauthTokenSecret = oauthTokenSecret;
    
    //webview加载 请求accessToken
    aWebView = [[AccreditWebView alloc] init];
    self.aWebView.oauthToken = oauthToken;
    self.aWebView.stringOauthTokenSecret = stringOauthTokenSecret;
    self.aWebView.isVerifing = isVerifing;
     self.aWebView.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    [self presentViewController:self.aWebView animated:YES completion:nil];
}

//oauthToken获取失败
- (void)getOauthTokenFailed:(WeiboCommonAPI *)api
{
    [self hideActivityIndicator];
    [self showOauthTokenError];
}

/*
 当获取到正确的AccessToken时，获取用户的信息，主要是用户昵称
 */
- (void)getaccesstokenSuccess:(WeiboCommonAPI *)api
{
    self.appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    self.weiboApi = self.appDelegate.weiboApi;
    NSLog(@"getaccesstokenSuccess:(WeiboCommonAPI *)api");
    [weiboApi getUserInfo];
    isVerifing = NO;
}
//获取accessToken失败
- (void)getAccessTokenFailed:(WeiboCommonAPI *)api
{
    NSLog(@"getAccessTokenFailed:(WeiboCommonAPI *)api");
    [self showOauthTokenError];
    isVerifing = NO;
}

//获取userInfo 成功
- (void)getUserInfoSuccess:(WeiboCommonAPI *)api andUserName:(NSString *)userName
{
    
    if(!self.weiboTableView){
        [self.view reloadInputViews];
        [weiboApi getHomeWeiboData];
    }
    [self.weiboApi getHomeWeiboData];
    
    //跳转
    if (delegate && [delegate respondsToSelector:@selector(oauthFinsh)]) {
        [delegate oauthFinsh];
    }
}

//获取accessToken失败
- (void)getUserInfoFailed:(WeiboCommonAPI *)api
{
//    [self switchToPublishMode];
     NSLog(@"getUserInfoFailed");
}

//微博数据获取成功
- (void)getHomeWeiboDataSuccess:(WeiboCommonAPI*)api andWeiboModel:(NSMutableArray *)weiboListModel{
    
    self.weiboModels = [NSMutableArray arrayWithCapacity:100];
    self.weiboModels = weiboListModel;
    //----------------初始化tableview-------------
    self.weiboTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 55, ScreenWidth, ScreenHeight-55) style:UITableViewStylePlain];
    self.weiboTableView.delegate = self;
    self.weiboTableView.dataSource = self;
    // 1.注册cell
    [self.weiboTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:MJTableViewCellIdentifier];
    
    // 2.集成刷新控件
    [self setupRefresh];
    
    
    [self.view addSubview:self.weiboTableView];
    
    //---------------初始化tableview end-------------------
}

//微博数据获取失败
- (void)getHomeWeiboDataFailed:(WeiboCommonAPI*)api{
    NSLog(@"获取微博失败！");
}


#pragma mark tableView delegate
//设置行高
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSArray *weiboArray = [self.weiboModels objectAtIndex:indexPath.row];
    WeiboModel *weiboModelRow = (WeiboModel *)weiboArray;
    float h = [WeiboView getWeiboViewHeight:weiboModelRow isRepost:NO] + WEIBO_OTHER_MARGIN;
//        float h = 300;
    return h;
}
#pragma mark tablView dataSource
//表视图中得section中有多少行rows
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.weiboModels count];
//    return 2;
}
//表视图中cell 填充单元格内容
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    //------------------添加cell-----------------
//    static NSString *CellIdentifier = @"cell";
//    _weiboCell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
//    if (_weiboCell == nil) {
//        _weiboCell = [[WeiboCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
//    }
//    NSArray *weiboArray = [self.weiboModels objectAtIndex:indexPath.row];
//    _weiboCell.weiboModel = (WeiboModel *)weiboArray;
//    [self.view addSubview:_weiboCell];
//
//    return _weiboCell;
    //------------------添加cell-----------------
    //添加cell
    _weiboCell = [[WeiboCell alloc] init];
    
    NSArray *weiboArray = [self.weiboModels objectAtIndex:indexPath.row];
    //    NSLog(@"数据：%@",weiboArray);
    _weiboCell.weiboModel = (WeiboModel *)weiboArray;
    [self.view addSubview:_weiboCell];
    //    [[_weiboCell layer] setBorderWidth:2.0f];
    
    return _weiboCell;
}

//----------------------------tableview 上拉 下拉刷新-------------------------------

/**
 *  集成刷新控件
 */
- (void)setupRefresh
{
    // 1.下拉刷新(进入刷新状态就会调用self的headerRereshing)
    [self.weiboTableView  addHeaderWithTarget:self action:@selector(headerRereshing)];
//#warning 自动刷新(一进入程序就下拉刷新)
    [self.weiboTableView headerBeginRefreshing];
    
    // 2.上拉加载更多(进入刷新状态就会调用self的footerRereshing)
    [self.weiboTableView addFooterWithTarget:self action:@selector(footerRereshing)];
    
    // 设置文字(也可以不设置,默认的文字在MJRefreshConst中修改)
    self.weiboTableView.headerPullToRefreshText = @"下拉可以刷新了";
    self.weiboTableView.headerReleaseToRefreshText = @"松开马上刷新了";
    self.weiboTableView.headerRefreshingText = @"哥正在刷新中";
    
    self.weiboTableView.footerPullToRefreshText = @"上拉可以加载更多数据了";
    self.weiboTableView.footerReleaseToRefreshText = @"松开马上加载更多数据了";
    self.weiboTableView.footerRefreshingText = @"正在加载中";
}

#pragma mark 开始进入刷新状态

- (void)headerRereshing
{
    //添加真数据
    NSArray *weiboArray = [self.weiboModels objectAtIndex:0];
    WeiboModel *weiboModelRow = (WeiboModel *)weiboArray;
//    [self rereshingApi:weiboModelRow.cursor_id andRereshType:@"max_id"];
//    NSLog(@"cursor_id :%@",weiboModelRow.cursor_id);
    [weiboApi getHomeRereshWeiboDataWithCursorId:weiboModelRow.cursor_id andType:@"max_id"];
    
    // 2.2秒后刷新表格UI
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        // 刷新表格
        [self.weiboTableView reloadData];
        
        // (最好在刷新表格后调用)调用endRefreshing可以结束刷新状态
        [self.weiboTableView headerEndRefreshing];
    });
}

- (void)footerRereshing
{
    //添加真数据
//    [self rereshingApi:self.weiboModel.cursor_id andRereshType:@"since_id"];
    NSArray *weiboArray = [self.weiboModels objectAtIndex:[self.weiboModels count]-1];
    WeiboModel *weiboModelRow = (WeiboModel *)weiboArray;
    [weiboApi getHomeRereshWeiboDataWithCursorId:weiboModelRow.cursor_id andType:@"since_id"];
    // 2.2秒后刷新表格UI
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        // 刷新表格
        [self.weiboTableView reloadData];
        
        // (最好在刷新表格后调用)调用endRefreshing可以结束刷新状态
        [self.weiboTableView footerEndRefreshing];
    });
}


@end
