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

#import "ORChannelViewModel.h"

static CGFloat const menuHeight = 55.0;
#define Tint_Back_Color [UIColor colorWithRed:245/255.f green:244/255.f blue:247/255.f alpha:1]


@interface ViewController ()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout> {
    BOOL _isDraging;
    CGFloat _lastBottowInset;
}
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (nonatomic, strong) ORScrollMenuView *menuView;

@property (nonatomic, strong) ORChannelViewModel *viewModel;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    _viewModel = [ORChannelViewModel new];
    
    self.view.backgroundColor = Tint_Back_Color;
    
    CGFloat menuY = [UIScreen mainScreen].bounds.size.height > 800 ? 75 + 24 : 75;

    [self.collectionView registerNib:[UINib nibWithNibName:@"ORNormalChannelHeader" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:NSStringFromClass([ORNormalChannelHeader class])];
    [self.collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:NSStringFromClass([UICollectionReusableView class])];

    UILongPressGestureRecognizer *longPressGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(_or_actionLongPressGesture:)];
    [_collectionView addGestureRecognizer:longPressGesture];
    
    
    self.menuView = [ORScrollMenuView new];
    self.menuView.frame = CGRectMake(0, menuY, [UIScreen mainScreen].bounds.size.width, menuHeight);
    self.menuView.titles = _viewModel.titles;
    self.menuView.backgroundColor = Tint_Back_Color;
    self.menuView.hidden = YES;
    [self.view addSubview:self.menuView];

    __weak typeof(self) weakSelf = self;
    [_menuView setMenuDidSelectConfig:^(NSInteger index) {
        [weakSelf _or_collectionViewOffsetAjustMenuWithIndex:index];
    }];
    
}

#pragma mark -- private
- (void)_or_actionLongPressGesture:(UILongPressGestureRecognizer *)gesture {
    
    CGPoint point = [gesture locationInView:_collectionView];
    NSIndexPath *indexPath = [self.collectionView indexPathForItemAtPoint:point];
    
    switch (gesture.state) {
            
        case UIGestureRecognizerStateBegan:
            [self.collectionView beginInteractiveMovementForItemAtIndexPath:indexPath];
            break;
            
        case UIGestureRecognizerStateChanged:
            [self.collectionView updateInteractiveMovementTargetPosition:point];
            break;
            
        case UIGestureRecognizerStateEnded:
            [self.collectionView endInteractiveMovement];
            break;
            
        default:
            [self.collectionView cancelInteractiveMovement];
            break;
    }
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
    if (nextIndexPath.section > _viewModel.dataSource.count-1) {
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


#pragma mark -- UICollectionViewDelegate && UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return _viewModel.dataSource.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return _viewModel.dataSource[section].chanels.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    ORChannelCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([ORChannelCell class]) forIndexPath:indexPath];
    cell.titleL.text = _viewModel.dataSource[indexPath.section].chanels[indexPath.item];
    return cell;
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
            menu.titles = _viewModel.titles;
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
    header.titleL.text = _viewModel.dataSource[indexPath.section].title;
    return header;
}

- (BOOL)collectionView:(UICollectionView *)collectionView canMoveItemAtIndexPath:(NSIndexPath *)indexPath {
    return indexPath.section == 0;
}

- (void)collectionView:(UICollectionView *)collectionView moveItemAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath {
    
    [self.viewModel or_moveItemAtIndexPath:sourceIndexPath.item toIndexPath:destinationIndexPath.item];
}

#pragma mark -- UICollectionViewDelegateFlowLayout

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    
    if (section == 0) {
        return UIEdgeInsetsMake(0, H_P(15), H_P(15), H_P(15));
    }
    if (section == 1) {
        return UIEdgeInsetsMake(H_P(15), H_P(15), 0, H_P(15));
    }
    
    if (section == _viewModel.dataSource.count - 1) {
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
