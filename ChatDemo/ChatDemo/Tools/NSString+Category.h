//
//  NSString+Category.h
//  IPAD
//
//  Created by Keyloft on 16/1/8.
//  Copyright © 2016年 Keyloft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CommonCrypto/CommonDigest.h"

@interface NSString (Category)
/** 加密*/
- (NSString *)md5;

/** emoji 判断*/
- (BOOL)containsEmoji;

@end
