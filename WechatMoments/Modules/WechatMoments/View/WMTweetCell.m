
//
//  WMTweetCell.m
//  WechatMoments
//
//  Created by Apple on 2018/11/8.
//  Copyright © 2018年 Apple. All rights reserved.
//

#import "WMTweetCell.h"
#import "WMPhotosView.h"
@interface WMTweetCell()
@property (nonatomic, strong)UIImageView *avaImgView;
@property (nonatomic, strong)UILabel *nameLabel;
@property (nonatomic, strong)UILabel *contentLabel;
@property(nonatomic,strong)UIImageView *replyBtn;
@property (nonatomic, strong) WMPhotosView *photosView;
@property (nonatomic, strong) UIImageView *moreImgView;
@property (nonatomic, strong) UIButton *lookMoreBtn;
@end
@implementation WMTweetCell
+ (WMTweetCell *)tweetCellForTableview:(UITableView *)tableView {
    static NSString *cellId = @"WMTweetCell";
    WMTweetCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell == nil) {
        cell = [[WMTweetCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    
     cell.translatesAutoresizingMaskIntoConstraints = NO;
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setUI];
    }
    return self;
}

- (void)setUI {
    [self.contentView addSubview:self.avaImgView];
    [self.contentView addSubview:self.nameLabel];
    [self.contentView addSubview:self.contentLabel];
    [self.contentView addSubview:self.lookMoreBtn];
    [self.contentView addSubview:self.photosView];
    [self.contentView addSubview:self.moreImgView];
    
    [self.avaImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(16);
        make.top.mas_equalTo(16);
        make.size.mas_equalTo(CGSizeMake(55, 55));
        
    }];
    
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.avaImgView.mas_right).offset(15);
        make.right.equalTo(self.contentView).offset(-15);
        make.height.mas_equalTo(16);
        make.top.equalTo(self.avaImgView);
    }];
    
    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.nameLabel);
        make.right.equalTo(self.nameLabel);
        make.top.mas_equalTo(self.nameLabel.mas_bottom).offset(10);
    }];
    
    [self.lookMoreBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.nameLabel);
        make.top.mas_equalTo(self.contentLabel.mas_bottom).offset(10);
    }];
    
    [self.moreImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.photosView.mas_bottom).offset(8);
        make.right.equalTo(self.nameLabel);
        make.bottom.equalTo(self.contentView);
        make.width.height.mas_equalTo(36);
    }];
}

- (void)setTweetModel:(WMTweetModel *)tweetModel {
    
    _tweetModel = tweetModel;
    [self.avaImgView setFPImageWithURL:tweetModel.sender.avatar placeholderImageName:@"img-portrait-def"];
    self.nameLabel.text = tweetModel.sender.username;
    if (tweetModel.isNeedExpanding ) {
        self.lookMoreBtn.hidden = NO;
        if (tweetModel.isExpanding) {
            self.contentLabel.numberOfLines = 0;
            [self.lookMoreBtn setTitle:@"收起" forState:UIControlStateNormal];
        }else {
            self.contentLabel.numberOfLines = 4;
            [self.lookMoreBtn setTitle:@"查看全部" forState:UIControlStateNormal];
        }
        [self.lookMoreBtn mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(10);
            make.top.mas_equalTo(self.contentLabel.mas_bottom).offset(8);
        }];
    }else {
        self.lookMoreBtn.hidden = YES;
        self.contentLabel.numberOfLines = 4;
        [self.lookMoreBtn mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(0);
            make.top.mas_equalTo(self.contentLabel.mas_bottom).offset(0);
        }];
    }
    self.contentLabel.text = tweetModel.content;
    self.photosView.imageModelArray = tweetModel.images;
    if(tweetModel.images.count > 0) {
        [self.photosView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.lookMoreBtn.mas_bottom).offset(10).with.priorityHigh();
            make.left.equalTo(self.nameLabel);
        }];
    }else {
        if (!tweetModel.content) {
            [self.photosView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.contentLabel.mas_bottom).offset(30).with.priorityHigh();
                make.left.equalTo(self.nameLabel);
            }];
        }else {
            [self.photosView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(self.contentLabel.mas_bottom).offset(20).with.priorityHigh();
                make.left.equalTo(self.nameLabel);
            }];
        }
    }
    
}

- (void)clickMore {
    if ([self.delegate respondsToSelector:@selector(cellMoreClick:rect:cell:)]) {
        [self.delegate cellMoreClick:self.tweetModel rect:self.moreImgView.frame cell:self];
    }
}

-(void)lookMoreBtnClick {
    if (self.tweetLookFullTextblock) {
        self.tweetModel.isExpanding = !self.tweetModel.isExpanding;
        self.tweetLookFullTextblock();
    }
}

#pragma mark ---lazy
- (UIImageView *)avaImgView {
    if (!_avaImgView) {
        _avaImgView = [[UIImageView alloc] init];
        _avaImgView.contentMode = UIViewContentModeScaleAspectFill;
        _avaImgView.clipsToBounds = YES;
        CALayer *layer = [_avaImgView layer];
        //是否设置边框以及是否可见
        [layer setMasksToBounds:YES];
        //设置边框线的宽
        [layer setBorderWidth:1];
        //设置边框线的颜色
        [layer setBorderColor:[[UIColor whiteColor] CGColor]];
    }
    return _avaImgView;
}

- (UILabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:17];
        _nameLabel.textColor = [UIColor colorWithHexString:@"#1D2230"];
    }
    return _nameLabel;
}

- (UILabel *)contentLabel {
    if (!_contentLabel) {
        _contentLabel = [[UILabel alloc] init];
        _contentLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:15];
        _contentLabel.textColor = [UIColor colorWithHexString:@"#1D2230"];
        _contentLabel.numberOfLines = 3;
    }
    return _contentLabel;
}

- (WMPhotosView *)photosView {
    if (!_photosView) {
        _photosView = [[WMPhotosView alloc] init];
    }
    return _photosView;
}

- (UIImageView *)moreImgView {
    if (!_moreImgView) {
        _moreImgView = [[UIImageView alloc] init];
        _moreImgView.userInteractionEnabled = YES;
        _moreImgView.image = [UIImage imageNamed:@"tweetMore"];
        UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickMore)];
        [_moreImgView addGestureRecognizer:gesture];
    }
    return _moreImgView;
}

- (UIButton *)lookMoreBtn {
    if (!_lookMoreBtn) {
        _lookMoreBtn = [[UIButton alloc] init];
        _lookMoreBtn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:13];
        [_lookMoreBtn setTitleColor:[UIColor colorWithHexString:@"#0077D1"] forState:UIControlStateNormal];
        [_lookMoreBtn setTitle:@"查看全部" forState:UIControlStateNormal];
        _lookMoreBtn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:15];
        [_lookMoreBtn addTarget:self action:@selector(lookMoreBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _lookMoreBtn;
}
@end
