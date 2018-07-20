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

@property (nonatomic, strong) UIColor *tintColor;

@property (nonatomic, strong) NSArray<NSString *> *titles;


@end
