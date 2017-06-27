//
//  clickView.m
//  RACDemo
//
//  Created by poplar on 2017/6/23.
//  Copyright © 2017年 poplar. All rights reserved.
//

#import "clickView.h"

@implementation clickView
- (IBAction)btnClick:(id)sender {
    
    [self sendMsg:@"hello Controller"];
    
    NSString *string = [(UIButton *)sender currentTitle];
    self.btnClickBlock(string);
    
}

- (void)sendMsg:(id)msg{
    
    
}

- (void)btnClick:(id)sender complete:(CompleteBlock)complete{

    NSString *string = (NSString *)sender;
    NSLog(@"2s later string will come");
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
    
        complete(string);
    });
}

- (ClickBlock)click{

    NSLog(@"开始click了");
    
    ClickBlock block = ^clickView *(NSString *string){
        NSLog(@"click click %@",string);
        return self;
    };
    
    return block;
}

- (ShowBlock)show{

    NSLog(@"开始show了");
    ShowBlock block = ^clickView *(NSString *string){
    
        NSLog(@"show show %@",string);
        return self;
    };
    return block;
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
