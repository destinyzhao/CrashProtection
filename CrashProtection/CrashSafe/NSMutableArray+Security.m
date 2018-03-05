//
//  NSMutableArray+Security.m
//  CrashProtection
//
//  Created by Destiny on 2018/3/4.
//  Copyright © 2018年 Destiny. All rights reserved.
//

#import "NSMutableArray+Security.h"
#import "NSObject+Swizzling.h"
#import <objc/runtime.h>

@implementation NSMutableArray (Security)

+ (void)load
{
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        Class class = objc_getClass("__NSArrayM");
        
        // addObject
        SEL originalSelector = @selector(addObject:);
        SEL swizzledSelector = @selector(safeMutableArrayAddObject:);
        [NSObject exchangeInstanceMethodWithSelfClass:class
                                                   originalSelector:originalSelector
                                                  swizzledSelector:swizzledSelector];
        
        // insertObject
        SEL inserObjOriginalSelector = @selector(insertObject:atIndex:);
        SEL safeInserObjSelector = @selector(safeMutableArrayInsertObject:atIndex:);
        [NSObject exchangeInstanceMethodWithSelfClass:class
                                     originalSelector:inserObjOriginalSelector
                                     swizzledSelector:safeInserObjSelector];
        
        // objectAtIndex
        SEL originalObjectAtIndexSelector = @selector(objectAtIndex:);
        SEL swizzledObjectAtIndexSelector = @selector(safeMutableArrayObjectAtIndex:);
        [NSObject exchangeInstanceMethodWithSelfClass:class
                                                   originalSelector:originalObjectAtIndexSelector
                                                  swizzledSelector:swizzledObjectAtIndexSelector];
    });
}

- (void)safeMutableArrayAddObject:(id)anObject {
    if (anObject) {
        [self safeMutableArrayAddObject:anObject];
    }
}

- (void)safeMutableArrayInsertObject:(id)anObject atIndex:(NSUInteger)index{
    if (index > self.count) {
        return;
    }
    
    if (!anObject){
        return;
    }
    
    [self safeMutableArrayInsertObject:anObject atIndex:index];
}

- (id)safeMutableArrayObjectAtIndex:(NSUInteger)index {
    if (index >= self.count){
        return nil;
    }
    return [self safeMutableArrayObjectAtIndex:index];
}

@end
