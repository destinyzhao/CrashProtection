
//
//  NSObject+Swizzling.m
//  CrashProtection
//
//  Created by Destiny on 2018/3/4.
//  Copyright © 2018年 Destiny. All rights reserved.
//

#import <objc/runtime.h>
#import "NSObject+Swizzling.h"

@implementation NSObject (Swizzling)
+ (void)exchangeInstanceMethodWithSelfClass:(Class)selfClass
                           originalSelector:(SEL)originalSelector
                           swizzledSelector:(SEL)swizzledSelector {
    
    Method originalMethod = class_getInstanceMethod(selfClass, originalSelector);
    Method swizzledMethod = class_getInstanceMethod(selfClass, swizzledSelector);
    
    // 动态添加方法 Class cls, SEL name, IMP imp, const char types
    BOOL didAddMethod = class_addMethod(selfClass,
                                        originalSelector,
                                        method_getImplementation(swizzledMethod),
                                        method_getTypeEncoding(swizzledMethod));
    // 如果动态方法添加成功
    if (didAddMethod) {
        // 如果方法存在替换方法
        class_replaceMethod(selfClass,
                            swizzledSelector,
                            method_getImplementation(originalMethod),
                            method_getTypeEncoding(originalMethod));
    } else {
        // 交换两个方法实现
        method_exchangeImplementations(originalMethod, swizzledMethod);
    }
}

@end
