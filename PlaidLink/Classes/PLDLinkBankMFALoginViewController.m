//
//  PLDLinkBankLoginViewController.m
//  PlaidLink
//
//  Created by Simon Levy on 10/14/15.
//

#import "PLDLinkBankMFALoginViewController.h"

#import "Plaid.h"
#import "PLDAuthentication.h"
#import "PLDInstitution.h"

#import "PLDLinkBankMFALoginView.h"
#import "PLDLinkStyledButton.h"
#import "NSString+Localization.h"

@implementation PLDLinkBankMFALoginViewController {
  PLDInstitution *_institution;
  PlaidProduct _product;
  NSMutableDictionary *_options;
  PLDLinkBankMFALoginView *_view;
}

- (instancetype)initWithInstitution:(PLDInstitution *)institution
                            product:(PlaidProduct)product {
  if (self = [super init]) {
    _institution = institution;
    _product = product;
    _options = [NSMutableDictionary new];
  }
  return self;
}

- (instancetype)initWithInstitution:(PLDInstitution *)institution
                            product:(PlaidProduct)product
                            options:(NSMutableDictionary *)options{
  if (self = [super init]) {
    _institution = institution;
    _product = product;
    _options = options;
  }
  return self;
}

- (void)loadView {
  _view = [[PLDLinkBankMFALoginView alloc] initWithFrame:CGRectZero
                                            tintColor:_institution.backgroundColor];
  _view.isPinRequired = [_institution.type isEqualToString:@"usaa"];
  self.view = _view;
}

- (void)viewDidLoad {
  [super viewDidLoad];

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
  
  _options[@"list"] = @(YES);

  __weak PLDLinkBankMFALoginViewController *weakSelf = self;
  __weak PLDLinkBankMFALoginView *weakView = _view;
  [[Plaid sharedInstance] addLinkUserForProduct:_product
                                       username:_view.usernameTextField.text
                                       password:_view.passwordTextField.text
                                            pin:_view.pinTextField.text
                                           type:_institution.type
                                        options:_options
                                     completion:^(PLDAuthentication *authentication, id response, NSError *error) {
    if (error && weakSelf) {
      [weakView showErrorWithTitle:[error localizedDescription]
                       description:[error localizedFailureReason]
                        buttonCopy:[error localizedRecoverySuggestion]];
      [weakView.submitButton hideLoadingState];
      return;
    }
    [weakSelf.delegate loginViewController:self didFinishWithAuthentication:authentication];
  }];
}

@end
