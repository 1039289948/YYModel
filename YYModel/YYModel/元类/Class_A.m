//
//  Class_A.m
//  YYModel
//
//  Created by Mobiyun on 2017/11/14.
//  Copyright © 2017年 冀凯旋. All rights reserved.
//

#import "Class_A.h"

@interface Class_A ()

@property (strong, nonatomic) Class_B *m_b;

@end

@implementation Class_A

- (instancetype)init{

    if (self = [super init]) {
     
        Class_B *clas = [[Class_B alloc]init];
        clas.m_name = @"123";
        id cls = [Class_B class];
        void *obj = &cls;
        [(__bridge id)obj speek];
        
    }
    return self;
}



@end
