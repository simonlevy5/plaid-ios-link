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

- (void)choiceView:(UIView *)view didSelectChoice:(NSString *)choice {
  NSDictionary *options = @{
    @"send_method" : @{
        @"type" : choice
      }
    };
  [self submitMFAStepResponse:nil options:options completion:^(NSError *error) {
    if (error) {
      UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:[error localizedDescription]
                                                          message:[error localizedRecoverySuggestion]
                                                         delegate:nil
                                                cancelButtonTitle:@"OK"
                                                otherButtonTitles:nil];
      [alertView show];
    }
  }];
}

@end
