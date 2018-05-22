//
//  NSObject+CS_KVO.m
//  Custom-kvo
//
//  Created by 叮咚钱包富银 on 2018/5/14.
//  Copyright © 2018年 leo. All rights reserved.
//

#import "NSObject+CS_KVO.h"
#import <objc/runtime.h>
#import <objc/message.h>

const void *kKVOInfoModel = &kKVOInfoModel;
//派生类的类名开头
NSString *kPrefixOfCSKVO = @"kPrefixOfCSKVO_";

@interface CSKVOInfoModal: NSObject {
    void *_context;
}

- (void)setContext:(void *)context;
- (void *)getContext;
@property (nonatomic, weak) id target;
@property (nonatomic, weak) id observer;
@property (nonatomic, copy) NSString *keyPath;
@property (nonatomic, assign) CS_NSKeyValueObservingOptions options;
@end

@implementation CSKVOInfoModal

- (void)dealloc {
    _context = NULL;
}

- (void)setContext:(void *)context {
    _context = context;
}

- (void *)getContext {
    return _context;
}
@end

static void callBack(id target, id nValue, id oValue, NSString *key, BOOL notificationIsPrior) {
    NSMutableDictionary *dic = objc_getAssociatedObject(target, kKVOInfoModel);
    if (dic && [dic objectForKey:key]) {
        NSMutableArray *mutArr = [dic objectForKey:key];
        for (CSKVOInfoModal *infoModel in mutArr) {
            if (infoModel && infoModel.observer && [infoModel.observer respondsToSelector:@selector(cs_observeValueForKeyPath:ofObject:change:context:)]) {
                NSMutableDictionary *changeDic = [NSMutableDictionary dictionary];
                if (infoModel.options & CS_NSKeyValueObservingOptionNew && nValue) {
                    [changeDic setObject:nValue forKey:@"new"];
                }
                if (infoModel.options & CS_NSKeyValueObservingOptionOld && oValue) {
                    [changeDic setObject:oValue forKey:@"old"];
                }
                
                if (notificationIsPrior) {
                    if (infoModel.options & CS_NSKeyValueObservingOptionPrior) {
                        [changeDic setObject:@"1" forKey:@"notificationIsPrior"];
                    } else {
                        continue;
                    }
                }
                
                [infoModel.observer cs_observeValueForKeyPath:infoModel.keyPath ofObject:infoModel.target change:changeDic context:infoModel.getContext];
                
            }
        }
    }
}


//通过getter方法名字转换成setter方法名
static NSString * setterNameFromGetterName(NSString *getterName) {
    if (getterName.length < 1) return nil;
    NSString *setterName;
    setterName = [getterName stringByReplacingCharactersInRange:NSMakeRange(0, 1) withString:[[getterName substringToIndex:1] uppercaseString]];
    setterName = [NSString stringWithFormat:@"set%@:", setterName];
    return setterName;
}

static inline int classHasSel(Class class, SEL sel) {
    unsigned int count = 0;
    Method *mehtods = class_copyMethodList(class, &count);
    for (int i = 0; i < count; i++) {
        Method method = mehtods[i];
        SEL mSel = method_getName(method);
        if (mSel == sel) {
            free(mehtods);
            return 1;
        }
    }
    free(mehtods);
    return 0;
}

//通过settername获取getter方法的name
static NSString * getterNameFromSetterName(NSString *setterName) {
    if (setterName.length < 1 || ![setterName hasPrefix:@"set"] || ![setterName hasSuffix:@":"]) return nil;
    NSString *getterName;
    getterName = [setterName substringWithRange:NSMakeRange(3, setterName.length-4)];
    getterName = [getterName stringByReplacingCharactersInRange:NSMakeRange(0, 1) withString:[[getterName substringToIndex:1] lowercaseString]];
    return getterName;
}

//KVO setter方法
static void cs_kvo_setter (id taget, SEL sel, id p0) {
        //通过setterName获取去gettername方法
    NSString *getterName = getterNameFromSetterName(NSStringFromSelector(sel));
    id old = [taget valueForKey:getterName];
    callBack(taget, nil, old, getterName, YES);
    
    //给父类发送消息
    struct objc_super sup = {
        .receiver = taget,
        .super_class = class_getSuperclass(object_getClass(taget))
    };
    ((void(*)(struct objc_super *, SEL, id)) objc_msgSendSuper)(&sup, sel, p0);
    
    callBack(taget, p0, old, getterName, NO);
}


@implementation NSObject (CS_KVO)

- (void)cs_addObserver:(NSObject *)observer forKeyPath:(NSString *)keyPath options:(CS_NSKeyValueObservingOptions)options context:(nullable void *)context {
        if (!observer || !keyPath) {
        return;
    }
//    加锁，保证线程安全
    @synchronized(self){
        //处理keypath
        NSArray *keyArr = [keyPath componentsSeparatedByString: @"."];
        if (keyPath <= 0) {
            return;
        }
    
        //通过kvc找到最终观察的对象及其属性
        id nextTargt = self;
        for (NSInteger i = 0; i < keyArr.count - 1; i++) {
            nextTargt = [nextTargt valueForKey:keyArr[i]];
        }
        
        if (![self cs_searchSetterMethodWithTarget:nextTargt getterName:keyArr.lastObject]) {
            return;
        }
        
        //    通过infoModal接受进来的参数
        CSKVOInfoModal *infoModal = [[CSKVOInfoModal alloc] init];
        infoModal.target = self;
        infoModal.observer = observer;
        infoModal.keyPath = keyPath;
        infoModal.options = options;
        [infoModal setContext:context];
        
        [self cs_bindInfoToTarget:nextTargt info:infoModal key:keyArr.lastObject options:options];
    }
}

