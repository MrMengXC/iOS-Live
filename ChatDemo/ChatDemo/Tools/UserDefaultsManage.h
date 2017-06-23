//
//  UserDefaultsManage.h
//  ChatDemo
//
//  Created by ios on 17/6/1.
//  Copyright © 2017年 YC_Z. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserDefaultsManage : NSObject


+ (void)saveUserId:(NSString *)uid;
+(NSString *)getUserId;
@end
