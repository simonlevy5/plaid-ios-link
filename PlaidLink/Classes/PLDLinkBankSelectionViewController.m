//
//  PLDLinkBankSelectionViewController.m
//  PlaidLink
//
//  Created by Simon Levy on 10/13/15.
//

#import <QuartzCore/CALayer.h>

#import "PLDLinkBankSelectionViewController.h"

#import "Plaid.h"

#import "PLDLinkBankSelectionSearchResultsViewController.h"
#import "PLDLinkBankMFALoginView.h"
#import "PLDLinkBankSelectionView.h"
#import "NSString+Localization.h"

@interface PLDLinkBankSelectionViewController ()<PLDLinkBankSelectionViewDelegate,
    PLDLinkBankSelectionSearchResultsViewControllerDelegate, UISearchResultsUpdating>
@end

@implementation PLDLinkBankSelectionViewController {
  PlaidProduct _product;
  PLDLinkBankSelectionView *_bankSelectionView;
  UIBarButtonItem *_closeButton;
  UISearchController *_searchController;
  PLDLinkBankSelectionSearchResultsViewController *_searchResultsController;
}

- (instancetype)initWithProduct:(PlaidProduct)product {
  if (self = [super init]) {
    _product = product;
    self.definesPresentationContext = YES;
  }
  return self;
}

- (void)loadView {
  [super loadView];

  _bankSelectionView = [[PLDLinkBankSelectionView alloc] initWithFrame:CGRectZero];
  _bankSelectionView.delegate = self;
  self.view = _bankSelectionView;
}

- (void)viewDidLoad {
  [super viewDidLoad];

  self.edgesForExtendedLayout = UIRectEdgeNone;

  _closeButton =
      [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemStop
                                                    target:self
                                                    action:@selector(didTapCancel)];
  self.navigationItem.rightBarButtonItem = _closeButton;

  [[Plaid sharedInstance] getInstitutionsWithCompletion:^(id response, NSError *error) {
    NSMutableArray *institutions = [NSMutableArray arrayWithArray:response];
    [institutions filterUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(PLDInstitution *institution,
                                                                             NSDictionary *bindings) {
      return [institution isProductAvailable:_product];
    }]];
    if (_product == PlaidProductConnect) {
      [institutions addObject:@"searchCell"];
    } else {
      [institutions addObject:@"bankNotListedCell"];
    }
    _bankSelectionView.institutions = institutions;
  }];
}

- (void)viewWillAppear:(BOOL)animated {
  [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithWhite:0.96 alpha:1]];
  [self.navigationController.navigationBar setBarStyle:UIBarStyleDefault];
  [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)viewDidAppear:(BOOL)animated {
  self.title = [NSString stringWithIdentifier:@"bank_selection_title"];
  if (_bankSelectionView.institutions.count == 0) {
    [_bankSelectionView showLoadingSpinner];
  }
}

- (void)viewWillDisappear:(BOOL)animated {
  // Remove the title so that the transition looks 👌🏽
  self.title = @"";
}

- (BOOL)prefersStatusBarHidden {
  return NO;
}

- (void)didTapCancel {
  [_delegate bankSelectionViewControllerCancelled:self];
}

#pragma mark - UISearchResultsUpdating

- (void)updateSearchResultsForSearchController:(UISearchController *)searchController {
  NSString *searchQuery = searchController.searchBar.text;
  if ([searchQuery length] == 0) {
    return;
  }
  [[Plaid sharedInstance] getLongTailInstitutionsWithQuery:searchController.searchBar.text
                                                   product:_product
                                                completion:^(id response, NSError *error) {
    if (error) {
      // TODO: Show error here.
      return;
    }
    _searchResultsController.institutions = response;
  }];
}

#pragma mark - PLDLinkBankSelectionViewDelegate

- (void)bankSelectionView:(PLDLinkBankSelectionView *)view
     didSelectInstitution:(PLDInstitution *)institution {
  [_delegate bankSelectionViewController:self didFinishWithInstitution:institution];
}

- (void)bankSelectionViewDidSelectSearch:(PLDLinkBankSelectionView *)view {
  _searchResultsController =
      [[PLDLinkBankSelectionSearchResultsViewController alloc] init];
  _searchResultsController.delegate = self;
  _searchController =
      [[UISearchController alloc] initWithSearchResultsController:_searchResultsController];
  _searchController.searchResultsUpdater = self;
  _searchController.hidesNavigationBarDuringPresentation = NO;
  _searchController.dimsBackgroundDuringPresentation = NO;
  _searchController.searchBar.searchBarStyle = UISearchBarStyleMinimal;
  _searchController.searchBar.tintColor = [UIColor blackColor];
  self.title = [NSString stringWithIdentifier:@"bank_selection_search_title"];
  self.navigationItem.rightBarButtonItem = nil;

  [self animateSelectionViewOutForSearch];
  [self presentViewController:_searchController animated:YES completion:nil];
  _searchResultsController.view.transform =
      CGAffineTransformMakeTranslation(0, CGRectGetHeight(_searchController.searchBar.bounds));
}