- (void)cs_bindInfoToTarget:(id)target info:(CSKVOInfoModal *)info key:(NSString *)key options:(CS_NSKeyValueObservingOptions)options {
    //利用hook，动态给target保存属性
    NSMutableDictionary *dic = objc_getAssociatedObject(target, kKVOInfoModel);
    if (dic) {
        if ([dic objectForKey:key]) {
            NSMutableArray *mutArr = [dic objectForKey:key];
            [mutArr addObject:info];
        } else {
            NSMutableArray *mutArr = [NSMutableArray array];
            [mutArr addObject:info];
            [dic setObject:mutArr forKey:key];
        }
    } else {
        NSMutableDictionary *addDic = [NSMutableDictionary dictionary];
        NSMutableArray *mutArr = [NSMutableArray array];
        [mutArr addObject:info];
        [addDic setObject:mutArr forKey:key];
        objc_setAssociatedObject(target, kKVOInfoModel, addDic, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    
    if (options & CS_NSKeyValueObservingOptionInitial) {
        callBack(target, nil, nil, key, NO);
    }
}


//查找对象是否存在setter方法，若没有直接返回，否则创建派生类
- (BOOL)cs_searchSetterMethodWithTarget:(id)target getterName:(NSString *)getterName {
    NSString *setterName = setterNameFromGetterName(getterName);
    //通过name获取SEL
    SEL setterSel = NSSelectorFromString(setterName);
    //通过SEL获取Method
    //class_getClassMethod 获取类方法，class_getInstanceMethod获取实例方法
    //object_getClass 通过对象获取class，其实就是isa指针 [target class] 只是获取class名
    Method setterMethod = class_getInstanceMethod(object_getClass(target), setterSel);
    if (!setterMethod) {
        return NO;
    }
    
    [self cs_creatSubClassWithTarget:target];
    
  
    //给派生类添加setter方法
    if (!classHasSel(object_getClass(target), setterSel)) {
        NSLog(@"object_getClass: %@",object_getClass(target));
        NSLog(@"target_Class: %@", [target class]);
        const char *types = method_getTypeEncoding(setterMethod);
        if (class_addMethod(object_getClass(target), setterSel, (IMP)cs_kvo_setter, types)) {
            return YES;
        } else {
            return NO;
        }
        
    }
    
    return YES;
}

//创建派生类
- (void)cs_creatSubClassWithTarget:(id)target {
    //获取当前target获取类名，判断是否是派生类，如果是，直接返回
    Class nowClass = object_getClass(target);
    NSString *nowClassName = NSStringFromClass(nowClass);
    if ([nowClassName hasPrefix:kPrefixOfCSKVO]) {
        return;
    }
    
    //生产派生类的名字kPrefixOfCSKVO_TestObj
    NSString *subClass_name = [kPrefixOfCSKVO stringByAppendingString:nowClassName];
    Class subClass = NSClassFromString(subClass_name);
    //若派生类存在
    if (subClass) {
        //将该对象的isa指针指向派生类
        object_setClass(target, subClass);
        return;
    }
    
    //若不存在，创建派生类,并给派生类添加class方法体
    subClass = objc_allocateClassPair(nowClass, subClass_name.UTF8String, 0);
    const char *types = method_getTypeEncoding(class_getInstanceMethod(nowClass, @selector(class)));
    IMP class_imp = imp_implementationWithBlock(^Class(id target){
        return class_getSuperclass(object_getClass(target));
    });
    class_addMethod(subClass, @selector(class), class_imp, types);
    objc_registerClassPair(subClass);
    
    //将该对象的isa指针指向派生类
    object_setClass(target, subClass);
}

- (void)cs_removeObserver:(NSObject *)observer forKeyPath:(NSString *)keyPath {
    [self cs_removeObserver:observer forKeyPath:keyPath context:nil];
}

- (void)cs_removeObserver:(NSObject *)observer forKeyPath:(NSString *)keyPath context:(nullable void *)context {
    
    @synchronized(self) {
        //处理keypath
        NSArray *keyArr = [keyPath componentsSeparatedByString: @"."];
        if (keyPath <= 0) {
            return;
        }
        
        //通过kvc找到最终观察的对象及其属性
        id nextTargt = self;
        for (NSInteger i = 0; i < keyArr.count - 1; i++) {
            nextTargt = [nextTargt valueForKey:keyArr[i]];
        }
        
        NSString *getterName = keyArr.lastObject;
        NSMutableDictionary *dic = objc_getAssociatedObject(nextTargt, kKVOInfoModel);

        if (dic && [dic objectForKey:getterName]) {
            NSMutableArray *mutArr = [dic objectForKey:getterName];
            @autoreleasepool {
                for (CSKVOInfoModal *model in mutArr) {
                    if (model.getContext == context && model.observer == observer && [model.keyPath isEqualToString:keyPath]) {
                        [mutArr removeObject:model];
                    }
                }
            }
            
            if (mutArr.count == 0) {
                [dic removeObjectForKey:getterName];
            }
            
            if (dic.count <= 0) {
                Class nowClass = object_getClass(nextTargt);
                NSString *nowClassName = NSStringFromClass(nowClass);
                if ([nowClassName hasPrefix:kPrefixOfCSKVO]) {
                    Class superClass = [nextTargt class];
                    object_setClass(nextTargt, superClass);
                }
            }
        }
        
    }
}



@end
