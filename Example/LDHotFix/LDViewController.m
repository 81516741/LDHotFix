//
//  LDViewController.m
//  LDHotfix
//
//  Created by 81516741@qq.com on 04/15/2018.
//  Copyright (c) 2018 81516741@qq.com. All rights reserved.
//

#import "LDViewController.h"
#import "ProblemClass.h"
#import "ProbleClass1.h"
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
    //instance method test
    ProblemClass * pb = [[ProblemClass alloc] init];
    [pb divide:0 dd:@"fadsf"];
    [pb test:3.1111 value2:3333 value3:@"11111"];
    //class method test
    [ProbleClass1 classMethod];
}

@end
