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
    
}

- (void)sendMsg:(id)msg{

    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
