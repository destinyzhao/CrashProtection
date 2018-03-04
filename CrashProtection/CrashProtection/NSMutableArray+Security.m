//
//  NSMutableArray+Security.m
//  CrashProtection
//
//  Created by Destiny on 2018/3/4.
//  Copyright © 2018年 Destiny. All rights reserved.
//

#import "NSMutableArray+Security.h"
#import "MethodSwizzlingWithClassAndSel.h"
#import <objc/runtime.h>

@implementation NSMutableArray (Security)

+ (void)load
{
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        Class class = objc_getClass("__NSArrayM");
        
        SEL originalSelector = @selector(addObject:);
        SEL swizzledSelector = @selector(addNullObject:);
        
        [MethodSwizzlingWithClassAndSel methodSwizzleWithClass:class
                                                   originalSEL:originalSelector
                                                  swizzlingSEL:swizzledSelector];
        
        SEL originalObjectAtIndexSelector = @selector(objectAtIndex:);
        SEL swizzledObjectAtIndexSelector = @selector(swizzledObjectAtIndex:);
        
        [MethodSwizzlingWithClassAndSel methodSwizzleWithClass:class
                                                   originalSEL:originalObjectAtIndexSelector
                                                  swizzlingSEL:swizzledObjectAtIndexSelector];
    });
}

- (void)addNullObject:(id)anObject {
    if (anObject) {
        [self addNullObject:anObject];
    }
}

- (void)insertNullObject:(id)anObject atIndex:(NSUInteger)index{
    if (anObject) {
        [self insertNullObject:anObject atIndex:index];
    }
}

- (id)swizzledObjectAtIndex:(NSUInteger)index {
    if (self.count-1 < index) {
        // 这里做一下异常处理，不然都不知道出错了。
        @try {
            return [self swizzledObjectAtIndex:index];
        }
        @catch (NSException *exception) {
            // 在崩溃后会打印崩溃信息，方便我们调试。
            NSLog(@"---------- %s Crash Because Method %s  ----------\n", class_getName(self.class), __func__);
            NSLog(@"%@", [exception callStackSymbols]);
            return nil;
        }
        @finally {}
    } else {
        return [self swizzledObjectAtIndex:index];
    }
}

@end
