//
//  GameDataMessageContent.h
//  ChatDemo
//
//  Created by ios on 17/4/21.
//  Copyright © 2017年 YC_Z. All rights reserved.
//

#import <RongIMLib/RongIMLib.h>

#define RCDGameDataMessageTypeIdentifier @"RCD:GameData"

/**
 
 拼脸数据类型
 */
typedef  NS_ENUM(NSInteger ,MadeFace_DATA_TYPE)
{
    MADEFACE_DATA = 0,          //拼脸的数据             @{}
    MADEFACE_MESSAGE = 1,   //拼脸的文字信息       @""
    MADEFACE_RESULT = 2,        //拼脸结果                  @()
    MADEFACE_NONE = 4,          //拼脸 none
};
/**
 
 拼脸结果
 */
typedef  NS_ENUM(NSInteger ,MadeFace_RESULT_TYPE)
{
    MADEFACE_RES_ENDINVITE= 0,              //拼脸结束邀请
    MADEFACE_RES_ENDFAILE = 1,               //拼脸结束失败
    MADEFACE_RES_ENDSUCCESS= 2,         //拼脸结束成功
    
};
/**
 
 五子棋数据类型
 */
typedef  NS_ENUM(NSInteger ,FiveRow_DATA_TYPE)
{
    FIVEROW_DATA = 0,          //拼脸的数据             @{}
    FIVEROW_NONE ,          //拼脸 none
};
@interface GameDataMessageContent : RCMessageContent<NSCoding>


@property (nonatomic ,assign)Game_Type type;      //游戏类型
@property (nonatomic ,strong)NSDictionary * contentDict;      //部位数据      //需要判断类型@{@"type":type, @"data":data}



+ (GameDataMessageContent *)gameDataMessageWithType:(Game_Type)type
                                       madefaceType:(MadeFace_DATA_TYPE)madefaceType
                                        fiveRowType:(FiveRow_DATA_TYPE)fiveRowType
                                          dataDcit:(id)dataDict;

@end
