
//
//  GameInviteContent.m
//  ChatDemo
//
//  Created by ios on 17/4/20.
//  Copyright © 2017年 YC_Z. All rights reserved.
//

#import "GameInviteMessageContent.h"

@implementation GameInviteMessageContent

+ (GameInviteMessageContent *)gameInviteMessageWithType:(Game_Type)type
{
    
    GameInviteMessageContent *content = [[GameInviteMessageContent alloc]init];
    content.type = type;
    content.isInvitor = YES;
    content.isAccept = NO;
    return content;
    
}
+ (GameInviteMessageContent *)gameInviteResultMessageWithType:(Game_Type)type
                                                     isAccept:(BOOL)isAccept
                                              resultExtraData:(id)data
{
    
    GameInviteMessageContent *content = [[GameInviteMessageContent alloc]init];
    content.type = type;
    content.isInvitor = NO;
    content.isAccept = isAccept;
    if(data)
    {
        content.resultExtraData = data;
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
        self.type = [aDecoder decodeIntegerForKey:TypeKey];
        self.isInvitor = [aDecoder decodeBoolForKey:IsInvitorKey];
        self.isAccept = [aDecoder decodeBoolForKey:InviteResKey];
        self.resultExtraData = [aDecoder decodeObjectForKey:@"resultExtraData"];
    }
    
    
    return self;
}
#pragma mark - encode
- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeInteger:self.type forKey:TypeKey];
    [aCoder encodeBool:self.isInvitor forKey:IsInvitorKey];
    [aCoder encodeBool:self.isAccept forKey:InviteResKey];
    [aCoder encodeObject:self.resultExtraData forKey:@"resultExtraData"];


}

#pragma mark - 将消息内容编码成json
- (NSData *)encode {
    NSMutableDictionary *dataDict = [NSMutableDictionary dictionary];
    
    [dataDict setObject:@(self.type) forKey:TypeKey];
    [dataDict setObject:[NSNumber numberWithBool:self.isInvitor] forKey:IsInvitorKey];
    [dataDict setObject:[NSNumber numberWithBool:self.isAccept] forKey:InviteResKey];
    if(self.resultExtraData){
        [dataDict setObject:self.resultExtraData forKey:@"resultExtraData"];
    }
    
    
    
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
                                                   options:kNilOptions
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
            self.isInvitor = [dictionary[IsInvitorKey] boolValue];
            self.isAccept = [dictionary[InviteResKey] boolValue];
            self.resultExtraData = dictionary[@"resultExtraData"];
            NSDictionary *userinfoDic = dictionary[@"user"];
            [self decodeUserInfo:userinfoDic];
        }
    }
}


///消息的类型名
+ (NSString *)getObjectName {
    return RCDGameInviteMessageTypeIdentifier;
}


@end
