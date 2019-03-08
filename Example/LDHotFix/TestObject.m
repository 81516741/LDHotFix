//
//  TestObject.m
//  Hotfix
//
//  Created by 令达 on 2018/4/13.
//  Copyright © 2018年 令达. All rights reserved.
//

#import "TestObject.h"

@implementation TestObject
+(void)log:(NSString *)str0 str:(NSString *)str1
{
    NSLog(@"我就是TestObject,%@,%@",str0,str1);
}

+ (instancetype)instance:(NSString *)sss
{
    NSLog(@"ddd");
    return [TestObject new];
}

- (int)show:(NSString *)name1 name2:(NSString *)name2 name3:(NSString *)name3 name4:(NSString *)name4 name5:(NSString *)name5 name6:(NSString *)name6
{
    NSLog(@"%@%@%@%@%@%@",name1,name2,name3,name4,name5,name6);
    return 666;
}
@end
