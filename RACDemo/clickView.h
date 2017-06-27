//
//  clickView.h
//  RACDemo
//
//  Created by poplar on 2017/6/23.
//  Copyright © 2017年 poplar. All rights reserved.
//

#import <UIKit/UIKit.h>

@class clickView;
typedef void(^CompleteBlock)(NSString *data);

typedef void(^BtnClickBlock)(NSString *title);

typedef clickView*(^ClickBlock)(NSString *string);
typedef clickView*(^ShowBlock)(NSString *string);

@interface clickView : UIView

@property(nonatomic, copy) NSString *name;

@property(nonatomic, copy) BtnClickBlock btnClickBlock;

- (IBAction)btnClick:(id)sender;
- (void)sendMsg:(id)msg;

- (void)btnClick:(id)sender complete:(CompleteBlock)complete;

- (ClickBlock)click;

- (ShowBlock)show;

@end
