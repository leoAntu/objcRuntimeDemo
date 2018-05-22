//
//  CSNotification.m
//  Custom_notification
//
//  Created by 叮咚钱包富银 on 2018/5/18.
//  Copyright © 2018年 leo. All rights reserved.
//

#import "CSNotification.h"
#import <objc/runtime.h>
#import <objc/message.h>
@interface CSNotification ()

@property (copy) NSString *name;
@property (weak) id object;
@property (copy) NSDictionary *userInfo;

@end

@implementation CSNotification

- (instancetype)initWithName:(NSNotificationName)name object:(id)object userInfo:(NSDictionary *)userInfo {
    if (!name || ![name isKindOfClass:[NSString class]]) {
        return nil;
    }
    
    CSNotification *notifi = [CSNotification new];
    notifi.name = name;
    notifi.object = object;
    notifi.userInfo = userInfo;
    
    return notifi;
}

- (nonnull id)copyWithZone:(nullable NSZone *)zone {
    CSNotification *notifi = [[self class] allocWithZone:zone];
    notifi.name = self.name;
    notifi.object = self.object;
    notifi.userInfo = self.userInfo;
    return notifi;
}

- (void)encodeWithCoder:(nonnull NSCoder *)aCoder {
    [aCoder encodeObject:self.name forKey:@"name"];
    [aCoder encodeObject:self.object forKey:@"object"];
    [aCoder encodeObject:self.userInfo forKey:@"userInfo"];

}

- (nullable instancetype)initWithCoder:(nonnull NSCoder *)aDecoder {
    if (self = [super init]) {
        self.name = [aDecoder decodeObjectForKey:@"name"];
        self.object = [aDecoder decodeObjectForKey:@"object"];
        self.userInfo = [aDecoder decodeObjectForKey:@"userInfo"];
    }
    
    return self;
}

@end


//数据模型

@interface CSNotificationInfo : NSObject

@property (weak, nonatomic) id observer;
@property (strong, nonatomic) id observer_strong;
@property (strong, nonatomic) NSString *observerId;
@property (assign, nonatomic) SEL selector;
@property (weak, nonatomic) id object;
@property (copy, nonatomic) NSString *name;
@property (strong, nonatomic) NSOperationQueue *queue;
@property (copy, nonatomic) void(^block)(CSNotification *noti);

@end
@implementation CSNotificationInfo

@end


//消息中心类
static NSString *kdefaultNoContentKey= @"kdefaultNoContentKey";
@interface CSNotificationCenter ()

@property (class, strong) CSNotificationCenter *defaultCenter;
@property (strong) NSMutableDictionary *observersDic;

@end


@implementation CSNotificationCenter

static CSNotificationCenter *_defaultCenter = nil;

+ (void)setDefaultCenter:(CSNotificationCenter *)center {
    if (!self.defaultCenter) {
        _defaultCenter = center;
    }
}

+ (CSNotificationCenter *)defaultCenter {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _defaultCenter = [CSNotificationCenter new];
        _defaultCenter.observersDic = [NSMutableDictionary dictionary];
    });
    return _defaultCenter;
}

- (void)addObserver:(id)observer selector:(SEL)aSelector name:(NSString *)aName object:(id)anObject {
    
    if (!observer || !aSelector) {
        return;
    }
    
    CSNotificationInfo *info = [CSNotificationInfo new];
    info.observer = observer;
    info.selector = aSelector;
    info.name = aName;
    info.object = anObject;
    
    [self addObserverInfo:info];
}

- (void)addObserverInfo:(CSNotificationInfo *)info {
    
    NSMutableDictionary *mutDic = [CSNotificationCenter defaultCenter].observersDic;
    @synchronized(mutDic) {
        NSString *key = info.name ?: kdefaultNoContentKey;
        if ([mutDic objectForKey:key]) {
            NSMutableArray *mutArr = [mutDic objectForKey:key];
            [mutArr addObject:info];
            
        } else {
            NSMutableArray *mutArr = [NSMutableArray array];
            [mutArr addObject:info];
            [mutDic setObject:mutArr forKey:key];
        }
    }
}

- (id <NSObject>)addObserverForName:(nullable NSString *)name object:(nullable id)obj queue:(nullable NSOperationQueue *)queue usingBlock:(void (^)(CSNotification *notifi))block {
    if (!block) {
        return nil;
    }
    CSNotificationInfo *info = [CSNotificationInfo new];
    info.name = name;
    info.object = obj;
    info.queue = queue;
    info.block = block;
    
    NSObject *observer = [NSObject new];
    info.observer = observer;
    
    [self addObserverInfo:info];
    return observer;
}


- (void)postNotification:(CSNotification *)notification {
    if (!notification) {
        return;
    }
    NSMutableDictionary *mutDic = [CSNotificationCenter defaultCenter].observersDic;
    NSMutableArray *mutArr = [mutDic objectForKey:notification.name];
    
    [mutArr enumerateObjectsUsingBlock:^(CSNotificationInfo *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        //通过block回调
        if (obj.block) {
            if (obj.queue) {
                NSBlockOperation *operation = [NSBlockOperation blockOperationWithBlock:^{
                    obj.block(notification);
                }];
                [obj.queue addOperation:operation];
            } else {
                obj.block(notification);
            }
            return;
        }
        
        if (!obj.object || obj.object == notification.object) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
            obj.observer ? [obj.observer performSelector:obj.selector withObject:notification] : nil;
#pragma clang diagnostic pop

        }
    }];
}

- (void)postNotificationName:(NSString *)aName object:(nullable id)anObject {
    CSNotification *noti = [[CSNotification alloc] initWithName:aName object:anObject userInfo:nil];
    [self postNotification:noti];
}

- (void)postNotificationName:(NSString *)aName object:(nullable id)anObject userInfo:(nullable NSDictionary *)aUserInfo {
    CSNotification *noti = [[CSNotification alloc] initWithName:aName object:anObject userInfo:aUserInfo];
    [self postNotification:noti];
}


- (void)removeObserver:(id)observer {
    [self removeObserver:observer name:nil object:nil];
}


- (void)removeObserver:(id)observer name:(nullable NSNotificationName)aName object:(nullable id)anObject {
    if (!observer) {
        return;
    }
    NSMutableDictionary *mutDic = [CSNotificationCenter defaultCenter].observersDic;
    @synchronized(mutDic) {
        if (!aName) {
            [mutDic enumerateKeysAndObjectsUsingBlock:^(NSString *key, NSMutableArray *obj, BOOL * _Nonnull stop) {
                [self array_removeItem:obj observer:observer];
            }];
        } else {
            NSMutableArray *mutArr = [mutDic objectForKey:aName];
            [self array_removeItem:mutArr observer:observer];
        }
    }
}

- (void)array_removeItem:(NSMutableArray *)array observer:(id)obeserver {
    [array.copy enumerateObjectsUsingBlock:^(CSNotificationInfo *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.observer == obeserver) {
            [array removeObject:obj];
            return;
        }
    }];
}

@end
