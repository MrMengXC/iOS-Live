//
//  UserLoginView.h
//  ChatDemo
//
//  Created by ios on 17/5/15.
//  Copyright © 2017年 YC_Z. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol UserLoginViewDelegate <NSObject>

- (void)intoLoginController:(NSDictionary *)userDict;
- (void)intoUserInfoView;
@end
@interface UserLoginView : UIView
@property (nonatomic ,strong)id < UserLoginViewDelegate>delegate;
@end
