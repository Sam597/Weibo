//
//  WeiboCell.h
//  DoubanMovie
//
//  Created by 阿满 on 14-7-22.
//  Copyright (c) 2014年 man_sam. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WeiboModel;
@class WeiboView;
@class RTLabel;

@interface WeiboCell : UITableViewCell{
    UIImageView             *_userImage;            //用户头像视图
    UILabel                 *_nickLabel;            //昵称
    UILabel                 *_repostCountLabel;     //转发数
    UILabel                 *_commentLabel;         //回复数
    RTLabel                 *_sourceLabel;           //发布来源
    UILabel                 *_createLabel;          //发布时间
    UILabel                 *_attitudesLabel;        //赞
    float                   h;                      //微博高度
}


//微博数据模型对象
@property(nonatomic,retain)WeiboModel *weiboModel;
//微博视图
@property(nonatomic,retain)WeiboView *weiboView;

@end
