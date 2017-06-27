//
//  NetTool.h
//  RACDemo
//
//  Created by poplar on 2017/6/22.
//  Copyright © 2017年 poplar. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking.h>
#import <ReactiveObjC.h>

@interface NetTool : AFHTTPSessionManager

+ (instancetype)shareTool;

- (RACSignal *)getWithURL:(NSString *)url parameters:(NSDictionary *)parameters;

- (RACCommand *)getDataWithUrl:(NSString *)url;

@end
