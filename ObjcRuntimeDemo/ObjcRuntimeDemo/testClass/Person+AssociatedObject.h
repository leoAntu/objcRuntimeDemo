//
//  Person+AssociatedObject.h
//  ObjcRuntimeDemo
//
//  Created by 叮咚钱包富银 on 2018/5/22.
//  Copyright © 2018年 leo. All rights reserved.
//

#import "Person.h"

@interface Person (AssociatedObject)
@property (nonatomic, strong) NSString *dynamicAddProperty;
@end
