//
//  UserProductModel.m
//  ChatDemo
//
//  Created by ios on 17/5/19.
//  Copyright © 2017年 YC_Z. All rights reserved.
//

#import "UserProductModel.h"

@implementation UserProductModel

- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    
}
+ (UserProductModel *)shareModelWithDict:(NSDictionary *)dict
{
    
    UserProductModel *model = [[UserProductModel alloc]init];
    
    [model setValuesForKeysWithDictionary:dict];
    
    return model;
}
@end
