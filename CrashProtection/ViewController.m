//
//  ViewController.m
//  CrashProtection
//
//  Created by Destiny on 2018/3/4.
//  Copyright © 2018年 Destiny. All rights reserved.
//

#import "ViewController.h"
#import "NSObject+UnRecognizeSelector.h"
#import "TestSelector.h"
#import "NSMutableArray+Security.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [self crashDic];
};

- (void)crashSelector
{
    //unrecognized selector crash Test
    TestSelector *obj = [TestSelector new];
    [obj performSelector:@selector(speak)];

}

- (void)crashArray
{
    // 利用Method Swizzling NSMutableArray addObject 为nil时候程序不会崩溃
    NSMutableArray *array = [NSMutableArray array];
    for (NSInteger i=0; i < 9; i++) {
        [array addObject:nil];
    }
    NSLog(@"array is :%@",array);
}

- (void)crashDic
{
    // 利用Method Swizzling 设置NSMutableDictionary object 为nil时候程序不会崩溃
    NSMutableDictionary *mutableDic = [NSMutableDictionary dictionary];
    [mutableDic setObject:nil forKey:@"key"];
    NSLog(@"mutableDic is :%@",mutableDic);

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
