//
//  MadeFaceMessageLabel.m
//  ChatDemo
//
//  Created by ios on 17/4/22.
//  Copyright © 2017年 YC_Z. All rights reserved.
//

#import "MadeFaceMessageLabel.h"
@interface MadeFaceMessageLabel()
@property (nonatomic ,strong)NSTimer *timer;
@end
@implementation MadeFaceMessageLabel

- (void)beginAlphaAnimation
{
    
    dispatch_async(dispatch_get_main_queue(), ^{
        self.timer = [NSTimer timerWithTimeInterval:1.0f target:self selector:@selector(alphaAnimation) userInfo:nil repeats:NO];
        [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
        
        //        [timer fire];
    });
    
    
}
- (void)alphaAnimation
{
        [UIView animateWithDuration:1.0f animations:^{
                self.alpha = 0;
        }];
}
- (void)stopAlphaAnimation
{
    if(self.timer){
        [self.timer invalidate];
    }
    self.timer = NULL;
    
}
@end
