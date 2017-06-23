//
//  ChatManager.h
//  ChatDemo
//
//  Created by ios on 17/4/18.
//  Copyright © 2017年 YC_Z. All rights reserved.
//

#import <Foundation/Foundation.h>
@protocol ChatManagerDelegate <NSObject>

/**
 接收消息
 */
- (void)receveMessage:(ChatMessageModel *)model;


- (void)receveGameInviteMessage:(RCMessage *)message;

- (void)receveGameDataMessage:(RCMessage *)message;

@end

@interface ChatManager : NSObject
@property (nonatomic ,strong)id <ChatManagerDelegate> delegate;

+(ChatManager *)shareManager;

- (void)connectRYSever;

/**
 获取消息列表
 */
- (NSArray *)getChatList;


/**
 获取用户聊天列表
 */
- (NSArray *)getUserChatListWithTargetId:(NSString *)targetId;


/**
 发送文本信息
 */
- (void)sendTextMessage:(NSString *)message
               targetId:(NSString *)targetId
           successBlock:(ResultBlock)successBlock
             faileBlock:(ResultBlock)faileBlock;

/**
 发送自定义消息
*/
- (void)sendCustomMessage:(NSDictionary *)message
                 targetId:(NSString *)targetId
             successBlock:(ResultBlock)successBlock
               faileBlock:(ResultBlock)faileBlock;


/**
 发送游戏邀请消息
 */
- (void)sendGameInviteMessage:(Game_Type)type
                     targetId:(NSString *)targetId
                 successBlock:(ResultBlock)successBlock
                   faileBlock:(ResultBlock)faileBlock;
/**
 发送游戏邀请结果消息
*/
- (void)sendGameInviteResultMessage:(Game_Type)type
                           isAccept:(BOOL)isAccept
                    resultExtraData:(id)data
                           targetId:(NSString *)targetId
                       successBlock:(ResultBlock)successBlock
                         faileBlock:(ResultBlock)faileBlock;

/**
 发送游戏数据结果消息
*/
- (void)sendGameDataMessage:(Game_Type)type
               madeFaceType:(MadeFace_DATA_TYPE)madefaceType
                fiveRowType:(FiveRow_DATA_TYPE)fiveRowType
                   dataDict:(id)dataDict
                   targetId:(NSString *)targetId
               successBlock:(ResultBlock)successBlock
                 faileBlock:(ResultBlock)faileBlock;
@end
