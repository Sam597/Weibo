//
//  WeiboCell.m
//  DoubanMovie
//
//  Created by 阿满 on 14-7-22.
//  Copyright (c) 2014年 man_sam. All rights reserved.
//

#import "WeiboCell.h"
#import "WeiboView.h"
#import "WeiboModel.h"
#import "RTLabel.h"
#import "UIImageView+WebCache.h"

@implementation WeiboCell
@synthesize weiboModel;
@synthesize weiboView;


#define CONTENT_MARGIN 10.0f

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        [self _initView];
    }
    return self;
}


- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}



//初始化子视图
-(void)_initView
{
    //用户头像
    _userImage = [[UIImageView alloc] initWithFrame:CGRectZero];
    _userImage.backgroundColor = [UIColor clearColor];
    _userImage.layer.cornerRadius = 5; //圆弧半径
    _userImage.layer.borderWidth = .5;
    _userImage.layer.borderColor = [UIColor grayColor].CGColor;
    _userImage.layer.masksToBounds = YES;
    [self.contentView addSubview:_userImage];
    
    //昵称
    _nickLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    _nickLabel.backgroundColor = [UIColor clearColor];
    _nickLabel.font = [UIFont systemFontOfSize:14.0];
    _nickLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:16];
    
    [self.contentView addSubview:_nickLabel];

    //转发数
    _repostCountLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    _repostCountLabel.font = [UIFont systemFontOfSize:10.0];
    _repostCountLabel.backgroundColor = [UIColor clearColor];
    _repostCountLabel.textColor = [UIColor grayColor];
    [self.contentView addSubview:_repostCountLabel];
    
    //回复数
    _commentLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    _commentLabel.font = [UIFont systemFontOfSize:10.0];
    _commentLabel.backgroundColor = [UIColor clearColor];
    _commentLabel.textColor = [UIColor grayColor];
    [self.contentView addSubview:_commentLabel];
    
    //发布来源
    _sourceLabel = [[RTLabel alloc] init];
    _sourceLabel.font = [UIFont systemFontOfSize:10.0];
    _sourceLabel.backgroundColor = [UIColor clearColor];
    _sourceLabel.textColor = [UIColor grayColor];
    [self.contentView addSubview:_sourceLabel];
    
    //发布时间
    _createLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    _createLabel.font = [UIFont systemFontOfSize:10.0];
    _createLabel.backgroundColor = [UIColor clearColor];
    _createLabel.textColor = [UIColor blackColor];
    [self.contentView addSubview:_createLabel];
    
    //赞
    _attitudesLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    _attitudesLabel.font = [UIFont systemFontOfSize:12.0];
    _attitudesLabel.backgroundColor = [UIColor clearColor];
    _attitudesLabel.textColor = [UIColor blackColor];
    [self.contentView addSubview:_attitudesLabel];
    
    weiboView = [[WeiboView alloc] initWithFrame:CGRectZero];
    [self.contentView addSubview:weiboView];
    
}

-(void)layoutSubviews
{
    [super layoutSubviews];
//    NSLog(@"bbb :%@",weiboModel);
    //------------用户头像视图----------------
    _userImage.frame = CGRectMake(5, CONTENT_MARGIN, 35, 35);
    // _userImage.backgroundColor = [UIColor redColor];
    NSString *userImageUrl =  weiboModel.user.profile_image_url;
    [_userImage setImageWithURL:[NSURL URLWithString:userImageUrl]];
//    NSLog(@"ddd: %@",weiboModel);

//    //------------用户昵称--------------------
    _nickLabel.frame = CGRectMake(50, CONTENT_MARGIN, 260, 20);
    _nickLabel.text = weiboModel.user.name;

    //------------发布时间-------------------
    _createLabel.frame = CGRectMake(_nickLabel.bounds.size.width+10, CONTENT_MARGIN, 50, 20);
    //时间戳转换
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];                //时间处理类
    [dateFormatter setDateFormat:@"ccc M d HH:mm:ss Z yyyy"];                       //设置时间格式
    NSString *weidate = weiboModel.created_at;                                      //API发布时间 Sat Apr 19 02:16:10 +0800 2014
    //    NSLog(@"api调取的发布时间：%@",weidate);
    NSDate *createTime = [dateFormatter dateFromString:weidate];                      //把API发布时间转换为时间戳
    //    NSLog(@"微博发布时间转换的时间戳:%ld",(long) [weidates timeIntervalSince1970]);     //
    //    NSString *weiBoDate = [dateFormatter stringFromDate:weidates];                  //测试把时间戳转换为时间
    //    NSLog(@"微博发布时间转换时间戳转换为时间：%@",weiBoDate);                             //
    //比较当前时间与微博发布时间
    NSString *timeDifference = [self compareCurrentTime:createTime];
