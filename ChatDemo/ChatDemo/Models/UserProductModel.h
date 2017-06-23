//
//  UserProductModel.h
//  ChatDemo
//
//  Created by ios on 17/5/19.
//  Copyright © 2017年 YC_Z. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserProductModel : NSObject


@property (nonatomic ,strong)NSString *poriurl;                 //原始图片
@property (nonatomic ,strong)NSNumber *pid;                 //作品id
@property (nonatomic ,strong)NSNumber *ptype;           //作品类型
@property (nonatomic ,strong)NSNumber *uid;                 //上传的用户id
@property (nonatomic ,strong)NSNumber *goods;                 //上传的用户id
@property (nonatomic ,strong)NSNumber *isgood;                 //是否点过赞

@property (nonatomic ,strong)NSString *ptime;                   //时间
@property (nonatomic ,strong)NSString * pauther;         //作者
@property (nonatomic ,strong)NSString *pvideourl;     //视频url
@property (nonatomic ,strong)NSString *pthumburl;       //缩略图url


+ (UserProductModel *)shareModelWithDict:(NSDictionary *)dict;



@end
