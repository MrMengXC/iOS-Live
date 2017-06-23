//
//  CustomMessageContent.h
//  ChatDemo
//
//  Created by ios on 17/4/19.
//  Copyright © 2017年 YC_Z. All rights reserved.
//

#import <RongIMLib/RongIMLib.h>

#define RCDCustomMessageTypeIdentifier @"RCD:CusMsg"


@interface CustomMessageContent : RCMessageContent<NSCoding>
@property (nonatomic ,strong)NSDictionary *dataDict;



+ (instancetype)messageWithDict:(NSDictionary *)dict;

@end
