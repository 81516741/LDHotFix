//
//  ProblemClass.m
//  Hotfix
//
//  Created by 令达 on 2018/4/13.
//  Copyright © 2018年 令达. All rights reserved.
//

#import "ProblemClass.h"
#import "TestObject.h"

@implementation ProblemClass

- (float)divideUsingDenominator:(NSInteger)denominator dd:(NSString *)nimei
{
    [TestObject log:@"sdd" str:@"3333"];
    float value =  1.f/denominator;
    return value;
}
- (void)test:(CGFloat)value1 value2:(NSInteger)value2 value3:(NSString *)value3{
    NSLog(@"最终打印%f----%d",value1,value2);
//    self,_cmd
}
@end
