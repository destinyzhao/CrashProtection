//
//  NSMutableDictionary+Security.m
//  CrashProtection
//
//  Created by Destiny on 2018/3/4.
//  Copyright © 2018年 Destiny. All rights reserved.
//

#import "NSMutableDictionary+Security.h"
#import "NSObject+Swizzling.h"
#import <objc/runtime.h>

@implementation NSMutableDictionary (Security)

+ (void)load
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        Class class = objc_getClass("__NSDictionaryM");
        
        SEL originalSelector = @selector(setObject:forKey:);
        SEL swizzledSelector = @selector(safeMutableDicSetObject:forKey:);
        
        [NSObject exchangeInstanceMethodWithSelfClass:class
                                                   originalSelector:originalSelector
                                                  swizzledSelector:swizzledSelector];
    });
}

- (void)safeMutableDicSetObject:(id)anObject forKey:(id<NSCopying>)aKey{
    if (!anObject) {
        return;
    }
    if (!aKey) {
        return;
    }
    return [self safeMutableDicSetObject:anObject forKey:aKey];
}

@end
