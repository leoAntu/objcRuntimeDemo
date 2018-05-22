//
//  ViewController.m
//  Custom-kvo
//
//  Created by 叮咚钱包富银 on 2018/5/14.
//  Copyright © 2018年 leo. All rights reserved.
//

#import "ViewController.h"
#import "NSObject+CS_KVO.h"

@interface TestObj: NSObject
@property (nonatomic, assign) NSInteger age;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *love;
@end
@implementation TestObj
- (instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}
- (void)setAge:(NSInteger)age {
    
    _age = age;
}

@end

@interface ViewController ()
@property (nonatomic, strong) TestObj *testObj;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.testObj = [[TestObj alloc] init];
    self.testObj.age = 10;

    [self cs_addObserver:self forKeyPath:@"testObj.love" options:CS_NSKeyValueObservingOptionNew|CS_NSKeyValueObservingOptionOld|CS_NSKeyValueObservingOptionPrior context:nil];
    
    [self cs_addObserver:self forKeyPath:@"testObj.name" options:CS_NSKeyValueObservingOptionNew|CS_NSKeyValueObservingOptionOld|CS_NSKeyValueObservingOptionPrior context:nil];
    self.testObj.name = @"vvvv";
    self.testObj.love = @"dddd";

    [self cs_removeObserver:self forKeyPath:@"testObj.love"];
    self.testObj.love = @"cccc";
//    self.testObj.love = @"ffff";

//    [self cs_addObserver:self forKeyPath:@"testObj.age" options:YB_NSKeyValueObservingOptionNew|YB_NSKeyValueObservingOptionOld|YB_NSKeyValueObservingOptionPrior context:nil];
    self.testObj.age = 11;

}

- (void)cs_observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    
    NSLog(@"keyPath--%@,ofObject---%@,change--%@",keyPath,object,change);
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
