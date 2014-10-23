//
//  WeiboView.m
//  DoubanMovie
//
//  Created by 阿满 on 14-7-22.
//  Copyright (c) 2014年 man_sam. All rights reserved.
//

#import "WeiboView.h"
#import "WeiboModel.h"
#import "UIImageView+WebCache.h"
#import "RTLabel.h"

@implementation WeiboView


@synthesize weiboModelData;
@synthesize relWeiboModelData;
@synthesize repostView;
@synthesize isRepost;
@synthesize imgUrl;

#define WEIBO_FONT_SIZE 14.0f
#define REPOST_FONT_SIZE 12.0f
#define WEIBO_CONTENT_WIDTH 250.0f
#define REPOST_CONTENT_WIDTH 230.0f
#define CONTENT_MARGIN 5.0f

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self _initWithParameter];
    }
    return self;
}


-(void)_initWithParameter
{
    _textLabel = [[RTLabel alloc] init];
    _repostTextLabel = [[RTLabel alloc] init];
    _image = [[UIImageView alloc] init];
    _repostImage = [[UIImageView alloc] init];
    _repostBackgroudView = [[UIImageView alloc] init];
    
    //----------------添加到视图---------------------
    [self addSubview:_repostBackgroudView ];
    [self addSubview:_textLabel];
    [self addSubview:_repostTextLabel];
    [self addSubview:_repostImage];
    [self addSubview:_image];
    
    
    
    
}
//初始化视图
-(void)loadView
{
    //----------------微博内容——textLabel子视图-------------------
    NSArray * textArray;
    //原微博
    textArray = [weiboModelData.text componentsSeparatedByCharactersInSet:[NSCharacterSet                                            characterSetWithCharactersInString:@" "]];
    
    _textLabel.frame = CGRectMake(0, 0, self.bounds.size.width, 0);
    float kLineSpacing = 9.0;
    [_textLabel setLineSpacing:kLineSpacing];
    //分离微博内容和图片

//    NSLog(@"text:%@",textArray);
    //处理微博内容 原微博
    NSArray *weiboText = [self exploed:@"1" array:textArray];
    _textLabel.font = [UIFont fontWithName:@"Helvetica" size:WEIBO_FONT_SIZE];
    _textLabel.text = [NSString stringWithFormat:@"<font kern=0.5>%@</font>",[weiboText objectAtIndex:0]];
    
    //文本内容尺寸
    CGSize textSize = _textLabel.optimumSize;
     _textLabel.frame = CGRectMake(0, 0, self.bounds.size.width, textSize.height);

    //设置颜色
    _textLabel.textColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1];
    
    //判断当前视图是否为转发微博
    if ([weiboModelData.flag isEqual:@"RETWEET"]) {
        //转发微博
        textArray = [weiboModelData.root_in_reply_to_status_text componentsSeparatedByCharactersInSet:[NSCharacterSet                                            characterSetWithCharactersInString:@" "]];
        //处理微博内容 转发微博
        NSArray *weiboRopostText = [self exploed:@"2" array:textArray];
        _repostTextLabel.text =[NSString stringWithFormat:@"<font kern=0.5>@%@：%@ </font>",weiboModelData.root_in_reply_to_user_name,[weiboRopostText objectAtIndex:0]];
        _repostTextLabel.frame = CGRectMake(10, _textLabel.frame.origin.y+CONTENT_MARGIN , REPOST_CONTENT_WIDTH, 100);
        _repostTextLabel.font = [UIFont fontWithName:@"Helvetica" size:REPOST_FONT_SIZE];
        //文本内容尺寸
        CGSize textSize = _repostTextLabel.optimumSize;

        _repostTextLabel.frame = CGRectMake(10, _textLabel.frame.origin.y+CONTENT_MARGIN , REPOST_CONTENT_WIDTH, textSize.height);
        
    }
    //--------------======================转发微博视图repostView=============================--------
    //转发微博model

    if ([weiboModelData.flag isEqual:@"RETWEET"]) {
        self.isRepost = YES;
    }
    
    
    
    //----------------微博图片视图image-----------------
    NSString *thumbnailImage = imgUrl;
    
    if (thumbnailImage != nil && ![@"" isEqualToString:thumbnailImage]) {
        _image.hidden = NO;
        //微博图片
        if (self.isRepost) {
            _image.frame = CGRectMake(20, _repostTextLabel.frame.size.height+5, 60, 60);
        }else{
            _image.frame = CGRectMake(10, _textLabel.frame.size.height+5, 60, 60);
        }
        
        
        //加载网络图片数据
        [_image setImageWithURL:[NSURL URLWithString:thumbnailImage]];
        _image.backgroundColor=[UIColor redColor];
        
    }else{
        _image.hidden = YES;
    }
    //--------------转发微博视图背景 repostBackgroundView------------
    if (self.isRepost) {
        
        _repostBackgroudView.frame = CGRectMake(10, _textLabel.frame.size.height+CONTENT_MARGIN , REPOST_CONTENT_WIDTH, _repostTextLabel.frame.size.height);;
        _repostBackgroudView.backgroundColor = [UIColor colorWithRed:246/255.0 green:246/255.0 blue:246/255.0 alpha:1];
        _repostBackgroudView.hidden = NO;
    }else{
        _repostBackgroudView.hidden = YES;
    }
}

