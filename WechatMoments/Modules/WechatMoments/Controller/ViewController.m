//
//  ViewController.m
//  WechatMoments
//
//  Created by Apple on 2018/11/6.
//  Copyright © 2018年 Apple. All rights reserved.
//

#import "ViewController.h"
#import "WMTweetFootView.h"
#import "WMTweetMoreView.h"
#import "UIView+WMRefresh.h"
static NSString *WMTweetFootViewID = @"WMTweetFootView";
@interface ViewController ()<UITableViewDelegate, UITableViewDataSource, WMTweetCellDelegate, UIGestureRecognizerDelegate>
@property(nonatomic, assign)NSInteger page;
@property(nonatomic, weak)UIImageView *imgView;
@property(nonatomic, copy)NSMutableArray *tweetsArray;
@property(nonatomic, copy)NSArray *allTweetsArray;
@property (nonatomic, strong) WMTweetMoreView *tweetMoreView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initData];
    if (kOpenRelease) {
        [self.view addSubview:self.testLabel];
    }
}

- (void)initData {
    self.page = 0;
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.bottom.mas_equalTo(0);
    }];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    WS(weakSelf);
    [self.view wm_refreshWithObject:self.tableView atPoint:CGPointMake(30.f, -30.f) downRefresh:^{
         weakSelf.page = 1;
        [weakSelf getTweetsInPage:weakSelf.page isPull:YES];
    }];
    [self.view wm_beginRefresh];
//    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
//        weakSelf.page = 1;
//        [weakSelf getTweetsInPage:weakSelf.page isPull:YES];
//    }];
    
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [weakSelf getTweetsInPage:(++weakSelf.page) isPull:NO];
    }];
    [self getUserInfoData];

    
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(touchView)];
    gesture.delegate = self;
    [self.view addGestureRecognizer:gesture];
}

- (void)touchView {
    if (!self.tweetMoreView.hidden) {
        [self.tweetMoreView hideTweetMoreView];
    }
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    return YES;
}

- (void)getTweetsInPage:(NSInteger)page isPull:(Boolean)isPull {
    if (isPull) {
        [self getNetData:page isPull:isPull];
    }else {
        if(self.allTweetsArray.count > 0) {
            self.tweetsArray = [NSMutableArray arrayWithArray: [self getCurrentTweets:self.tweetsArray nextPage:page fromAllArray:self.allTweetsArray]];
            if (isPull) {
                 [self.view wm_endRefresh];
                [self.tableView.mj_header endRefreshing];
            }else {
                [self.tableView.mj_footer endRefreshing];
            }
            [self.tableView reloadData];
        }else {
            [self getNetData:page isPull:isPull];
        }
    }
}

- (void)getNetData:(NSInteger)page isPull:(Boolean)isPull {
    [[HttpManager shareManager] requestGetWithUrl:tweets_url withPatams:nil withSuccessBlock:^(NSDictionary *dict) {
        NSArray *tweetsArray =  [NSArray modelArrayWithClass:[WMTweetModel class] json:dict];
        self.allTweetsArray = [self removeErrTweets:tweetsArray];
        self.tweetsArray = [NSMutableArray arrayWithArray: [self getCurrentTweets:self.tweetsArray nextPage:page fromAllArray:self.allTweetsArray]];
        if (isPull) {
            [self.view wm_endRefresh];
            [self.tableView.mj_header endRefreshing];
        }else {
            [self.tableView.mj_footer endRefreshing];
        }
        [self.tableView reloadData];
    } withFailureBlock:^(NSError *error) {
        if (isPull) {
            [self.tableView.mj_header endRefreshing];
        }else {
            [self.tableView.mj_footer endRefreshing];
        }
    }];
}

- (void)getUserInfoData {
    [[HttpManager shareManager] requestGetWithUrl:userInfo_url withPatams:nil withSuccessBlock:^(NSDictionary *dict) {
        WMUserInfoModel *model = [WMUserInfoModel modelWithJSON:dict];
        self.tableViewHeaderView.backgroundColor = [UIColor whiteColor];
        [self.tableViewHeaderView.headerBgImgView setFPImageWithURL:model.profileImage];
        [self.tableViewHeaderView.avaImgView setFPImageWithURL:model.avatar placeholderImageName:@"img-portrait-def"];
    } withFailureBlock:^(NSError *error) {
        
    }];
}

- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator {
    [self.tableView reloadData];
}

#pragma mark - TableView Delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
     return self.tweetsArray.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    WMTweetModel *tweetModel = self.tweetsArray[section];
    return tweetModel.comments.count + 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    WMTweetModel *tweetModel = self.tweetsArray[indexPath.section];
    if(indexPath.row == 0) {
        WMTweetCell *cell = [WMTweetCell tweetCellForTableview:tableView];
        cell.tweetModel = tweetModel;
        cell.delegate = self;
        WS(weakSelf);
        cell.tweetLookFullTextblock = ^{
            [weakSelf.tableView reloadData];
        };
        return cell;
    }else {
        WMCommentCell *cell = [WMCommentCell commentCelForTableview:tableView atIndexPath:indexPath];
        if (indexPath.row == 1) {
            cell.isShowBg = true;
        }else {
            cell.isShowBg = false;
        }
        cell.tweetModel = tweetModel.comments[indexPath.row - 1];
        return cell;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    WMTweetFootView *footView = (WMTweetFootView *)[tableView  dequeueReusableCellWithIdentifier:WMTweetFootViewID];
    if (!footView) {
        footView = [[WMTweetFootView alloc] initWithReuseIdentifier:WMTweetFootViewID];
    }
    return footView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.001;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self.tweetMoreView hideTweetMoreView];
}

- (void)dealloc {
    [self.view wm_freeReFresh];
}

#pragma mark - tweetCellDelegate
- (void)cellMoreClick:(NSString *)text rect:(CGRect)rect cell:(WMTweetCell *)cell {
    if (self.tweetMoreView.hidden) {
        CGRect rc = [cell convertRect:rect toView:[UIApplication sharedApplication].keyWindow];
        [self.tweetMoreView showTweetMoreViewWithRect:rc];
    }else {
        [self.tweetMoreView hideTweetMoreView];
    }
   
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark --lazy
- (NSMutableArray *)tweetsArray {
    if (!_tweetsArray) {
        _tweetsArray = [NSMutableArray array];
    }
    return _tweetsArray;
}

- (WMTweetMoreView *)tweetMoreView {
    if (!_tweetMoreView) {
        _tweetMoreView = [[WMTweetMoreView alloc] initWithFrame:CGRectZero];
        _tweetMoreView.backgroundColor = [UIColor colorWithHexString:@"#000000" alpha:0.6];
        _tweetMoreView.layer.cornerRadius = 4;
        _tweetMoreView.clipsToBounds = YES;
        _tweetMoreView.hidden = YES;
        [[UIApplication sharedApplication].keyWindow addSubview:_tweetMoreView];
    }
    return _tweetMoreView;
}
@end
