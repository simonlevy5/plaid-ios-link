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
  [self submitMFAStepResponse:choice options:nil completion:^(NSError *error) {
    if (error) {
      UIAlertController *alert =
          [UIAlertController alertControllerWithTitle:[error localizedDescription]
                                              message:[error localizedRecoverySuggestion]
                                       preferredStyle:UIAlertControllerStyleAlert];
      NSString *buttonTitle = [NSString stringWithIdentifier:@"common_ok"];
      UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:buttonTitle
                                                              style:UIAlertActionStyleDefault
                                                            handler:^(UIAlertAction * action) {}];

      [alert addAction:defaultAction];
      [weakSelf presentViewController:alert animated:YES completion:nil];
    }
  }];
}

@end
