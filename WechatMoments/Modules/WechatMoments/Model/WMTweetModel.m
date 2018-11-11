//
//  WMTweetModel.m
//  WechatMoments
//
//  Created by Apple on 2018/11/7.
//  Copyright © 2018年 Apple. All rights reserved.
//

#import "WMTweetModel.h"

@implementation WMTweetModel
+ (NSDictionary *)modelContainerPropertyGenericClass {
    
    return @{@"comments" : [WMTweetModel class],
             @"images" : [WMImagModel class]
             };
}

- (BOOL)modelCustomTransformFromDictionary:(NSDictionary *)dic {
    UIFont *font = [UIFont fontWithName:@"PingFangSC-Regular" size:15];
    CGFloat width = SCREEN_WIDTH - 32;
    CGFloat height = [_content calculateRowHeightWithFont:font andWidth:width];
    if (height > 40) {
        _isNeedExpanding = YES;
    }else {
        _isNeedExpanding = NO;
    }
    
    return YES;
}
@end
