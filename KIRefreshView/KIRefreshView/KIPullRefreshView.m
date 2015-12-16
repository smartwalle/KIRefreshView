//
//  KIPullRefreshView.m
//  Kitalker
//
//  Created by 杨 烽 on 12-7-11.
//  Copyright (c) 2012年 杨 烽. All rights reserved.
//

#import "KIPullRefreshView.h"
#import "UIScrollView+KIRefreshView.h"

@interface KIPullRefreshView () {
}
@property (nonatomic, assign) KIPullRefreshState    state;
@property (nonatomic, assign) UIEdgeInsets          defaultEdgeInsets;

@property (nonatomic, copy) NSString *normalTitle;
@property (nonatomic, copy) NSString *pullingTitle;
@property (nonatomic, copy) NSString *loadingTitle;

@end

@implementation KIPullRefreshView

#pragma mark Lifecycle
- (void)dealloc {
    _delegate = nil;
    _normalTitle = nil;
    _pullingTitle = nil;
    _loadingTitle = nil;
}

- (id)init {
    if (self = [super init]) {
        [self setState:KIPullRefreshNormal];
    }
    return self;
}

- (void)awakeFromNib {
    [self setState:KIPullRefreshNormal];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat width = CGRectGetWidth(self.frame);
    CGFloat height = CGRectGetHeight(self.frame);
    
    CGFloat viewHeight = [self pullRefreshViewHeight];
    
    [self.descLabel setFrame:CGRectMake((width-170)/2, (height - (viewHeight + 21) / 2), 170, 21)];
    [self.imageView setFrame:CGRectMake(CGRectGetMinX(self.descLabel.frame)-20, (height - (viewHeight + 25) / 2), 20, 25)];
    [self.activityIndicatorView setFrame:CGRectMake(CGRectGetMinX(self.descLabel.frame)-20, (height - (viewHeight + 20) / 2), 20, 20)];
}

- (CGFloat)offset {
    return 5.0f;
}

- (void)scrollView:(UIScrollView *)scrollView contentOffset:(CGPoint)contentOffset {
    //判断是向下拉
    if (contentOffset.y < 0) {
        if (self.state == KIPullRefreshLoading) {
            //如果是正在加载中，则不用做任何特殊的处理
            /*
            CGFloat offset = MAX(contentOffset.y * -1, 0);
            offset = MIN(offset, [self pullRefreshViewHeight]);
            
            UIEdgeInsets insets = scrollView.contentInset;
            insets.top = offset;
            [scrollView setContentInset:insets];
             */
        } else if (scrollView.isDragging) {
            //如果是拖动中
            if (contentOffset.y > -[self _pullRefreshViewHeight] - [self offset]
                && self.state == KIPullRefreshPulling) {
                [self setState:KIPullRefreshNormal];
            }
            
            if (contentOffset.y < -[self _pullRefreshViewHeight] - [self offset]
                && self.state == KIPullRefreshNormal) {
                [self setState:KIPullRefreshPulling];
            }
        } else {
            //即不是正在加载中，也没有在拖动
            if (contentOffset.y < -[self _pullRefreshViewHeight] - [self offset]
                && self.state == KIPullRefreshPulling) {
                [UIView animateWithDuration:0.2f
                                      delay:0
                                    options:UIViewAnimationOptionAllowUserInteraction|UIViewAnimationOptionBeginFromCurrentState
                                 animations:^{
                                     [scrollView setContentOffset:CGPointMake(0, -[self _pullRefreshViewHeight]) animated:NO];
                                 } completion:^(BOOL finished) {
                                 }];
            }
        }
    }
}


- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView preload:(BOOL)preload {
    if (self.state == KIPullRefreshLoading && !preload) {
        return ;
    }
    
    if (self.state == KIPullRefreshPulling || preload) {
        [self setState:KIPullRefreshLoading];
        
        [UIView animateWithDuration:0.2f
                              delay:0
                            options:UIViewAnimationOptionAllowUserInteraction|UIViewAnimationOptionBeginFromCurrentState
                         animations:^{
                             [scrollView setContentOffset:CGPointMake(0, -[self _pullRefreshViewHeight]) animated:NO];
//                             UIEdgeInsets insets = scrollView.contentInset;
//                             insets.top = [self pullRefreshViewHeight];
//                             [scrollView setContentInset:insets];
                             [self update:scrollView edgeInsetTop:[self _pullRefreshViewHeight]];
                         } completion:^(BOOL finished) {
                         }];
    }
}

