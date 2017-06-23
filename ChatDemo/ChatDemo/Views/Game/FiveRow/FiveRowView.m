//
//  FiveRowView.m
//  ChatDemo
//
//  Created by ios on 17/5/10.
//  Copyright © 2017年 YC_Z. All rights reserved.
//

#import "FiveRowView.h"

#define kBoardSpace 20 //棋盘边距
static const NSInteger kGridCount = 15;         //多少个格子

typedef NS_ENUM(NSInteger ,ChessMan_Direction)     //检查棋子的方向
{
    CMD_Horizontal,
    CMD_Vertical,
    CMD_ObliqueDown, //斜向下
    CMD_ObliqueUp //斜向上
};

@interface FiveRowView ()<UIAlertViewDelegate>

@property (nonatomic, strong)UIView * baseView;     //棋盘
@property (nonatomic, assign)CGFloat gridWidth;     //网格宽度
@property (nonatomic, assign)NSInteger gridCount;     //数量
@property (nonatomic,strong) NSMutableDictionary * chessmanDict; //存放棋子字典的字典
@property (nonatomic ,assign)BOOL isFirstMove;          //是否先执子（先执子为黑反之为白）
@property (nonatomic ,assign)BOOL isMoving;             //是否执子中
@end

@implementation FiveRowView


- (id)initWithFrame:(CGRect)frame isFirstMove:(BOOL)isFirstMove
{
    
    if(self = [super initWithFrame:frame])
    {
        self.isFirstMove = isFirstMove;
        self.isMoving = self.isFirstMove;
    }
    return self;
}

- (void)layoutSubviews{
    
    [super layoutSubviews];
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        //初始化设置
        [self setUp];
    });
    
}

- (void)setUp{
    
    
    self.baseView = [[UIView alloc]initWithFrame:CGRectMake(0, (self.height - SCREEN_WIDTH)/2, SCREEN_WIDTH, SCREEN_WIDTH)];
    self.baseView.backgroundColor = [UIColor colorWithRed:200/255.0 green:160/255.0 blue:130/255.0 alpha:1];
    [self addSubview:self.baseView];
    self.backgroundColor = [UIColor whiteColor];
    self.gridCount = 15;
    self.chessmanDict = [[NSMutableDictionary alloc]init];
    
    [self drawBackground:self.frame.size];
    [self.baseView addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapBoard:)]];
}


#pragma mark - 绘制棋盘
- (void)drawBackground:(CGSize)size
{
    
    
    self.gridWidth = (size.width - 2 * kBoardSpace) / self.gridCount;
    //1.开启图像上下文
    UIGraphicsBeginImageContext(size);
    //2.获取上下文
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    CGContextSetLineWidth(ctx, 0.8f);
    //3.1 画16条竖线
    for (int i = 0; i <= self.gridCount; i ++) {
        CGContextMoveToPoint(ctx, kBoardSpace + i * self.gridWidth , kBoardSpace);
        CGContextAddLineToPoint(ctx, kBoardSpace + i * self.gridWidth , kBoardSpace + self.gridCount * self.gridWidth);
    }
    //3.1 画16条横线
    for (int i = 0; i <= self.gridCount; i ++) {
        CGContextMoveToPoint(ctx, kBoardSpace, kBoardSpace  + i * self.gridWidth );
        CGContextAddLineToPoint(ctx, kBoardSpace + self.gridCount * self.gridWidth , kBoardSpace + i * self.gridWidth);
    }
    CGContextStrokePath(ctx);
    
    //4.获取生成的图片
    UIImage *image=UIGraphicsGetImageFromCurrentImageContext();
    //5.显示生成的图片到imageview
    UIImageView * imageView = [[UIImageView alloc]initWithImage:image];
    [self.baseView addSubview:imageView];
    UIGraphicsEndImageContext();
}


