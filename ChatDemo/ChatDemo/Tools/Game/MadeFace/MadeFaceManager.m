//
//  MadeFaceManager.m
//  ChatDemo
//
//  Created by ios on 17/4/20.
//  Copyright © 2017年 YC_Z. All rights reserved.
//

#import "MadeFaceManager.h"
#import "ImageHandleManager.h"

static MadeFaceManager *manager = NULL;
static dispatch_once_t once;

@interface MadeFaceManager ()
@property (nonatomic, strong)id<MadeFaceDelegaet> madeFaceDelegate;
@property (nonatomic, strong)id<MadeFaceMessageDelegaet> madeFaceMessageDelegate;

@end

@implementation MadeFaceManager
+ (MadeFaceManager *)shareManager
{
    if(manager == NULL)
    {
        manager = [[MadeFaceManager alloc]init];
    }
    return manager;
}
- (void)setTargetId:(NSString *)targetId madeFaceView:(id)madeFaceView madeFaceMessageView:(id )messageView
{
    self.targetId = targetId;
    self.madeFaceDelegate = madeFaceView;
    self.madeFaceMessageDelegate = messageView;
}

- (void)selectPartShowWithPartModel:(PartModel *)partModel
{
    if(self.madeFaceDelegate && [self.madeFaceDelegate respondsToSelector:@selector(selectPartShowWithPartModel:)])
    {
        [self.madeFaceDelegate performSelector:@selector(selectPartShowWithPartModel:) withObject:partModel];
    }
}
- (void)receiveMadeFaceMessage:(NSString *)message
{
    
    if(self.madeFaceMessageDelegate && [self.madeFaceMessageDelegate respondsToSelector:@selector(receiveMadeFaceMessage:)])
    {
        [self.madeFaceMessageDelegate performSelector:@selector(receiveMadeFaceMessage:) withObject:message];
    }
    
}

#pragma mark - 退出拼脸
- (void)backMadeFace
{
    
    if(self.madeFaceDelegate && [self.madeFaceDelegate respondsToSelector:@selector(backMadeFace)])
    {
        [self.madeFaceDelegate performSelector:@selector(backMadeFace)];
    }
    
}
#pragma mark - 合成作品
+ (UIImage *)componseProductWithShapeDict:(NSDictionary *)shapeDict
{
    
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(1080, 1080), NO, [UIScreen mainScreen].scale);
    NSArray *shapes =  [[MadeFaceDataManager shareManager]getShapesLocation];
    for(NSString *shape in shapes)
    {
        NSDictionary *dict = shapeDict[shape];
        if(dict){
            PartModel *partModel = [[MadeFaceDataManager shareManager] getPartModelWithShape:shape partId:[dict[@"id"] integerValue ] gender:dict[@"gender"]];
            
            UIImage *image = [ ImageHandleManager getImageWithFileName:partModel.imgPath];
            
            [image drawInRect:CGRectMake(partModel.location.x, partModel.location.y, image.size.width, image.size.height)];
        }

    }
    UIImage* result = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return result;
}

@end
