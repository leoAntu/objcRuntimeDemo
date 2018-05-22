//
//  Person+AssociatedObject.m
//  ObjcRuntimeDemo
//
//  Created by 叮咚钱包富银 on 2018/5/22.
//  Copyright © 2018年 leo. All rights reserved.
//

#import "Person+AssociatedObject.h"
#import <objc/runtime.h>

const void *kDynamicAddProperty = &kDynamicAddProperty;

@implementation Person (AssociatedObject)

- (void)setDynamicAddProperty:(NSString *)dynamicAddProperty {
    objc_setAssociatedObject(self, kDynamicAddProperty, dynamicAddProperty,  OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSString *)dynamicAddProperty {
   return objc_getAssociatedObject(self, kDynamicAddProperty);
}

@end
