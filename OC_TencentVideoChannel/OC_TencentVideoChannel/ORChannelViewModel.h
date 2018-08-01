//
//  ORChannelViewModel.h
//  OC_TencentVideoChannel
//
//  Created by 欧阳荣 on 2018/7/25.
//  Copyright © 2018 欧阳荣. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ORChannelsModel;

@interface ORChannelViewModel : NSObject

@property (nonatomic, strong) NSArray <ORChannelsModel *> *dataSource;
@property (nonatomic, strong) NSArray *titles;

- (void)or_moveItemAtIndexPath:(NSInteger)sourceIndex toIndexPath:(NSInteger)destinationIndex;

- (BOOL)_or_save;

@end

@interface ORChannelsModel : NSObject<NSCoding>

@property (nonatomic, strong) NSArray <NSString *>*chanels;
@property (nonatomic, strong) NSString *title;

+ (instancetype)or_chanelesModelWithTitle:(NSString *)title count:(NSInteger)count;

@end
