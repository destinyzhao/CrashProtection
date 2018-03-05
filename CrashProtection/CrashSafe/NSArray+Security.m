//
//  NSArray+Security.m
//  CrashProtection
//
//  Created by Destiny on 2018/3/4.
//  Copyright © 2018年 Destiny. All rights reserved.
//

#import "NSArray+Security.h"
#import "NSObject+Swizzling.h"
#import <objc/runtime.h>

@implementation NSArray (Security)

+ (void)load
{
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        Class class = objc_getClass("__NSArrayI");
        
        SEL originalSelector = @selector(objectAtIndex:);
        SEL swizzledSelector = @selector(safeArrayObjectAtIndex:);
        
        [NSObject exchangeInstanceMethodWithSelfClass:class
                                                   originalSelector:originalSelector
                                                  swizzledSelector:swizzledSelector];
    });
}

- (id)safeArrayObjectAtIndex:(NSUInteger)index {
    if (index >= self.count){
        return nil;
    }
    return [self safeArrayObjectAtIndex:index];
}

@end
