//
//  ChatManager.m
//  ChatDemo
//
//  Created by ios on 17/4/18.
//  Copyright © 2017年 YC_Z. All rights reserved.
//

#import "ChatManager.h"


static ChatManager *_manager = NULL;
static dispatch_once_t once;

@interface ChatManager ()<RCIMClientReceiveMessageDelegate>
@property (nonatomic ,assign,)__block BOOL isConnect;
@end

@implementation ChatManager
+(ChatManager *)shareManager
{
    dispatch_once(&once, ^{
        if(_manager == NULL)
        {
            _manager = [[ChatManager alloc]init];
            _manager.isConnect = NO;
        }
    });
    if(!_manager.isConnect)
    {
        [_manager connectRYSever];
    }
    return _manager;
    
}
//退出容云
- (void)existRy
{
    
    
}
- (void)connectRYSever
{
    //初始化SDK
    [[RCIMClient  sharedRCIMClient] initWithAppKey:AppKey];
    //注册自定义消息体
    [[RCIMClient sharedRCIMClient] registerMessageType:[CustomMessageContent class]];
    [[RCIMClient sharedRCIMClient] registerMessageType:[GameInviteMessageContent class]];
    [[RCIMClient sharedRCIMClient] registerMessageType:[GameDataMessageContent class]];
    

    NSString *token1 = @"OFBVKhVx2CKjP+n2t9xEcnib/nxODFO+2XSuPI9KIhYNTyf7tfKWBXIe5yGIzWqCSLywtYsJeLzyTFo9zWErMQ==";
    NSString *token2 = @"ioMsUsJYUNOetCO5pjuylaTX702C3T8DJ90ufxXg8AO7FT1vVZooFvdLMgTe3S4sLI59WYnf/GlBgm7bczO0yQ==";
    UserSelfInfoModel *userModel = [UserSelfInfoModel shareModel];
    
    //连接服务器
    [[RCIMClient sharedRCIMClient]connectWithToken:userModel.rtoken success:^(NSString *userId)
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            self.isConnect = YES;
            userModel.uid = userId;
        });
        //设置消息接收监听
        [[RCIMClient  sharedRCIMClient] setReceiveMessageDelegate:self object:nil];
        
    } error:^(RCConnectErrorCode status) {
        
    } tokenIncorrect:^{
        
    }];
    
}

#pragma mark - 获取消息列表
- (NSArray *)getChatList
{
    NSArray *list = [[RCIMClient sharedRCIMClient]getConversationList:@[
                                                                        @(ConversationType_PRIVATE),
                                                                        @(ConversationType_DISCUSSION),
                                                                        @(ConversationType_GROUP),
                                                                        @(ConversationType_SYSTEM),
                                                                        @(ConversationType_APPSERVICE),
                                                                        @(ConversationType_PUBLICSERVICE)]];
    
    NSMutableArray *array = [[NSMutableArray alloc]init];
    for(RCConversation *conversation in list)
    {
//        NSLog(@"%lu ------- %@",conversation.conversationType,conversation.targetId);
        //获取单个会话数据
        ChatListModel *model = [ChatListModel shareModelWithConversation:conversation];
        [array addObject:model];
    }
    
    return array;
   
    
}

#pragma mark - 获取用户聊天列表
- (NSArray *)getUserChatListWithTargetId:(NSString *)targetId
{
 
    
//        [[RCIMClient sharedRCIMClient]getRemoteHistoryMessages:ConversationType_PRIVATE targetId:targetId recordTime:0 count:20 success:^(NSArray *messages) {
//            
//    
//        } error:^(RCErrorCode status) {
//    
//        }];
//
    NSArray *array = [[RCIMClient sharedRCIMClient] getLatestMessages:ConversationType_PRIVATE targetId:targetId count:20];
    NSMutableArray *list = [[NSMutableArray alloc]init];
    
    for(RCMessage *message in array)
    {
        //设置消息状态
        if(message.messageDirection == MessageDirection_RECEIVE
           && message.receivedStatus == ReceivedStatus_UNREAD)
        {
 
            [[RCIMClient sharedRCIMClient]setMessageReceivedStatus:message.messageId receivedStatus:ReceivedStatus_READ];
        
        }
        ChatMessageModel *model = [ChatMessageModel shareModelWithMessage:message];
        [list insertObject:model atIndex:0];
//        [list addObject:model];
    
    }
    return list;
    
}

#pragma mark - 发送文本消息
- (void)sendTextMessage:(NSString *)message
               targetId:(NSString *)targetId
           successBlock:(ResultBlock)successBlock
             faileBlock:(ResultBlock)faileBlock
{
    RCTextMessage *textMessage = [RCTextMessage messageWithContent:message];
    
    [[RCIMClient sharedRCIMClient] sendMessage:ConversationType_PRIVATE targetId:targetId content:textMessage pushContent:nil pushData:nil success:^(long messageId)
    {
        NSLog(@"发送成功：%ld",messageId);
        successBlock();
    } error:^(RCErrorCode nErrorCode, long messageId) {
        NSLog(@"发送失败：%ld",messageId);
        faileBlock();
    }];
}


