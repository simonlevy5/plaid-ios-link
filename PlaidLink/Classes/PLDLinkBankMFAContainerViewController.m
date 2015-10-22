//
//  PLDLinkBankMFAContainerViewController.m
//  Plaid
//
//  Created by Simon Levy on 10/21/15.
//  Copyright © 2015 Vouch Financial, Inc. All rights reserved.
//

#import "PLDLinkBankMFAContainerViewController.h"

#import "PLDAuthentication.h"
#import "PLDInstitution.h"
#import "PLDLinkBankLoginViewController.h"
#import "PLDLinkBankContainerView.h"
#import "PLDLinkBankMFAViewController.h"
#import "PLDLinkBankMFAChoiceViewController.h"
#import "PLDLinkBankMFAInputViewController.h"
#import "PLDLinkBankMFASelectionsViewController.h"

@interface PLDLinkBankMFAContainerViewController ()<PLDLinkBankLoginViewControllerDelegate,
    PLDLinkBankMFAViewControllerDelegate>
@end

@implementation PLDLinkBankMFAContainerViewController {
  UIViewController *_currentChildViewController;
  PLDLinkBankContainerView *_view;

  PLDInstitution *_institution;
  PlaidProduct _product;
}

- (instancetype)initWithInstitution:(PLDInstitution *)institution product:(PlaidProduct)product {
  if (self = [super init]) {
    _institution = institution;
    _product = product;
  }
  return self;
}

- (void)loadView {
  _view = [[PLDLinkBankContainerView alloc] initWithFrame:CGRectZero];
  self.view = _view;
}

- (void)viewDidLayoutSubviews {
  [super viewDidLayoutSubviews];

  self.childViewControllers.firstObject.view.frame = _view.contentContainer.bounds;
}

- (void)viewDidLoad {
  [super viewDidLoad];

  self.title = _institution.name;
//  _view.contentContainer.backgroundColor = _institution.backgroundColor;
  self.navigationItem.backBarButtonItem.action = @selector(didTapBack);
  self.navigationItem.backBarButtonItem.target = self;

  PLDLinkBankLoginViewController *viewController =
      [[PLDLinkBankLoginViewController alloc] initWithInstitution:_institution
                                                          product:_product];
  viewController.delegate = self;
  [self addChildViewController:viewController];
  viewController.view.frame = _view.contentContainer.bounds;
  [_view.contentContainer addSubview:viewController.view];
  [viewController didMoveToParentViewController:self];
  _currentChildViewController = viewController;
}

#pragma mark - PLDLinkBankLoginViewControllerDelegate

- (void)loginViewController:(PLDLinkBankLoginViewController *)loginViewController
    didFinishWithAuthentication:(PLDAuthentication *)authentication {
  if (authentication.mfa) {
    [self displayNextMFAStepWithAuthentication:authentication];
    return;
  }

  [_delegate mfaContainerViewController:self didFinishWithAuthentication:authentication];
}

#pragma mark - PLDLinkBankMFAViewControllerDelegate

- (void)bankMFAViewController:(PLDLinkBankMFAViewController *)viewController
  didFinishWithAuthentication:(PLDAuthentication *)authentication {
  if (authentication.mfa) {
    [self displayNextMFAStepWithAuthentication:authentication];
    return;
  }

  [_delegate mfaContainerViewController:self didFinishWithAuthentication:authentication];
}

#pragma mark - Private

- (void)didTapBack {
  [self.navigationController popViewControllerAnimated:YES];
}

- (void)displayNextMFAStepWithAuthentication:(PLDAuthentication *)authentication {
  PLDMFAType mfaType = authentication.mfa.type;
  PLDLinkBankMFAViewController *mfaViewController = nil;
  if (mfaType == kPLDMFATypeList) {
    mfaViewController =
        [[PLDLinkBankMFAChoiceViewController alloc] initWithAuthentication:authentication];
  } else if (mfaType == kPLDMFATypeCode) {
    mfaViewController =
        [[PLDLinkBankMFAInputViewController alloc] initWithAuthentication:authentication];
  } else if (mfaType == kPLDMFATypeSelection) {
    mfaViewController =
        [[PLDLinkBankMFASelectionsViewController alloc] initWithAuthentication:authentication];
  } else if (mfaType == kPLDMFATypeQuestion) {
    mfaViewController =
        [[PLDLinkBankMFAInputViewController alloc] initWithAuthentication:authentication];
  } else {
    NSAssert(NO, @"Invalid mfa type");
  }

  mfaViewController.delegate = self;
  [self addChildViewController:mfaViewController];
  mfaViewController.view.frame = _view.contentContainer.bounds;
  [_view.contentContainer addSubview:mfaViewController.view];
  [mfaViewController didMoveToParentViewController:self];

  if (_currentChildViewController) {
    [_currentChildViewController willMoveToParentViewController:nil];
    [_currentChildViewController.view removeFromSuperview];
    [_currentChildViewController removeFromParentViewController];
  }
  _currentChildViewController = mfaViewController;
}

@end
