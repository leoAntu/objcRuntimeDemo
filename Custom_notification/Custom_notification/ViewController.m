//
//  ViewController.m
//  Custom_notification
//
//  Created by 叮咚钱包富银 on 2018/5/18.
//  Copyright © 2018年 leo. All rights reserved.
//

#import "ViewController.h"
#import "CSNotification.h"

@interface ViewController ()
@property (nonatomic, strong) NSObject *observerNotifi;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
//    [NSNotificationCenter defaultCenter]
    
    [[CSNotificationCenter defaultCenter] addObserver:self selector:@selector(notifiCallBack:) name:@"test" object:nil];
    
   self.observerNotifi = [[CSNotificationCenter defaultCenter] addObserverForName:@"test1" object:nil queue:nil usingBlock:^(CSNotification *notifi) {
       NSLog(@"---%@,--%@,,--%@",notifi.name,notifi.object,notifi.userInfo);
    }];

}

- (void)notifiCallBack:(CSNotification *)notification {
    
    NSLog(@"---%@,--%@,,--%@",notification.name,notification.object,notification.userInfo);
    
}

- (IBAction)sendAction:(id)sender {
    [[CSNotificationCenter defaultCenter] postNotificationName:@"test" object:nil userInfo:@{@"key":@"123"}];
    [[CSNotificationCenter defaultCenter] postNotificationName:@"test1" object:nil userInfo:@{@"key":@"456"}];

}

- (IBAction)removeNotifiAction:(id)sender {
//    [[CSNotificationCenter defaultCenter] removeObserver:self.observerNotifi];
//    [[CSNotificationCenter defaultCenter] removeObserver:self];
    [[CSNotificationCenter defaultCenter] removeObserver:self name:@"test" object:nil];
    [[CSNotificationCenter defaultCenter] removeObserver:self.observerNotifi name:@"test1" object:nil];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
