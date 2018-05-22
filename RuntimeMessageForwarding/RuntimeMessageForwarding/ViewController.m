//
//  ViewController.m
//  RuntimeMessageForwarding
//
//  Created by 叮咚钱包富银 on 2018/5/21.
//  Copyright © 2018年 leo. All rights reserved.
//

#import "ViewController.h"
#import "Student.h"
#import "NSObject+messageForwarding.h"
@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIButton *btn;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    //实例方法
    Student *obj = [Student new];
    
    [obj sendMessage:@"haha"];
    
    [obj forwardingSendMessage:@"haha"];
    
    [obj normalForwardingSendMessage:@"hehe"];
    
    [obj doesNotNormalForwardingSendMessage:@"sdf"];
    

    //类方法
    [Student classSendMessage:@"hehe"];
    
    //未实现btn，不进行消息转发会崩溃
    [self.btn addTarget:self action:@selector(btnClickAction:) forControlEvents:UIControlEventTouchUpInside];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