//    [dateFormatter release];
    _createLabel.textColor = [UIColor orangeColor];
    _createLabel.text = timeDifference;
    
    //-------------微博视图--------------------
    weiboView.isRepost = NO;
    h =  [WeiboView getWeiboViewHeight:weiboModel isRepost:NO];
    weiboView.frame = CGRectMake(50, _nickLabel.frame.size.height+15, (320-60), h+50);
    weiboView.weiboModelData = weiboModel;
    [weiboView loadView];
    //    weiboView.backgroundColor = [UIColor redColor];
    //-----------来源-------------------------
    _sourceLabel.frame = CGRectMake(50, weiboView.frame.size.height+19, 100, 16);
    _sourceLabel.text = [NSString stringWithFormat:@"来自：%@",weiboModel.source];
    //    _sourceLabel.backgroundColor = [UIColor orangeColor];
    //--------------转发----------------------
    _repostCountLabel.frame = CGRectMake(180, weiboView.frame.size.height+15, 60, 20);
    _repostCountLabel.text = [NSString stringWithFormat:@"转发数：%@",weiboModel.retweet_count];
    //    _repostCountLabel.backgroundColor = [UIColor blueColor];
    
    //--------------评论-----------------------
    _commentLabel.frame = CGRectMake(245, weiboView.frame.size.height+15, 60, 20);
    _commentLabel.text = [NSString stringWithFormat:@"评论数：%@",weiboModel.comments_count];
    //    _commentLabel.backgroundColor = [UIColor brownColor];
    
    
}

/**
 * 计算指定时间与当前的时间差
 * @param compareDate   某一指定时间
 * @return 多少(秒or分or天or月or年)+前 (比如，3天前、10分钟前)
 */
-(NSString *) compareCurrentTime:(NSDate*) compareDate
//
{
    NSTimeInterval  timeInterval = [compareDate timeIntervalSinceNow];
    timeInterval = -timeInterval;
    long temp = 0;
    NSString *result;
    if (timeInterval < 60) {
        result = @"刚刚";
    }
    else if((temp = timeInterval/60) <60){
        result = [NSString stringWithFormat:@"%ld分前",temp];
    }
    
    else if((temp = temp/60) <24){
        result = [NSString stringWithFormat:@"%ld小时前",temp];
    }
    
    else if((temp = temp/24) <30){
        result = [NSString stringWithFormat:@"%ld天前",temp];
    }
    
    else if((temp = temp/30) <12){
        result = [NSString stringWithFormat:@"%ld月前",temp];
    }
    else{
        temp = temp/12;
        //        result = [NSStringstringWithFormat:@"%d年前",temp];
        result = [NSString stringWithFormat:@"%ld年前",temp];
    }
    
    return  result;
}
#pragma mark dealloc
-(void)dealloc
{
//    [super dealloc];
//    [_userImage release];
//    [_nickLabel release];
//    [_userImage release];
//    [_repostCountLabel release];
//    [_commentLabel release];
//    [_sourceLabel release];
//    [_createLabel release];
//    [_attitudesLabel release];
//    [_sourceLabel release];
//    [weiboView release];
//    [weiboModel release];
}
@end