- (void)bankSelectionViewDidSelectNotListed:(PLDLinkBankSelectionView *)view {
  [_delegate bankSelectionViewControllerDidFinishWithBankNotListed:self];
}

#pragma mark - PLDLinkBankSelectionSearchResultsViewControllerDelegate

- (void)searchResultsViewControllerWillDisappear:(PLDLinkBankSelectionSearchResultsViewController *)viewController {
  self.title = [NSString stringWithIdentifier:@"bank_selection_title"];
  self.navigationItem.rightBarButtonItem = _closeButton;

  CABasicAnimation *transformAnimation = [CABasicAnimation animationWithKeyPath:@"transform"];
  transformAnimation.duration = 0.5;
  transformAnimation.timingFunction =
      [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
  transformAnimation.removedOnCompletion = NO;
  transformAnimation.fillMode = kCAFillModeForwards;
  transformAnimation.toValue = [NSValue valueWithCATransform3D:CATransform3DIdentity];
  [_bankSelectionView.collectionView.layer addAnimation:transformAnimation forKey:@"revertTransformAnimation"];

  _bankSelectionView.collectionView.layer.opacity = 1;
  CABasicAnimation *alphaAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
  alphaAnimation.duration = 0.5;
  alphaAnimation.timingFunction =
      [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
  alphaAnimation.removedOnCompletion = YES;
  alphaAnimation.fromValue = [NSNumber numberWithFloat:0];
  alphaAnimation.toValue = [NSNumber numberWithFloat:1];
  [_bankSelectionView.collectionView.layer addAnimation:alphaAnimation forKey:@"appearAnimation"];
  _bankSelectionView.collectionView.userInteractionEnabled = YES;
}

- (void)searchResultsViewController:(PLDLinkBankSelectionSearchResultsViewController *)viewController
       didSelectLongTailInstitution:(PLDLongTailInstitution *)institution {
  [_searchController.view endEditing:YES];

  NSMutableArray *institutions = [NSMutableArray arrayWithArray:_bankSelectionView.institutions];
  NSUInteger searchIndex = ([institutions count] - 1);
  [institutions insertObject:institution atIndex:searchIndex];
  _bankSelectionView.institutions = institutions;

  // Animator expects a selected cell
  NSIndexPath *index = [NSIndexPath indexPathForRow:searchIndex inSection:0];
  [_bankSelectionView.collectionView selectItemAtIndexPath:index
                                                  animated:NO
                                            scrollPosition:UICollectionViewScrollPositionNone];
  [viewController dismissViewControllerAnimated:YES completion:^{
    [_delegate bankSelectionViewController:self didFinishWithInstitution:institution];
  }];
}

#pragma mark - Private

- (void)animateSelectionViewOutForSearch {
  CABasicAnimation *transformAnimation = [CABasicAnimation animationWithKeyPath:@"transform"];
  transformAnimation.duration = 0.5;
  transformAnimation.timingFunction =
  [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
  transformAnimation.removedOnCompletion = NO;
  transformAnimation.fillMode = kCAFillModeForwards;

  CATransform3D xform = CATransform3DIdentity;
  xform.m34 = 1.0 / -500;
  xform = CATransform3DTranslate(xform, 0, 0, -50);
  transformAnimation.toValue = [NSValue valueWithCATransform3D:xform];
  [_bankSelectionView.collectionView.layer addAnimation:transformAnimation forKey:@"transformAnimation"];

  _bankSelectionView.collectionView.layer.opacity = 0;
  CABasicAnimation *alphaAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
  alphaAnimation.duration = 0.5;
  alphaAnimation.timingFunction =
  [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
  alphaAnimation.removedOnCompletion = YES;
  alphaAnimation.fromValue = [NSNumber numberWithFloat:1];
  alphaAnimation.toValue = [NSNumber numberWithFloat:0];
  [_bankSelectionView.collectionView.layer addAnimation:alphaAnimation forKey:@"alphaAnimation"];
  _bankSelectionView.collectionView.userInteractionEnabled = NO;
}

@end
