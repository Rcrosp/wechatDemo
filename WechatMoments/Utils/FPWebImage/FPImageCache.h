//
//  FPImageCache.h
//  WechatMoments
//
//  Created by Apple on 2018/11/7.
//  Copyright © 2018年 Apple. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef NS_ENUM(NSInteger, FPImageCacheType) {
    /**
     * 没有缓存，网络请求下来
     */
    FPImageCacheTypeNetworking,
    /**
     * 磁盘中读出
     */
    FPImageCacheTypeDisk,
    /**
     * 内存中读出
     */
    FPImageCacheTypeMemory
};

@interface FPImageCache : NSObject

+ (FPImageCache *)sharedImageCache;

- (void)writeImageData:(NSData *)data forKey:(NSString *)fileName;

/**
 *  将下载的图片   从原始地址移动到 image文件夹
 *
 *  @param srcURL <#srcURL description#>
 *
 *  @return <#return value description#>
 */
- (BOOL)moveImageDataName:(NSString *)fileName AtURL:(NSURL *)srcURL;

- (NSData *)readDataForKey:(NSString *)fileName;

- (void)readFileAsync:(NSString *)fileName complete:(void (^)(NSData *data, FPImageCacheType cacheType))complete;
@end
