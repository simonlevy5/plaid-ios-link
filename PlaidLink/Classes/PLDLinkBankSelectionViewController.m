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
#import "PLDInstitution.h"

#import "PLDLinkBankLoginView.h"
#import "PLDLinkBankSelectionView.h"

@interface PLDLinkBankSelectionViewController ()<PLDLinkBankSelectionViewDelegate>
@end

@implementation PLDLinkBankSelectionViewController {
  PLDLinkBankSelectionView *_bankSelectionView;
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
    _bankSelectionView.institutions = response;
  }];
}

- (void)viewWillAppear:(BOOL)animated {
  [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithWhite:0.96 alpha:1]];
  [self.navigationController.navigationBar setBarStyle:UIBarStyleDefault];
}

- (void)viewDidAppear:(BOOL)animated {
  self.title = @"Select your bank";
  if (_bankSelectionView.institutions.count == 0) {
    [_bankSelectionView showLoading];
  }
}

- (void)viewWillDisappear:(BOOL)animated {
  self.title = @"";
}

- (void)didTapCancel {
  [_delegate bankSelectionViewControllerCancelled:self];
}

#pragma mark - PLDLinkBankSelectionViewDelegate

- (void)bankSelectionView:(PLDLinkBankSelectionView *)view
     didSelectInstitution:(PLDInstitution *)institution {
  [_delegate bankSelectionViewController:self didFinishWithInstitution:institution];
}

@end
