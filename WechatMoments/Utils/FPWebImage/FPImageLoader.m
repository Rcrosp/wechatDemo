//
//  FPImageLoader.m
//  WechatMoments
//
//  Created by Apple on 2018/11/7.
//  Copyright © 2018年 Apple. All rights reserved.
//

#import "FPImageLoader.h"
@interface FPImageLoader ()
@property (nonatomic, copy) FPWebImageLoadFinishedBlock finishedBlock;
@end
@implementation FPImageLoader

- (id)loadImageWithURL:(NSURL *)url completed:(FPWebImageLoadFinishedBlock)completedBlock {
    
    FPImageCache *imageCache = [FPImageCache sharedImageCache];
    [imageCache readFileAsync:[url lastPathComponent] complete:^(NSData *data, FPImageCacheType cacheType) {
        if (data) {
            completedBlock(data, nil, cacheType, YES, url);
        } else {
            [self downloadImageFromNetworkWithURL:url Completed:completedBlock];
        }
    }];
    
    return self;
}

- (void)downloadImageFromNetworkWithURL:(NSURL *)url Completed:(FPWebImageLoadFinishedBlock)completedBlock {
    
    NSURLSessionDownloadTask *downloadTask = [[NSURLSession sharedSession] downloadTaskWithURL:url completionHandler:^(NSURL * _Nullable location, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        WMLog(@"线程:%@",[NSThread currentThread]);
        NSData *data = [NSData dataWithContentsOfURL:location];
        if (data) {
            completedBlock(data, nil, FPImageCacheTypeNetworking, YES, url);
            [[FPImageCache sharedImageCache] moveImageDataName:[[response URL] lastPathComponent] AtURL:location];
        } else {
            completedBlock(nil, error, FPImageCacheTypeNetworking, NO, url);
        }
        
    }];
    [downloadTask resume];
    
}

@end
