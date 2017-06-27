//
//  NetTool.m
//  RACDemo
//
//  Created by poplar on 2017/6/22.
//  Copyright © 2017年 poplar. All rights reserved.
//

#import "NetTool.h"

@implementation NetTool

+ (instancetype)shareTool{
    
    static dispatch_once_t onceToken;
    static NetTool *netTool = nil;
    dispatch_once(&onceToken, ^{
        netTool = [[NetTool alloc] init];
        netTool.requestSerializer = [AFJSONRequestSerializer serializer];
        netTool.responseSerializer = [AFHTTPResponseSerializer serializer];
        netTool.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/x-www-form-urlencoded",@"application/json",@"text/xml", @"text/json", @"text/javascript",@"text/html",@"text/plain", nil];
    });
    return netTool;
}

- (RACSignal *)getWithURL:(NSString *)url parameters:(NSDictionary *)parameters{

    RACSignal *signal = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
      
        [self GET:url parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress) {
                NSLog(@"\n downProgress = %@",downloadProgress);
            } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                NSString *response = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
//                NSLog(@"\n responseObject = %@",response);
                
                ////========发送信号
                [subscriber sendNext:response];

            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                NSLog(@"\n error = %@",error);
            }];

        //信号的返回通常是对于信号的销毁
        return nil;
    }];
    return signal;
}

- (RACCommand *)getDataWithUrl:(NSString *)url{

    RACCommand *command = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
        NSLog(@"要请求啦");

        RACSignal *signal = [[RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
            [self GET:url parameters:input progress:^(NSProgress * _Nonnull downloadProgress) {
                NSLog(@"\n downProgress = %@",downloadProgress);
            } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                NSString *response = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
                //                NSLog(@"\n responseObject = %@",response);
                
                ////========发送信号
                [subscriber sendNext:response];
                [subscriber sendCompleted];
                
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                NSLog(@"\n error = %@",error);
            }];
            
            return nil;
        }] delay:3];
        

        return signal;
    }];
    return command;
}

@end
