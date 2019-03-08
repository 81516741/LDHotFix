//
//  LDViewController.m
//  LDHotfix
//
//  Created by 81516741@qq.com on 04/15/2018.
//  Copyright (c) 2018 81516741@qq.com. All rights reserved.
//

#import "LDViewController.h"
#import "ProblemClass.h"
@interface LDViewController ()

@end

@implementation LDViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor redColor];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    ProblemClass * pb = [[ProblemClass alloc] init];
    CGFloat result = [pb divideUsingDenominator:0 dd:@"fadsf"];
    [pb test:33 value2:3.1111 value3:@""];
    NSLog(@"结果是%f",result);
}

@end
