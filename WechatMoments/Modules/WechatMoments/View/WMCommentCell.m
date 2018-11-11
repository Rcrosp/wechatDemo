




//
//  WMCommentCell.m
//  WechatMoments
//
//  Created by Apple on 2018/11/9.
//  Copyright © 2018年 Apple. All rights reserved.
//

#import "WMCommentCell.h"

@interface WMCommentCell()
@property (nonatomic, strong) UIImageView *commentBgView;
@property (nonatomic, strong) YYLabel *commentLabel;

@end
@implementation WMCommentCell
+ (WMCommentCell *)commentCelForTableview:(UITableView *)tableView atIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellId = @"WMCommentCell";
    WMCommentCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell == nil) {
        cell = [[WMCommentCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
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
    [self.contentView addSubview:self.commentBgView];
    [self.commentBgView addSubview:self.commentLabel];
    
    [self.commentBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(96);
        make.top.mas_equalTo(0);
        make.right.mas_equalTo(-15);
        make.bottom.mas_equalTo(0).priorityHigh();
    }];
    [self.commentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(5);
        make.top.mas_equalTo(8);
        make.right.mas_equalTo(-5);
        make.bottom.mas_equalTo(-5);
    }];
}

- (void)setTweetModel:(WMTweetModel *)tweetModel {
    if (_tweetModel != tweetModel) {
        if (tweetModel.content && ![tweetModel.content isEmpty]) {
             self.commentLabel.attributedText = [self getAttributeCommentString:[NSString stringWithFormat:@"%@:%@",tweetModel.sender.username,tweetModel.content] withUserName:tweetModel.sender.username];
        }
    }
}

- (void)setIsShowBg:(Boolean)isShowBg {
    _isShowBg = isShowBg;
    UIImage *commentBgImg = [UIImage imageNamed:@"cmtBg"];
    self.commentBgView.image = isShowBg ? [commentBgImg stretchableImageWithLeftCapWidth:commentBgImg.size.width * 0.5 topCapHeight:commentBgImg.size.height * 0.5]:nil;
    self.commentBgView.backgroundColor = isShowBg ?[UIColor clearColor]:[UIColor colorWithHexString:@"#F2F3F7"];
}

- (NSMutableAttributedString *)getAttributeCommentString:(NSString *)str withUserName:(NSString *)userName {
    
    NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:str];
    text.font = [UIFont fontWithName:@"PingFangSC-Regular" size:15];
    text.color = [UIColor colorWithHexString:@"#666666"];
    if (userName && ![userName isEmpty]) {
       [text setColor:[UIColor colorWithHexString:@"#0077D1"] range:[str rangeOfString:userName]];
    }
    return text.copy;
}

#pragma mark - lazy
- (YYLabel *)commentLabel {
    if (!_commentLabel) {
        _commentLabel = [[YYLabel alloc] init];
        _commentLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:15];
        _commentLabel.backgroundColor = [UIColor colorWithHexString:@"#F2F3F7"];
    }
    return _commentLabel;
}

- (UIImageView *)commentBgView {
    if (!_commentBgView) {
        _commentBgView = [[UIImageView alloc] init];
        UIImage *image = [UIImage imageNamed:@"cmtBg"];
        _commentBgView.image = [image stretchableImageWithLeftCapWidth:image.size.width * 0.5 topCapHeight:image.size.height * 0.5];
    }
    return _commentBgView;
}
@end