- (void)scrollViewDidFinishedLoading:(UIScrollView *)scrollView {
    [self setState:KIPullRefreshNormal];
    
    [UIView animateWithDuration:0.2f
                          delay:0
                        options:UIViewAnimationOptionAllowUserInteraction|UIViewAnimationOptionBeginFromCurrentState
                     animations:^{
//                         UIEdgeInsets insets = scrollView.contentInset;
//                         insets.top = 0;
//                         [scrollView setContentInset:insets];
                         [self update:scrollView edgeInsetTop:0+self.defaultEdgeInsets.top];
                     } completion:^(BOOL finished) {
                          [scrollView setUpdateContentInsetWithPullRefreshView:NO];
                     }];
}

- (void)update:(UIScrollView *)scrollView edgeInsetTop:(CGFloat)top {
    //标记为内部更新的edgeinset
    [scrollView setUpdateContentInsetWithPullRefreshView:YES];
    UIEdgeInsets insets = scrollView.contentInset;
    insets.top = top;
    [scrollView setContentInset:insets];
}

- (void)reset:(UIScrollView *)scrollView {
    [self scrollViewDidFinishedLoading:scrollView];
}

- (void)setTitle:(NSString *)title forState:(KIPullRefreshState)state {
    if (state == KIPullRefreshNormal) {
        [self setNormalTitle:title];
        if (self.state == KIPullRefreshNormal) {
            [self.descLabel setText:self.normalTitle];
        }
    } else if (state == KIPullRefreshLoading) {
        [self setLoadingTitle:title];
    } else if (state == KIPullRefreshPulling) {
        [self setPullingTitle:title];
    }
}

- (void)setState:(KIPullRefreshState)aState {
    if (_state == aState) {
        return ;
    }
    _state = aState;
    [self updateState:_state];
}

- (void)updateState:(KIPullRefreshState)aState {
    switch (aState) {
        case KIPullRefreshNormal: {
            if (aState == KIPullRefreshPulling) {
                //还原
            }
            [self.activityIndicatorView setHidden:YES];
            [self.activityIndicatorView stopAnimating];
            [self.imageView setHidden:NO];
            [UIView animateWithDuration:0.2 animations:^{
                self.imageView.transform = CGAffineTransformMakeRotation((0 * M_PI) / 180.0f);
            }];
            [self.descLabel setText:self.normalTitle != nil ? self.normalTitle : NSLocalizedString(@"下拉刷新...", nil)];
        }
            break;
        case KIPullRefreshPulling: {
            [UIView animateWithDuration:0.2 animations:^{
               self.imageView.transform = CGAffineTransformMakeRotation((-180.0f * M_PI) / 180.0f);
            }];
            [self.descLabel setText:self.pullingTitle != nil ? self.pullingTitle : NSLocalizedString(@"释放更新...", nil)];
            break;
        }
        case KIPullRefreshLoading: {
            [self.imageView setHidden:YES];
            [UIView animateWithDuration:0.2 animations:^{
                self.imageView.transform = CGAffineTransformMakeRotation((0 * M_PI) / 180.0f);
            }];
            
            [self.activityIndicatorView setHidden:NO];
            [self.activityIndicatorView startAnimating];
            [self.descLabel setText:self.loadingTitle != nil ? self.loadingTitle : NSLocalizedString(@"更新中，请稍候...", nil)];
            
            if (_delegate != nil
                && [_delegate respondsToSelector:@selector(pullRefreshViewStartLoad:)]) {
                [_delegate pullRefreshViewStartLoad:self];
            }
        }
            break;
        default:
            break;
    }
}

- (CGFloat)_pullRefreshViewHeight {
    return [self pullRefreshViewHeight] + self.defaultEdgeInsets.top;
}

- (CGFloat)pullRefreshViewHeight {
    return 60.0f;
}

