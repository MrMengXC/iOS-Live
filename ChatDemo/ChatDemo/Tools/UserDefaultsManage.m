//
//  UserDefaultsManage.m
//  ChatDemo
//
//  Created by ios on 17/6/1.
//  Copyright © 2017年 YC_Z. All rights reserved.
//

#import "UserDefaultsManage.h"

@implementation UserDefaultsManage



+ (void)saveUserId:(NSString *)uid
{
    [[NSUserDefaults standardUserDefaults]setObject:uid forKey:@"userid"];
}
+ (NSString *)getUserId
{
    return [[NSUserDefaults standardUserDefaults]objectForKey:@"userid"];
}
@end
