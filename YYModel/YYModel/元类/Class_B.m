//
//  Class_B.m
//  YYModel
//
//  Created by Mobiyun on 2017/11/14.
//  Copyright © 2017年 冀凯旋. All rights reserved.
//

#import "Class_B.h"

@interface Class_B ()


@end

@implementation Class_B

- (void)setM_name:(NSString *)m_name{
    _m_name = m_name;
}

-(void)speek{

    NSLog(@"my name is %@",self.m_name);
}

@end
