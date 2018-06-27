//
//  ViewController.m
//  LLModel
//
//  Created by 叮咚钱包富银 on 2018/5/22.
//  Copyright © 2018年 leo. All rights reserved.
//

#import "ViewController.h"
#import "NSObject+LLModelKit.h"
#import "LLStatusModel.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"model.plist" ofType:nil];
    NSDictionary *modePlist = [NSDictionary dictionaryWithContentsOfFile:path];
    NSArray *arr = modePlist[@"statuses"];
    
    for (NSDictionary *dic in arr) {
        LLStatusModel *model = [LLStatusModel ll_modelWithDictionary:dic];
        NSLog(@"%@",model);
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
