//
//  PLDLinkBankMFAChoiceViewController.m
//  PlaidLink
//
//  Created by Simon Levy on 10/20/15.
//

#import "PLDLinkBankMFAChoiceViewController.h"

#import "PLDAuthentication.h"
#import "PLDInstitution.h"

#import "PLDLinkBankMFAContainerView.h"
#import "PLDLinkBankMFAChoiceView.h"
#import "NSString+Localization.h"

@interface PLDLinkBankMFAChoiceViewController ()<PLDLinkBankMFAChoiceViewDelegate>
@end

@implementation PLDLinkBankMFAChoiceViewController {
  PLDLinkBankMFAChoiceView *_view;
}

- (void)loadView {
  _view = [[PLDLinkBankMFAChoiceView alloc] initWithFrame:CGRectZero
                                                tintColor:self.institution.backgroundColor];
  _view.choices = self.authentication.mfa.data;
  _view.delegate = self;
  self.view = _view;
}

- (void)viewDidLoad {
  [super viewDidLoad];
}

#pragma mark - PLDLinkBankMFAChoiceViewDelegate

- (void)choiceView:(UIView *)view didSelectChoice:(id)choice {
  __weak PLDLinkBankMFAChoiceViewController *weakSelf = self;
  __weak PLDLinkBankMFAChoiceView *weakView = _view;
  [self submitMFAStepResponse:choice options:nil completion:^(NSError *error) {
    if (error && weakSelf) {
      [weakView showErrorWithTitle:[error localizedDescription]
                       description:[error localizedFailureReason]
                        buttonCopy:[error localizedRecoverySuggestion]];
    }
  }];
}

@end
