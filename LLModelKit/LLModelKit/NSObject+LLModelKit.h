//
//  NSObject+LLModelKit.h
//  LLModel
//
//  Created by 叮咚钱包富银 on 2018/5/22.
//  Copyright © 2018年 leo. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol LLModelDelegate <NSObject>

@optional
// 提供一个协议，只要准备这个协议的类，都能把数组中的字典转模型
+ (NSDictionary *)arrayContainModelClass;
@end

@interface NSObject (LLModelKit)

+ (id)ll_modelWithDictionary:(NSDictionary *)dic;

//属性为字典时，二级转换，需要在model实现此方法
//+ (NSDictionary *)dictWithModelClass;

@end
