//
//  Person.h
//  RACDemo
//
//  Created by poplar on 2017/6/22.
//  Copyright © 2017年 poplar. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef void(^Complete)(NSString *feeling);

@interface Person : NSObject

@property(nonatomic, strong) NSString *name;

- (void)eatFood:(NSString *)name complete:(Complete)complete;

- (CGFloat (^)(int meter))run;

//block高级用法 链式编程
- (Person *(^)(NSString *value))value;

@end
