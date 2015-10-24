//
//  PLDLinkBankMFAViewController.m
//  Plaid
//
//  Created by Simon Levy on 10/14/15.
//  Copyright © 2015 Vouch Financial, Inc. All rights reserved.
//

#import "PLDLinkBankMFAViewController.h"

#import "Plaid.h"
#import "PLDAuthentication.h"
#import "PLDLinkBankContainerView.h"
#import "PLDLinkBankMFAChoiceViewController.h"
#import "PLDLinkBankMFAQuestionOrCodeViewController.h"
#import "PLDLinkBankMFASelectionsViewController.h"

@interface PLDLinkBankMFAViewController ()<PLDLinkBankMFAViewControllerDelegate>
@end

@implementation PLDLinkBankMFAViewController {
  PLDLinkBankContainerView *_view;
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
  _view = [[PLDLinkBankContainerView alloc] initWithFrame:CGRectZero];
  self.view = _view;
}

- (void)viewDidLayoutSubviews {
  [super viewDidLayoutSubviews];

  self.childViewControllers.firstObject.view.frame = _view.contentContainer.frame;
}

#pragma mark - PLDLinkBankMFAViewControllerDelegate

- (void)bankMFAViewController:(PLDLinkBankMFAViewController *)viewController
    didFinishWithAuthentication:(PLDAuthentication *)authentication {
  if (authentication.mfa) {
    
    return;
  }
  
}

#pragma mark - Protected

- (void)submitMFAStepResponse:(id)response
                      options:(NSDictionary *)options
                   completion:(void (^)(NSError *))completion {
  [[Plaid sharedInstance] stepUserForProduct:_authentication.product
                                 accessToken:_authentication.accessToken
                                 mfaResponse:response
                                     options:options
                                  completion:^(PLDAuthentication *authentication, id response, NSError *error) {
                                    if (error) {
                                      NSLog(@"Error stepping user: %@", error);
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
    mfaViewController = [[PLDLinkBankMFAChoiceViewController alloc] initWithAuthentication:_authentication
                                                                               institution:_institution];
  } else if (mfaType == kPLDMFATypeCode) {
    mfaViewController = [[PLDLinkBankMFAQuestionOrCodeViewController alloc] initWithAuthentication:_authentication
                                                                                       institution:_institution];
  } else if (mfaType == kPLDMFATypeSelection) {
    mfaViewController = [[PLDLinkBankMFASelectionsViewController alloc] initWithAuthentication:_authentication
                                                                                   institution:_institution];
  } else if (mfaType == kPLDMFATypeQuestion) {
    mfaViewController = [[PLDLinkBankMFAQuestionOrCodeViewController alloc] initWithAuthentication:_authentication
                                                                                       institution:_institution];
  } else {
    NSAssert(NO, @"Invalid mfa type");
  }
}

@end
