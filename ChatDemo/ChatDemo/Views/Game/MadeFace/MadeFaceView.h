//
//  MadeFaceView.h
//  ChatDemo
//
//  Created by ios on 17/4/20.
//  Copyright © 2017年 YC_Z. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MadeFaceMessageView.h"
#import "MadeFaceManager.h"

@interface MadeFaceView : UIView<MadeFaceDelegaet>
@property (nonatomic ,strong)MadeFaceMessageView *messageView;


- (id)initWithFrame:(CGRect)frame targetId:(NSString *)temtargetId;


/**
 视图进行赋值
 */
- (void)viewAssignWithArray:(NSArray *)array;

/**
 获取所有部位ID
 */
- (NSDictionary *)getAllShapId;


@end
