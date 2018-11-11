//
//  FPImageCache.m
//  WechatMoments
//
//  Created by Apple on 2018/11/7.
//  Copyright © 2018年 Apple. All rights reserved.
//

#import "FPImageCache.h"
static char *queueName = "fileManagerQueue";

@interface FPImageCache ()
{
    dispatch_queue_t _queue;
}
@property (strong, nonatomic) NSCache *imageDataCache;
@end
@implementation FPImageCache

- (NSCache *)imageDataCache {
    if (!_imageDataCache) {
        self.imageDataCache = [[NSCache alloc] init];
    }
    return _imageDataCache;
}

+ (FPImageCache *)sharedImageCache {
    static FPImageCache *imageCache = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        imageCache = [[FPImageCache alloc] init];
    });
    return imageCache;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _queue = dispatch_queue_create(queueName, DISPATCH_QUEUE_CONCURRENT);
    }
    return self;
}

- (void)writeImageData:(NSData *)data forKey:(NSString *)fileName {
    [self.imageDataCache setObject:data forKey:fileName];
    NSString *filepath = [self filePathForKey:fileName];
    dispatch_queue_t fileQueue = dispatch_queue_create("my.imagefile.queue", DISPATCH_QUEUE_CONCURRENT);
    dispatch_async(fileQueue, ^{
        [[NSFileManager defaultManager] createFileAtPath:filepath contents:data attributes:nil];
    });
    
}

- (BOOL)moveImageDataName:(NSString *)fileName AtURL:(NSURL *)srcURL {
    [self.imageDataCache setObject:[NSData dataWithContentsOfURL:srcURL] forKey:fileName];
    NSString *filepath = [self filePathForKey:fileName];
    NSURL *filepathURL = [NSURL fileURLWithPath:filepath];
    //移动到文件夹
    return [[NSFileManager defaultManager] moveItemAtURL:srcURL toURL:filepathURL error:NULL];
}

/**
 *  从缓存中读取数据(同步读取)
 *
 *  @return <#return value description#>
 */
- (NSData *)readDataForKey:(NSString *)fileName {
    if (fileName == nil) {
        return nil;
    }
    NSData *memoryData = [self.imageDataCache objectForKey:fileName];
    if (memoryData) {
        return memoryData;
    }
    
    NSString *filepath = [self filePathForKey:fileName];
    NSData *fileData = [[NSFileManager defaultManager] contentsAtPath:filepath];
    if (fileData) {
        [self.imageDataCache setObject:fileData forKey:fileName];
        return fileData;
    }
    
    return nil;
    
}

- (void)readFileAsync:(NSString *)fileName complete:(void (^)(NSData *data, FPImageCacheType cacheType))complete {
    NSData *memoryData = [self.imageDataCache objectForKey:fileName];
    if (memoryData) {
        complete(memoryData, FPImageCacheTypeMemory);
        return;
    }
    
    dispatch_async(_queue, ^{
        
        NSString *filepath = [self filePathForKey:fileName];
        NSData *fileData = [[NSFileManager defaultManager] contentsAtPath:filepath];
        if (fileData) {
            [self.imageDataCache setObject:fileData forKey:fileName];
        }
        
        if (complete) {
            complete(fileData, FPImageCacheTypeDisk);
        }
    });
}

#pragma mark -------   file path
- (NSString *)filePathForKey:(NSString *)fileName {
    return [[[self class] getCachesImagePath] stringByAppendingPathComponent:fileName];
}

//获取Images文件夹路径
+ (NSString *)getCachesImagePath {
    //1.获取Caches文件夹的路径
    NSString *filePath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject];
    //2.获取Images文件夹的路径
    NSString *imagesPath = [filePath stringByAppendingPathComponent:@"Images"];
    //3.判断文件夹是否存在
    NSFileManager *manager = [NSFileManager defaultManager];
    if (![manager fileExistsAtPath:imagesPath]) {
        //没有,创建Images文件夹
        BOOL isSuccess = [manager createDirectoryAtPath:imagesPath withIntermediateDirectories:YES attributes:nil error:nil];
        if (isSuccess) {
            WMLog(@"创建成功");
        } else {
            WMLog(@"创建失败");
        }
    }
    return imagesPath;
}

#pragma mark -----  clear caches
+ (void)clearCachesImage {
    NSFileManager *manager = [NSFileManager defaultManager];
    //删除文件夹
    [manager removeItemAtPath:[self getCachesImagePath] error:nil];
    [self getCachesImagePath];
}

@end
