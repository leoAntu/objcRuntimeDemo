//
//  NSObject+CS_KVO.h
//  Custom-kvo
//
//  Created by 叮咚钱包富银 on 2018/5/14.
//  Copyright © 2018年 leo. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_OPTIONS(NSUInteger, CS_NSKeyValueObservingOptions) {
    CS_NSKeyValueObservingOptionNew = 0x01,
    CS_NSKeyValueObservingOptionOld = 0x02,
    CS_NSKeyValueObservingOptionInitial = 0x04,
    CS_NSKeyValueObservingOptionPrior = 0x08
};

//模仿系统提供的方法设置api
@interface NSObject (YB_KVO)

- (void)cs_addObserver:(NSObject *)observer forKeyPath:(NSString *)keyPath options:(CS_NSKeyValueObservingOptions)options context:(nullable void *)context;
- (void)cs_removeObserver:(NSObject *)observer forKeyPath:(NSString *)keyPath context:(nullable void *)context;
- (void)cs_removeObserver:(NSObject *)observer forKeyPath:(NSString *)keyPath;

//kvo回调方法
- (void)cs_observeValueForKeyPath:(nullable NSString *)keyPath ofObject:(nullable id)object change:(nullable NSDictionary*)change context:(nullable void *)context;

@end

NS_ASSUME_NONNULL_END

