//
//  NSObject+messageForwarding.m
//  RuntimeMessageForwarding
//
//  Created by 叮咚钱包富银 on 2018/5/21.
//  Copyright © 2018年 leo. All rights reserved.
//

#import "NSObject+messageForwarding.h"

@implementation NSObject (messageForwarding)
#pragma mark -- 3 消息转发: Normal Forwarding

- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector {

    NSMethodSignature *methodSignature = [NSMethodSignature signatureWithObjCTypes:"v@:*"];
    return methodSignature;
}

- (void)forwardInvocation:(NSInvocation *)anInvocation {
    NSLog(@"NSObject+messageForwarding.h---在类:%@中 未实现该方法:%@",NSStringFromClass([anInvocation.target class]),NSStringFromSelector(anInvocation.selector));

}
@end
