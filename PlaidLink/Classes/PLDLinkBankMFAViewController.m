//
//  PLDLinkBankMFAViewController.m
//  PlaidLink
//
//  Created by Simon Levy on 10/14/15.
//

#import "PLDLinkBankMFAViewController.h"

#import "Plaid.h"
#import "PLDLinkBankMFAContainerView.h"
#import "PLDLinkBankMFAChoiceViewController.h"
#import "PLDLinkBankMFAQuestionOrCodeViewController.h"
#import "PLDLinkBankMFASelectionsViewController.h"

@interface PLDLinkBankMFAViewController ()
@end

@implementation PLDLinkBankMFAViewController {
  PLDLinkBankMFAContainerView *_view;
}

- (instancetype)initWithAuthentication:(PLDAuthentication *)authentication
                           institution:(PLDInstitution *)institution {
  if (self = [super init]) {
    _authentication = authentication;
    _institution = institution;
  }
  return self;
}

- (void)loadView {
  _view = [[PLDLinkBankMFAContainerView alloc] initWithFrame:CGRectZero];
  self.view = _view;
}

#pragma mark - Protected

- (void)submitMFAStepResponse:(id)response
                      options:(NSDictionary *)options
                   completion:(void (^)(NSError *))completion {
  [[Plaid sharedInstance] stepLinkUserForProduct:_authentication.product
                                     publicToken:_authentication.accessToken
                                     mfaResponse:response
                                         options:options
                                      completion:^(PLDAuthentication *authentication, id response, NSError *error) {
    if (error) {
      completion(error);
      return;
    }

    completion(nil);
    [_delegate bankMFAViewController:self
         didFinishWithAuthentication:authentication];
  }];
}

#pragma mark - Private

- (void)displayNextMFAStep {
  PLDMFAType mfaType = _authentication.mfa.type;
  PLDLinkBankMFAViewController *mfaViewController = nil;
  if (mfaType == kPLDMFATypeList) {
    mfaViewController =
        [[PLDLinkBankMFAChoiceViewController alloc] initWithAuthentication:_authentication
                                                               institution:_institution];
  } else if (mfaType == kPLDMFATypeCode) {
    mfaViewController =
        [[PLDLinkBankMFAQuestionOrCodeViewController alloc] initWithAuthentication:_authentication
                                                                       institution:_institution];
  } else if (mfaType == kPLDMFATypeSelection) {
    mfaViewController =
        [[PLDLinkBankMFASelectionsViewController alloc] initWithAuthentication:_authentication
                                                                   institution:_institution];
  } else if (mfaType == kPLDMFATypeQuestion) {
    mfaViewController =
        [[PLDLinkBankMFAQuestionOrCodeViewController alloc] initWithAuthentication:_authentication
                                                                       institution:_institution];
  } else {
    NSAssert(NO, @"Invalid mfa type");
  }
}

@end
