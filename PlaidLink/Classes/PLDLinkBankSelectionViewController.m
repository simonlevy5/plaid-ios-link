//
//  PLDLinkBankSelectionViewController.m
//  Plaid
//
//  Created by Simon Levy on 10/13/15.
//  Copyright © 2015 Vouch Financial, Inc. All rights reserved.
//

#import <QuartzCore/CALayer.h>

#import "PLDLinkBankSelectionViewController.h"

#import "Plaid.h"
#import "PLDLinkBankSelectionSearchResultsViewController.h"
#import "PLDLinkBankMFALoginView.h"
#import "PLDLinkBankSelectionView.h"

@interface PLDLinkBankSelectionViewController ()<PLDLinkBankSelectionViewDelegate,
    PLDLinkBankSelectionSearchResultsViewControllerDelegate, UISearchResultsUpdating>
@end

@implementation PLDLinkBankSelectionViewController {
  PLDLinkBankSelectionView *_bankSelectionView;
  PlaidProduct _product;
  UISearchController *_searchController;
  PLDLinkBankSelectionSearchResultsViewController *_searchResultsController;
}

- (instancetype)initWithProduct:(PlaidProduct)product {
  if (self = [super init]) {
    _product = product;
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

  UIBarButtonItem *closeButton =
      [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemStop
                                                    target:self
                                                    action:@selector(didTapCancel)];
  self.navigationItem.rightBarButtonItem = closeButton;

  [[Plaid sharedInstance] getInstitutionsWithCompletion:^(id response, NSError *error) {
    NSMutableArray *institutions = [NSMutableArray arrayWithArray:response];
    if (_product == PlaidProductConnect) {
      [institutions addObject:@"searchCell"];
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
  self.title = @"Select your bank";
  if (_bankSelectionView.institutions.count == 0) {
    [_bankSelectionView showLoading];
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
  [self presentViewController:_searchController animated:YES completion:nil];
}

#pragma mark - PLDLinkBankSelectionSearchResultsViewControllerDelegate

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
                                            scrollPosition:UICollectionViewScrollPositionBottom];
  [viewController dismissViewControllerAnimated:YES completion:^{
    [_delegate bankSelectionViewController:self didFinishWithInstitution:institution];
  }];
}

@end
