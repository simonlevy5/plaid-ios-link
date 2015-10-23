//
//  PLDLinkBankSelectionView.m
//  Plaid
//
//  Created by Simon Levy on 10/13/15.
//  Copyright © 2015 Vouch Financial, Inc. All rights reserved.
//

#import "PLDLinkBankSelectionView.h"

#import "PLDLinkBankTileView.h"

#import "PLDInstitution.h"

@interface PLDLinkBankSelectionLayout : UICollectionViewFlowLayout
@end

@implementation PLDLinkBankSelectionLayout

- (UICollectionViewLayoutAttributes*)initialLayoutAttributesForAppearingItemAtIndexPath:(NSIndexPath *)itemIndexPath {
  UICollectionViewLayoutAttributes *attributes =
      [super initialLayoutAttributesForAppearingItemAtIndexPath:itemIndexPath];
  attributes.alpha = 0;
  attributes.transform = CGAffineTransformMakeTranslation(0, 300);
  return attributes;
}

@end

@implementation PLDLinkBankSelectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
  if (self = [super initWithFrame:frame]) {
    _tileView = [[PLDLinkBankTileView alloc] initWithFrame:frame];
    [self.contentView addSubview:_tileView];
  }
  return self;
}

- (void)updateWithInstitution:(PLDInstitution *)institution {
  _tileView.institution = institution;
}

- (void)layoutSubviews {
  [super layoutSubviews];
  _tileView.frame = self.bounds;
}

@end

@implementation PLDLinkBankSelectionView {
  UICollectionViewFlowLayout *_collectionViewLayout;
}

- (void)setInstitutions:(NSArray *)institutions {
  _institutions = institutions;
  [self.collectionView performBatchUpdates:^{
    [self.collectionView reloadSections:[NSIndexSet indexSetWithIndex:0]];
  } completion:^(BOOL finished) {}];
}

- (instancetype)initWithFrame:(CGRect)frame {
  if (self = [super initWithFrame:frame]) {
    _institutions = [NSArray array];
    
    _collectionViewLayout = [[PLDLinkBankSelectionLayout alloc] init];
    _collectionViewLayout.minimumLineSpacing = 8;
    _collectionViewLayout.minimumInteritemSpacing = 8;
    _collectionViewLayout.sectionInset = UIEdgeInsetsMake(0, 8, 8, 8);

    _collectionView = [[UICollectionView alloc] initWithFrame:frame
                                         collectionViewLayout:_collectionViewLayout];
    _collectionView.backgroundColor = [UIColor clearColor];
    _collectionView.clipsToBounds = YES;
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
    [_collectionView registerClass:[PLDLinkBankSelectionViewCell class]
        forCellWithReuseIdentifier:@"cell"];
    [self addSubview:_collectionView];
  }
  return self;
}

- (void)layoutSubviews {
  [super layoutSubviews];
  
  _collectionView.frame = self.bounds;
  CGFloat itemWidth = (self.frame.size.width - 24) / 2;
  _collectionViewLayout.itemSize = CGSizeMake(itemWidth, itemWidth / 2);
}

- (PLDLinkBankSelectionViewCell *)selectedCell {
  NSIndexPath *selectedIndexPath = [_collectionView indexPathsForSelectedItems].firstObject;
  if (selectedIndexPath != nil) {
    PLDLinkBankSelectionViewCell *cell =
        (PLDLinkBankSelectionViewCell *)[_collectionView cellForItemAtIndexPath:selectedIndexPath];
    return cell;
  }
  return nil;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView
     numberOfItemsInSection:(NSInteger)section {
  return [_institutions count];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
  return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath {
  PLDLinkBankSelectionViewCell *cell =
      [collectionView dequeueReusableCellWithReuseIdentifier:@"cell"
                                                forIndexPath:indexPath];
  [cell updateWithInstitution:_institutions[indexPath.row]];
  return cell;
}

- (void)collectionView:(UICollectionView *)collectionView
    didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
  [_delegate bankSelectionView:self didSelectInstitution:_institutions[indexPath.row]];
}

@end
