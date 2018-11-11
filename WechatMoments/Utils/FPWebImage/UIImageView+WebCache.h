//
//  UIImageView+WebCache.h
//  WechatMoments
//
//  Created by Apple on 2018/11/6.
//  Copyright © 2018年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImageView (WebCache)

/**
 *  返回imageUrl
 *
 *  @return imageUrl
 */
- (NSString *)imageURL;

/**
 *  直接设置WebUrl
 *
 *  @param url WebUrl
 */
- (void)setFPImageWithURL:(NSString *)url;

/**
 *  设置WebUrl,还设置placeholderImageName
 *
 *  @param url             WebUrl
 *  @param placeholderName placeholderImageName
 */
- (void)setFPImageWithURL:(NSString *)url placeholderImageName:(NSString *)placeholderName;


@end
