//
//  ChatMessageModel.h
//  ChatDemo
//
//  Created by ios on 17/4/18.
//  Copyright © 2017年 YC_Z. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ChatMessageModel : NSObject
@property (nonatomic ,assign)ChatMessageType msgType;
//Common
@property (nonatomic ,strong)NSString * sendUserId;

//TEXT
@property (nonatomic ,strong)NSString * message;


+ (ChatMessageModel *)shareModelWithMessage:(RCMessage *)message;

@end
