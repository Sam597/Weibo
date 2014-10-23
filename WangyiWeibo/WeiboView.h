//
//  WeiboView.h
//  DoubanMovie
//
//  Created by 阿满 on 14-7-22.
//  Copyright (c) 2014年 man_sam. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RTLabel.h"
@class WeiboModel;
@class WeiboView;
@class RelWeiboModel;
@interface WeiboView : UIView<RTLabelDelegate>
{
@private
    RTLabel             *_textLabel;        //微博内容
    RTLabel             *_repostTextLabel;  //转发微博内容
    UIImageView         *_image;            //微博图片
    UIImageView         *_repostImage;            //转发微博图片
    UIImageView         *_repostBackgroudView;//转发微博视图背景
    int                 num;
}

//微博数据模型对象
@property(nonatomic,retain)WeiboModel *weiboModelData;
@property(nonatomic,retain)WeiboModel *relWeiboModelData;
//转发的微博视图
@property(nonatomic,retain)WeiboView *repostView;

@property(nonatomic,assign)BOOL isRepost;//当前的微博视图，是否是转发

@property(nonatomic,assign)NSString *imgUrl;//微博图片url

//计算微博视图的高度
+ (CGFloat)getWeiboViewHeight:(WeiboModel *)weiboModel isRepost:(BOOL)isRepost;
//加载视图
-(void)loadView;


@end
