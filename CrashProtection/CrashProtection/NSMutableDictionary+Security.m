//
//  NSMutableDictionary+Security.m
//  CrashProtection
//
//  Created by Destiny on 2018/3/4.
//  Copyright © 2018年 Destiny. All rights reserved.
//

#import "NSMutableDictionary+Security.h"
#import "MethodSwizzlingWithClassAndSel.h"
#import <objc/runtime.h>

@implementation NSMutableDictionary (Security)

+ (void)load
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        Class class = objc_getClass("__NSDictionaryM");
        
        SEL originalSelector = @selector(setObject:forKey:);
        SEL swizzledSelector = @selector(setNullObject:forKey:);
        
        [MethodSwizzlingWithClassAndSel methodSwizzleWithClass:class
                                                   originalSEL:originalSelector
                                                  swizzlingSEL:swizzledSelector];
    });
}

- (void)setNullObject:(id)anObject forKey:(id<NSCopying>)aKey{
    if (anObject && aKey) {
        [self setNullObject:anObject forKey:aKey];
    }
}

@end
