//
//  RuntimeManager.m
//  ObjcRuntimeDemo
//
//  Created by 叮咚钱包富银 on 2018/5/22.
//  Copyright © 2018年 leo. All rights reserved.
//

#import "RuntimeManager.h"
#import <objc/runtime.h>
@implementation RuntimeManager

+ (NSString *)fetchClassName:(Class)cls {
    const char *name =  class_getName(cls);
    return [NSString stringWithUTF8String:name];
}

+ (NSMutableArray *)fetchIvarList:(Class)cls {
    unsigned int count = 0;
    
    Ivar *ivarList = class_copyIvarList(cls, &count);
    NSMutableArray *mutArr = [NSMutableArray array];
    
    for (unsigned int i = 0; i < count; i++) {
        NSMutableDictionary *mutDic = [NSMutableDictionary dictionary];
        const char *ivarName =  ivar_getName(ivarList[i]);
        const char *ivarType =  ivar_getTypeEncoding(ivarList[i]);
        
        [mutDic setObject:[NSString stringWithUTF8String:ivarName] forKey:@"ivarName"];
        [mutDic setObject:[NSString stringWithUTF8String:ivarType] forKey:@"ivarType"];
        [mutArr addObject:mutDic];
    }
    
    free(ivarList);
    
    return mutArr;
}

+ (NSMutableArray *)fetchPropertyList:(Class)cls {
    unsigned int count = 0;
    objc_property_t *propertyList = class_copyPropertyList(cls, &count);
    NSMutableArray *mutArr = [NSMutableArray array];
    
    for (unsigned int i = 0; i < count; i++) {
        const char *name =  property_getName(propertyList[i]);
        [mutArr addObject:[NSString stringWithUTF8String:name]];
    }
    free(propertyList);
    
    return mutArr;
}

+ (NSMutableArray *)fetchProtocolList:(Class)cls {
    unsigned int count = 0;
    __unsafe_unretained  Protocol **protocolList =  class_copyProtocolList(cls, &count);
    NSMutableArray *mutArr = [NSMutableArray array];
    for (unsigned int i = 0; i < count; i++) {
        const char *protocolName = protocol_getName(protocolList[i]);
        [mutArr addObject:[NSString stringWithUTF8String:protocolName]];
    }
    free(protocolList);
    return mutArr;
}

+ (NSMutableArray *)fetchMethodList:(Class)cls {
    unsigned int count = 0;
    Method * methodList =  class_copyMethodList(cls, &count);
    NSMutableArray *mutArr = [NSMutableArray array];
    for (unsigned int i = 0; i < count; i++) {
       SEL sel = method_getName(methodList[i]);
        NSString *methodName = NSStringFromSelector(sel);
        
        char returnType[512] = {};
        method_getReturnType(methodList[i], returnType, 512);

        unsigned int argCount =  method_getNumberOfArguments(methodList[i]);
        NSLog(@"methodName -- %@,returnType --- %s, argCount--- %d",methodName,returnType,argCount);
        char argName[512] = {};
        for (unsigned int j = 0; j < argCount; ++j) {
            method_getArgumentType(methodList[i], j, argName, 512);
            NSLog(@"第%u个参数类型为： %s",j,argName);
            memset(argName, '\0', strlen(argName));
        }
        
        NSLog(@"TypeEncoding: %s", method_getTypeEncoding(methodList[i]));
        NSLog(@"----------------------------------");

        [mutArr addObject:methodName];
    }
    free(methodList);
    return mutArr;
}

+ (NSMutableArray *)fetchClassMethodList:(Class)cls {
    unsigned int count = 0;
    //获取类方法，需要获取当前类的metaclass （通过isa指针）
    Method * methodList =  class_copyMethodList(object_getClass(cls), &count);
    NSMutableArray *mutArr = [NSMutableArray array];
    for (unsigned int i = 0; i < count; i++) {
        SEL sel = method_getName(methodList[i]);
        NSString *methodName = NSStringFromSelector(sel);
        [mutArr addObject:methodName];
    }
    free(methodList);
    return mutArr;
}

+ (void)addMethod:(Class)cls oldSel:(SEL)oSel newSel:(SEL)nSel {
    Method method = class_getInstanceMethod(cls, nSel);
    IMP imp = method_getImplementation(method);
    class_addMethod(cls, oSel, imp, method_getTypeEncoding(method));
}

+ (void)swapMethod:(Class)cls oldSel:(SEL)oSel newSel:(SEL)nSel {
    Method oldMethod = class_getInstanceMethod(cls, oSel);
    Method newMethod = class_getInstanceMethod(cls, nSel);
    method_exchangeImplementations(oldMethod, newMethod);
}

@end
