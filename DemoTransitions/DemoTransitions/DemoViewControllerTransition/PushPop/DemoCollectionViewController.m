//
//  DemoCollectionViewController.m
//  DemoTransitions
//
//  Created by Chris Hu on 16/7/18.
//  Copyright © 2016年 icetime17. All rights reserved.
//

#import "DemoCollectionViewController.h"
#import "CollectionViewItemViewController.h"

#import "AnimatorPushPopTransition.h"

@interface DemoCollectionViewController () <

    UICollectionViewDataSource,
    UICollectionViewDelegate,

    UINavigationControllerDelegate
>

@end

@implementation DemoCollectionViewController {

    UICollectionView *_collectionView;
}

static NSString * const reuseIdentifier = @"Cell";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    layout.itemSize = CGSizeMake(100, 150);
    
    _collectionView = [[UICollectionView alloc] initWithFrame:self.view.frame collectionViewLayout:layout];
    [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
    [self.view addSubview:_collectionView];
    
    _collectionView.backgroundColor = [UIColor whiteColor];
    
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];

    self.navigationController.delegate = nil;
}

#pragma mark - <UICollectionViewDataSource>

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 6;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    cell.backgroundColor = [UIColor colorWithRed:((arc4random() % 255) / 255.0)
                                           green:((arc4random() % 255) / 255.0)
                                            blue:((arc4random() % 255) / 255.0)
                                           alpha:1.0f];
    
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:cell.contentView.frame];
    [cell.contentView addSubview:imageView];
    
    imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%ld", (long)indexPath.item]];
    
    return cell;
}

#pragma mark - <UICollectionViewDelegate>

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    CollectionViewItemViewController *itemVC = [[CollectionViewItemViewController alloc] init];
    itemVC.navigationItem.title = @"CollectionViewItemViewController";
    
    self.navigationController.delegate = self;
    [self.navigationController pushViewController:itemVC animated:YES];
}


#pragma mark - <UINavigationControllerDelegate>

- (nullable id <UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController
                                            animationControllerForOperation:(UINavigationControllerOperation)operation
                                                         fromViewController:(UIViewController *)fromVC
                                                           toViewController:(UIViewController *)toVC {
    // Push/Pop
    AnimatorPushPopTransition *pushPopTransition = [[AnimatorPushPopTransition alloc] init];
    
    if (operation == UINavigationControllerOperationPush) {
        pushPopTransition.animatorTransitionType = kAnimatorTransitionTypePush;
    } else {
        pushPopTransition.animatorTransitionType = kAnimatorTransitionTypePop;
    }
    
    
    NSArray *indexPaths = [_collectionView indexPathsForSelectedItems];
    if (indexPaths.count == 0) {
        return nil;
    }
    
    UICollectionViewCell *cell = [_collectionView cellForItemAtIndexPath:indexPaths[0]];
    
    pushPopTransition.itemCenter = cell.center;
    pushPopTransition.itemSize = cell.frame.size;
    
    return pushPopTransition;
}


@end