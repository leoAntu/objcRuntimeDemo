快速集成：

```
pod 'LLModelKit'
```

使用方法：参照demo

```
@interface LLStatusModel : NSObject <LLModelDelegate>

@property (nonatomic, copy) NSString *title;

@property (nonatomic, strong) LLPersonModel *person;

@property (nonatomic, strong) NSArray *cellMdlArr;

+ (NSDictionary *)dictWithModelClass;
```

*  1. 二级转换实现方法--- 字典转model

```
+ (NSDictionary *)dictWithModelClass;
```

*  2. 三级转换 -- 数组转model

```
实现协议代理
<LLModelDelegate>
```

