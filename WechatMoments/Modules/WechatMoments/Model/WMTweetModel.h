//
//  WMTweetModel.h
//  WechatMoments
//
//  Created by Apple on 2018/11/7.
//  Copyright © 2018年 Apple. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WMSenderModel.h"
#import "WMImagModel.h"
@interface WMTweetModel : NSObject
@property(nonatomic, copy) NSString *error;
@property(nonatomic, copy) NSString *content;
@property(nonatomic, strong) WMSenderModel *sender;
@property(nonatomic, copy) NSArray *images;
@property(nonatomic, copy) NSArray *comments;
@property (nonatomic, assign) Boolean isExpanding;
@property (nonatomic, assign) Boolean isNeedExpanding;
@end
