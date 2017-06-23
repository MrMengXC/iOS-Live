//
//  PartModel.h
//  ChatDemo
//
//  Created by ios on 17/4/20.
//  Copyright © 2017年 YC_Z. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PartModel : NSObject <NSCoding>


@property (nonatomic ,assign)NSInteger partId;
@property (nonatomic ,assign)NSInteger locId;
@property (nonatomic ,assign)CGPoint location;

@property (nonatomic ,strong)NSString *partType;
@property (nonatomic ,strong)NSString * iconPath;
@property (nonatomic ,strong)NSString * imgPath;
@property (nonatomic ,strong)NSString * gender;

- (id)initWithValue:(NSDictionary *)dictionaryValue
           partType:(NSString *)partType;

@end
