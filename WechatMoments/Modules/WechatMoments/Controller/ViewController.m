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
@property(nonatomic, strong)NSMutableArray *tweetsArray;
@property(nonatomic, copy)NSArray *allTweetsArray;
@property (nonatomic, strong) WMTweetMoreView *tweetMoreView;
@end
int global_var = 3;
static int static_global_var = 4;
@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.page = 0;
//    dispatch_async(dispatch_queue_create("xxxx",  DISPATCH_QUEUE_CONCURRENT), ^{
//        for (int i = 0;  i< 10000; i ++) {
//            self.page ++;
//            NSLog(@"xxxx:%ld",(long)self.page);
//        }
//    });
//    NSOperation
//    NSMutableArray *arr = @[@"1"].mutableCopy;
//    [arr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//
//    }];
//    NSLog(@"%ld",(long)self.page);
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(10 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//         NSLog(@"%ld",(long)self.page);
//    });
//    int a = 6;
//    NSString *str = @"123";
//    static int static_global_var1 = 14;
//    NSMutableArray *arr = [NSMutableArray array];
//    int(^mBlock)(void) = ^(void) {
//        NSLog(@"%d",self.page);
//        [arr addObject:@"123"];
//        return static_global_var1 * 2;
//    };
//    str = @"456";
//    self.page = 3;
//    static_global_var1 = 5 ;
//    NSLog(@"%d",mBlock());
   
//    NSMutableArray *arr = @[@1,@3,@0,@0,@5,@0,@9,@7,@0,@2,@4,@6,@0,@8,@0,@10].mutableCopy;
//    for (int i = 0; i < arr.count ; i ++) {
//        for (int j = i; j < arr.count - 1; j ++) {
//             NSNumber *num = arr[j];
//            if (num.integerValue == 0) {
//                NSNumber *tmp = arr[j];
//                arr[j] = arr[j + 1];
//                arr[j + 1] = tmp;
//
//            }
//        }
//        for (NSInteger j = arr.count - 1; j > i; j --) {
//            NSNumber *num = arr[j];
//            NSNumber *nextNum = arr[j-1];
//            if (num.integerValue < nextNum.integerValue ) {
//                NSNumber *tmp = arr[j];
//                arr[j] = arr[j - 1];
//                arr[j - 1] = tmp;
//            }
//        }
//        for (int j = i; j < arr.count - 1; j ++) {
//            NSNumber *num = arr[j];
//            NSNumber *nextNum = arr[j+1];
//            if (nextNum.integerValue < num.integerValue) {
//                 [arr exchangeObjectAtIndex:j withObjectAtIndex:(j + 1)];
//            }
////            if (num.intValue == 0) {
////                [arr exchangeObjectAtIndex:j withObjectAtIndex:(j + 1)];
////            }
//        }
//    }
//
//    NSLog(@"%@", arr);
    [self initData];
    if (kOpenRelease) {
        [self.view addSubview:self.testLabel];
    }
}

//- (void)tick:(CADisplayLink *)link {
//    if (_lastTime == 0) {
//        _lastTime = link.timestamp;
//        return;
//    }
//    _count++;
//    NSTimeInterval delta = link.timestamp - _lastTime;
//    if (delta < 1) return;
//    _lastTime = link.timestamp;
//    float fps = _count / delta;
//    NSLog(@"页面帧率：%f",fps);
//    _count = 0;
//}

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
