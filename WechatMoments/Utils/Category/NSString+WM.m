
//
//  NSString+WM.m
//  WechatMoments
//
//  Created by Apple on 2018/11/9.
//  Copyright © 2018年 Apple. All rights reserved.
//

#import "NSString+WM.h"

@implementation NSString (WM)
- (Boolean)isEmpty{
    if (!self) {
        return true;
    } else {
        NSCharacterSet *set = [NSCharacterSet whitespaceAndNewlineCharacterSet];
        NSString *trimedString = [self stringByTrimmingCharactersInSet:set];
        if ([trimedString length] == 0) {
            return true;
        } else {
            return false;
        }
    }
}

- (CGFloat)calculateRowHeightWithFont:(UIFont *)font andWidth:(CGFloat)width {
    NSDictionary *dic = @{NSFontAttributeName:font};  //指定字号
    CGRect rect = [self boundingRectWithSize:CGSizeMake(width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:dic context:nil];
    return rect.size.height;
}

@end
