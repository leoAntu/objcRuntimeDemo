//
//  RuntimeManager.h
//  ObjcRuntimeDemo
//
//  Created by 叮咚钱包富银 on 2018/5/22.
//  Copyright © 2018年 leo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RuntimeManager : NSObject
/**
 获取类名
 
 @param cls 类
 @return 类名
 */
+ (NSString *)fetchClassName:(Class)cls;

/**
 获取成员变量ivarList (私有成员变量，property都能获取)

 @param cls 类
 @return 成员变量数组
 */
+ (NSMutableArray *)fetchIvarList:(Class)cls;

/**
 获取属性列表

 @param cls 类
 @return 属性数组
 */
+ (NSMutableArray *)fetchPropertyList:(Class)cls;

/**
 获取类的协议列表

 @param cls 类
 @return 协议名字数组
 */
+ (NSMutableArray *)fetchProtocolList:(Class)cls;

/**
 获取类的实例方法，不能获取类方法
 @param cls 类
 @return 方法名数组
 */
+ (NSMutableArray *)fetchMethodList:(Class)cls;

/**
 获取类的类方法，不能获取实例方法

 @param cls 类
 @return 类方法名数组
 */
+ (NSMutableArray *)fetchClassMethodList:(Class)cls;

/**
 给实例对象动态添加对象方法，此方法不能添加类方法

 @param cls 类
 @param oSel 调用的SEL
 @param nSel 动态添加新的SEL
 */
+ (void)addMethod:(Class)cls oldSel:(SEL)oSel newSel:(SEL)nSel;

/**
 给实例对象动态交换对象方法，此方法不能交换类方法


 @param cls 类
 @param oSel 老方法
 @param nSel 新方法
 */
+ (void)swapMethod:(Class)cls oldSel:(SEL)oSel newSel:(SEL)nSel;

@end
