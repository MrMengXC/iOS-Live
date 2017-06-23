//
//  FiveRowManager.m
//  ChatDemo
//
//  Created by ios on 17/5/10.
//  Copyright © 2017年 YC_Z. All rights reserved.
//

#import "FiveRowManager.h"
static FiveRowManager *_manager = NULL;
@interface FiveRowManager()
@property (nonatomic ,assign)BOOL isFirstMove;          //是否先执子（先执子为黑反之为白）
@property (nonatomic ,assign)BOOL isMoving;             //是否执子中

@end
@implementation FiveRowManager
+ (FiveRowManager *)shareManager
{
    if(_manager == NULL)
    {
        _manager = [[FiveRowManager alloc]init];
    }
    return _manager;

}
- (void)setTargetId:(NSString *)targetId delegate:(id)delegate
{
    self.targetId = targetId;
    self.delegate = delegate;
    
}
-(void)receiveOpposeChessLocation:(NSString *)key
{
    
    if(self.delegate && [self.delegate respondsToSelector:@selector(receiveOpposeChessLocation:)])
    {
        [self.delegate performSelector:@selector(receiveOpposeChessLocation:) withObject:key];
    }
}

@end
