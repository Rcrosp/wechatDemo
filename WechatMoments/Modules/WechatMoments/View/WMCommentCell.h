//
//  WMCommentCell.h
//  WechatMoments
//
//  Created by Apple on 2018/11/9.
//  Copyright © 2018年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WMTweetModel.h"
@interface WMCommentCell : UITableViewCell
@property(nonatomic, strong) WMTweetModel *tweetModel;
@property (nonatomic, assign) Boolean isShowBg;
+ (WMCommentCell *)commentCelForTableview:(UITableView *)tableView atIndexPath:(NSIndexPath *)indexPath;
@end
