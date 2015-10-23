//
//  PLDLinkBankLoginViewController.m
//  Plaid
//
//  Created by Simon Levy on 10/14/15.
//  Copyright © 2015 Vouch Financial, Inc. All rights reserved.
//

#import "PLDLinkBankLoginViewController.h"

#import "Plaid.h"
#import "PLDAuthentication.h"
#import "PLDLinkBankLoginView.h"
#import "PLDInstitution.h"

@implementation PLDLinkBankLoginViewController {
  PLDInstitution *_institution;
  PlaidProduct _product;
  PLDLinkBankLoginView *_view;
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
  _view = [[PLDLinkBankLoginView alloc] initWithFrame:CGRectZero
                                            tintColor:_institution.backgroundColor];
  self.view = _view;
}

- (void)viewDidLoad {
  [super viewDidLoad];

  self.edgesForExtendedLayout = UIRectEdgeNone;
  _view.usernameTextField.text = @"plaid_test";
  _view.passwordTextField.text = @"plaid_good";
  [_view.submitButton addTarget:self
                         action:@selector(didTapSubmit)
               forControlEvents:UIControlEventTouchUpInside];
}

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  [self setEdgesForExtendedLayout:UIRectEdgeBottom];
}

- (void)viewDidAppear:(BOOL)animated {
  [_view.usernameTextField becomeFirstResponder];
}

#pragma mark - Private

- (void)didTapSubmit {
  [self.view endEditing:YES];
  NSDictionary *options = @{
      @"list" : @(YES)
  };
  [[Plaid sharedInstance] addUserForProduct:_product
                                   username:_view.usernameTextField.text
                                   password:_view.passwordTextField.text
                                       type:_institution.type
                                    options:options
                                 completion:^(PLDAuthentication *authentication, id response, NSError *error) {
                                   if (error) {
                                     NSLog(@"Error adding user: %@", error);
                                     return;
                                   }
                                   
                                   [_delegate loginViewController:self
                                      didFinishWithAuthentication:authentication];
                                 }];
}

@end
