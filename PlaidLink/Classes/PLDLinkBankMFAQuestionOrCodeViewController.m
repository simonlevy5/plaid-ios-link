//
//  PLDLinkBankMFAQuestionOrCodeViewController.m
//  Plaid
//
//  Created by Simon Levy on 10/20/15.
//  Copyright © 2015 Vouch Financial, Inc. All rights reserved.
//

#import "PLDLinkBankMFAQuestionOrCodeViewController.h"

#import "PLDAuthentication.h"
#import "PLDLinkBankContainerView.h"
#import "PLDLinkBankMFAQuestionOrCodeView.h"

@interface PLDLinkBankMFAQuestionOrCodeViewController ()<PLDLinkBankMFAQuestionOrCodeViewDelegate>
@end

@implementation PLDLinkBankMFAQuestionOrCodeViewController {
  PLDLinkBankMFAQuestionOrCodeView *_view;
}

- (void)loadView {
  _view = [[PLDLinkBankMFAQuestionOrCodeView alloc] initWithFrame:CGRectZero];
  self.view = _view;
}

- (void)viewDidLoad {
  [super viewDidLoad];

  _view.delegate = self;
  if (self.authentication.mfa.type == kPLDMFATypeCode) {
    _view.inputLabel.text = self.authentication.mfa.data;
    _view.inputTextField.placeholder = @"Code";
  } else if (self.authentication.mfa.type == kPLDMFATypeQuestion) {
    _view.inputLabel.text = self.authentication.mfa.data;
    _view.inputTextField.placeholder = @"Answer";
  } else {
    NSAssert(NO, @"Inproper mfa type for PLDLinkBankMFAQuestionOrCodeViewController");
  }
}

#pragma mark - PLDLinkBankMFAInputViewDelegate

- (void)inputView:(UIView *)view didTapSubmitWithResponse:(NSString *)response {
  [self submitMFAStepResponse:response options:nil completion:^(NSError *error) {

  }];
}

@end
