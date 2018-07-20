//
//  ORScrollMenuView.m
//  OC_TencentVideoChannel
//
//  Created by 欧阳荣 on 2018/7/18.
//  Copyright © 2018 欧阳荣. All rights reserved.
//

#import "ORScrollMenuView.h"

static NSInteger const btnTag = 2018;

@interface ORScrollMenuView () {
    NSInteger _currentTag;
}

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIView *slider;

@end

@implementation ORScrollMenuView

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self _or_initilaizeUI];
    }
    return self;
}


- (void)_or_initilaizeUI {
    
    [self addSubview:self.scrollView];
    [self.scrollView addSubview:self.slider];
    
//    __block CGFloat contentW = 0.f;
//
//    [self.titles enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//        CGFloat btw = [obj boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, 10) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:H_P(18)]} context:nil].size.width + H_P(30);
//
//        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
//        btn.frame = CGRectMake(contentW, 0, btw, self.bounds.size.height-5);
//        [btn setTitle:obj forState:UIControlStateNormal];
//        [btn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
//        [btn setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
//        btn.titleLabel.font = [UIFont systemFontOfSize:H_P(18)];
//        btn.tag = idx + btnTag;
//        [self.scrollView addSubview:btn];
//
//        if (idx == 0) {
//            self.slider.center = CGPointMake(btw / 2.0, btn.center.y + H_P(18));
//            [self _or_action_btn:btn];
//        }
//        [btn addTarget:self action:@selector(_or_action_btn:) forControlEvents:UIControlEventTouchUpInside];
//        contentW += btw;
//    }];
//
//    _scrollView.contentSize = CGSizeMake(contentW, 0);
}

- (void)_or_action_btn:(UIButton *)sender {
    [self or_setSelectIndex:sender.tag - btnTag animated:YES];
    if (self.menuDidSelectConfig) {
        self.menuDidSelectConfig(sender.tag-btnTag);
    }
}

- (void)_or_stateChangedWithBtn:(UIButton *)btn lastBtn:(UIButton *)lastBtn {
    
    CGPoint center = _slider.center;
    center.x = btn.center.x;
    _slider.center = center;
    
    btn.titleLabel.font = [UIFont systemFontOfSize:H_P(18) weight:2.3];
    btn.selected = YES;
    
    if (lastBtn) {
        lastBtn.titleLabel.font = [UIFont systemFontOfSize:H_P(18)];
        lastBtn.selected = NO;
    }
    
}

- (void)or_setSelectIndex:(NSInteger)index animated:(BOOL)animated {
    
    if (index == _currentTag - btnTag) {
        return;
    }
    UIButton *btn = [_scrollView viewWithTag:index + 2018];
    UIButton *lastBtn = [_scrollView viewWithTag:_currentTag];
    
    CGPoint btnCenter = [_scrollView convertPoint:btn.center toView:self];
    CGFloat inset = btnCenter.x - self.bounds.size.width / 2.0;
    
    if (inset > 0) {
        CGFloat maxInset = _scrollView.contentSize.width - _scrollView.contentOffset.x - self.bounds.size.width;
        inset = MIN(inset, maxInset);
        inset = MAX(inset, 0);
    }else {
        CGFloat minInset = -_scrollView.contentOffset.x;
        inset = MAX(inset, minInset);
        inset = MIN(inset, 0);
    }
    
    if (animated) {
        [UIView animateWithDuration:0.25 animations:^{
            [self _or_stateChangedWithBtn:btn lastBtn:lastBtn];
        }];
    }else {
        [self _or_stateChangedWithBtn:btn lastBtn:lastBtn];
    }
    
    [_scrollView setContentOffset:CGPointMake(_scrollView.contentOffset.x + inset, 0) animated:animated];
    _currentTag = btn.tag;
}


#pragma mark -- getter && setter

- (void)setTitles:(NSArray<NSString *> *)titles {
    
    _titles = titles;
    
    _slider.hidden = _titles.count == 0;
    
    if (_titles.count == 0) {
        return;
    }
    
    [_scrollView.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[UIButton class]]) {
            [obj removeFromSuperview];
        }
    }];
    
    _currentTag = 0;
    __block CGFloat contentW = 0.f;
    
    [_titles enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        CGFloat btw = [obj boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, 10) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:H_P(18)]} context:nil].size.width + H_P(30);
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(contentW, 0, btw, self.bounds.size.height-5);
        [btn setTitle:obj forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:H_P(18)];
        btn.tag = idx + btnTag;
        [self.scrollView addSubview:btn];
        
        if (idx == 0) {
            self.slider.center = CGPointMake(btw / 2.0, btn.center.y + H_P(12));
            [self or_setSelectIndex:idx animated:NO];
        }
        [btn addTarget:self action:@selector(_or_action_btn:) forControlEvents:UIControlEventTouchUpInside];
        contentW += btw;
    }];
    
    _scrollView.contentSize = CGSizeMake(contentW, 0);
    
}

- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
        _scrollView.showsHorizontalScrollIndicator = NO;
        if (@available(iOS 11.0, *)) {
            _scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
    }
    return _scrollView;
}

- (UIView *)slider {
    if (!_slider) {
        _slider = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 18, 3)];
        _slider.backgroundColor = [UIColor orangeColor];
    }
    return _slider;
}

- (NSInteger)currentIndex {
    return _currentTag - btnTag;
}

- (void)setTintColor:(UIColor *)tintColor {
    [_titles enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UIButton *btn = [self.scrollView viewWithTag:idx + btnTag];
        [btn setTitleColor:tintColor forState:UIControlStateSelected];
    }];
    self.slider.backgroundColor = tintColor;
}

- (UIColor *)tintColor {
    return self.slider.backgroundColor;
}

@end


