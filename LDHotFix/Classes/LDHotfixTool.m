//
//  LDHotfixTool.m
//  Hotfix
//
//  Created by 令达 on 2018/4/13.
//  Copyright © 2018年 令达. All rights reserved.
//

#import "LDHotfixTool.h"
#import <JavaScriptCore/JavaScriptCore.h>
#import <objc/runtime.h>
#import <Foundation/Foundation.h>
#import "Aspects.h"

#define kAddNoNilObj(arr,obj)\
if (obj != nil) {\
    [arr addObject:obj];\
}

@implementation LDHotfixTool

+ (LDHotfixTool *)sharedInstance
{
    static LDHotfixTool * sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    
    return sharedInstance;
}

+ (JSContext *)context
{
    static JSContext *_context;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _context = [[JSContext alloc] init];
        [_context setExceptionHandler:^(JSContext *context, JSValue *value) {
            NSLog(@"Oops: %@", value);
        }];
    });
    return _context;
}

#pragma mark - public method
+ (void)registerHotfix
{
    [self context][@"fixInstanceMethodBefore"] = ^(NSString *instanceName, NSString *selectorName, JSValue *fixImpl) {
        [self _fixWithMethod:NO aspectionOptions:AspectPositionBefore instanceName:instanceName selectorName:selectorName fixImpl:fixImpl];
    };
    
    [self context][@"fixInstanceMethodReplace"] = ^(NSString *instanceName, NSString *selectorName, JSValue *fixImpl) {
        [self _fixWithMethod:NO aspectionOptions:AspectPositionInstead instanceName:instanceName selectorName:selectorName fixImpl:fixImpl];
    };
    
    [self context][@"fixInstanceMethodAfter"] = ^(NSString *instanceName, NSString *selectorName, JSValue *fixImpl) {
        [self _fixWithMethod:NO aspectionOptions:AspectPositionAfter instanceName:instanceName selectorName:selectorName fixImpl:fixImpl];
    };
    
    [self context][@"fixClassMethodBefore"] = ^(NSString *instanceName, NSString *selectorName, JSValue *fixImpl) {
        [self _fixWithMethod:YES aspectionOptions:AspectPositionBefore instanceName:instanceName selectorName:selectorName fixImpl:fixImpl];
    };
    
    [self context][@"fixClassMethodReplace"] = ^(NSString *instanceName, NSString *selectorName, JSValue *fixImpl) {
        [self _fixWithMethod:YES aspectionOptions:AspectPositionInstead instanceName:instanceName selectorName:selectorName fixImpl:fixImpl];
    };
    
    [self context][@"fixClassMethodAfter"] = ^(NSString *instanceName, NSString *selectorName, JSValue *fixImpl) {
        [self _fixWithMethod:YES aspectionOptions:AspectPositionAfter instanceName:instanceName selectorName:selectorName fixImpl:fixImpl];
    };
    
    [self context][@"runClassWithParamters"] = ^id(NSString *className, NSString *selectorName, id obj1, id obj2, id obj3, id obj4, id obj5,id obj6,id obj7) {
        NSMutableArray * params = [NSMutableArray array];
        kAddNoNilObj(params, obj1)
        kAddNoNilObj(params, obj2)
        kAddNoNilObj(params, obj3)
        kAddNoNilObj(params, obj4)
        kAddNoNilObj(params, obj5)
        kAddNoNilObj(params, obj6)
        kAddNoNilObj(params, obj7)
        NSObject * obj = [self _runClassSelector:selectorName className:className params:params];
        if (obj != nil) {
            return obj;
        } else {
            return nil;
        }
    };
    
    [self context][@"runInstanceWithParamters"] = ^id(id instance, NSString *selectorName, id obj1, id obj2, id obj3, id obj4, id obj5,id obj6,id obj7) {
        NSMutableArray * params = [NSMutableArray array];
        kAddNoNilObj(params, obj1)
        kAddNoNilObj(params, obj2)
        kAddNoNilObj(params, obj3)
        kAddNoNilObj(params, obj4)
        kAddNoNilObj(params, obj5)
        kAddNoNilObj(params, obj6)
        kAddNoNilObj(params, obj7)
        NSObject * obj = [self _runInstanceSelector:selectorName instance:instance params:params];
        if (obj != nil) {
            return obj;
        } else {
            return nil;
        }
    };
    
    [self context][@"runInvocation"] = ^(NSInvocation *invocation,NSArray * params) {
        NSPredicate * predicateInt = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",@"Int\\([0-9]+\\)"];
        NSPredicate * predicateFloat = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",@"Float\\((-?\\d+)(\\.\\d+)?\\)"];
        for (int i = 0; i < params.count; i ++) {
            NSString * param = params[i];
            NSAssert([param isKindOfClass:NSString.self], @"js传参必须是字符串类型");
            if ([predicateInt evaluateWithObject:param]) {
                NSLog(@"匹配到了Int");
                param = [[param stringByReplacingOccurrencesOfString:@"Int(" withString:@""] stringByReplacingOccurrencesOfString:@")" withString:@""];
                long long arg = [param longLongValue];
                [invocation setArgument:&arg atIndex:i + 2];
            } else if ([predicateFloat evaluateWithObject:param]) {
                NSLog(@"匹配到了Float");
                param = [[param stringByReplacingOccurrencesOfString:@"Float(" withString:@""] stringByReplacingOccurrencesOfString:@")" withString:@""];
                double arg = [param doubleValue];
                [invocation setArgument:&arg atIndex:i + 2];
            } else {
                [invocation setArgument:&param atIndex:i + 2];
            }
            
        }
        [invocation invoke];
    };
    
    // helper
    [[self context] evaluateScript:@"var console = {}"];
    [self context][@"console"][@"log"] = ^(id message) {
        NSLog(@"Javascript log: %@",message);
    };
}

