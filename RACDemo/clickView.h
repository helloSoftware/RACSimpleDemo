//
//  clickView.h
//  RACDemo
//
//  Created by poplar on 2017/6/23.
//  Copyright © 2017年 poplar. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface clickView : UIView

@property(nonatomic, copy) NSString *name;


- (IBAction)btnClick:(id)sender;
- (void)sendMsg:(id)msg;

@end
