//
//  UIManager.m
//  ChatDemo
//
//  Created by ios on 17/4/18.
//  Copyright © 2017年 YC_Z. All rights reserved.
//

#import "UIManager.h"

@implementation UIManager

+ (void)addConstraintWithFormat:(NSString *)format
                       viewDict:(NSDictionary *)viewDict
                      superView:(UIView *)superView
{

    NSArray *array = [NSLayoutConstraint constraintsWithVisualFormat:format options:0 metrics:nil views:viewDict];
    [superView addConstraints:array];

}

+ (void)clearFooterView:(UITableView *)tableView
{
    
    UIView *view = [[UIView alloc]init];
    view.backgroundColor = [UIColor clearColor];
    
    tableView.tableFooterView = view;
    
}

+ (void)addMessage:(NSString *)message
{
    
    UIWindow *window = [UIApplication sharedApplication].windows.lastObject;

    UILabel *label = [[UILabel alloc]init];
    label.backgroundColor = [UIColor blackColor];
    label.textColor = [UIColor redColor];
    label.text = message;
//    label.center =
    CGSize size= [message sizeWithFont:label.font constrainedToSize:CGSizeMake(MAXFLOAT, MAXFLOAT)];
    label.frame = CGRectMake(0, 0, size.width, size.height);
    label.center = window.center;
    
    
    [window addSubview:label];
    
    
    [UIView animateWithDuration:2.0f animations:^{
        label.alpha = 0;
    } completion:^(BOOL finished) {
        [label removeFromSuperview];
    }];
    
    
    
}
@end
