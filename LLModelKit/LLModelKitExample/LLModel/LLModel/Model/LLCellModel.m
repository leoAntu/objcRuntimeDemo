//
//  LLCellModel.m
//  LLModel
//
//  Created by 叮咚钱包富银 on 2018/5/22.
//  Copyright © 2018年 leo. All rights reserved.
//

#import "LLCellModel.h"

@implementation LLCellModel

- (NSString *)description {
    return [NSString stringWithFormat:@"partnerStr:%@\n,stateStr%@",self.partnerStr,self.stateStr];
}

@end
