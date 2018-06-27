//
//  NSObject+LLModelKit.m
//  LLModel
//
//  Created by 叮咚钱包富银 on 2018/5/22.
//  Copyright © 2018年 leo. All rights reserved.
//

#import "NSObject+LLModelKit.h"
#import <objc/runtime.h>
#import <objc/message.h>
const void * kproperties = &kproperties;

@implementation NSObject (LLModelKit)

+ (id)ll_modelWithDictionary:(NSDictionary *)dic {
    //1.初始化model
    id model = [[self alloc] init];
    
    //2.获取Model类的属性数组
    NSArray *propertiesArr = [self ll_getObjcProperties];
    
    //3.遍历字典
    [dic enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
       //4.判断字典中的key是否存在于属性数组中
        if ([propertiesArr containsObject:key]) {
            NSString *propertyType = @"";
            if ([obj isKindOfClass:NSClassFromString(@"__NSCFString")]) {
                propertyType = @"NSString";
            }else if ([obj isKindOfClass:NSClassFromString(@"__NSCFArray")]){
                propertyType = @"NSArray";
            }else if ([obj isKindOfClass:NSClassFromString(@"__NSCFNumber")]){
                propertyType = @"int";
            }else if ([obj isKindOfClass:NSClassFromString(@"__NSCFDictionary")]){
                propertyType = @"NSDictionary";
            }
            
            //5.进行判断，需不需要二级或者三家转换，如果是字典，就二级转换，数组三级转换
            //5.1 二级转换
            if ([obj isKindOfClass:NSClassFromString(@"__NSCFDictionary")]) {
                //判断类有没有实现此方法，否则直接调用会崩溃
                if ([[self class] respondsToSelector:@selector(dictWithModelClass)]) {
                    //通过发送消息调用类方法
                    NSDictionary *keyDic = ((NSDictionary * (*)(id, SEL))objc_msgSend)((id)[self class], @selector(dictWithModelClass));
                    //通过key获取二级对象的class名字
                    NSString *classStr = keyDic[key];
                    Class modelClass = NSClassFromString(classStr);
                    //判断类是否存在
                    if (modelClass) {
                        //字典转模型
                        obj = [modelClass ll_modelWithDictionary:obj];
                    }
                }
            }
            //5.2 三级转换，数组中包含字典
            if ([obj isKindOfClass:NSClassFromString(@"__NSCFArray")]) {
                //判断是否实现协议方法
                if ([[self class] respondsToSelector:@selector(arrayContainModelClass)]) {
                    //转成id对象，可以随意调用方法
                    id this = self;
                    //调用协议方法
                    NSDictionary *dic = [this arrayContainModelClass];
                    NSString *classStr = dic[key];
                    //获取协议的model类
                    Class modelClass = NSClassFromString(classStr);
                    //如果类存在
                    if (modelClass) {
                        NSMutableArray *modelArr = [NSMutableArray array];
                        //遍历数组
                        for (NSDictionary *item in obj) {
                            //字典转模型
                            id iteModel = [modelClass ll_modelWithDictionary:item];
                            
                            [modelArr addObject:iteModel];
                        }
                        obj = modelArr;
                    }
                    
                }
            }
            
            if (model) {
                [model setValue:obj forKey:key];
            }
        }
    }];
    
    return model;
}

+ (NSArray *)ll_getObjcProperties {
    //如果此对象已经解析过属性，直接返回
    NSMutableArray * plist = objc_getAssociatedObject(self, kproperties);
    if (plist) {
        return plist;
    }
    
    unsigned int count = 0;
    objc_property_t *propertyList = class_copyPropertyList([self class], &count);
    
    NSMutableArray *mutArr = [NSMutableArray array];
    for (unsigned int i = 0 ; i < count; i++) {
        const char *name = property_getName(propertyList[i]);
        [mutArr addObject:[NSString stringWithUTF8String:name]];
    }
    objc_setAssociatedObject(self, kproperties, mutArr.copy, OBJC_ASSOCIATION_RETAIN_NONATOMIC);

    free(propertyList);
    return mutArr.copy;
}

@end
