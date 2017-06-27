//
//  ViewController.h
//  RACDemo
//
//  Created by poplar on 2017/6/21.
//  Copyright © 2017年 poplar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "clickView.h"

typedef void(^TitleBlock)(NSString *title);

@interface ViewController : UIViewController

@property(nonatomic, copy) TitleBlock titleBlock;

@property(nonatomic, strong) clickView *clickView;

@end

