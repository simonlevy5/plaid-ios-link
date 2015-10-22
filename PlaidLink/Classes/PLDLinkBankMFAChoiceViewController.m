//
//  PLDLinkBankMFAChoiceViewController.m
//  Plaid
//
//  Created by Simon Levy on 10/20/15.
//  Copyright © 2015 Vouch Financial, Inc. All rights reserved.
//

#import "PLDLinkBankMFAChoiceViewController.h"

#import "PLDAuthentication.h"
#import "PLDLinkBankContainerView.h"
#import "PLDLinkBankMFAChoiceView.h"

@interface PLDLinkBankMFAChoiceViewController ()<PLDLinkBankMFAChoiceViewDelegate>
@end

@implementation PLDLinkBankMFAChoiceViewController {
  PLDLinkBankMFAChoiceView *_view;
}

- (void)loadView {
  _view = [[PLDLinkBankMFAChoiceView alloc] initWithFrame:CGRectZero];
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
    
  }];
}

@end