- (void)willMoveToSuperview:(UIView *)newSuperview {
    if (newSuperview != nil && [newSuperview isKindOfClass:[UIScrollView class]]) {
        UIScrollView *scrollView = (UIScrollView *)newSuperview;
        [scrollView addObserver:self forKeyPath:@"contentOffset"
                        options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld
                        context:nil];
        [scrollView addObserver:self forKeyPath:@"contentInset"
                        options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld
                        context:nil];
        
    }
    [super willMoveToSuperview:newSuperview];
}

- (void)didMoveToSuperview {
    [super didMoveToSuperview];
    
    if ([self.superview isKindOfClass:[UIScrollView class]]) {
        [self setDefaultEdgeInsets:[(UIScrollView *)self.superview contentInset]];
    }
}

- (void)removeFromSuperview {
    if (self.superview != nil && [self.superview isKindOfClass:[UIScrollView class]]) {
        UIScrollView *scrollView = (UIScrollView *)self.superview;
        [scrollView removeObserver:self forKeyPath:@"contentOffset" context:nil];
        [scrollView removeObserver:self forKeyPath:@"contentInset" context:nil];
    }
    [super removeFromSuperview];
}

- (void)setDefaultEdgeInsets:(UIEdgeInsets)defaultEdgeInsets {
    _defaultEdgeInsets = defaultEdgeInsets;
    UIScrollView *scrollView = (UIScrollView *)self.superview;
    if ([scrollView isKindOfClass:[UIScrollView class]]) {
        [self setFrame:CGRectMake(0,
                                  0-scrollView.bounds.size.height-scrollView.contentInset.top + self.topOffset,
                                  scrollView.bounds.size.width,
                                  scrollView.bounds.size.height)];
    }
    
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    UIScrollView *scrollView = object;
    
    if ([keyPath isEqualToString:@"contentOffset"]) {
        CGPoint oldOffset = [[change objectForKey:NSKeyValueChangeOldKey] CGPointValue];
        CGPoint newOffset = [[change objectForKey:NSKeyValueChangeNewKey] CGPointValue];
        
        [self scrollView:scrollView oldOffset:oldOffset newOffset:newOffset];
        
        CGRect frame = self.frame;
        frame.origin.x = 0;
        frame.size.width = CGRectGetWidth(scrollView.frame);
        [self setFrame:frame];
    } else if ([keyPath isEqualToString:@"contentInset"]) {
//        UIEdgeInsets oldEdgeInset = [[change objectForKey:NSKeyValueChangeOldKey] UIEdgeInsetsValue];
        UIEdgeInsets newEdgeInset = [[change objectForKey:NSKeyValueChangeNewKey] UIEdgeInsetsValue];
        
        //判断是不是内部更新的edgeinset,如果不是内部更新的，则存储最新的值
        if (scrollView.updateContentInsetWithPullRefreshView == NO && scrollView.updateContentInsetWithPushRefreshView == NO) {
            [self setDefaultEdgeInsets:newEdgeInset];
        }
    }
}

- (void)scrollView:(UIScrollView *)scrollView oldOffset:(CGPoint)oldOffset newOffset:(CGPoint)newOffset {
    [self scrollView:scrollView contentOffset:oldOffset];
    if (!scrollView.isDragging) {
        [self scrollViewDidEndDragging:scrollView preload:NO];
    }
}

#pragma mark Getters & Setters;
- (UILabel *)descLabel {
    if (_descLabel == nil) {
        _descLabel = [[UILabel alloc] init];
        [_descLabel setBackgroundColor:[UIColor clearColor]];
        [_descLabel setTextAlignment:NSTextAlignmentCenter];
        [_descLabel setFont:[UIFont systemFontOfSize:15.0f]];
        [self addSubview:_descLabel];
    }
    return _descLabel;
}

- (UIImageView *)imageView {
    if (_imageView == nil) {
        _imageView = [[UIImageView alloc] init];
        [_imageView setBackgroundColor:[UIColor clearColor]];
        [_imageView setImage:[UIImage imageNamed:@"refreshArrow.png"]];
        [self addSubview:_imageView];
    }
    return _imageView;
}

- (UIActivityIndicatorView *)activityIndicatorView {
    if (_activityIndicatorView == nil) {
        _activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        [self addSubview:_activityIndicatorView];
    }
    return _activityIndicatorView;
}

@end