-(NSArray *)exploed:(NSString *)type array:(NSArray *)array
{
    imgUrl = nil;
    NSString *weiboText;
    if(array.count > 2 || array.count == 2){
        NSString *t0 = [array objectAtIndex:0];
        NSString *t1 = [array objectAtIndex:1];
        if([t0 hasPrefix:@"http://126.fm/"]){
            imgUrl = t0;
            weiboText = t1;
        }else{
            if ([t1 hasPrefix:@"http://126.fm/"]) {
                imgUrl = t1;
                weiboText = t0;
            } else {
                weiboText = weiboModelData.text;;
            }
        }
    }else{
        weiboText = [array objectAtIndex:0];
    }
    
    NSArray *data = [[NSArray alloc] init];
    if ([type isEqual:@"1"]) {
        //如果是原微博传送text 回去
        
        data = [NSArray arrayWithObjects:weiboText,imgUrl, nil];
    }
    else {
        //如果是转发的微博传送root_in_reply_to_status_text这个值回去
        data = [NSArray arrayWithObjects:weiboModelData.root_in_reply_to_status_text,imgUrl, nil];
    }
    return data;
}
//
//-(void)loadView
//{
//    _textLabel.text = weiboModelData.text;
//}

+ (CGFloat)getWeiboViewHeight:(WeiboModel *)GetWeiboModel isRepost:(BOOL)isRepost
{
    //原微博数据
    NSArray *array = [GetWeiboModel.text componentsSeparatedByCharactersInSet:[NSCharacterSet                                            characterSetWithCharactersInString:@" "]];
    //转发微博数据
    NSString *imgUrl = nil;
    NSString *imgRosUrl = nil;
    if ([@"RETWEET" isEqualToString:GetWeiboModel.flag]) {
        NSArray *arrayRos = [GetWeiboModel.root_in_reply_to_status_text componentsSeparatedByCharactersInSet:[NSCharacterSet                                            characterSetWithCharactersInString:@" "]];
        
        if(arrayRos.count > 2 || arrayRos.count == 2){
            NSString *t0 = [arrayRos objectAtIndex:0];
            NSString *t1 = [arrayRos objectAtIndex:1];
            
            if([t0 hasPrefix:@"http://126.fm/"]){
                imgRosUrl = t0;
            }else{
                if ([t1 hasPrefix:@"http://126.fm/"]) {
                    imgRosUrl = t1;
                }
            }
        }
    }

    if(array.count > 2 || array.count == 2){
        NSString *t0 = [array objectAtIndex:0];
        NSString *t1 = [array objectAtIndex:1];
        if([t0 hasPrefix:@"http://126.fm/"]){
            imgUrl = t0;
        }else{
            if ([t1 hasPrefix:@"http://126.fm/"]) {
                imgUrl = t1;
            }
        }
    }

    
    
    //判断是否为转发微博
    if ([@"RETWEET" isEqualToString:GetWeiboModel.flag]) {
        
        NSString *text =GetWeiboModel.text;
        NSString *reText =GetWeiboModel.root_in_reply_to_status_text;
        CGSize size = CGSizeMake(WEIBO_CONTENT_WIDTH,CGFLOAT_MAX);;
        UIFont *font = [UIFont fontWithName:@"Helvetica" size:WEIBO_FONT_SIZE];
        
        CGSize reSize = CGSizeMake(REPOST_CONTENT_WIDTH,CGFLOAT_MAX);
        UIFont *reFont = [UIFont fontWithName:@"Helvetica" size:REPOST_FONT_SIZE];
        
        CGSize labelsize = [text sizeWithFont:font constrainedToSize:size lineBreakMode:NSLineBreakByWordWrapping];
        CGSize reLabelsize = [reText sizeWithFont:font constrainedToSize:size lineBreakMode:NSLineBreakByWordWrapping];
        
        float h3 = labelsize.height+reLabelsize.height;//15底边距
        //转发了别人的微博带图片
        if (imgRosUrl.length > 0) {
            return h3+60;
        }else{
            return h3;
        }
        
    }else{//不是转发微博

        CGSize reSize = CGSizeMake(REPOST_CONTENT_WIDTH,CGFLOAT_MAX);
        UIFont *reFont = [UIFont fontWithName:@"Helvetica" size:REPOST_FONT_SIZE];
        CGSize labelsize = [GetWeiboModel.text sizeWithFont:reFont constrainedToSize:reSize lineBreakMode:NSLineBreakByWordWrapping];
        //判断是否转发微博有图片
        if ( imgUrl.length > 0 ) {//转发微博有图
            return labelsize.height+60;//10文字上方间距 5 图片上边距 60 图片 10 图片下边距
        }else//转发微博无图
        {
            return labelsize.height+10;
        }
    }

//float h = 200.0;
//return h;
}


#pragma mark -rtLabel delegate
- (void)rtLabel:(id)rtLabel didSelectLinkWithURL:(NSURL*)url
{
    
}

#pragma mark dealloc
-(void)dealloc
{
//    [super dealloc];
//    [_image release];
//    [_textLabel release];
//    [_repostBackgroudView release];
    
}
@end
