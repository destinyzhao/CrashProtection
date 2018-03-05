//
//  NSObject+UnRecognizeSelector.m
//  CrashProtection
//
//  Created by Destiny on 2018/3/4.
//  Copyright © 2018年 Destiny. All rights reserved.
//

#import "NSObject+UnRecognizeSelector.h"
#import <objc/runtime.h>
#import "ForwardingTarget.h"
#import "NSObject+Swizzling.h"

static ForwardingTarget *_target = nil;

@implementation NSObject (UnRecognizeSelector)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _target = [ForwardingTarget new];
        [NSObject exchangeInstanceMethodWithSelfClass:[self class] originalSelector:@selector(forwardingTargetForSelector:) swizzledSelector:@selector(doesnot_recognize_selector_swizzleForwardingTargetForSelector:)];
        
        //not_recognize_selector_classMethodSwizzle([self class], @selector(forwardingTargetForSelector:), @selector(doesnot_recognize_selector_swizzleForwardingTargetForSelector:));
    });
}

+ (BOOL)isWhiteListClass:(Class)class {
    // 添加白名单，限制hook的范围，排除内部类
    NSString *classString = NSStringFromClass(class);
    BOOL isInternal = [classString hasPrefix:@"_"];
    if (isInternal) {
        return YES;
    }
    BOOL isNull =  [classString isEqualToString:NSStringFromClass([NSNull class])];

    return isNull;
}

- (id)doesnot_recognize_selector_swizzleForwardingTargetForSelector:(SEL)aSelector {
    id result = [self doesnot_recognize_selector_swizzleForwardingTargetForSelector:aSelector];
    if (result) {
        return result;
    }
    
    BOOL isWhiteListClass = [[self class] isWhiteListClass:[self class]];
    if (isWhiteListClass) {
        return nil;
    }
    
    if (!result) {
        result = _target;
    }
    return result;
}

#pragma mark - private method

BOOL not_recognize_selector_classMethodSwizzle(Class aClass, SEL originalSelector, SEL swizzleSelector) {
    Method originalMethod = class_getInstanceMethod(aClass, originalSelector);
    Method swizzleMethod = class_getInstanceMethod(aClass, swizzleSelector);
    BOOL didAddMethod =
    class_addMethod(aClass,
                    originalSelector,
                    method_getImplementation(swizzleMethod),
                    method_getTypeEncoding(swizzleMethod));
    if (didAddMethod) {
        class_replaceMethod(aClass,
                            swizzleSelector,
                            method_getImplementation(originalMethod),
                            method_getTypeEncoding(originalMethod));
    } else {
        method_exchangeImplementations(originalMethod, swizzleMethod);
    }
    return YES;
}

@end
