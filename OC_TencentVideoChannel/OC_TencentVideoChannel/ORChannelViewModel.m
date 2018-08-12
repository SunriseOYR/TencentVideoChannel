//
//  ORChannelViewModel.m
//  OC_TencentVideoChannel
//
//  Created by 欧阳荣 on 2018/7/25.
//  Copyright © 2018 欧阳荣. All rights reserved.
//

#import "ORChannelViewModel.h"

@implementation ORChannelViewModel

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self _or_initDataSource];
    }
    return self;
}

- (void)_or_initDataSource {
    
    _titles = @[@"大IP", @"HOT", @"衍生", @"影视综", @"游戏", @"搞笑", @"生活", @"体育", @"时尚", @"音乐", @"育儿", @"旅游", @"视听体验", @"其他", @"默认"];
    
    self.canMove = YES;
    
    NSMutableArray *chanleModels = [NSMutableArray arrayWithCapacity:_titles.count + 1];
    
    ORChannelsModel *model = [self _or_cache];
    
    if (!model) {
        model = [ORChannelsModel or_chanelesModelWithTitle:@"我的频道" count:21];
    }
    
    [chanleModels addObject:model];

    [_titles enumerateObjectsUsingBlock:^(NSString *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        NSInteger count = arc4random() % 11 + 3;
        [chanleModels addObject:[ORChannelsModel or_chanelesModelWithTitle:obj count:count]];
    }];
    
    _dataSource = chanleModels.copy;
}

- (id)_or_cache {
    
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject stringByAppendingPathComponent:@"or_chanle_path.dat"];
    
    return [NSKeyedUnarchiver unarchiveObjectWithFile:path];
}

- (BOOL)_or_save {
    
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject stringByAppendingPathComponent:@"or_chanle_path.dat"];

    
   return [NSKeyedArchiver archiveRootObject:_dataSource.firstObject toFile:path];
}

- (void)or_moveItemAtIndexPath:(NSInteger)sourceIndex toIndexPath:(NSInteger)destinationIndex {
    
    NSMutableArray *array = self.dataSource.firstObject.chanels.mutableCopy;
    
    id object = array[sourceIndex];
    [array removeObject:object];
    [array insertObject:object atIndex:destinationIndex];
    
    self.dataSource.firstObject.chanels = array.copy;
    [self _or_save];
}

@end

@implementation ORChannelsModel

+ (instancetype)or_chanelesModelWithTitle:(NSString *)title count:(NSInteger)count {
    
    ORChannelsModel *model = [ORChannelsModel new];
    NSMutableArray *chanleNames = [NSMutableArray arrayWithCapacity:count];
    for (int i = 0; i < count; i ++) {
        NSString *name = [NSString stringWithFormat:@"%@-%02d", title, i];
        [chanleNames addObject:name];
    }
    model.title = title;
    model.chanels = chanleNames.copy;
    return model;
}

- (void)encodeWithCoder:(NSCoder *)coder
{
    [coder encodeObject:self.title forKey:@"title"];
    [coder encodeObject:self.chanels forKey:@"chanels"];
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super init];
    if (self) {
        self.title = [coder decodeObjectForKey:@"title"];
        self.chanels = [coder decodeObjectForKey:@"chanels"];
    }
    return self;
}

@end
