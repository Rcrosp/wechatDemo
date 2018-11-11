//
//  NSString+WM.h
//  WechatMoments
//
//  Created by Apple on 2018/11/9.
//  Copyright © 2018年 Apple. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (WM)
- (Boolean) isEmpty;
- (CGFloat)calculateRowHeightWithFont:(UIFont *)font andWidth:(CGFloat)width ;
@end
