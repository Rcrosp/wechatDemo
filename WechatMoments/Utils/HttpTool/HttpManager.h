//
//  HttpManager.h
//  WechatMoments
//
//  Created by Apple on 2018/11/6.
//  Copyright © 2018年 Apple. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef void(^SuccessBlock)(NSDictionary * dict);
typedef void(^FailureBlock)(NSError *error);
@interface HttpManager : NSObject
+(HttpManager *)shareManager;

-(void)requestGetWithUrl:(NSString *)urlString withPatams:(NSDictionary *)dic withSuccessBlock:(SuccessBlock)sucBlock withFailureBlock:(FailureBlock)failureBlock;

@end
