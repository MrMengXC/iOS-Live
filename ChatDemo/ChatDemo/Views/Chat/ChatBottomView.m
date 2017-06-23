//
//  ChatBottomView.m
//  ChatDemo
//
//  Created by ios on 17/4/24.
//  Copyright © 2017年 YC_Z. All rights reserved.
//

#import "ChatBottomView.h"
@interface ChatBottomView()<UITextViewDelegate>
{
    CGFloat init_y;     //初始y值
}
@property (nonatomic ,strong)UITextView *textView;
@property (nonatomic ,assign)BOOL isBottom;

@end
@implementation ChatBottomView

- (instancetype)initWithFrame:(CGRect)frame
{
    if(self = [super initWithFrame:frame])
    {
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    
    if(self.textView){
        return;
    }
    
    //输入框
    self.textView = [[UITextView alloc]initWithFrame:CGRectZero];
    self.textView.translatesAutoresizingMaskIntoConstraints = NO;
    self.textView.layer.borderColor = [UIColor redColor].CGColor;
    self.textView.layer.borderWidth = 1.0f;
    self.textView.delegate = self;
    self.textView.scrollEnabled = YES;
    self.textView.font = [UIFont systemFontOfSize:20];
    self.textView.returnKeyType = UIReturnKeySend;
    [self addSubview:self.textView];
    
    //发送按钮
    UIButton *send = [[UIButton alloc]init];
    send.translatesAutoresizingMaskIntoConstraints = NO;
    send.backgroundColor = [UIColor redColor];
    [send setTitle:@"发送" forState:UIControlStateNormal];
    [send setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [send addTarget:self action:@selector(sendMessage:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:send];
    
    //other
    UIButton *other = [[UIButton alloc]init];
    other.translatesAutoresizingMaskIntoConstraints = NO;
    other.backgroundColor = [UIColor redColor];
    [other setTitle:@" + " forState:UIControlStateNormal];
    [other setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [other addTarget:self action:@selector(showOtherFunction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:other];
    
   NSDictionary * dict = NSDictionaryOfVariableBindings(_textView,send,other);
    [UIManager addConstraintWithFormat:@"|-20-[_textView]-6-[send(41)]-6-[other(41)]-6-|" viewDict:dict superView:self];
    
    [UIManager addConstraintWithFormat:@"V:|-5-[_textView]-5-|" viewDict:dict superView:self];
    [UIManager addConstraintWithFormat:@"V:|-5-[send]-5-|" viewDict:dict superView:self];
    [UIManager addConstraintWithFormat:@"V:|-5-[other]-5-|" viewDict:dict superView:self];
    
    
    
    
    init_y = CGRectGetMinY(self.frame);

    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(showKeyBoard:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(hiddenKeyBoard:) name:UIKeyboardWillHideNotification object:nil];

    
    
}

- (void)sendMessage:(UIButton *)button
{
    if(self.delegate && [self.delegate respondsToSelector:@selector(sendMessage)])
    {
        [self.delegate performSelector:@selector(sendMessage)];
    }
}

- (void)showOtherFunction:(UIButton *)button
{
    
    if(self.delegate && [self.delegate respondsToSelector:@selector(showOtherFunction)])
    {
        [self.delegate performSelector:@selector(showOtherFunction)];
    }
    
}

#pragma mark - UITextViewDelegate
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
//    
    NSString *currentText;
    if ([text isEqual:@""]) {
        
        if (![textView.text isEqualToString:@""]) {
            
            currentText = [textView.text substringToIndex:[textView.text length] - 1];
            
        }else{
            
            currentText = textView.text;
        
        }
    }else{
        currentText = [NSString stringWithFormat:@"%@%@",textView.text,text];
    }
    
    
    CGFloat broadWith    = (textView.contentInset.left + textView.contentInset.right
                            + textView.textContainerInset.left
                            + textView.textContainerInset.right
                            + textView.textContainer.lineFragmentPadding/*左边距*/
                            + textView.textContainer.lineFragmentPadding/*右边距*/);
    CGFloat height = [currentText boundingRectWithSize:CGSizeMake(CGRectGetWidth(textView.frame) - broadWith,  MAXFLOAT) options:NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:textView.font} context:nil].size.height;
    if(height/textView.font.lineHeight > 3)
    {
        return YES;
    }
    self.baseview_H.constant = MAX(44.0f, height + 10.0f);
    return YES;
}
#pragma mark - 监听键盘升起
- (void)showKeyBoard:(NSNotification *)notification
{
    CGFloat duration  = [notification.userInfo[UIKeyboardAnimationDurationUserInfoKey]floatValue];
    CGRect rect  = [notification.userInfo[UIKeyboardBoundsUserInfoKey]CGRectValue];
    [UIView animateWithDuration:duration animations:^{
        
        self.baseview_Y.constant =  -CGRectGetHeight(rect);
        [self.superview layoutIfNeeded];
        
    } completion:^(BOOL finished) {
    }];
    
}
#pragma mark - 监听键盘落下
- (void)hiddenKeyBoard:(NSNotification *)notification
{
    if(!self.isBottom){
        return;
    }
    CGFloat duration  = [notification.userInfo[UIKeyboardAnimationDurationUserInfoKey]floatValue];
    [UIView animateWithDuration:duration animations:^{
        self.baseview_Y.constant = 0;
        [self.superview layoutIfNeeded];
    } completion:^(BOOL finished) {
        
    }];
    
}

#pragma mark - 隐藏键盘
- (void)hidderKeyBoardWithIsBottom:(BOOL)isBottom
{
    self.isBottom = isBottom;
    [self.textView resignFirstResponder];
    
    
}
@end
