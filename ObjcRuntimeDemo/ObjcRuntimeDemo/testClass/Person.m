//
//  Person.m
//  ObjcRuntimeDemo
//
//  Created by 叮咚钱包富银 on 2018/5/22.
//  Copyright © 2018年 leo. All rights reserved.
//

#import "Person.h"
#import <objc/runtime.h>
#import "RuntimeManager.h"
@interface Person() {
    NSInteger _var1;
    NSString *_var2;
    BOOL _var3;
}

@end

@implementation Person

- (NSString *)getPersonName:(NSString *)name {
    return @"ererer";
}

+ (Person *)defaultPserson {
    
    return [Person new];
}

- (void)dynamicAddMehtod:(NSString *)str {
    NSLog(@"dynamicAddMehtod替换的方法：%@", str);
}

#pragma mark --1. Method resolution  动态方法解析
+ (BOOL)resolveInstanceMethod:(SEL)sel {
    if (sel == @selector(noThisMethod:)) {
        [RuntimeManager addMethod:[self class] oldSel:sel newSel:@selector(dynamicAddMehtod:)];
        return NO;
    }
    return YES;
}

- (void)swapMethod {
    [RuntimeManager swapMethod:[self class] oldSel:@selector(methodOld) newSel:@selector(methodNew)];
}

- (void)methodOld {
    NSLog(@"methodOld");
}

- (void)methodNew {
    //重新调用自己，会先执行methodOld方法后，在执行自己方法
    [self methodNew];
    NSLog(@"methodNew");
}

@end
