//
//  FPImageLoader.h
//  WechatMoments
//
//  Created by Apple on 2018/11/7.
//  Copyright © 2018年 Apple. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FPImageCache.h"

typedef void(^FPWebImageLoadFinishedBlock)(NSData *imageData, NSError *error, FPImageCacheType cacheType, BOOL finished, NSURL *imageURL);

@interface FPImageLoader : NSObject

- (id)loadImageWithURL:(NSURL *)url completed:(FPWebImageLoadFinishedBlock)completedBlock;

@end
