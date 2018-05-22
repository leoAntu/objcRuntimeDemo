//
//  Student.h
//  RuntimeMessageForwarding
//
//  Created by 叮咚钱包富银 on 2018/5/21.
//  Copyright © 2018年 leo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Student : NSObject
- (void)sendMessage:(NSString *)word;

+ (void)classSendMessage:(NSString *)word;

- (void)forwardingSendMessage:(NSString *)word;

- (void)normalForwardingSendMessage:(NSString *)word;

- (void)doesNotNormalForwardingSendMessage:(NSString *)word;
@end
