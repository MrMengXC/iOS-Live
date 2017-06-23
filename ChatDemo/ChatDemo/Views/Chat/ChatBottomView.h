//
//  ChatBottomView.h
//  ChatDemo
//
//  Created by ios on 17/4/24.
//  Copyright © 2017年 YC_Z. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol  ChatBottomViewDelegate<NSObject>

/**
 
 发送信息（文本。图片。语音。自定义）
 
 */
- (void)sendMessage;

/**
 
 显示其他功能
 
 */
- (void)showOtherFunction;


@end

/**
 自定义聊天底部View
 */
@interface ChatBottomView : UIView

@property (nonatomic ,strong)NSLayoutConstraint *baseview_Y;
@property (nonatomic ,strong)NSLayoutConstraint *baseview_H;
@property (nonatomic ,strong)id <ChatBottomViewDelegate> delegate;

/**
 隐藏键盘是否下降到底
 
 */
- (void)hidderKeyBoardWithIsBottom:(BOOL)isBottom;


@end
