




//
//  WMTweetFootView.m
//  WechatMoments
//
//  Created by Apple on 2018/11/9.
//  Copyright © 2018年 Apple. All rights reserved.
//

#import "WMTweetFootView.h"
@interface WMTweetFootView()
@property (nonatomic ,strong)UIView *lineView;
@end
@implementation WMTweetFootView
- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithReuseIdentifier:reuseIdentifier]) {
        self.contentView.backgroundColor = [UIColor colorWithHexString:@"#FFFFFF"];
        [self setUI];
    }
    return self;
}

- (void)setUI {
    [self.contentView addSubview:self.lineView];
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(10);
        make.left.right.equalTo(self.contentView);
        make.height.mas_equalTo(1);
    }];
}


#pragma mark - lazy
- (UIView *)lineView {
    if (!_lineView) {
        _lineView  = [[UIView alloc]init];
        _lineView.backgroundColor = [UIColor colorWithHexString:@"#e0e0e0"];
    }
    return _lineView;
}
@end
