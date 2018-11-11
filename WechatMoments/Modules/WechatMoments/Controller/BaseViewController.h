//
//  BaseViewController.h
//  WechatMoments
//
//  Created by Apple on 2018/11/6.
//  Copyright © 2018年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WMHeaderView.h"
#import <MJRefresh.h>
#import "HttpManager.h"
#import "WMUserInfoModel.h"
#import "WMTweetModel.h"
#import "WMTweetCell.h"
#import "YYFPSLabel.h"
#import "WMCommentCell.h"
@interface BaseViewController : UIViewController
@property (nonatomic, strong) YYFPSLabel *testLabel;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) WMHeaderView *tableViewHeaderView;

- (NSArray *)removeErrTweets:(NSArray *)allTweetsArray;
- (NSArray *)getCurrentTweets:(NSMutableArray *)currentTweetsArr nextPage:(NSInteger)page fromAllArray:(NSArray *)allTweetsArray;
@end
