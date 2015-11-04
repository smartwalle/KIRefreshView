//
//  UIScrollView+KIAdditiions.m
//  Kitalker
//
//  Created by 杨 烽 on 13-5-16.
//  Copyright (c) 2013年 杨 烽. All rights reserved.
//

#import "UIScrollView+KIRefreshView.h"
#import <objc/runtime.h>

#define kPullRefreshViewTag 917996695
#define kPushRefreshViewTag 917996696

static char KI_UPDATE_CONTENT_INSET_WITH_PULL_REFRESH_VIEW;
static char KI_UPDATE_CONTENT_INSET_WITH_PUSH_REFRESH_VIEW;

@implementation UIScrollView (KIRefreshView)


- (void)setUpdateContentInsetWithPullRefreshView:(BOOL)updateContentInsetWithPullRefreshView {
    objc_setAssociatedObject(self,
                             &KI_UPDATE_CONTENT_INSET_WITH_PULL_REFRESH_VIEW,
                             [NSNumber numberWithBool:updateContentInsetWithPullRefreshView],
                             OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)updateContentInsetWithPullRefreshView {
    NSNumber *value = objc_getAssociatedObject(self,
                                               &KI_UPDATE_CONTENT_INSET_WITH_PULL_REFRESH_VIEW);
    return [value boolValue];
}

- (void)setUpdateContentInsetWithPushRefreshView:(BOOL)updateContentInsetWithPushRefreshView {
    objc_setAssociatedObject(self,
                             &KI_UPDATE_CONTENT_INSET_WITH_PUSH_REFRESH_VIEW,
                             [NSNumber numberWithBool:updateContentInsetWithPushRefreshView],
                             OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)updateContentInsetWithPushRefreshView {
    NSNumber *value = objc_getAssociatedObject(self,
                                               &KI_UPDATE_CONTENT_INSET_WITH_PUSH_REFRESH_VIEW);
    return [value boolValue];
}

#pragma mark ****************************************
#pragma mark 【下拉刷新】
#pragma mark ****************************************
/*下拉刷新*/
- (void)showPullRefreshView:(NSString *)viewIdentifer delegate:(id<KIPullRefreshViewDelegate>)delegate {
    if ([self viewWithTag:kPullRefreshViewTag] == nil) {
        if (viewIdentifer == nil || viewIdentifer.length == 0) {
            viewIdentifer = @"KIPullRefreshView";
        }
        [self initPullRefreshView:viewIdentifer delegate:delegate];
    }
}

- (void)initPullRefreshView:(NSString *)viewIdentifer delegate:(id<KIPullRefreshViewDelegate>)delegate {
    KIPullRefreshView *refreshView = (KIPullRefreshView *)[self viewWithTag:kPullRefreshViewTag];
    if (refreshView == nil) {
        
        Class class = NSClassFromString(viewIdentifer);
        refreshView = [[class alloc] init];
        
        if (refreshView != nil) {
            [refreshView setDelegate:delegate];
            [refreshView setTag:kPullRefreshViewTag];
            [refreshView setAutoresizingMask:UIViewAutoresizingFlexibleBottomMargin];
        }
        [self addSubview:refreshView];
    }
}

- (KIPullRefreshView *)pullRefreshView {
    KIPullRefreshView *refreshView = (KIPullRefreshView *)[self viewWithTag:kPullRefreshViewTag];
    CGRect frame = refreshView.frame;
    frame.size.width = CGRectGetWidth(self.frame);
    [refreshView setFrame:frame];
    return refreshView;
}

- (void)pullRefreshViewPreload {
    if ([self viewWithTag:kPullRefreshViewTag] != nil) {
        [[self pullRefreshView] scrollViewDidEndDragging:self preload:YES];
    }
}

- (void)pullRefreshViewDidFinishedLoad {
    if ([self viewWithTag:kPullRefreshViewTag] != nil) {
        [[self pullRefreshView] scrollViewDidFinishedLoading:self];
    }
}

- (void)resetPullRefreshView {
    if ([self viewWithTag:kPullRefreshViewTag] != nil) {
        [[self pullRefreshView] reset:self];
    }
}

- (void)removePullRefreshView {
    UIView *view = [self viewWithTag:kPullRefreshViewTag];
    [view removeFromSuperview];
}


#pragma mark ****************************************
#pragma mark 【上推刷新】
#pragma mark ****************************************

- (void)showPushRefreshView:(NSString *)viewIdentifer delegate:(id<KIPushRefreshViewDelegate>)delegate {
    if ([self viewWithTag:kPushRefreshViewTag] == nil) {
        if (viewIdentifer == nil || viewIdentifer.length == 0) {
            viewIdentifer = @"KIPushRefreshView";
        }
        [self initPushRefreshView:viewIdentifer delegate:delegate];
    }
}

- (void)initPushRefreshView:(NSString *)viewIdentifer delegate:(id<KIPushRefreshViewDelegate>)delegate {
    KIPushRefreshView *refreshView = (KIPushRefreshView *)[self viewWithTag:kPushRefreshViewTag];
    if (refreshView == nil) {
        
        Class class = NSClassFromString(viewIdentifer);
        refreshView = [[class alloc] init];
        
        if (refreshView != nil) {
            [refreshView setDelegate:delegate];
            [refreshView setTag:kPushRefreshViewTag];
            
            [refreshView setFrame:CGRectMake(0,
                                             self.contentSize.height,
                                             self.bounds.size.width,
                                             self.bounds.size.height)];
            [self addSubview:refreshView];
        }
    }
    
}

- (KIPushRefreshView *)pushRefreshView {
    KIPushRefreshView *refreshView = (KIPushRefreshView *)[self viewWithTag:kPushRefreshViewTag];
    CGRect frame = refreshView.frame;
    frame.size.width = CGRectGetWidth(self.frame);
    [refreshView setFrame:frame];
    return refreshView;
}

- (NSString *)pushRefreshViewIdentifer {
    return @"KIPushRefreshView";
}

- (void)pushRefreshViewDidFinishedLoad {
    if ([self viewWithTag:kPushRefreshViewTag] != nil) {
        [[self pushRefreshView] scrollViewDidFinishedLoading:self];
    }
}

- (void)resetPushRefreshView {
    if ([self viewWithTag:kPushRefreshViewTag] != nil) {
        [[self pushRefreshView] reset:self];
    }
}

- (void)removePushRefreshView {
    UIView *view = [self viewWithTag:kPushRefreshViewTag];
    if (view != nil) {
        [view removeFromSuperview];
    }
}

@end
