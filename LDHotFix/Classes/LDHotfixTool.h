//
//  LDHotfixTool.h
//  Hotfix
//
//  Created by 令达 on 2018/4/13.
//  Copyright © 2018年 令达. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LDHotfixTool : NSObject

+ (void)registerHotfix;
+ (void)evaluateScript:(NSString *)javascript;

@end
