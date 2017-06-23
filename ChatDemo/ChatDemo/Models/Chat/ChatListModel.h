//
//  ChatListModel.h
//  ChatDemo
//
//  Created by ios on 17/4/18.
//  Copyright © 2017年 YC_Z. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ChatListModel : NSObject
@property (nonatomic ,strong)NSString *targetId;                        //目标ID
@property (nonatomic ,assign)int unreadMessageCount;        //未读数量
@property (nonatomic ,strong)NSString * lastestMessage;        //最后一条消息内容


+ (ChatListModel *)shareModelWithConversation:(RCConversation *)conversation;

@end
