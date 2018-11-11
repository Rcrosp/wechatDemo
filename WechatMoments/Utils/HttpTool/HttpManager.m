//
//  HttpManager.m
//  WechatMoments
//
//  Created by Apple on 2018/11/6.
//  Copyright © 2018年 Apple. All rights reserved.
//

#import "HttpManager.h"
#import "AFNetworking.h"
@implementation HttpManager

+(HttpManager *)shareManager{
    static HttpManager *manager=nil;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        if (manager==nil) {
            manager=[[HttpManager alloc]init];
        }
    });
    return manager;
}

-(void)requestGetWithUrl:(NSString *)urlString withPatams:(NSDictionary *)dic withSuccessBlock:(SuccessBlock)sucBlock withFailureBlock:(FailureBlock)failureBlock{
    AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json",@"text/html", @"text/javascript",@"text/plain", nil];
    [manager GET:urlString parameters:dic progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        sucBlock(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failureBlock(error);
    }];
}


@end
