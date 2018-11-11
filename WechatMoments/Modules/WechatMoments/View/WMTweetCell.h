//
//  WMTweetCell.h
//  WechatMoments
//
//  Created by Apple on 2018/11/8.
//  Copyright © 2018年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WMTweetModel.h"
@class WMTweetCell;
typedef void(^TweetLookFullTextblock)(void);
@protocol WMTweetCellDelegate<NSObject>
-(void)cellMoreClick:(WMTweetModel *)tweetModel rect:(CGRect)rect cell:(WMTweetCell *)cell;
@end
@interface WMTweetCell : UITableViewCell
@property(nonatomic, strong) WMTweetModel *tweetModel;
@property (nonatomic, copy) TweetLookFullTextblock tweetLookFullTextblock;
@property(nonatomic, weak)id<WMTweetCellDelegate> delegate;
+ (WMTweetCell *)tweetCellForTableview:(UITableView *)tableView;
@end