//点击棋盘,下棋
- (void)tapBoard:(UITapGestureRecognizer *)tap
{
    if(!self.isMoving){
        return;
    }
    
    CGPoint point = [tap locationInView:tap.view];
    //计算下子的列号行号
    NSInteger col = (point.x - kBoardSpace + 0.5 * self.gridWidth) / self.gridWidth;
    NSInteger row = (point.y - kBoardSpace + 0.5 * self.gridWidth) / self.gridWidth;
    NSString * key = [NSString stringWithFormat:@"%ld-%ld",col,row];
    
    if (![self.chessmanDict.allKeys containsObject:key])
    {
        
        UIView * chessman = [self chessmanWithIsBlack:self.isFirstMove];
        chessman.center = CGPointMake(kBoardSpace + col * self.gridWidth, kBoardSpace + row * self.gridWidth);
        [self.baseView addSubview:chessman];
        [self.chessmanDict setValue:chessman forKey:key];
        //检查游戏结果
        if([self checkResult:col andRow:row andColor:self.isFirstMove])
        {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"恭喜您赢得了比赛" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
            [alertView show];
        }
    }
    
    self.isMoving = !self.isMoving;
    //发送消息
    [[ChatManager shareManager] sendGameDataMessage:GAME_FiveRow madeFaceType:MADEFACE_NONE fiveRowType:FIVEROW_DATA dataDict:key targetId:[FiveRowManager shareManager].targetId successBlock:^{
        
    } faileBlock:^{
        
    }];
    
    
    
}
#pragma mark - 受到对方棋子位置
- (void)receiveOpposeChessLocation:(NSString *)key
{
    NSInteger col = [[key componentsSeparatedByString:@"-"][0] integerValue];
    NSInteger row = [[key componentsSeparatedByString:@"-"][1] integerValue];
    UIView * chessman = [self chessmanWithIsBlack:!self.isFirstMove];
    chessman.center = CGPointMake(kBoardSpace + col * self.gridWidth, kBoardSpace + row * self.gridWidth);
    [self.baseView addSubview:chessman];
    [self.chessmanDict setValue:chessman forKey:key];
    //检查游戏结果
    if([self checkResult:col andRow:row andColor:self.isFirstMove])
    {
        NSLog(@"对方赢了");
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"很遗憾输掉了比赛" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alertView show];     
    }
    self.isMoving = !self.isMoving;

}

#define kChessmanSizeRatio 0.8f
#pragma mark - 生成棋子
- (UIView *)chessmanWithIsBlack:(BOOL)isBlack
{
    UIView * chessmanView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.gridWidth * kChessmanSizeRatio, self.gridWidth * kChessmanSizeRatio)];
    chessmanView.layer.cornerRadius = chessmanView.width * 0.5;
    chessmanView.backgroundColor = isBlack ? [UIColor blackColor]:[UIColor whiteColor];
    return chessmanView;
}

//检查此时游戏结果
- (BOOL)checkResult:(NSInteger)col andRow:(NSInteger)row andColor:(BOOL)isBlack{
    
    BOOL isWin = NO;
    if([self checkResult:col andRow:row andColor:isBlack andDirection:CMD_Horizontal]
       ||[self checkResult:col andRow:row andColor:isBlack andDirection:CMD_Vertical]
       ||[self checkResult:col andRow:row andColor:isBlack andDirection:CMD_ObliqueDown]
       ||[self checkResult:col andRow:row andColor:isBlack andDirection:CMD_ObliqueUp])
    {
        isWin = YES;
    }
    
    return isWin;

}

