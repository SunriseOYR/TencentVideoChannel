//
//  ViewController.m
//  OC_TencentVideoChannel
//
//  Created by 欧阳荣 on 2018/7/18.
//  Copyright © 2018 欧阳荣. All rights reserved.
//

#import "ViewController.h"
#import "ORChannelCell.h"
#import "ORNormalChannelHeader.h"
#import "ORMyChannelHeader.h"
#import "ORScrollMenuView.h"

static CGFloat const menuHeight = 55.0;
#define Tint_Back_Color [UIColor colorWithRed:245/255.f green:244/255.f blue:247/255.f alpha:1]


@interface ViewController ()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout> {
    BOOL _isDraging;
    CGFloat _lastBottowInset;
}
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (nonatomic, strong) ORScrollMenuView *menuView;
@property (nonatomic, strong) NSArray *dataSource;



@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    _dataSource = @[@"大IP", @"HOT", @"衍生", @"影视综", @"游戏", @"搞笑", @"生活", @"体育", @"时尚", @"音乐", @"育儿", @"旅游", @"视听体验", @"其他", @"默认"];
    
    
    self.view.backgroundColor = Tint_Back_Color;
    
    CGFloat menuY = [UIScreen mainScreen].bounds.size.height > 800 ? 75 + 24 : 75;

    [self.collectionView registerNib:[UINib nibWithNibName:@"ORNormalChannelHeader" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:NSStringFromClass([ORNormalChannelHeader class])];
    [self.collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:NSStringFromClass([UICollectionReusableView class])];

    self.menuView = [ORScrollMenuView new];
    self.menuView.frame = CGRectMake(0, menuY, [UIScreen mainScreen].bounds.size.width, menuHeight);
    self.menuView.titles = _dataSource;
    self.menuView.backgroundColor = Tint_Back_Color;
    self.menuView.hidden = YES;
    [self.view addSubview:self.menuView];

    __weak typeof(self) weakSelf = self;
    [_menuView setMenuDidSelectConfig:^(NSInteger index) {
        [weakSelf _or_collectionViewOffsetAjustMenuWithIndex:index];
    }];
    
}

- (void)_or_collectionViewOffsetAjustMenuWithIndex:(NSInteger)index {
    
    self->_isDraging = NO;
    
    UICollectionViewLayoutAttributes *attr = [self.collectionView layoutAttributesForSupplementaryElementOfKind:UICollectionElementKindSectionHeader atIndexPath:[NSIndexPath indexPathForItem:0 inSection:index + 1]];
    
    CGFloat offsetY = index == 0 ? attr.frame.origin.y : attr.frame.origin.y - menuHeight;
    [self.collectionView setContentOffset:CGPointMake(0,offsetY) animated:YES];
}

#pragma mark -- UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    if ((_collectionView.visibleCells.count == 0)) {
        return;
    }

    UICollectionViewLayoutAttributes *menuAttr = [self.collectionView layoutAttributesForSupplementaryElementOfKind:UICollectionElementKindSectionHeader atIndexPath:[NSIndexPath indexPathForItem:0 inSection:1]];

    if (scrollView.contentOffset.y < menuAttr.frame.origin.y) {
        _menuView.hidden = YES;
        _collectionView.backgroundColor = Tint_Back_Color;
        return;
    }
    
    _collectionView.backgroundColor = [UIColor colorWithRed:241/255.f green:240/255.f blue:246/255.f alpha:1];
    _menuView.hidden = NO;

    
    if (!_isDraging) {
        return;
    }
    
    NSIndexPath *currentIndexPath = [NSIndexPath indexPathForItem:0 inSection:self.menuView.currentIndex + 1];
    UICollectionViewLayoutAttributes *currentAttr = [self.collectionView layoutAttributesForSupplementaryElementOfKind:UICollectionElementKindSectionHeader atIndexPath:currentIndexPath];
    
    
    if (scrollView.contentOffset.y + menuHeight < currentAttr.frame.origin.y) {
        [_menuView or_setSelectIndex:_menuView.currentIndex-1 animated:YES];
        return;
    }
    
    NSIndexPath *nextIndexPath = [NSIndexPath indexPathForItem:0 inSection:self.menuView.currentIndex + 2];
    if (nextIndexPath.section > _dataSource.count) {
        return;
    }
    UICollectionViewLayoutAttributes *nextAttr = [self.collectionView layoutAttributesForSupplementaryElementOfKind:UICollectionElementKindSectionHeader atIndexPath:nextIndexPath];
    if (nextAttr && scrollView.contentOffset.y + menuHeight > nextAttr.frame.origin.y) {
        [_menuView or_setSelectIndex:_menuView.currentIndex+1 animated:YES];
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    _isDraging = YES;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    _isDraging = NO;
}


#pragma mark -- UICollectionViewDelegate && UICollectionViewDataSource && UICollectionViewDelegateFlowLayout

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return _dataSource.count + 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    if (section == _dataSource.count) {
        return 31;
    }
    return section == 0 ? 21 : arc4random() % 11 + 3;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    return [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([ORChannelCell class]) forIndexPath:indexPath];
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    
    if ([kind isEqualToString:UICollectionElementKindSectionFooter]) {
        
        return [UICollectionReusableView new];
    }
    
    if (indexPath.section == 0) {
        ORMyChannelHeader *header = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:NSStringFromClass([ORMyChannelHeader class]) forIndexPath:indexPath];
        
        return header;
    }
    
    if (indexPath.section == 1) {
        UICollectionReusableView *header = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:NSStringFromClass([UICollectionReusableView class]) forIndexPath:indexPath];
        ORScrollMenuView *menu = [header viewWithTag:2019];
        if (!menu) {
            menu = [[ORScrollMenuView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, menuHeight)];
            menu.titles = _dataSource;
            menu.tag = 2019;
            [header addSubview:menu];
            __weak typeof(self) weakSelf = self;
            [menu setMenuDidSelectConfig:^(NSInteger index) {
                __strong typeof(weakSelf) strongSelf = weakSelf;
                [strongSelf _or_collectionViewOffsetAjustMenuWithIndex:index];
                [strongSelf.menuView or_setSelectIndex:index animated:YES];
            }];
        }
        [menu or_setSelectIndex:_menuView.currentIndex animated:NO];
        return header;
    }
    
    ORNormalChannelHeader *header = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:NSStringFromClass([ORNormalChannelHeader class]) forIndexPath:indexPath];
    header.titleL.text = _dataSource[indexPath.section - 1];
    return header;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    
    if (section == 0) {
        return UIEdgeInsetsMake(0, H_P(15), H_P(15), H_P(15));
    }
    if (section == 1) {
        return UIEdgeInsetsMake(H_P(15), H_P(15), 0, H_P(15));
    }
    
    if (section == _dataSource.count) {
        return UIEdgeInsetsMake(0, H_P(15), 10, H_P(15));
    }
    
    return UIEdgeInsetsMake(0, H_P(15), 0, H_P(15));
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return CGSizeMake(0, 80);
    }
    if (section == 1) {
        return CGSizeMake(0, menuHeight);
    }
    return CGSizeMake(0, 50);
}



@end
