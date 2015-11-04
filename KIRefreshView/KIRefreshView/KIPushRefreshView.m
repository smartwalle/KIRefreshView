//
//  KIPushRefreshView.m
//  Kitalker
//
//  Created by 杨 烽 on 12-7-12.
//  Copyright (c) 2012年 杨 烽. All rights reserved.
//

#import "KIPushRefreshView.h"
#import "UIScrollView+KIRefreshView.h"

@interface KIPushRefreshView ()
@property (nonatomic, assign) KIPushRefreshState    state;
@property (nonatomic, assign) UIEdgeInsets          defaultEdgeInsets;

@property (nonatomic, copy) NSString *normalTitle;
@property (nonatomic, copy) NSString *pushingTitle;
@property (nonatomic, copy) NSString *loadingTitle;

@end

@implementation KIPushRefreshView

#pragma mark Lifecycle
- (void)dealloc {
    _delegate = nil;
    _normalTitle = nil;
    _pushingTitle = nil;
    _loadingTitle = nil;
}

- (id)init {
    if (self = [super init]) {
        [self setState:KIPushRefreshNormal];
    }
    return self;
}

- (void)awakeFromNib {
    [self setState:KIPushRefreshNormal];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat width = CGRectGetWidth(self.frame);
    
    CGFloat viewHeight = [self pushRefreshViewHeight];
    
    [self.descLabel setFrame:CGRectMake((width-170)/2, (viewHeight - 21) / 2, 170, 21)];
    [self.activityIndicatorView setFrame:CGRectMake(CGRectGetMinX(self.descLabel.frame)-20, (viewHeight - 20) / 2, 20, 20)];
}

