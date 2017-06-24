//
//  Person.m
//  RACDemo
//
//  Created by poplar on 2017/6/22.
//  Copyright © 2017年 poplar. All rights reserved.
//

#import "Person.h"

@implementation Person

- (void)eatFood:(NSString *)name complete:(Complete)complete{

    if ([name isEqualToString:@"apple"]) {
        complete(@"delicious!");
    }
}

- (CGFloat(^)(int meter))run{

    //这里的float 可写可不写
    return ^CGFloat(int meter) {
        NSLog(@"%@ run %tu kilometers",self.name,meter);
        CGFloat kilo =  1.0 * meter/1000;
        return kilo;
    };
}

- (Person *(^)(NSString *value))value{

    return ^Person *(NSString *value){
        NSLog(@" %@ ",value);
        return self;
    };
}

@end
