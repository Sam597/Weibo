//
//  AboutMeViewController.m
//  WangyiWeibo
//
//  Created by 阿满 on 14-9-30.
//  Copyright (c) 2014年 man_sam. All rights reserved.
//

#import "AboutMeViewController.h"
#import "WeiboCommonAPI.h"

@interface AboutMeViewController ()

@end

@implementation AboutMeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"我";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)RemoveOAuth:(id)sender {
     [WeiboCommon deleteWeiboInfo];
}
@end
