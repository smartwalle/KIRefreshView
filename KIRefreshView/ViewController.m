//
//  ViewController.m
//  KIRefreshView
//
//  Created by apple on 15/11/3.
//  Copyright (c) 2015年 smartwalle. All rights reserved.
//

#import "ViewController.h"
#import "KIPullRefreshView.h"
#import "UIScrollView+KIRefreshView.h"

@interface ViewController () <KIPullRefreshViewDelegate, KIPushRefreshViewDelegate, UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) UITableView *tableView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView = [[UITableView alloc] initWithFrame:self.view.frame];
    [self.tableView setDelegate:self];
    [self.tableView setDataSource:self];
    [self.view addSubview:self.tableView];
    
    [self.tableView showPullRefreshView:nil delegate:self];
    [self.tableView showPushRefreshView:nil delegate:self];
}

- (void)pullRefreshViewStartLoad:(KIPullRefreshView *)view {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.tableView pullRefreshViewDidFinishedLoad];
    });
}

- (void)pushRefreshViewStartLoad:(KIPushRefreshView *)view {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.tableView pushRefreshViewDidFinishedLoad];
    });
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CELL_IDENTIFIER = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CELL_IDENTIFIER];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CELL_IDENTIFIER];
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}

@end
