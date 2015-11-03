//
//  UIScrollView+KIAdditiions.h
//  Kitalker
//
//  Created by 杨 烽 on 13-5-16.
//  Copyright (c) 2013年 杨 烽. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KIPullRefreshView.h"
#import "KIPushRefreshView.h"

@interface UIScrollView (KIAdditiions)

@property (nonatomic, assign) BOOL updateContentInsetWithPullRefreshView;
@property (nonatomic, assign) BOOL updateContentInsetWithPushRefreshView;

/**************************************************
 *下拉刷新
 **************************************************/
- (void)showPullRefreshView:(NSString *)viewIdentifer delegate:(id<KIPullRefreshViewDelegate>)delegate;

- (KIPullRefreshView *)pullRefreshView;

- (void)pullRefreshViewPreload;

- (void)pullRefreshViewDidFinishedLoad;

- (void)resetPullRefreshView;
- (void)removePullRefreshView;

/**************************************************
 *上推刷新
 **************************************************/
- (void)showPushRefreshView:(NSString *)viewIdentifer delegate:(id<KIPushRefreshViewDelegate>)delegate;

- (KIPushRefreshView *)pushRefreshView;

- (void)pushRefreshViewDidFinishedLoad;

- (void)resetPushRefreshView;
- (void)removePushRefreshView;

/*
    - (void)viewDidLoad {
        [super viewDidLoad];
        [UIScrollView showPullRefreshView:nil delegate:self];
        [UIScrollView showPushRefreshView:nil delegate:self];
    }
 
    - (void)viewDidAppear:(BOOL)animated {
        [super viewDidAppear:animated];
        [self.tableView pullRefreshViewPreload];
    }

    - (void)pullRefreshViewStartLoad:(KIPullRefreshView *)view {
        [self performSelector:@selector(done) withObject:nil afterDelay:5];
    }

    - (void)done {
        [UIScrollView pullRefreshViewDidFinishedLoad];
        [UIScrollView pushRefreshViewDidFinishedLoad];
    }

    - (void)dealloc {
        [UIScrollView removePullRefreshView];
        [UIScrollView removePushRefreshView];
        [super dealloc];
    }
 */

@end