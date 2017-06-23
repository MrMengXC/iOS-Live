//
//  PartModel.m
//  ChatDemo
//
//  Created by ios on 17/4/20.
//  Copyright © 2017年 YC_Z. All rights reserved.
//

#import "PartModel.h"

@implementation PartModel
- (id)initWithValue:(NSDictionary *)dictionaryValue
           partType:(NSString *)partType
{
    
    if(self = [super init]){
        self.partId = [dictionaryValue[@"id"] integerValue];
        self.partType = partType;
        self.iconPath = dictionaryValue[@"smallimg"];
        self.imgPath = dictionaryValue[@"bigimg"];
        NSDictionary *locationDic = dictionaryValue[@"location"];
        float locX = [locationDic[@"x"] floatValue];
        float locY = [locationDic[@"y"] floatValue];
        self.location = CGPointMake(locX, locY);
        self.locId = [dictionaryValue[@"locid"]integerValue];
        self.gender = dictionaryValue[@"gender"];

    }
    return self;
}


#pragma mark - code
- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    if (self) {
        
        self.partId = [aDecoder decodeIntegerForKey:@"partId"];
        self.locId = [aDecoder decodeIntegerForKey:@"locId"];
        self.location = [aDecoder decodeCGPointForKey:@"location"];
        
        self.partType = [aDecoder decodeObjectForKey:@"partType"];
        self.iconPath = [aDecoder decodeObjectForKey:@"iconPath"];
        self.imgPath = [aDecoder decodeObjectForKey:@"imgPath"];
        self.gender= [aDecoder decodeObjectForKey:@"gender"];

    }
    
    
    return self;
}
#pragma mark - encode
- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeInteger:self.partId forKey:@"partId"];
    [aCoder encodeInteger:self.locId forKey:@"locId"];
    [aCoder encodeCGPoint:self.location forKey:@"location"];
    
    [aCoder encodeObject:self.partType forKey:@"partType"];
    [aCoder encodeObject:self.iconPath forKey:@"iconPath"];
    [aCoder encodeObject:self.imgPath forKey:@"imgPath"];
    [aCoder encodeObject:self.gender forKey:@"gender"];
}



@end
