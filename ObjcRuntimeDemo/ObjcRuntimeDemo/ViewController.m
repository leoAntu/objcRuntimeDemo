//
//  ViewController.m
//  ObjcRuntimeDemo
//
//  Created by 叮咚钱包富银 on 2018/5/22.
//  Copyright © 2018年 leo. All rights reserved.
//

#import "ViewController.h"
#import "Person.h"
#import "RuntimeManager.h"
#import <objc/runtime.h>
#import "Person+AssociatedObject.h"
@interface ViewController ()
@property (nonatomic, strong) Person *person;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    Person *obj = [Person new];
    
    //实例对象获取
    NSLog(@"实例对象获取");
    NSLog(@"instance         :%p", obj);
    NSLog(@"class            :%p", object_getClass(obj));
    NSLog(@"meta class       :%p", object_getClass(object_getClass(obj)));
    NSLog(@"root meta        :%p", object_getClass(object_getClass(object_getClass(obj))));
    NSLog(@"root meta's meta :%p", object_getClass(object_getClass(object_getClass(object_getClass(obj)))));
    NSLog(@"---------------------------------------------");
    NSLog(@"class            :%p", [obj class]);
    NSLog(@"meta class       :%p", [[obj class] class]);
    NSLog(@"root meta        :%p", [[[obj class] class] class]);
    NSLog(@"root meta's meta :%p", [[[[obj class] class] class] class]);
    NSLog(@"---------------------------------------------");
    //类获取
    NSLog(@"实例对象获取");
    NSLog(@"meta class       :%p", object_getClass([Person class]));
    NSLog(@"root class       :%p", object_getClass(object_getClass([Person class])));
    NSLog(@"root meta's meta :%p", object_getClass(object_getClass(object_getClass([Person class]))));
    NSLog(@"---------------------------------------------");
    NSLog(@"class            :%p", [Person class]);
    NSLog(@"meta class       :%p", [[Person class] class]);
    NSLog(@"root meta        :%p", [[[Person class] class] class]);
    NSLog(@"root meta's meta :%p", [[[[Person class] class] class] class]);
    NSLog(@"---------------------------------------------");
    
//    2018-06-28 11:11:24.854838+0800 ObjcRuntimeDemo[3053:4311329] 实例对象获取
//    2018-06-28 11:11:24.855023+0800 ObjcRuntimeDemo[3053:4311329] instance         :0x60000044d7a0
//    2018-06-28 11:11:24.855137+0800 ObjcRuntimeDemo[3053:4311329] class            :0x10331f930
//    2018-06-28 11:11:24.855260+0800 ObjcRuntimeDemo[3053:4311329] meta class       :0x10331f958
//    2018-06-28 11:11:24.855378+0800 ObjcRuntimeDemo[3053:4311329] root meta        :0x1042cbe58
//    2018-06-28 11:11:24.855486+0800 ObjcRuntimeDemo[3053:4311329] root meta's meta :0x1042cbe58
//    2018-06-28 11:11:24.855579+0800 ObjcRuntimeDemo[3053:4311329] ---------------------------------------------
//    2018-06-28 11:11:24.855681+0800 ObjcRuntimeDemo[3053:4311329] class            :0x10331f930
//    2018-06-28 11:11:24.855797+0800 ObjcRuntimeDemo[3053:4311329] meta class       :0x10331f930
//    2018-06-28 11:11:24.855946+0800 ObjcRuntimeDemo[3053:4311329] root meta        :0x10331f930
//    2018-06-28 11:11:24.856149+0800 ObjcRuntimeDemo[3053:4311329] root meta's meta :0x10331f930
//    2018-06-28 11:11:24.856472+0800 ObjcRuntimeDemo[3053:4311329] ---------------------------------------------
//    2018-06-28 11:11:24.857417+0800 ObjcRuntimeDemo[3053:4311329] 实例对象获取
//    2018-06-28 11:11:24.857806+0800 ObjcRuntimeDemo[3053:4311329] meta class       :0x10331f958
//    2018-06-28 11:11:24.858098+0800 ObjcRuntimeDemo[3053:4311329] root class       :0x1042cbe58
//    2018-06-28 11:11:24.858240+0800 ObjcRuntimeDemo[3053:4311329] root meta's meta :0x1042cbe58
//    2018-06-28 11:11:24.858486+0800 ObjcRuntimeDemo[3053:4311329] ---------------------------------------------
//    2018-06-28 11:11:24.858688+0800 ObjcRuntimeDemo[3053:4311329] class            :0x10331f930
//    2018-06-28 11:11:24.858886+0800 ObjcRuntimeDemo[3053:4311329] meta class       :0x10331f930
//    2018-06-28 11:11:24.859254+0800 ObjcRuntimeDemo[3053:4311329] root meta        :0x10331f930
//    2018-06-28 11:11:24.859477+0800 ObjcRuntimeDemo[3053:4311329] root meta's meta :0x10331f930
//    2018-06-28 11:11:24.859620+0800 ObjcRuntimeDemo[3053:4311329] ---------------------------------------------
}

//获取类名
- (IBAction)classNameAction:(id)sender {
    NSString *name = [RuntimeManager fetchClassName:[Person class]];
    NSLog(@"类名---- %@",name);
}

- (IBAction)ivarListAction:(id)sender {
    NSMutableArray *arr = [RuntimeManager fetchIvarList:[Person class]];
    NSLog(@"ivarList---- %@",arr);
}

- (IBAction)propertyListAction:(id)sender {
    NSMutableArray *arr = [RuntimeManager fetchPropertyList:[Person class]];
    NSLog(@"PropertyList---- %@",arr);
}

- (IBAction)methodListAction:(id)sender {
    NSMutableArray *arr = [RuntimeManager fetchMethodList:[Person class]];
    NSLog(@"fetchProtocolList---- %@",arr);
}

- (IBAction)classMethodListAction:(id)sender {
    NSMutableArray *arr = [RuntimeManager fetchClassMethodList:[Person class]];
    NSLog(@"fetchClassMethodList---- %@",arr);
}

- (IBAction)protocalListAction:(id)sender {
    NSMutableArray *arr = [RuntimeManager fetchProtocolList:[Person class]];
    NSLog(@"fetchProtocolList---- %@",arr);
}

- (IBAction)addMethodAction:(id)sender {
    [self.person performSelector:@selector(noThisMethod:) withObject:@"随便传参"];
}

- (IBAction)associatedAction:(id)sender {
    self.person.dynamicAddProperty = @"我是动态添加的属性";
    NSLog(@"associatedAction---- %@",self.person.dynamicAddProperty);

}

- (IBAction)swapMethodAction:(id)sender {
    [self.person swapMethod];
    //交换后，调用老方法
    [self.person methodOld];
}


- (Person *)person {
    if (_person == nil) {
        _person = [[Person alloc] init];
    }
    return _person;
}

@end
