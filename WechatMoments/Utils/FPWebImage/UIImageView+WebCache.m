//
//  UIImageView+WebCache.m
//  WechatMoments
//
//  Created by Apple on 2018/11/6.
//  Copyright © 2018年 Apple. All rights reserved.
//

#import "objc/runtime.h"
#import "UIImageView+WebCache.h"
#import "FPImageLoader.h"

static const void *imageURLKey = &imageURLKey;
@implementation UIImageView (WebCache)
- (NSString *)imageURL {
    return objc_getAssociatedObject(self, imageURLKey);
}

- (void)setImageURL:(NSString *)imageURL {
    objc_setAssociatedObject(self, imageURLKey, imageURL, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)setFPImageWithURL:(NSString *)url {
    [self setFPImageWithURL:url placeholderImageName:nil];
    
}

- (void)setFPImageWithURL:(NSString *)url placeholderImageName:(NSString *)placeholderName {
    if (placeholderName) {
        UIImage *image = [UIImage imageNamed:placeholderName];
        self.image = image;
        
    }
    [self setFPImageWithURL:url options:nil];
}

/**
 *  设置图片
 *
 *  @param url             图片url
 *  @param options         预留参数 添加功能时会做更改
 */
- (void)setFPImageWithURL:(NSString *)url options:(NSString *)options {
    
    objc_setAssociatedObject(self, imageURLKey, url, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    FPImageLoader *loader = [[FPImageLoader alloc] init];
    [loader loadImageWithURL:[NSURL URLWithString:url] completed:^(NSData *imageData, NSError *error, FPImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
        if (finished) {
            dispatch_async(dispatch_get_main_queue(), ^{
                //切换到主线程
                self.image = [UIImage imageWithData:imageData];
            });
        }
    }];
    
}

@end
