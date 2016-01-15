//
//  PLDLinkBankMFAQuestionOrCodeViewController.m
//  PlaidLink
//
//  Created by Simon Levy on 10/20/15.
//

#import "PLDLinkBankMFAQuestionOrCodeViewController.h"

#import "PLDAuthentication.h"
#import "PLDInstitution.h"

#import "PLDLinkBankMFAContainerView.h"
#import "PLDLinkBankMFAQuestionOrCodeView.h"
#import "PLDLinkStyledButton.h"
#import "PLDLinkBankMFAExplainerView.h"
#import "NSString+Localization.h"

@interface PLDLinkBankMFAQuestionOrCodeViewController ()<PLDLinkBankMFAQuestionOrCodeViewDelegate>
@end

@implementation PLDLinkBankMFAQuestionOrCodeViewController {
  PLDLinkBankMFAQuestionOrCodeView *_view;
}

- (void)loadView {
  _view = [[PLDLinkBankMFAQuestionOrCodeView alloc] initWithFrame:CGRectZero
                                                        tintColor:self.institution.backgroundColor];
  self.view = _view;
}

- (void)viewDidLoad {
  [super viewDidLoad];

  _view.delegate = self;
  if (self.authentication.mfa.type == kPLDMFATypeCode) {
    _view.inputLabel.text = self.authentication.mfa.data;
    _view.inputTextField.placeholder = [NSString stringWithIdentifier:@"mfa_code_placeholder"];
    _view.explainer.explainerText = [NSString stringWithIdentifier:@"mfa_code_explainer"];
  } else if (self.authentication.mfa.type == kPLDMFATypeQuestion) {
    _view.inputLabel.text = self.authentication.mfa.data;
    _view.inputTextField.placeholder = [NSString stringWithIdentifier:@"mfa_questions_placeholder"];
    _view.explainer.explainerText = [NSString stringWithIdentifier:@"mfa_questions_explainer"];
  } else {
    NSAssert(NO, @"Incorrect mfa type for PLDLinkBankMFAQuestionOrCodeViewController");
  }
}

#pragma mark - PLDLinkBankMFAInputViewDelegate

- (void)inputView:(UIView *)view didTapSubmitWithResponse:(NSString *)response {
  [_view.submitButton showLoadingState];
  __weak PLDLinkBankMFAQuestionOrCodeViewController *weakSelf = self;
  __weak PLDLinkBankMFAQuestionOrCodeView *weakView = _view;
  [self submitMFAStepResponse:response options:nil completion:^(NSError *error) {
    if (error && weakSelf) {
      [weakView showErrorWithTitle:[error localizedDescription]
                       description:[error localizedFailureReason]
                        buttonCopy:[error localizedRecoverySuggestion]];
      [weakView.submitButton hideLoadingState];
    }
  }];
}

@end
