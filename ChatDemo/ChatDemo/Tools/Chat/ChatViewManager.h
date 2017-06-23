//
//  ChatViewManager.h
//  ChatDemo
//
//  Created by ios on 17/4/25.
//  Copyright © 2017年 YC_Z. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ChatFunctionView.h"
#import "ChatBottomView.h"

@interface ChatViewManager : UIView
+ (ChatViewManager *)shareManagerWithDelegate:(id)delegate targetId:(NSString *)temtargetId;



@end
