//
//  KIPullRefreshView.h
//  Kitalker
//
//  Created by 杨 烽 on 12-7-11.
//  Copyright (c) 2012年 杨 烽. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    KIPullRefreshNormal=1,
    KIPullRefreshPulling,
    KIPullRefreshLoading,
} KIPullRefreshState;

@protocol KIPullRefreshViewDelegate;
@interface KIPullRefreshView : UIView {
}

@property (nonatomic, weak)   id<KIPullRefreshViewDelegate>     delegate;
@property (strong, nonatomic) UIActivityIndicatorView  *activityIndicatorView;
@property (strong, nonatomic) UIImageView              *imageView;
@property (strong, nonatomic) UILabel                  *descLabel;

@property (nonatomic, assign) CGFloat topOffset;

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView preload:(BOOL)preload;
- (void)scrollViewDidFinishedLoading:(UIScrollView *)scrollView;
- (void)reset:(UIScrollView *)scrollView;

- (void)setTitle:(NSString *)title forState:(KIPullRefreshState)state;

//重写这两个方法
- (void)updateState:(KIPullRefreshState)aState;
- (CGFloat)pullRefreshViewHeight;
@end

@protocol KIPullRefreshViewDelegate <NSObject>
@optional
- (void)pullRefreshViewStartLoad:(KIPullRefreshView *)view;
@end
