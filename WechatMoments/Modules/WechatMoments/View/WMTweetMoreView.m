//
//  WMTweetMoreView.m
//  WechatMoments
//
//  Created by Apple on 2018/11/10.
//  Copyright © 2018年 Apple. All rights reserved.
//

#import "WMTweetMoreView.h"
@interface WMTweetMoreView()
@property (nonatomic, strong) UIButton *likeBtn;
@property (nonatomic, strong) UIView *lineView;
@property (nonatomic, strong) UIButton *commentBtn;

@end

@implementation WMTweetMoreView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setUI];
    }
    return self;
}

- (void)setUI {
    [self addSubview:self.likeBtn];
    [self addSubview:self.lineView];
    [self addSubview:self.commentBtn];
    [self.likeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.mas_equalTo(5);
        make.width.mas_equalTo(80);
        make.bottom.mas_equalTo(-5);
    }];
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(5);
        make.left.mas_equalTo(self.likeBtn.mas_right).offset(5);
        make.width.mas_equalTo(0.5);
        make.bottom.mas_equalTo(-5);
    }];
    
    [self.commentBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(10);
        make.left.mas_equalTo(self.lineView.mas_right).offset(5);
        make.width.mas_equalTo(80);
        make.bottom.mas_equalTo(-10);
    }];
    
}

-(void)showTweetMoreViewWithRect:(CGRect)rect {
    self.frame = CGRectMake(rect.origin.x, rect.origin.y - (32 - rect.size.height) * 0.5, 0, 32);
    [UIView animateWithDuration:0.2 animations:^{
        self.hidden = NO;
        self.frame = CGRectMake(rect.origin.x - 185, rect.origin.y - (32 - rect.size.height) * 0.5, 185, 32);
        [self.superview bringSubviewToFront:self];
    }];
}

-(void)hideTweetMoreView {
    [UIView animateWithDuration:0.2 animations:^{
        self.frame = CGRectMake(self.left + self.width, self.top, 0, 32);
    } completion:^(BOOL finished) {
        self.hidden = YES;
    }];
}

#pragma mark - lazy
- (UIButton *)likeBtn {
    if (!_likeBtn) {
        _likeBtn = [[UIButton alloc] init];
        [_likeBtn setImage:[UIImage imageNamed:@"like"] forState:UIControlStateNormal];
        _likeBtn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:13];
        [_likeBtn setTitle:@" 喜欢" forState:UIControlStateNormal];
    }
    return _likeBtn;
}

- (UIButton *)commentBtn {
    if (!_commentBtn) {
        _commentBtn = [[UIButton alloc] init];
        [_commentBtn setImage:[UIImage imageNamed:@"commentImg"] forState:UIControlStateNormal];
        _commentBtn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:13];
        _commentBtn.imageView.contentMode = UIViewContentModeScaleAspectFill;
        _commentBtn.clipsToBounds = YES;
        [_commentBtn setTitle:@" 评论" forState:UIControlStateNormal];
    }
    return _commentBtn;
}

- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = [UIColor colorWithHexString:@"#999999"];
    }
    return _lineView;
}
@end
