//
//  BaseViewController.m
//  WechatMoments
//
//  Created by Apple on 2018/11/6.
//  Copyright © 2018年 Apple. All rights reserved.
//

#import "BaseViewController.h"
@interface BaseViewController ()

@end

@implementation BaseViewController
- (NSArray *)getCurrentTweets:(NSMutableArray *)currentTweetsArr nextPage:(NSInteger)page fromAllArray:(NSArray *)allTweetsArray {
    if(currentTweetsArr.count >= 5 * page) {
        return [allTweetsArray subarrayWithRange:NSMakeRange(0, page * 5)];
    }
    if (allTweetsArray.count >= (currentTweetsArr.count + 5 * page)) {
        return [allTweetsArray subarrayWithRange:NSMakeRange(0, page * 5)];
    }else {
        return [allTweetsArray subarrayWithRange:NSMakeRange(0, allTweetsArray.count)];
    }
}

- (NSArray *)removeErrTweets:(NSArray *)allTweetsArray {
    NSMutableArray *tmpArr = [NSMutableArray array];
    for (WMTweetModel *tweetModel in allTweetsArray) {
        if (tweetModel.error == nil || tweetModel.error.length == 0) {
            if (tweetModel.sender) {
                [tmpArr addObject:tweetModel];
            }
        }
    }
    return tmpArr;
}

#pragma mark - lazy
- (YYFPSLabel *)testLabel {
    if (!_testLabel) {
        _testLabel = [[YYFPSLabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 70, 20, 50, 30)];
    }
    return _testLabel;
}

- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.tableFooterView = [UIView new];
        _tableView.sectionIndexColor = [UIColor grayColor];
        _tableView.sectionIndexBackgroundColor = [UIColor clearColor];
        _tableView.tableFooterView = [UIView new];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.tableHeaderView = self.tableViewHeaderView;
        _tableView.rowHeight = UITableViewAutomaticDimension;
        if (@available(iOS 11.0, *)) {
            _tableView.estimatedRowHeight = 165.0f;
            _tableView.estimatedSectionHeaderHeight = 0;
            _tableView.estimatedSectionFooterHeight = 0;
            _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }else {
            _tableView.estimatedRowHeight = 165.0f;
        }
        
    }
    return _tableView;
}

- (WMHeaderView *)tableViewHeaderView{
    if (!_tableViewHeaderView) {
        _tableViewHeaderView = [[WMHeaderView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 350)];
        
    }
    return _tableViewHeaderView;
}


@end
