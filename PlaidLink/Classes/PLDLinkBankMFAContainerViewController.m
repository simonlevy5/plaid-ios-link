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
#import "PLDLinkBankMFAQuestionOrCodeViewController.h"
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

- (void)viewDidLoad {
  [super viewDidLoad];

  self.title = _institution.name;
  self.navigationItem.backBarButtonItem.action = @selector(didTapBack);
  self.navigationItem.backBarButtonItem.target = self;
  self.edgesForExtendedLayout = UIRectEdgeNone;

  PLDLinkBankLoginViewController *viewController =
      [[PLDLinkBankLoginViewController alloc] initWithInstitution:_institution
                                                          product:_product];
  viewController.delegate = self;
  [self addChildViewController:viewController];
  [_view setCurrentContentView:viewController.view];
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
        [[PLDLinkBankMFAChoiceViewController alloc] initWithAuthentication:authentication
                                                               institution:_institution];
  } else if (mfaType == kPLDMFATypeCode) {
    mfaViewController =
        [[PLDLinkBankMFAQuestionOrCodeViewController alloc] initWithAuthentication:authentication
                                                                       institution:_institution];
  } else if (mfaType == kPLDMFATypeSelection) {
    mfaViewController =
        [[PLDLinkBankMFASelectionsViewController alloc] initWithAuthentication:authentication
                                                                   institution:_institution];
  } else if (mfaType == kPLDMFATypeQuestion) {
    mfaViewController =
        [[PLDLinkBankMFAQuestionOrCodeViewController alloc] initWithAuthentication:authentication
                                                                       institution:_institution];
  } else {
    NSAssert(NO, @"Invalid mfa type");
  }

  mfaViewController.delegate = self;
  [self addChildViewController:mfaViewController];
  [_view setCurrentContentView:mfaViewController.view];
  [mfaViewController didMoveToParentViewController:self];

  if (_currentChildViewController) {
    [_currentChildViewController willMoveToParentViewController:nil];
    [_currentChildViewController removeFromParentViewController];
  }
  _currentChildViewController = mfaViewController;
}

@end
