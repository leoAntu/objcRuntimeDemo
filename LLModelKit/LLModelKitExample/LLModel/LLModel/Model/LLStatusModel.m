
//
//  LLStatusModel.m
//  LLModel
//
//  Created by 叮咚钱包富银 on 2018/5/22.
//  Copyright © 2018年 leo. All rights reserved.
//

#import "LLStatusModel.h"

@implementation LLStatusModel

+ (NSDictionary *)arrayContainModelClass
{
    return @{@"cellMdlArr" : @"CellModel"};
}

+ (NSDictionary *)dictWithModelClass {
    return @{@"person": @"LLPersonModel"};
}

- (NSString *)description {
    return [NSString stringWithFormat:@"title:%@\n,person:%@\n,cellMdlArr:%@",self.title,self.person,self.cellMdlArr];
}

@end
