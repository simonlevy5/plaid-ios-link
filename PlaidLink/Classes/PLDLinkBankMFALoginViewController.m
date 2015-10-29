//
//  PLDLinkBankLoginViewController.m
//  Plaid
//
//  Created by Simon Levy on 10/14/15.
//  Copyright © 2015 Vouch Financial, Inc. All rights reserved.
//

#import "PLDLinkBankMFALoginViewController.h"

#import "Plaid.h"
#import "PLDAuthentication.h"
#import "PLDInstitution.h"
#import "PLDLinkBankMFALoginView.h"
#import "PLDLinkStyledButton.h"

@implementation PLDLinkBankMFALoginViewController {
  PLDInstitution *_institution;
  PlaidProduct _product;
  PLDLinkBankMFALoginView *_view;
}

- (instancetype)initWithInstitution:(PLDInstitution *)institution
                            product:(PlaidProduct)product {
  if (self = [super init]) {
    _institution = institution;
    _product = product;
  }
  return self;
}

- (void)loadView {
  _view = [[PLDLinkBankMFALoginView alloc] initWithFrame:CGRectZero
                                            tintColor:_institution.backgroundColor];
  self.view = _view;
}

- (void)viewDidLoad {
  [super viewDidLoad];

  _view.usernameTextField.text = @"plaid_test";
  _view.passwordTextField.text = @"plaid_good";
  [_view.submitButton addTarget:self
                         action:@selector(didTapSubmit)
               forControlEvents:UIControlEventTouchUpInside];
}

- (void)viewDidAppear:(BOOL)animated {
  [_view.usernameTextField becomeFirstResponder];
}

#pragma mark - Private

- (void)didTapSubmit {
  [_view.submitButton showLoadingState];
  [self.view endEditing:YES];
  NSDictionary *options = @{
      @"list" : @(YES)
  };
  __weak PLDLinkBankMFALoginViewController *weakSelf = self;
  __weak PLDLinkBankMFALoginView *weakView = _view;
  [[Plaid sharedInstance] addUserForProduct:_product
                                   username:_view.usernameTextField.text
                                   password:_view.passwordTextField.text
                                       type:_institution.type
                                    options:options
                                 completion:^(PLDAuthentication *authentication, id response, NSError *error) {
    if (error && weakSelf) {
     [weakView.submitButton hideLoadingState];
     UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Invalid credentials"
                                                         message:[error localizedRecoverySuggestion]
                                                        delegate:nil
                                               cancelButtonTitle:@"OK"
                                               otherButtonTitles:nil];
     [alertView show];
     return;
    }
    [weakSelf.delegate loginViewController:self didFinishWithAuthentication:authentication];
  }];
}

@end
