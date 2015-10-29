//
//  PLDLinkBankSelectionSearchResultsViewController.m
//  PlaidLink
//
//  Created by Simon Levy on 10/28/15.
//

#import "PLDLinkBankSelectionSearchResultsViewController.h"

#import "Plaid.h"

@interface PLDLinkBankSelectionSearchResultsViewCell : UICollectionViewCell
@end

@implementation PLDLinkBankSelectionSearchResultsViewCell {
  UIImageView *_imageView;
  UILabel *_label;
}

- (instancetype)initWithFrame:(CGRect)frame {
  if (self = [super initWithFrame:frame]) {
    _label = [[UILabel alloc] initWithFrame:CGRectZero];
    _label.font = [UIFont systemFontOfSize:17 weight:UIFontWeightLight];
    [self addSubview:_label];
    
    _imageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    [self addSubview:_imageView];
  }
  return self;
}

- (void)layoutSubviews {
  [super layoutSubviews];

  CGRect bounds = self.bounds;
  CGFloat imagePadding = 12.0;
  _imageView.frame = CGRectMake(imagePadding,
                                imagePadding,
                                bounds.size.height - 2 * imagePadding,
                                bounds.size.height - 2 * imagePadding);
  _label.frame = CGRectMake(CGRectGetMaxX(_imageView.frame) + imagePadding,
                            0,
                            bounds.size.width - (CGRectGetMaxX(_imageView.frame) + 2 *imagePadding),
                            bounds.size.height);
}

- (void)updateWithLongTailInstitution:(PLDLongTailInstitution *)longTailInstitution {
  _label.text = longTailInstitution.name;
  _imageView.image = longTailInstitution.logoImage;
}

@end

@implementation PLDLinkBankSelectionSearchResultsViewController {
  UICollectionViewFlowLayout *_layout;
}

- (instancetype)init {
  _layout = [[UICollectionViewFlowLayout alloc] init];
  if (self = [super initWithCollectionViewLayout:_layout]) {
    _institutions = [NSArray array];

    _layout.minimumLineSpacing = 2;
    _layout.minimumInteritemSpacing = 8;
    _layout.sectionInset = UIEdgeInsetsMake(0, 8, 8, 8);

    self.collectionView.backgroundColor = [UIColor clearColor];
    [self.collectionView registerClass:[PLDLinkBankSelectionSearchResultsViewCell class]
            forCellWithReuseIdentifier:@"cell"];
  }
  return self;
}

- (void)setInstitutions:(NSArray *)institutions {
  _institutions = institutions;
  [self.collectionView reloadData];
}

- (void)viewDidLoad {
  [super viewDidLoad];
  self.edgesForExtendedLayout = UIRectEdgeNone;
  self.automaticallyAdjustsScrollViewInsets = NO;
  [self.collectionView setContentInset:UIEdgeInsetsMake(6, 0, 0, 0)];

  _layout.itemSize = CGSizeMake(self.view.bounds.size.width - 16, 60);
}

- (void)viewWillDisappear:(BOOL)animated {
  [_delegate searchResultsViewControllerWillDisappear:self];
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView
     numberOfItemsInSection:(NSInteger)section {
  return [_institutions count];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
  return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath {
  PLDLinkBankSelectionSearchResultsViewCell *cell =
      [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
  [cell updateWithLongTailInstitution:_institutions[indexPath.row]];
  return cell;
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView
    didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
  [_delegate searchResultsViewController:self
            didSelectLongTailInstitution:_institutions[indexPath.row]];
}

@end
