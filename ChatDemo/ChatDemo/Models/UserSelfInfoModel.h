//
//  UserSelfInfoModel.h
//  ChatDemo
//
//  Created by ios on 17/4/19.
//  Copyright © 2017年 YC_Z. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface UserSelfInfoModel : NSObject
@property (nonatomic ,strong)NSString *uid;                 //用户id
@property (nonatomic ,strong)NSString *rtoken;          //融云的token
@property (nonatomic ,strong)NSString *uimg;            //头像
@property (nonatomic ,strong)NSNumber *ugender;     //用户性别
@property (nonatomic ,strong)NSNumber *umoney;     //用户金币
@property (nonatomic ,strong)NSString *uname;     //用户金币



+ (UserSelfInfoModel *)shareModel;

+ (UserSelfInfoModel *)shareModelWithDict:(NSDictionary *)dict;
@end
