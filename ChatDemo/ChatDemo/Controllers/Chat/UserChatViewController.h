//
//  UserChatViewController.h
//  DayPhoto
//
//  Created by Keyloft on 16/7/21.
//  Copyright © 2016年 YC_Z. All rights reserved.
//

#import "RootViewController.h"
@interface UserChatViewController : RootViewController


@property (nonatomic ,strong)NSString *conversationId;
- (id)initWithTargetId:(NSString *)targetId;


@end
