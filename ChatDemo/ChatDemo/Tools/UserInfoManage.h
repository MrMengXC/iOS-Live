//
//  UserInfoManage.h
//  ChatDemo
//
//  Created by ios on 17/6/2.
//  Copyright © 2017年 YC_Z. All rights reserved.
//


#import <Foundation/Foundation.h>
/**
 用户信息管理
 */
@interface UserInfoManage : NSObject
/**
 设置用户头像
*/
+ (void)setUserPhotoWithImage:(UIImage *)userPhoto
                 successBlock:(upSuccessBlock)successBlock
                   faileBlock:(ResultBlock)faileBlock;
@end
