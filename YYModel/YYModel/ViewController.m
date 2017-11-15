//
//  ViewController.m
//  YYModel
//
//  Created by Mobiyun on 2017/11/14.
//  Copyright © 2017年 冀凯旋. All rights reserved.
//

#import "ViewController.h"
#import "Class_A.h"
#import "Son.h"
#import <objc/runtime.h>

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    Class_A *clss = [[Class_A alloc]init];
    
    
    Son *son = [Son new];
    
    Class class = object_getClass(son);
    
    do {
        
        Class isaClass = object_getClass(class);
        
        id metaClass = objc_getMetaClass(object_getClassName(class));
        Class superClass = class_getSuperclass(class);
        
        NSMutableString *string = [NSMutableString new];
        
        [string appendFormat:@"Class %@->isa=%@(%p); superClass=%@(%p); metaclass=%@(%p)\n\n", class, isaClass, isaClass, superClass ?: @"nil", superClass, metaClass, metaClass];
        
        Class metaClassSuper = class_getSuperclass(metaClass);
        id metaClassIsa = object_getClass(metaClass);
        
        [string appendFormat:@"metaclass %@(%p)->isa=%@(%p); superClass=%@(%p)\n", metaClass, metaClass, metaClassIsa, metaClassIsa, metaClassSuper, metaClassSuper];
        
        NSLog(@"%@-------------------------------------\n", string);
        
        class = superClass;
        
    }while (class);

    /**
     
     关于YYModel学习的一点心得，并借助：https://juejin.im/post/5a097435f265da431769a49c 如有不足之处，或是错误，请麻烦支出，并指导一下，菜鸟恳请
     
     元类的定义：
        一个对象的实质就是一块内存空间，如果内存空间想调用一个方法，则通过ISA找到class对象，然后找到imp，然后通过imp找到对应的方法
     
     
     
     */



}

- (void)YYClassInfo{

    /**
     
     YYClassInfo 主要将 Runtime 层级的一些结构体封装到 NSObject 层级以便调用
     
     YYClassInfo 中包含了：
     
        YYClassIvarInfo     -->> objc_ivar  -->> 变量的结构体
        YYClassMethodInfo   -->> objc_method-->> 定义方法的结构体
        YYClassPropertyInfo -->> property_t -->> 表示属性的结构体
        YYClassInfo         -->> objc_class -->> 表示一个 Objective-C 类
     
        YYClassIvarInfo:{
     
            YYClassIvarInfo 看做是对 Runtime 层 objc_ivar 结构体的封装，objc_ivar 是 Runtime 中表示变量的结构体。
     
            @property (nonatomic, assign, readonly) Ivar ivar;              ///< ivar opaque struct     < 变量，对应 objc_ivar
            @property (nonatomic, strong, readonly) NSString *name;         ///< Ivar's name            < 变量名称，对应 ivar_name
            @property (nonatomic, assign, readonly) ptrdiff_t offset;       ///< Ivar's offset          < 变量偏移量，对应 ivar_offset
            @property (nonatomic, strong, readonly) NSString *typeEncoding; ///< Ivar's type encoding   < 变量类型编码，通过 ivar_getTypeEncoding 函数得到
            @property (nonatomic, assign, readonly) YYEncodingType type;    ///< Ivar's type            < 变量类型，通过 YYEncodingGetType 方法从类型编码中得到
     
            
            struct objc_ivar {
                char * _Nullable ivar_name OBJC2_UNAVAILABLE; // 变量名称
                char * _Nullable ivar_type OBJC2_UNAVAILABLE; // 变量类型
                int ivar_offset OBJC2_UNAVAILABLE; // 变量偏移量
            #ifdef __LP64__ // 如果已定义 __LP64__ 则表示正在构建 64 位目标
                int space OBJC2_UNAVAILABLE; // 变量空间
            #endif
            }
        }
     
     
        YYClassMethodInfo:{
     
            YYClassMethodInfo 则是对 Runtime 中 objc_method 的封装，objc_method 在 Runtime 是用来定义方法的结构体。
     
            @property (nonatomic, assign, readonly) Method method;                  ///< method opaque struct                < 方法
            @property (nonatomic, strong, readonly) NSString *name;                 ///< method name                         < 方法名称
            @property (nonatomic, assign, readonly) SEL sel;                        ///< method's selector                   < 方法选择器
            @property (nonatomic, assign, readonly) IMP imp;                        ///< method's implementation             < 方法实现，指向实现方法函数的函数指针
            @property (nonatomic, strong, readonly) NSString *typeEncoding;         ///< method's parameter and return types < 方法参数和返回类型编码
            @property (nonatomic, strong, readonly) NSString *returnTypeEncoding;   ///< return value's type                 < 返回值类型编码
            @property (nullable, nonatomic, strong, readonly) NSArray<NSString *> *argumentTypeEncodings; ///< array of arguments' type < 参数类型编码数组

     
            struct objc_method {
                SEL _Nonnull method_name OBJC2_UNAVAILABLE; // 方法名称
                char * _Nullable method_types OBJC2_UNAVAILABLE; // 方法类型
                IMP _Nonnull method_imp OBJC2_UNAVAILABLE; // 方法实现（函数指针）
            }
     
            SEL 和 char * 存在某种映射关系，可以相互转换。同时猜测 SEL 本质上就是 char *
     
        }
     
        YYClassPropertyInfo：{
     
            是作者对 property_t 的封装，property_t 在 Runtime 中是用来表示属性的结构体。
     
            @property (nonatomic, assign, readonly) objc_property_t property; ///< property's opaque struct < 属性
            @property (nonatomic, strong, readonly) NSString *name;           ///< property's name          < 属性名称
            @property (nonatomic, assign, readonly) YYEncodingType type;      ///< property's type          < 属性类型
            @property (nonatomic, strong, readonly) NSString *typeEncoding;   ///< property's encoding value< 属性类型编码
            @property (nonatomic, strong, readonly) NSString *ivarName;       ///< property's ivar name     < 变量名称
            @property (nullable, nonatomic, assign, readonly) Class cls;      ///< may be nil               < 类型
            @property (nullable, nonatomic, strong, readonly) NSArray<NSString *> *protocols; ///< may nil  < 属性相关协议
            @property (nonatomic, assign, readonly) SEL getter;               ///< getter (nonnull)         < getter 方法选择器
            @property (nonatomic, assign, readonly) SEL setter;               ///< setter (nonnull)         < setter 方法选择器
     
     
        }
     
     
     
     */
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
