//
//  PLDLinkBankSelectionView.m
//  PlaidLink
//
//  Created by Simon Levy on 10/13/15.
//

#import "PLDLinkBankSelectionView.h"

#import "PLDInstitution.h"

#import "PLDLinkBankTileView.h"
#import "NSString+Localization.h"

@interface PLDLinkBankLongtailSearchViewCell : UICollectionViewCell
@end

@implementation PLDLinkBankLongtailSearchViewCell {
  UILabel *_label;
}

- (instancetype)initWithFrame:(CGRect)frame {
  if (self = [super initWithFrame:frame]) {
    self.backgroundColor = [UIColor whiteColor];
    self.layer.cornerRadius = 8.0;

    _label = [[UILabel alloc] initWithFrame:frame];
    _label.numberOfLines = 0;
    _label.font = [UIFont systemFontOfSize:18 weight:UIFontWeightLight];
    _label.textAlignment = NSTextAlignmentCenter;
    _label.text = [NSString stringWithIdentifier:@"bank_selection_more_banks"];
    [self addSubview:_label];
  }
  return self;
}

- (void)layoutSubviews {
  [super layoutSubviews];
  _label.frame = self.bounds;
  [_label sizeToFit];
  _label.center = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds) - 1);
}

@end

@interface PLDLinkBankNotListedViewCell : UICollectionViewCell
@end

@implementation PLDLinkBankNotListedViewCell {
  UILabel *_label;
}

- (instancetype)initWithFrame:(CGRect)frame {
  if (self = [super initWithFrame:frame]) {
    self.backgroundColor = [UIColor whiteColor];
    self.layer.cornerRadius = 8.0;

    _label = [[UILabel alloc] initWithFrame:frame];
    _label.numberOfLines = 0;
    _label.font = [UIFont systemFontOfSize:16 weight:UIFontWeightLight];
    _label.textAlignment = NSTextAlignmentCenter;
    _label.text = [NSString stringWithIdentifier:@"bank_selection_not_found"];
    [self addSubview:_label];
  }
  return self;
}

- (void)layoutSubviews {
  [super layoutSubviews];
  _label.frame = self.bounds;
  [_label sizeToFit];
  _label.center = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds) - 1);
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

@interface PLDLinkBankSelectionView ()<UIGestureRecognizerDelegate>
@end

@implementation PLDLinkBankSelectionView {
  UICollectionViewFlowLayout *_collectionViewLayout;
  UIActivityIndicatorView *_spinner;
  BOOL _dragging;
  UILongPressGestureRecognizer *_gestureRecognizer;
  UICollectionViewCell *_pressedCell;
}

- (instancetype)initWithFrame:(CGRect)frame {
  if (self = [super initWithFrame:frame]) {
    _institutions = [NSArray array];

    _spinner = [[UIActivityIndicatorView alloc]
        initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    _spinner.hidesWhenStopped = YES;
    _spinner.alpha = 0.0;
    [self addSubview:_spinner];
    
    _collectionViewLayout = [[PLDLinkBankSelectionLayout alloc] init];
    _collectionViewLayout.minimumLineSpacing = 8;
    _collectionViewLayout.minimumInteritemSpacing = 8;
    _collectionViewLayout.sectionInset = UIEdgeInsetsMake(0, 8, 16, 8);

    _collectionView = [[UICollectionView alloc] initWithFrame:frame
                                         collectionViewLayout:_collectionViewLayout];
    _collectionView.backgroundColor = [UIColor clearColor];
    _collectionView.clipsToBounds = YES;
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
    [_collectionView registerClass:[PLDLinkBankSelectionViewCell class]
        forCellWithReuseIdentifier:@"cell"];
    [_collectionView registerClass:[PLDLinkBankLongtailSearchViewCell class]
        forCellWithReuseIdentifier:@"searchCell"];
    [_collectionView registerClass:[PLDLinkBankNotListedViewCell class]
        forCellWithReuseIdentifier:@"bankNotListedCell"];
    [self addSubview:_collectionView];

    _gestureRecognizer =
        [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handlePress:)];
    _gestureRecognizer.minimumPressDuration = 0;
    _gestureRecognizer.delaysTouchesBegan = NO;
    _gestureRecognizer.cancelsTouchesInView = NO;
    _gestureRecognizer.delegate = self;
    [_collectionView addGestureRecognizer:_gestureRecognizer];
  }
  return self;
}

