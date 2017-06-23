//
//  MadeFaceMessageLabel.h
//  ChatDemo
//
//  Created by ios on 17/4/22.
//  Copyright © 2017年 YC_Z. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MadeFaceMessageLabel : UILabel
/**
 开始透明度动画
 */
- (void)beginAlphaAnimation;
/**
 技术透明度动画
 */
- (void)stopAlphaAnimation;
@end
