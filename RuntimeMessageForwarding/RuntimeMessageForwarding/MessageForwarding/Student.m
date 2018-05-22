//
//  Student.m
//  RuntimeMessageForwarding
//
//  Created by 叮咚钱包富银 on 2018/5/21.
//  Copyright © 2018年 leo. All rights reserved.
//

#import "Student.h"
#import <objc/runtime.h>
#import <objc/message.h>
#import "StudentForwarding.h"
#import "StudentNormalForwarding.h"
@implementation Student

//- (void)sendMessage:(NSString *)word {
//    NSLog(@"%@",word);
//}


/**
在异常抛出前，Objective-C 的运行时会给你三次拯救程序的机会,依次的顺序为：
 
1. Method resolution
2. Fast forwarding
3. Normal forwarding
 */
#pragma mark --1. Method resolution  动态方法解析

//动态解析类方法
+ (BOOL)resolveClassMethod:(SEL)sel {
    
    //动态解析 类方法
    //首先创建类方法的实现
    void(^resolveClassMethodBlock)(id,SEL) = ^(id objc_self,SEL objc_cmd){
        NSLog(@"未实现的类方法，在这里执行");
    };
    //为本类添加类方法 object_getClass 传入的是id类型，则返回当前id的isa指向的类， 若是class类型，则返回的当前类的isa指向的元类（metaclass）
    class_addMethod(object_getClass(self), sel, imp_implementationWithBlock(resolveClassMethodBlock), "v@:");
    return YES;
}

/**
 imp方法
 @param obj 对象
 @param _cmd 方法名称
 @param word 参数
 */
static void sendMessage(id obj, SEL _cmd, NSString* word) {
    NSLog(@"sendMessage -- %@",word);
}

//动态解析实例方法
+ (BOOL)resolveInstanceMethod:(SEL)sel {
//block方法创建解析方法
//    void (^resolveInstanseMethodBlock)(id,SEL) = ^(id objc_self, SEL objc_cmd) {
//        NSLog(@"未实现的实例方法，在这里执行");
//
//    };
//    //添加实例方法
//    class_addMethod([self class], sel, imp_implementationWithBlock(resolveInstanseMethodBlock), "v@:");
//    return YES;
    if (sel == @selector(sendMessage:)) {
        //self.class:当self是实例对象的时候，返回的是类对象，否则则返回自身。
        class_addMethod([self class], sel, (IMP)sendMessage, "v@:");
    }
    
    return YES;
}

#pragma mark -- 2.快速转发: Fast Rorwarding
//如果此方法返回的是nil 或者self,则会进入消息转发机制（- (void)forwardInvocation:(NSInvocation *)invocation），否则将会向返回的对象重新发送消息。
- (id)forwardingTargetForSelector:(SEL)aSelector {
    
    if (aSelector == @selector(forwardingSendMessage:)) {
        return [[StudentForwarding alloc] init];
    }
    return nil;
}


#pragma mark -- 3 消息转发: Normal Forwarding
- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector {
    //先判断父类有没有实现方法，其实可以省略，直接实现if内方法
    NSMethodSignature *methodSignature = [super methodSignatureForSelector:aSelector];
    if (!methodSignature) {
        methodSignature = [NSMethodSignature signatureWithObjCTypes:"v@:*"];
    }
    
    return methodSignature;
}

- (void)forwardInvocation:(NSInvocation *)anInvocation {
//    <NSInvocation: 0x600000466d00>
//    return value: {v} void
//target: {@} 0x600000009650
//selector: {:} normalForwardingSendMessage:
//    argument 2: {*} pBT
    StudentNormalForwarding *student = [[StudentNormalForwarding alloc] init];
    if ([student respondsToSelector:anInvocation.selector]) {
        [anInvocation invokeWithTarget:student];
    } else {
//        [self doesNotRecognizeSelector:anInvocation.selector];
        [self test: anInvocation];
    }
}

//防止未找到方法崩溃
- (void)test:(NSInvocation *)anInvocation {
    NSLog(@"test 未找到方法-------------%@ ",NSStringFromSelector(anInvocation.selector));
}

@end
