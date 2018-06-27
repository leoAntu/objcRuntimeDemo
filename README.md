# objcRuntimeDemo
包含开发中常见使用到的runtime情景，关联属性，添加新方法，交换方法，runtime实现kvo，通知，消息转发等

* 1.Custom_notification --- 自定义通知功能。

* 2.Custom-kvo -- 通过runtime，模仿官方kvo api实现功能。 

* 3.RuntimeMessageForwarding --- 实现消息转发。
    
* 4.ObjcRuntimeDemo -- runtime常用操作集合，包括获取类的ivar，property，method，classMethod,protocol,关联属性，新增方法，交换方法。


# LLModelKit基于runtime+kvo实现的数据模型转换练习demo

使用方法：参照demo

```
@interface LLStatusModel : NSObject <LLModelDelegate>

@property (nonatomic, copy) NSString *title;

@property (nonatomic, strong) LLPersonModel *person;

@property (nonatomic, strong) NSArray *cellMdlArr;

+ (NSDictionary *)dictWithModelClass;
```

* 1. 二级转换实现方法--- 字典转model

```
+ (NSDictionary *)dictWithModelClass;
```

* 2. 三级转换 -- 数组转model

```
实现协议代理
<LLModelDelegate>
```

