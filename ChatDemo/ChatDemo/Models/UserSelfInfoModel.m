//
//  UserSelfInfoModel.m
//  ChatDemo
//
//  Created by ios on 17/4/19.
//  Copyright © 2017年 YC_Z. All rights reserved.
//

#import "UserSelfInfoModel.h"
static UserSelfInfoModel *model = NULL;
static dispatch_once_t once;

@implementation UserSelfInfoModel

- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    
    
}
+ (UserSelfInfoModel *)shareModel{
    
    dispatch_once(&once
                  , ^{
                      model = [[UserSelfInfoModel alloc]init];
                  });
    
    return model;
    
    
}

+ (UserSelfInfoModel *)shareModelWithDict:(NSDictionary *)dict
{
    NSMutableDictionary *dataDict  = [[NSMutableDictionary alloc]initWithDictionary:dict];
    
    UserSelfInfoModel *model = [UserSelfInfoModel shareModel];
    if(dict[@"uid"])
    {
        dataDict[@"uid"] = [NSString stringWithFormat:@"%@",dict[@"uid"]];
    }
    [model setValuesForKeysWithDictionary:dataDict];
    return model;
    
}
@end
