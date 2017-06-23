//
//  GameDataMessageContent.m
//  ChatDemo
//
//  Created by ios on 17/4/21.
//  Copyright © 2017年 YC_Z. All rights reserved.
//

#import "GameDataMessageContent.h"

@implementation GameDataMessageContent
+ (GameDataMessageContent *)gameDataMessageWithType:(Game_Type)type
                                       madefaceType:(MadeFace_DATA_TYPE)madefaceType
                                          fiveRowType:(FiveRow_DATA_TYPE)fiveRowType
                                           dataDcit:(id)dataDict
{
    
    
    GameDataMessageContent *content = [[GameDataMessageContent alloc]init];
    content.type = type;

    if(dataDict)
    {
        content.contentDict = @{
                                @"type":madefaceType == MADEFACE_NONE?@(fiveRowType):@(madefaceType),
                                @"data":dataDict
                                };
    }
    return content;
    
}


#pragma mark - 消息是否存储，是否计入未读数
+ (RCMessagePersistent)persistentFlag {
    return (MessagePersistent_NONE | MessagePersistent_STATUS);
}

#pragma mark - code
- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    if (self) {
        self.type = [aDecoder decodeIntegerForKey:@"type"];
        self.contentDict = [aDecoder decodeObjectForKey:@"contentDict"];

    }
    
    
    return self;
}
#pragma mark - encode
- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeInteger:self.type forKey:@"type"];
    [aCoder encodeObject:self.contentDict forKey:@"contentDict"];
    
    
}

#pragma mark - 将消息内容编码成json
- (NSData *)encode {
    NSMutableDictionary *dataDict = [NSMutableDictionary dictionary];
    
    [dataDict setObject:@(self.type) forKey:TypeKey];
    [dataDict setObject:self.contentDict forKey:@"contentDict"];
    
    if (self.senderUserInfo) {
        NSMutableDictionary *userInfoDic = [[NSMutableDictionary alloc] init];
        if (self.senderUserInfo.name) {
            [userInfoDic setObject:self.senderUserInfo.name
                 forKeyedSubscript:@"name"];
        }
        if (self.senderUserInfo.portraitUri) {
            [userInfoDic setObject:self.senderUserInfo.portraitUri
                 forKeyedSubscript:@"icon"];
        }
        if (self.senderUserInfo.userId) {
            [userInfoDic setObject:self.senderUserInfo.userId
                 forKeyedSubscript:@"id"];
        }
        [dataDict setObject:userInfoDic forKey:@"user"];
    }
    
    
    
    NSData *data = [NSJSONSerialization dataWithJSONObject:dataDict
                                                   options:NSJSONWritingPrettyPrinted
                                                     error:nil];
    return data;
}

#pragma mark - 将json解码生成消息内容
- (void)decodeWithData:(NSData *)data {
    if (data) {
        __autoreleasing NSError *error = nil;
        
        NSDictionary *dictionary =
        [NSJSONSerialization JSONObjectWithData:data
                                        options:kNilOptions
                                          error:&error];
        
        if (dictionary)
        {
            self.type = [dictionary[TypeKey] integerValue];
            self.contentDict = dictionary[@"contentDict"];
            NSDictionary *userinfoDic = dictionary[@"user"];
            [self decodeUserInfo:userinfoDic];
        }
    }
}


///消息的类型名
+ (NSString *)getObjectName {
    return RCDGameDataMessageTypeIdentifier;
}

@end
