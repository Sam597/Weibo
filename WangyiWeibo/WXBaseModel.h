//
//  WXBaseModel.h
//  DoubanMovie
//
//  Created by 阿满 on 14-7-24.
//  Copyright (c) 2014年 man_sam. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WXBaseModel : NSObject <NSCoding>{
    
}
-(id)initWithDataDic:(NSDictionary*)data; //根据出过来的字典创建对象
- (NSDictionary*)attributeMapDictionary; //属性映射字典
- (void)setAttributes:(NSDictionary*)dataDic;//根据键值映射到字典里
- (NSString *)customDescription;//自定义描述
- (NSString *)description;
- (NSData*)getArchivedData; //归档数据

- (NSString *)cleanString:(NSString *)str;    //清除\n和\r的字符串
@end
