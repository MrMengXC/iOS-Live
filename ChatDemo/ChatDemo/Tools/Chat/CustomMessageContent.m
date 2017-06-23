//
//  CustomMessageContent.m
//  ChatDemo
//
//  Created by ios on 17/4/19.
//  Copyright © 2017年 YC_Z. All rights reserved.
//

#import "CustomMessageContent.h"

@implementation CustomMessageContent

+ (instancetype)messageWithDict:(NSDictionary *)dict {
    CustomMessageContent *content = [[CustomMessageContent alloc] init];
    if (dict) {
        content.dataDict = dict;
    }
    return content;
}
///消息是否存储，是否计入未读数
+ (RCMessagePersistent)persistentFlag {
    return (MessagePersistent_NONE | MessagePersistent_STATUS);
}

#pragma mark - code
- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    if (self) {
        self.dataDict = [aDecoder decodeObjectForKey:@"dataDict"];
    }
    return self;
}

#pragma mark - encode
- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.dataDict forKey:@"dataDict"];
}

#pragma mark - 将消息内容编码成json
- (NSData *)encode {
    NSMutableDictionary *dataDict = [NSMutableDictionary dictionary];
    
    [dataDict setObject:self.dataDict forKey:@"dataDict"];
   
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
        
        if (dictionary) {
            self.dataDict = dictionary[@"dataDict"];
            
            NSDictionary *userinfoDic = dictionary[@"user"];
            [self decodeUserInfo:userinfoDic];
        }
    }
}


///消息的类型名
+ (NSString *)getObjectName {
    
    return RCDCustomMessageTypeIdentifier;

}

@end
