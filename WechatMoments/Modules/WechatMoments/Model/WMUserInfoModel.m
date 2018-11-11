//
//  WMUserInfoModel.m
//  WechatMoments
//
//  Created by Apple on 2018/11/6.
//  Copyright © 2018年 Apple. All rights reserved.
//

#import "WMUserInfoModel.h"

@implementation WMUserInfoModel
+ (nullable NSDictionary<NSString *, id> *)modelCustomPropertyMapper{
    return @{@"profileImage":@"profile-image"};
}
@end