- (void)scrollView:(UIScrollView *)scrollView contentOffset:(CGPoint)contentOffset {
    //判断是向上推
    
    CGFloat contentHeight = scrollView.contentSize.height;
    CGFloat height = scrollView.bounds.size.height-self.defaultEdgeInsets.top;
    
    if (height > contentHeight) {
        [scrollView bringSubviewToFront:self];
    }
    
    contentHeight = MAX(contentHeight+self.defaultEdgeInsets.bottom, height);
    
    CGFloat offsetY = MAX(contentOffset.y-self.defaultEdgeInsets.bottom-self.defaultEdgeInsets.top, contentOffset.y+self.defaultEdgeInsets.top);
    
    if (offsetY > 0) {
        if (self.state == KIPushRefreshLoading) {
            /*
            CGFloat offset = scrollView.bounds.size.height - scrollView.contentSize.height + [self pushRefreshViewHeight];
            offset = MAX(offset, [self pushRefreshViewHeight]);
            
            UIEdgeInsets insets = scrollView.contentInset;
            insets.bottom = offset;
            [scrollView setContentInset:insets];
             */
        } else if (scrollView.isDragging) {
            if (offsetY+height > contentHeight+[self _pushRefreshViewHeight]
                && self.state == KIPushRefreshNormal) {
                [self setState:KIPushRefreshPushing];
            }
            
            if (offsetY+height < contentHeight+[self _pushRefreshViewHeight]
                && self.state == KIPushRefreshPushing) {
                [self setState:KIPushRefreshNormal];
            }
            
        } else {
            if (offsetY+height > contentHeight+[self _pushRefreshViewHeight]
                && self.state == KIPushRefreshPushing) {
                CGFloat offset = ABS(height - contentHeight) + [self _pushRefreshViewHeight];
                offset = MAX(offset - self.defaultEdgeInsets.top, [self _pushRefreshViewHeight]) + self.defaultEdgeInsets.bottom;
                [UIView animateWithDuration:0.2f
                                      delay:0
                                    options:UIViewAnimationOptionAllowUserInteraction|UIViewAnimationOptionBeginFromCurrentState
                                 animations:^{
                                     [scrollView setContentOffset:CGPointMake(0, offset) animated:NO];
                                 } completion:^(BOOL finished) {
                                 }];
            }
        }
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView {
    if (self.state == KIPushRefreshLoading) {
        return ;
    }
    
    if (self.state == KIPushRefreshPushing) {
        [self setState:KIPushRefreshLoading];
        
        CGFloat offset = scrollView.bounds.size.height - scrollView.contentSize.height + [self _pushRefreshViewHeight];
        
        offset = MAX(offset - self.defaultEdgeInsets.top, [self _pushRefreshViewHeight] + self.defaultEdgeInsets.bottom);
        
        [UIView animateWithDuration:0.2f
                              delay:0
                            options:UIViewAnimationOptionAllowUserInteraction|UIViewAnimationOptionBeginFromCurrentState
                         animations:^{
//                             UIEdgeInsets insets = scrollView.contentInset;
//                             insets.bottom = offset;
//                             [scrollView setContentInset:insets];
                             [self update:scrollView edgeInsetBottom:offset];
                         } completion:^(BOOL finished) {
                         }];
    }
}

- (void)scrollViewDidFinishedLoading:(UIScrollView *)scrollView {
    [self setState:KIPushRefreshNormal];
    
    [UIView animateWithDuration:0.2f
                          delay:0
                        options:UIViewAnimationOptionAllowUserInteraction|UIViewAnimationOptionBeginFromCurrentState
                     animations:^{
//                         UIEdgeInsets insets = scrollView.contentInset;
//                         insets.bottom = 0;
//                         [scrollView setContentInset:insets];
                         [self update:scrollView edgeInsetBottom:0+self.defaultEdgeInsets.bottom];
                     } completion:^(BOOL finished) {
                         [scrollView setUpdateContentInsetWithPushRefreshView:NO];
                     }];
}

- (void)update:(UIScrollView *)scrollView edgeInsetBottom:(CGFloat)bottom {
    //标记为内部更新的edgeinset
    [scrollView setUpdateContentInsetWithPushRefreshView:YES];
    UIEdgeInsets insets = scrollView.contentInset;
    insets.bottom = bottom;
    [scrollView setContentInset:insets];
}


- (void)reset:(UIScrollView *)scrollView {
    [self scrollViewDidFinishedLoading:scrollView];
}

- (void)setState:(KIPushRefreshState)aState {
    if (_state == aState) {
        return ;
    }
    _state = aState;
    [self updateState:_state];
}

- (void)setTitle:(NSString *)title forState:(KIPushRefreshState)state {
    if (state == KIPushRefreshNormal) {
        [self setNormalTitle:title];
        if (self.state == KIPushRefreshNormal) {
            [self.descLabel setText:self.normalTitle];
        }
    } else if (state == KIPushRefreshLoading) {
        [self setLoadingTitle:title];
    } else if (state == KIPushRefreshPushing) {
        [self setPushingTitle:title];
    }
}

- (void)updateState:(KIPushRefreshState)aState {
    switch (aState) {
        case KIPushRefreshNormal: {
            if (aState == KIPushRefreshPushing) {
                //还原
            }
            [self.activityIndicatorView setHidden:YES];
            [self.activityIndicatorView stopAnimating];
            [self.descLabel setText:self.normalTitle != nil ? self.normalTitle :NSLocalizedString(@"上拉获取更多...", nil)];
        }
            break;
        case KIPushRefreshPushing:
            [self.descLabel setText:self.pushingTitle != nil ? self.pushingTitle :NSLocalizedString(@"释放更新...", nil)];
            break;
        case KIPushRefreshLoading: {
            [self.activityIndicatorView setHidden:NO];
            [self.activityIndicatorView startAnimating];
            [self.descLabel setText:self.loadingTitle != nil ? self.loadingTitle :NSLocalizedString(@"更新中，请稍候...", nil)];
            if (_delegate != nil
                && [_delegate respondsToSelector:@selector(pushRefreshViewStartLoad:)]) {
                [_delegate pushRefreshViewStartLoad:self];
            }
        }
            break;
        default:
            break;
    }
}

- (CGFloat)_pushRefreshViewHeight {
    return [self pushRefreshViewHeight];
}

- (CGFloat)pushRefreshViewHeight {
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
        [scrollView addObserver:self forKeyPath:@"contentSize"
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

- (void)setDefaultEdgeInsets:(UIEdgeInsets)defaultEdgeInsets {
    _defaultEdgeInsets = defaultEdgeInsets;
    [self updateFrame:(UIScrollView *)self.superview];
}

- (void)removeFromSuperview {
    if (self.superview != nil && [self.superview isKindOfClass:[UIScrollView class]]) {
        UIScrollView *scrollView = (UIScrollView *)self.superview;
        [scrollView removeObserver:self forKeyPath:@"contentOffset" context:nil];
        [scrollView removeObserver:self forKeyPath:@"contentInset" context:nil];
        [scrollView removeObserver:self forKeyPath:@"contentSize" context:nil];
    }
    [super removeFromSuperview];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    UIScrollView *scrollView = object;
    if([keyPath isEqualToString:@"contentOffset"]) {
        CGPoint oldOffset = [[change objectForKey:NSKeyValueChangeOldKey] CGPointValue];
        CGPoint newOffset = [[change objectForKey:NSKeyValueChangeNewKey] CGPointValue];
        
        [self scrollView:scrollView oldOffset:oldOffset newOffset:newOffset];
    } else if ([keyPath isEqualToString:@"contentInset"]) {
        //        UIEdgeInsets oldEdgeInset = [[change objectForKey:NSKeyValueChangeOldKey] UIEdgeInsetsValue];
        UIEdgeInsets newEdgeInset = [[change objectForKey:NSKeyValueChangeNewKey] UIEdgeInsetsValue];
        
        //判断是不是内部更新的edgeinset,如果不是内部更新的，则存储最新的值
        if (scrollView.updateContentInsetWithPushRefreshView == NO && scrollView.updateContentInsetWithPullRefreshView == NO) {
            [self setDefaultEdgeInsets:newEdgeInset];
        }
    } else if ([keyPath isEqualToString:@"contentSize"]) {
        [self updateFrame:object];
    }
}

- (void)scrollView:(UIScrollView *)scrollView oldOffset:(CGPoint)oldOffset newOffset:(CGPoint)newOffset {
    [self updateFrame:scrollView];
    
    [self scrollView:scrollView contentOffset:oldOffset];
    if (!scrollView.isDragging) {
        [self scrollViewDidEndDragging:scrollView];
    }
}

- (void)updateFrame:(UIScrollView *)scrollView {
    CGFloat height = scrollView.bounds.size.height;
    CGFloat contentSizeHeight = scrollView.contentSize.height;
    [self setFrame:CGRectMake(0,
                              MAX(height-self.defaultEdgeInsets.top, contentSizeHeight+self.defaultEdgeInsets.bottom) - self.bottomOffset,
                              self.bounds.size.width,
                              self.bounds.size.height)];
    
    if (self.state == KIPushRefreshLoading) {
        CGFloat offset = scrollView.bounds.size.height - scrollView.contentSize.height + [self _pushRefreshViewHeight];
        offset = MAX(offset - self.defaultEdgeInsets.top, [self _pushRefreshViewHeight] + self.defaultEdgeInsets.bottom);

        [self update:scrollView edgeInsetBottom:offset];
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

- (UIActivityIndicatorView *)activityIndicatorView {
    if (_activityIndicatorView == nil) {
        _activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        [self addSubview:_activityIndicatorView];
    }
    return _activityIndicatorView;
}

@end
