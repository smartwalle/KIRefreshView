//
//  KIPushRefreshView.h
//  Kitalker
//
//  Created by 杨 烽 on 12-7-12.
//  Copyright (c) 2012年 杨 烽. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    KIPushRefreshNormal=1,
    KIPushRefreshPushing,
    KIPushRefreshLoading,
} KIPushRefreshState;

@protocol KIPushRefreshViewDelegate;
@interface KIPushRefreshView : UIView {
}

@property (nonatomic, weak)   id<KIPushRefreshViewDelegate>     delegate;
@property (strong, nonatomic) UIActivityIndicatorView  *activityIndicatorView;
@property (strong, nonatomic) UILabel                  *descLabel;

@property (nonatomic, assign) CGFloat bottomOffset;

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView;
- (void)scrollViewDidFinishedLoading:(UIScrollView *)scrollView;
- (void)reset:(UIScrollView *)scrollView;

- (void)setTitle:(NSString *)title forState:(KIPushRefreshState)state;

//重写这两个方法
- (void)updateState:(KIPushRefreshState)aState;
- (CGFloat)pushRefreshViewHeight;
@end

@protocol KIPushRefreshViewDelegate <NSObject>
@optional
- (void)pushRefreshViewStartLoad:(KIPushRefreshView *)view;
@end
