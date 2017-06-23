//
//  ChatMessageModel.m
//  ChatDemo
//
//  Created by ios on 17/4/18.
//  Copyright © 2017年 YC_Z. All rights reserved.
//

#import "ChatMessageModel.h"

@implementation ChatMessageModel
+ (ChatMessageModel *)shareModelWithMessage:(RCMessage *)message
{
    ChatMessageModel *model = [[ChatMessageModel alloc]init];
    
    //文本消息
    if([message.objectName isEqualToString:RCTextMessageTypeIdentifier])
    {
        RCTextMessage *textMessage = (RCTextMessage *) message.content;
        model.msgType = MSG_TEXT;
        model.message = textMessage.content;
    }
    model.sendUserId = message.senderUserId;
    return model;
}

@end
