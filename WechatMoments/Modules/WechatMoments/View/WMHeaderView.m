//
//  WMHeaderView.m
//  WechatMoments
//
//  Created by Apple on 2018/11/6.
//  Copyright © 2018年 Apple. All rights reserved.
//

#import "WMHeaderView.h"
static CGFloat kAvaImgViewHeight = 60.0f;

@implementation WMHeaderView
- (instancetype)init {
    if (self = [super init]) {
        [self setUI];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setUI];
    }
    return self;
}

- (void)setUI {
   UIImageView *headerBgImgView = [[UIImageView alloc] init];
    headerBgImgView.contentMode = UIViewContentModeScaleAspectFill;
    headerBgImgView.clipsToBounds = YES;
    headerBgImgView.userInteractionEnabled = YES;
    headerBgImgView.image = [UIImage imageNamed:@"coffe"];
    [self addSubview:headerBgImgView];
    self.headerBgImgView = headerBgImgView;
    
    UIImageView *avaImgView = [[UIImageView alloc] init];
    avaImgView.contentMode = UIViewContentModeScaleAspectFill;
    avaImgView.clipsToBounds = YES;
    avaImgView.image = [UIImage imageNamed:@"img-portrait-def"];
    avaImgView.userInteractionEnabled = YES;
    [self addSubview:avaImgView];
    
    //添加边框
    CALayer * layer = [avaImgView layer];
    layer.borderColor = [[UIColor whiteColor] CGColor];
    layer.borderWidth = 2.0f;
    
    //添加四个边阴影
    avaImgView.layer.shadowColor = [UIColor blackColor].CGColor;//阴影颜色
    avaImgView.layer.shadowOffset = CGSizeMake(0, 0);//偏移距离
    avaImgView.layer.shadowOpacity = 0.5;//不透明度
    avaImgView.layer.shadowRadius = 4.0;//半径
    self.avaImgView = avaImgView;
   
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self.headerBgImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.mas_equalTo(0);
        make.bottom.mas_equalTo(-60 * kViewHeightScale);
    }];
    
    [self.avaImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-16 * kViewHeightScale);
        make.bottom.mas_equalTo(-40 * kViewHeightScale);
    make.width.height.mas_equalTo(kAvaImgViewHeight);
    }];
}

@end