+ (void)evaluateScript:(NSString *)javascript
{
    [[self context] evaluateScript:javascript];
}

#pragma mark - private method
+ (void)_fixWithMethod:(BOOL)isClassMethod aspectionOptions:(AspectOptions)option instanceName:(NSString *)instanceName selectorName:(NSString *)selectorName fixImpl:(JSValue *)fixImpl {
    Class klass = NSClassFromString(instanceName);
    if (isClassMethod) {
        klass = object_getClass(klass);
    }
    SEL sel = NSSelectorFromString(selectorName);
    [klass aspect_hookSelector:sel withOptions:option usingBlock:^(id<AspectInfo> aspectInfo){
        [fixImpl callWithArguments:@[aspectInfo.instance, aspectInfo.originalInvocation, aspectInfo.arguments]];
    } error:nil];
}

+ (id)_runClassSelector:(NSString *)selector className:(NSString *)className  params:(NSArray *)params {
    Class class = NSClassFromString(className);
    return [self _safePerformSelector:NSSelectorFromString(selector) target:class params:params];
}

+ (id)_runInstanceSelector:(NSString *)selector instance:(id)instance  params:(NSArray *)params{
    return [self _safePerformSelector:NSSelectorFromString(selector) target:instance params:params];
}


+ (id)_safePerformSelector:(SEL)selector target:(id)target params:(NSArray *)params
{
    NSMethodSignature* methodSig;
    
    methodSig = [target methodSignatureForSelector:selector];
    
    if(methodSig == nil) {
        return nil;
    }
    
    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:methodSig];
    for (int i = 0; i < params.count; i ++) {
        id param = params[i];
        [invocation setArgument:&param atIndex:i + 2];
    }
    [invocation setSelector:selector];
    [invocation setTarget:target];
    [invocation invoke];
    
    const char* retType = [methodSig methodReturnType];
    //void
    if (strcmp(retType, "v") == 0) {
        return nil;
    }
    //bool  char short  int  long    long long
    if (strcmp(retType, "B") == 0 ||strcmp(retType, "c") == 0 ||strcmp(retType, "s") == 0 ||strcmp(retType, "i") == 0 ||strcmp(retType, "l") == 0 ||strcmp(retType, "q") == 0 ) {
        long long result = 0;
        [invocation getReturnValue:&result];
        return @(result);
    }
    
    //float  double
    if (strcmp(retType, "f") == 0 ||strcmp(retType, "d") == 0 ) {
        double result = 0.0;
        [invocation getReturnValue:&result];
        return @(result);
    }
    
    //NSObject
    if (strcmp(retType, "@") == 0) {
        __autoreleasing NSObject * result=nil;
        [invocation getReturnValue:&result];
        return result;
    }
    
    return nil;
}

@end
