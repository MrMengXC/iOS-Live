//
//  FiveRowManager.h
//  ChatDemo
//
//  Created by ios on 17/5/10.
//  Copyright © 2017年 YC_Z. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol FiveRowManagerDelegate <NSObject>

/**
 接受到对方棋子位置
 */
- (void)receiveOpposeChessLocation:(NSString *)key;

@end

@interface FiveRowManager : NSObject
@property (nonatomic ,strong)NSString *targetId;
@property (nonatomic ,strong)id <FiveRowManagerDelegate>delegate;

+ (FiveRowManager *)shareManager;
- (void)setTargetId:(NSString *)targetId delegate:(id)delegate;
/**
 接受到对方棋子位置
 */
- (void)receiveOpposeChessLocation:(NSString *)key;


@end
