//
//  ChatListModel.m
//  ChatDemo
//
//  Created by ios on 17/4/18.
//  Copyright © 2017年 YC_Z. All rights reserved.
//

#import "ChatListModel.h"

@implementation ChatListModel

+ (ChatListModel *)shareModelWithConversation:(RCConversation *)conversation
{
    
    ChatListModel *model = [[ChatListModel alloc]init];
    model.targetId = conversation.targetId;
    model.unreadMessageCount = conversation.unreadMessageCount;
//    model.lastestMessage = conversation.lastestMessage;
    
    return model;

}
@end