//判断是否大于等于五个同色相连
- (BOOL)checkResult:(NSInteger)col
             andRow:(NSInteger)row
           andColor:(BOOL)isBlack
       andDirection:(ChessMan_Direction)direction{
    

    NSInteger chessManSameNum  = 1;
    //获取当前棋子颜色
    UIButton *currentChessman = self.chessmanDict[[NSString stringWithFormat:@"%ld-%ld",col,row]];
    UIColor * currentChessmanColor = currentChessman.backgroundColor;

    switch (direction) {
            //水平方向检查结果
        case CMD_Horizontal:{
            //向前遍历
            for (NSInteger i = col - 1; i > 0; i --)
            {
                NSString * key = [NSString stringWithFormat:@"%ld-%ld",i,row];
                UIView * chessman = self.chessmanDict[key];
            
                
                if (![self.chessmanDict.allKeys containsObject:key] || chessman.backgroundColor != currentChessmanColor){
                    break;

                }
                chessManSameNum++;
            }
            //向后遍历
            for (NSInteger i = col + 1; i < kGridCount; i ++) {
                NSString * key = [NSString stringWithFormat:@"%ld-%ld",i,row];
                UIView * chessman = self.chessmanDict[key];
                if (![self.chessmanDict.allKeys containsObject:key] || chessman.backgroundColor != currentChessmanColor)
                {
                        break;
                }
                chessManSameNum++;

            }
   
        }
            break;
        case CMD_Vertical:{
            //向前遍历
            for (NSInteger i = row - 1; i > 0; i --) {
                NSString * key = [NSString stringWithFormat:@"%ld-%ld",col,i];
                UIView * chessman = self.chessmanDict[key];
                if (![self.chessmanDict.allKeys containsObject:key] || chessman.backgroundColor != currentChessmanColor) break;
                chessManSameNum++;
            }
            //向后遍历
            for (NSInteger i = row + 1; i < kGridCount; i ++) {
                NSString * key = [NSString stringWithFormat:@"%ld-%ld",col,i];
                UIView * chessman = self.chessmanDict[key];
                if (![self.chessmanDict.allKeys containsObject:key] || chessman.backgroundColor != currentChessmanColor) break;
                chessManSameNum++;
            }
        
            
        }
            break;
        case CMD_ObliqueDown:{
            
            //向前遍历
            NSInteger j = col - 1;
            for (NSInteger i = row - 1; i >= 0; i--,j--) {
                NSString * key = [NSString stringWithFormat:@"%ld-%ld",j,i];
                UIView * chessman = self.chessmanDict[key];
                if (![self.chessmanDict.allKeys containsObject:key] || chessman.backgroundColor != currentChessmanColor || j < 0) break;
                chessManSameNum++;
            }
            //向后遍历
            j = col + 1;
            for (NSInteger i = row + 1 ; i < kGridCount; i++,j++) {
                NSString * key = [NSString stringWithFormat:@"%ld-%ld",j,i];
                UIView * chessman = self.chessmanDict[key];
                if (![self.chessmanDict.allKeys containsObject:key] || chessman.backgroundColor != currentChessmanColor || j > kGridCount) break;
                chessManSameNum++;
            }
    
            
        }
            break;
        case CMD_ObliqueUp:{
            //向前遍历
            NSInteger j = col + 1;
            for (NSInteger i = row - 1; i >= 0; i--,j++) {
                NSString * key = [NSString stringWithFormat:@"%ld-%ld",j,i];
                UIView * chessman = self.chessmanDict[key];
                if (![self.chessmanDict.allKeys containsObject:key] || chessman.backgroundColor != currentChessmanColor || j > kGridCount) break;
                chessManSameNum++;
            }
            
            //向后遍历
            j = col - 1;
            for (NSInteger i = row + 1 ; i < kGridCount; i++,j--) {
                NSString * key = [NSString stringWithFormat:@"%ld-%ld",j,i];
                UIView * chessman = self.chessmanDict[key];
                if (![self.chessmanDict.allKeys containsObject:key] || chessman.backgroundColor != currentChessmanColor || j < 0) break;
                chessManSameNum++;
            }
            
        }
            break;
    }
    
    if (chessManSameNum >= 5) {
        return YES;
    }
    else{
        return NO;
    }
}
#pragma mark - 退出五子棋游戏界面
- (void)backFiveRow
{
    [self removeFromSuperview];
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [self backFiveRow];
}
@end
