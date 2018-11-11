





//
//  WMPhotosView.m
//  WechatMoments
//
//  Created by Apple on 2018/11/8.
//  Copyright © 2018年 Apple. All rights reserved.
//

#import "WMPhotosView.h"
#import "WMImagModel.h"
@interface WMPhotosView()
@property (nonatomic, strong) NSArray *imageViewsArray;
@end
@implementation WMPhotosView

-(instancetype)init{
    if (self = [super init]) {
        [self setUp];
    }
    return self;
}

-(void)setUp{
    NSMutableArray *temp = [NSMutableArray new];
    for (int i = 0; i < 9; i++) {
        UIImageView *imageView = [UIImageView new];
        [self addSubview:imageView];
        imageView.userInteractionEnabled = YES;
        imageView.tag = i;
        [temp addObject:imageView];
    }
    self.imageViewsArray = [temp copy];
}

-(void)setImageModelArray:(NSArray *)imageModelArray{
    _imageModelArray = imageModelArray;
    [self dealData];
}

-(void)dealData{
    for (long i = _imageModelArray.count; i < self.imageViewsArray.count; i++) {
        UIImageView *imageView = [self.imageViewsArray objectAtIndex:i];
        imageView.hidden = YES;
    }
    
    if (_imageModelArray.count == 0) {
        
        [self mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(0);
            make.width.mas_equalTo(0);
        }];
        
        return;
    }
    
    CGFloat itemW = [self itemWidthForPicPathArray:_imageModelArray];
    CGFloat itemH = _imageModelArray.count == 1 ? 180 : itemW;
    long perRowItemCount = [self perRowItemCountForPicPathArray:_imageModelArray];
    CGFloat margin = 5;
    
    [self.imageModelArray enumerateObjectsUsingBlock:^(NSString *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        long columnIndex = idx % perRowItemCount;
        long rowIndex = idx / perRowItemCount;
        UIImageView *imageView = [self.imageViewsArray objectAtIndex:idx];
        imageView.hidden = NO;
        WMImagModel *model = self.imageModelArray[idx];

        [imageView setFPImageWithURL:model.url placeholderImageName:@"placeholder"];
        [imageView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(columnIndex * (itemW + margin));
            make.top.mas_equalTo(rowIndex * (itemH + margin));
            make.width.mas_equalTo(itemW);
            make.height.mas_equalTo(itemH);
        }];
    }];
    
    CGFloat w = perRowItemCount * itemW + (perRowItemCount - 1) * margin;
    int columnCount = ceilf(_imageModelArray.count * 1.0 / perRowItemCount);
    CGFloat h = columnCount * itemH + (columnCount - 1) * margin;
  
    [self mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(h);
        make.width.mas_equalTo(w);
    }];
    
}

- (CGFloat)itemWidthForPicPathArray:(NSArray *)array
{
    if (array.count == 1) {
        return 120;
    } else {
        CGFloat w = [UIScreen mainScreen].bounds.size.width > 320 ? 80 : 70;
        return w;
    }
}

- (NSInteger)perRowItemCountForPicPathArray:(NSArray *)array
{
    if (array.count <= 3) {
        return array.count;
    } else {
        return 3;
    }
}
@end
