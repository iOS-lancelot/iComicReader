//
//  ComicStoreTableViewController.m
//  ComicReader
//
//  Created by Jiang on 14/12/10.
//  Copyright (c) 2014年 Mac. All rights reserved.
//

#import "ComicStoreViewController.h"
#import "ComicStoreTool.h"
#import "ShowWaitView.h"
#import "ComicStoreHeaderView.h"
#import "ContentListView.h"
#import "ComicStoreContentListCollectionView.h"
#import "NewStoreTitleModel.h"
#import "ListContentModel.h"
#import "AFNetworking.h"

@interface ComicStoreViewController ()

//加载等待画面
@property (nonatomic, weak) ShowWaitView *showWaitView;
//content列表View
@property (nonatomic, weak) ComicStoreContentListCollectionView *comicStoreContentListCollectionView;
//content列表View容器
@property (nonatomic, weak) ContentListView *contentListView;
//headerView所需模型数据数组
@property (nonatomic, strong) NSMutableArray *headerModelArray;
//图书列表模型数据数组
@property (nonatomic, strong) NSMutableArray *listModelArray;
//图书列表页内容模型数据数组
@property (nonatomic, strong) NSMutableArray *listRowContentModelArray;

@property (nonatomic, strong) UIView *headerBackView;

@end

@implementation ComicStoreViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.layer.masksToBounds = YES;
    [self settingBackGround];
    [self initWithContentView];
    [self insertShowWaitView];
    [self.showWaitView showWait];
}

#pragma mark - 数据加载载

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.tabBarController.tabBar.hidden = NO;
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void)loadModelData{
    __unsafe_unretained typeof(self) p = self;
    [[ComicStoreTool sharedRequestTool] requestComicStoreNewModelCompletion:^(NSMutableArray *blockHeaderArray, NSMutableArray *blockListArray) {
        [p.showWaitView removeFromSuperview];
        p.headerModelArray = blockHeaderArray;
        p.listModelArray = blockListArray;
    } failure:^(NSError *error) {
        [p.showWaitView performSelector:@selector(showError) withObject:nil afterDelay:1.5];
    }];
}

#pragma mark 加载等待控件
- (void)insertShowWaitView{
    __unsafe_unretained typeof(self) p = self;
    ShowWaitView *showWaitView = [[ShowWaitView alloc]initWithOperation:^{
        [p loadModelData];
    }];
    [self.view insertSubview:showWaitView aboveSubview:self.view];
    _showWaitView = showWaitView;
}

- (void)requestDataForContentListWithModel:(NewStoreTitleModel *)model{
    NSString *urlString = @"http://api.kuaikanmanhua.com/v1/topics";
    NSDictionary *parameter = @{@"limit": @(model.contentCount),
                                @"offset": @0,
                                @"tag": model.title};
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:urlString parameters:parameter success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSMutableArray *array = [ListContentModel modelArrayForDataArray:responseObject[@"data"][@"topics"]];
        model.contentArray = array;
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    }];
}

- (void)comicOrderSelectedIndex:(NSInteger)index{
    [self.contentListView showRefreshState:stateLoading];
}

#pragma mark - set and get
- (void)setHeaderModelArray:(NSMutableArray *)headerModelArray{
    self.comicStoreContentListCollectionView.headerModelArray = headerModelArray;
    _headerModelArray = headerModelArray;
}

- (void)setListModelArray:(NSMutableArray *)listModelArray{
    _listModelArray = listModelArray;
    self.listRowContentModelArray = listModelArray;
    for (NewStoreTitleModel *listModel in  listModelArray) {
        [self requestDataForContentListWithModel:listModel];
    }
}

- (void)setListRowContentModelArray:(NSMutableArray *)listRowContentModelArray{
    _listRowContentModelArray = listRowContentModelArray;
    self.contentListView.listRowContentModelArray = listRowContentModelArray;
}

- (ComicStoreContentListCollectionView *)comicStoreContentListCollectionView{
    return self.contentListView.comicStoreContentListCollectionView;
}

#pragma mark - 初始化控件

- (void)initWithContentView{
    ContentListView *contentListView = [[ContentListView alloc]initWithFrame:self.view.bounds];
    [self.view insertSubview:contentListView atIndex:0];
    self.contentListView = contentListView;
}

- (void)settingBackGround{
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    self.automaticallyAdjustsScrollViewInsets = NO;
}

#pragma mark - collectionDelegate

@end
