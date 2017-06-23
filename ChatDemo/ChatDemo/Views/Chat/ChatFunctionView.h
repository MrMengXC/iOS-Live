//
//  OtherFunctionView.h
//  ChatDemo
//
//  Created by ios on 17/4/25.
//  Copyright © 2017年 YC_Z. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger,ChatFunctionType) {
    CF_TakePicture = 1000,          //拍照
    CF_MadeFace,                        //拼脸
    CF_FiveRow,                             //五子棋
};


@protocol ChatFunctionViewDelegate <NSObject>
/**
 选择聊天功能
 */
- (void)selectChatFunction:(ChatFunctionType)type;

@end
@interface ChatFunctionView : UIView

@property (nonatomic ,strong)id<ChatFunctionViewDelegate>delegate;
@end