- (void)layoutSubviews {
  [super layoutSubviews];

  _spinner.center = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds));
  
  _collectionView.frame = self.bounds;
  CGFloat itemWidth = (self.frame.size.width - 24) / 2;
  _collectionViewLayout.itemSize = CGSizeMake(itemWidth, itemWidth / 2);
}

- (void)setInstitutions:(NSArray *)institutions {
  [self hideLoadingSpinner];
  if (_institutions.count > 0) {
    _institutions = institutions;
    [_collectionView reloadData];
  } else {
    _institutions = institutions;
    [_collectionView performBatchUpdates:^{
      [_collectionView reloadSections:[NSIndexSet indexSetWithIndex:0]];
    } completion:^(BOOL finished) {}];
  }
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

- (void)scrollToBottom {
  NSInteger section = [self numberOfSectionsInCollectionView:_collectionView] - 1;
  NSInteger item = [self collectionView:_collectionView numberOfItemsInSection:section] - 1;
  NSIndexPath *lastIndexPath = [NSIndexPath indexPathForItem:item inSection:section];
  [_collectionView scrollToItemAtIndexPath:lastIndexPath
                          atScrollPosition:UICollectionViewScrollPositionBottom
                                  animated:YES];
}

- (void)showLoadingSpinner {
  [_spinner startAnimating];
  [UIView animateWithDuration:0.5
                        delay:0
                      options:UIViewAnimationOptionCurveEaseIn
                   animations:^{
                     if (_institutions.count == 0) {
                       _spinner.alpha = 1.0;
                     }
                   } completion:nil];
}

- (void)hideLoadingSpinner {
  [_spinner stopAnimating];
}

# pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView
     numberOfItemsInSection:(NSInteger)section {
  return [_institutions count];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
  return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath {
  id rowData = _institutions[indexPath.row];
  if ([rowData isKindOfClass:[NSString class]]) {
    PLDLinkBankLongtailSearchViewCell *cell =
        [collectionView dequeueReusableCellWithReuseIdentifier:rowData
                                                  forIndexPath:indexPath];
    return cell;
  }
  PLDLinkBankSelectionViewCell *cell =
      [collectionView dequeueReusableCellWithReuseIdentifier:@"cell"
                                                forIndexPath:indexPath];
  [cell updateWithInstitution:_institutions[indexPath.row]];
  return cell;
}

# pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView
    didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
  id rowData = _institutions[indexPath.row];
  if ([rowData isKindOfClass:[NSString class]]) {
    NSString *cellName = rowData;
    if ([cellName isEqual:@"searchCell"]) {
      [_delegate bankSelectionViewDidSelectSearch:self];
      return;
    } else if ([cellName isEqual:@"bankNotListedCell"]) {
      [_delegate bankSelectionViewDidSelectNotListed:self];
      return;
    }
  }
  [_delegate bankSelectionView:self didSelectInstitution:_institutions[indexPath.row]];
}

# pragma mark - UIScrollViewDelegate

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
  _dragging = YES;
  if (_pressedCell) {
    _pressedCell.transform = CGAffineTransformIdentity;
    _pressedCell = nil;
  }
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView
                     withVelocity:(CGPoint)velocity
              targetContentOffset:(inout CGPoint *)targetContentOffset {
  _dragging = NO;
}

# pragma mark - UIGestureRecognizerDelegate

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer
    shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
  return YES;
}

# pragma mark - Private

- (void)handlePress:(UILongPressGestureRecognizer *)recognizer {
  if (_dragging) {
    return;
  }
  
  CGPoint locationInView = [recognizer locationInView:_collectionView];
  NSIndexPath *indexPath = [_collectionView indexPathForItemAtPoint:locationInView];
  UICollectionViewCell* cell = [_collectionView cellForItemAtIndexPath:indexPath];
  if (cell != _pressedCell) {
    if (_pressedCell) {
      _pressedCell.transform = CGAffineTransformIdentity;
    }
    _pressedCell = cell;
  }
  if (recognizer.state == UIGestureRecognizerStateEnded && _pressedCell) {
    _pressedCell.transform = CGAffineTransformIdentity;
    _pressedCell = nil;
    return;
  }
  if (_pressedCell) {
    cell.transform = CGAffineTransformMakeScale(0.93, 0.93);
  }
}

@end
