//
//  MadeFaceMessageView.m
//  ChatDemo
//
//  Created by ios on 17/4/21.
//  Copyright © 2017年 YC_Z. All rights reserved.
//

#import "MadeFaceMessageView.h"
#import "MadeFaceMessageLabel.h"
#define Messages @[@"可以啦",@"再等等",@"好的",@"没问题了"]

@interface MadeFaceMessageView ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic ,strong)UITableView *messageTableView;
@property (nonatomic ,strong)UIView *messageView;


@property (nonatomic ,strong)NSMutableArray *notUseLabelArray;      //不在用的Label数组
//@property (nonatomic ,strong)UILabel *currentLabel;      //当前显示的Label

@end


@implementation MadeFaceMessageView


- (instancetype)init
{
    if(self = [super init])
    {
        self.backgroundColor = [UIColor clearColor];
        self.notUseLabelArray = [[NSMutableArray alloc]init];
        
        
    }
    return self;
}
#define LH 50.0f

- (void)drawRect:(CGRect)rect
{
    
    if(self.messageTableView)
    {
        return;
    }

    self.messageTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.frame)*0.25, CGRectGetHeight(self.frame)) style:UITableViewStylePlain];
    self.messageTableView.dataSource = self;
    self.messageTableView.delegate = self;
    [self addSubview:self.messageTableView];
    [UIManager clearFooterView:self.messageTableView];
    
    
    self.messageView = [[UIView alloc]initWithFrame:CGRectMake(CGRectGetWidth(self.frame)*0.7, 0, CGRectGetWidth(self.frame)*0.3, 2*LH)];
    self.messageView.backgroundColor = [UIColor yellowColor];
    self.messageView.clipsToBounds = YES;
    [self addSubview:self.messageView];
    
    
}
#pragma mark - MadeFaceMessageDelegaet
- (void)receiveMadeFaceMessage:(NSString *)message
{
    
    NSLog(@"%@",message);
    //先移动当前向上
    //TODO：枷锁
    MadeFaceMessageLabel *messageLabel;
    if(self.notUseLabelArray.count > 0)
    {
        messageLabel = self.notUseLabelArray[0];
        [messageLabel.layer removeAllAnimations];       //结束所有动画
        messageLabel.alpha = 1;
        [self.notUseLabelArray removeObject:messageLabel];
        
    }else{
        messageLabel = [[MadeFaceMessageLabel alloc]init];
        [self.messageView addSubview:messageLabel];

    }
    messageLabel.frame = CGRectMake(0, 2*LH, CGRectGetWidth(self.messageView.frame), LH);
    messageLabel.text = message;
    [messageLabel addObserver:self forKeyPath:@"frame" options:NSKeyValueObservingOptionNew context:nil];

    for(id obj in self.messageView.subviews)
    {
        
        if([obj class] == [MadeFaceMessageLabel class])
        {
            MadeFaceMessageLabel *label = (MadeFaceMessageLabel *)obj;
            if(label.frame.origin.y <= -LH)
            {
                continue;
            }
            __block CGRect rect = label.frame;
            [UIView animateWithDuration:0.3f animations:^{
                rect.origin.y -= LH;
                label.frame = rect;
            } completion:^(BOOL finished) {
               
                
            }];
        }
    }
    [messageLabel beginAlphaAnimation];
    
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context
{
    if([keyPath isEqualToString:@"frame"] && [object class] == [MadeFaceMessageLabel class])
    {
            MadeFaceMessageLabel *label = (MadeFaceMessageLabel *)object;
            if(label.frame.origin.y <= -LH)
            {
                [label removeObserver:self forKeyPath:keyPath];
                [label stopAlphaAnimation];
                [self.notUseLabelArray addObject:label];
                
            }
    }
}

#pragma mark - UITableViewDelegate/UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return [Messages count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"messageCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if(cell == NULL)
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    cell.textLabel.text = Messages[indexPath.row];
    return cell;
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSString *message = Messages[indexPath.row];
    //发送Message消息
    [[ChatManager shareManager] sendGameDataMessage:GAME_MadeFace madeFaceType:MADEFACE_MESSAGE fiveRowType:FIVEROW_NONE dataDict:message targetId:[MadeFaceManager shareManager].targetId successBlock:^{
        
    } faileBlock:^{
        
    }];
    [self receiveMadeFaceMessage:message];
}
@end
