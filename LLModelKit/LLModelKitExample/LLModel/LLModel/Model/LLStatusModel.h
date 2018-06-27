//
//  LLStatusModel.h
//  LLModel
//
//  Created by 叮咚钱包富银 on 2018/5/22.
//  Copyright © 2018年 leo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LLCellModel.h"
#import "LLPersonModel.h"
#import "NSObject+LLModelKit.h"
@interface LLStatusModel : NSObject <LLModelDelegate>

@property (nonatomic, copy) NSString *title;

@property (nonatomic, strong) LLPersonModel *person;

@property (nonatomic, strong) NSArray *cellMdlArr;

+ (NSDictionary *)dictWithModelClass;

@end
