//
//  GameInviteContent.h
//  ChatDemo
//
//  Created by ios on 17/4/20.
//  Copyright © 2017年 YC_Z. All rights reserved.
//

#import <RongIMLib/RongIMLib.h>

/**
 游戏邀请

 type:拼脸 五子棋
 bool isInvite：是否是邀请方
 bool inviteRes:邀请结果
 
 
 */

typedef NS_ENUM(NSInteger , Game_Type) {
    
    GAME_MadeFace = 1,
    GAME_FiveRow,
    
};
#define RCDGameInviteMessageTypeIdentifier @"RCD:GameInvite"

#define TypeKey @"type"
#define IsInvitorKey @"isInvitor"
#define InviteResKey @"isAccept"

@interface GameInviteMessageContent : RCMessageContent<NSCoding>

@property (nonatomic ,assign)Game_Type type;      //游戏类型
@property (nonatomic ,assign)BOOL isInvitor;            //是否是邀请方
@property (nonatomic ,assign)BOOL isAccept;        //邀请结果
@property (nonatomic ,strong)id resultExtraData;           //邀请结果附带数据


/**
 游戏邀请信息
 */
+ (GameInviteMessageContent *)gameInviteMessageWithType:(Game_Type)type;

/**
 游戏邀请反馈结果信息
 */
+ (GameInviteMessageContent *)gameInviteResultMessageWithType:(Game_Type)type
                                                     isAccept:(BOOL)isAccept
                                              resultExtraData:(id)data;
@end
