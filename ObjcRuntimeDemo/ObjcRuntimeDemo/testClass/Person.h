//
//  Person.h
//  ObjcRuntimeDemo
//
//  Created by 叮咚钱包富银 on 2018/5/22.
//  Copyright © 2018年 leo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ManPerson.h"
@interface Person : NSObject <NSCopying,NSCoding>
@property (nonatomic, copy) NSString *name;
@property (nonatomic, strong) ManPerson *man;

+ (Person *)defaultPserson;

- (void)swapMethod;

- (void)methodOld;

@end
