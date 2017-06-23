//
//  FiveRowView.h
//  ChatDemo
//
//  Created by ios on 17/5/10.
//  Copyright © 2017年 YC_Z. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FiveRowManager.h"

@interface FiveRowView : UIView <FiveRowManagerDelegate>

- (id)initWithFrame:(CGRect)frame isFirstMove:(BOOL)isFirstMove;

@end