#pragma mark - 发送自定义消息
- (void)sendCustomMessage:(NSDictionary *)message
                 targetId:(NSString *)targetId
             successBlock:(ResultBlock)successBlock
               faileBlock:(ResultBlock)faileBlock
{
    
    CustomMessageContent *content = [CustomMessageContent messageWithDict:message];
    [[RCIMClient sharedRCIMClient]sendMessage:ConversationType_PRIVATE targetId:targetId content:content pushContent:nil pushData:nil success:^(long messageId)
     {
         NSLog(@"发送成功：%ld",messageId);
         successBlock();
         
     } error:^(RCErrorCode nErrorCode, long messageId) {
         NSLog(@"发送失败：%ld",messageId);
         faileBlock();
     }];
}


#pragma mark - 发送游戏邀请消息
- (void)sendGameInviteMessage:(Game_Type)type
                     targetId:(NSString *)targetId
                 successBlock:(ResultBlock)successBlock
                   faileBlock:(ResultBlock)faileBlock
{
    
    GameInviteMessageContent *content = [GameInviteMessageContent gameInviteMessageWithType:type];
    
    [[RCIMClient sharedRCIMClient]sendMessage:ConversationType_PRIVATE targetId:targetId content:content pushContent:nil pushData:nil success:^(long messageId)
     {
         NSLog(@"发送成功：%ld",messageId);
         successBlock();
         
     } error:^(RCErrorCode nErrorCode, long messageId) {
         NSLog(@"发送失败：%ld",messageId);
         faileBlock();
     }];
}

#pragma mark - 发送游戏邀请结果消息
- (void)sendGameInviteResultMessage:(Game_Type)type
                           isAccept:(BOOL)isAccept
                    resultExtraData:(id)data
                           targetId:(NSString *)targetId
                       successBlock:(ResultBlock)successBlock
                         faileBlock:(ResultBlock)faileBlock
{
    
    GameInviteMessageContent *content = [GameInviteMessageContent gameInviteResultMessageWithType:type isAccept:isAccept resultExtraData:data];
    [[RCIMClient sharedRCIMClient]sendMessage:ConversationType_PRIVATE targetId:targetId content:content pushContent:nil pushData:nil success:^(long messageId)
     {
         NSLog(@"发送成功：%ld",messageId);
         successBlock();
         
     } error:^(RCErrorCode nErrorCode, long messageId) {
         NSLog(@"发送失败：%ld",messageId);
         faileBlock();
     }];
}
#pragma mark - 发送游戏数据结果消息
- (void)sendGameDataMessage:(Game_Type)type
               madeFaceType:(MadeFace_DATA_TYPE)madefaceType
                fiveRowType:(FiveRow_DATA_TYPE)fiveRowType
                        dataDict:(id)dataDict
                           targetId:(NSString *)targetId
               successBlock:(ResultBlock)successBlock
                 faileBlock:(ResultBlock)faileBlock
{
    
    GameDataMessageContent *content = [GameDataMessageContent gameDataMessageWithType:type madefaceType:madefaceType fiveRowType:fiveRowType dataDcit:dataDict];
    
    [[RCIMClient sharedRCIMClient]sendMessage:ConversationType_PRIVATE targetId:targetId content:content pushContent:nil pushData:nil success:^(long messageId)
     {
         NSLog(@"发送成功：%ld",messageId);
         successBlock();
     } error:^(RCErrorCode nErrorCode, long messageId) {
         NSLog(@"发送失败：%ld",messageId);
         faileBlock();
     }];
}


#pragma mark - RCIMClientReceiveMessageDelegate
- (void)onReceived:(RCMessage *)message left:(int)nLeft object:(id)object
{
    

    if(self.delegate != NULL)
    {
        if([message.objectName isEqualToString:RCDCustomMessageTypeIdentifier])                         //接收到自定义消息
        {
            NSLog(@"受到自定义消息");
            NSLog(@"%@",( (CustomMessageContent *)message.content).dataDict);
        }
        else if([message.objectName isEqualToString:RCDGameInviteMessageTypeIdentifier])        //接收到游戏邀请
        {
            
            if([self.delegate respondsToSelector:@selector(receveGameInviteMessage:)])
            {
                [self.delegate performSelector:@selector(receveGameInviteMessage:) withObject:message];
            }
        }
        else if([message.objectName isEqualToString:RCDGameDataMessageTypeIdentifier])        //接收到游戏数据
        {
            
            if([self.delegate respondsToSelector:@selector(receveGameDataMessage:)])
            {
                [self.delegate performSelector:@selector(receveGameDataMessage:) withObject:message];
            }
        }
        else
        {

            ChatMessageModel *model = [ChatMessageModel shareModelWithMessage:message];
            if([self.delegate respondsToSelector:@selector(receveMessage:)])
            {
                [self.delegate performSelector:@selector(receveMessage:) withObject:model];
            }
        }
        
    }
}



@end
