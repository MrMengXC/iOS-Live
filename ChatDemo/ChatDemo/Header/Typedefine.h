//
//  Typedefine.h
//  ChatDemo
//
//  Created by ios on 17/4/18.
//  Copyright © 2017年 YC_Z. All rights reserved.
//

#ifndef Typedefine_h
#define Typedefine_h

typedef  void(^RequestDataSuccessBlock)(NSDictionary *result);
typedef  void(^ResultBlock)();

//聊天信息
typedef enum {
    MSG_TEXT = 0,
    
    
}ChatMessageType;


#endif /* Typedefine_h */
