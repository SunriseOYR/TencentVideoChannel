//
//  ORScrollMenuView.h
//  OC_TencentVideoChannel
//
//  Created by 欧阳荣 on 2018/7/18.
//  Copyright © 2018 欧阳荣. All rights reserved.
//

#import <UIKit/UIKit.h>

#define H_P(X) X * [UIScreen mainScreen].bounds.size.width / 375.0f

@interface ORScrollMenuView : UIView

@property (nonatomic, copy) void(^menuDidSelectConfig)(NSInteger index);

@property (nonatomic, assign, readonly) NSInteger currentIndex;

@property (nonatomic, strong) UIColor *sliderColor;

@property (nonatomic, strong) NSArray<NSString *> *titles;

- (void)or_setSelectIndex:(NSInteger)index animated:(BOOL)animated;

- (void)or_setNormalColor:(UIColor *)normalColor selectedColor:(UIColor *)selectedColor;

@end
