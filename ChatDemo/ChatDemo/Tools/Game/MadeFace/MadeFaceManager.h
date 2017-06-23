//
//  MadeFaceManager.h
//  ChatDemo
//
//  Created by ios on 17/4/20.
//  Copyright © 2017年 YC_Z. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol MadeFaceDelegaet <NSObject>
/**
 选择部位进行显示
 */
- (void)selectPartShowWithPartModel:(PartModel *)partModel;
/**
 退出拼脸游戏
 */
- (void)backMadeFace;
@end

@protocol MadeFaceMessageDelegaet <NSObject>

/**
 受到拼脸界面信息
 */
- (void)receiveMadeFaceMessage:(NSString *)message;


@end


/**
 拼脸管理类
 */
@interface MadeFaceManager : NSObject
@property (nonatomic, strong)NSString *targetId;

+ (MadeFaceManager *)shareManager;

- (void)setTargetId:(NSString *)targetId
       madeFaceView:(id)madeFaceView
    madeFaceMessageView:(id)messageView;

/**
 选择部位进行显示
 */
- (void)selectPartShowWithPartModel:(PartModel *)partModel;


/**
 受到拼脸界面信息
 */
- (void)receiveMadeFaceMessage:(NSString *)message;

/**
 合成作品
 */
+ (UIImage *)componseProductWithShapeDict:(NSDictionary *)shapeDict;

/**
 退出拼脸
*/
- (void)backMadeFace;
@end
