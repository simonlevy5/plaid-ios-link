//
//  PLDLinkBankMFASelectionsViewController.m
//  Plaid
//
//  Created by Simon Levy on 10/20/15.
//  Copyright © 2015 Vouch Financial, Inc. All rights reserved.
//

#import "PLDLinkBankMFASelectionsViewController.h"

#import "PLDAuthentication.h"
#import "PLDLinkBankMFASelectionViewController.h"

@interface PLDLinkBankMFASelectionsViewController ()<PLDLinkBankMFASelectionViewControllerDelegate>
@end

@implementation PLDLinkBankMFASelectionsViewController {
  NSMutableArray *_answers;
  NSArray *_selections;
}

- (instancetype)initWithAuthentication:(PLDAuthentication *)authentication {
  if (self = [super initWithAuthentication:authentication]) {
    _answers = [NSMutableArray array];
    _selections = authentication.mfa.data;
    for (PLDMFAAuthenticationSelection *selection in _selections) {
      PLDLinkBankMFASelectionViewController *selectionViewController =
          [[PLDLinkBankMFASelectionViewController alloc] initWithAuthenticationSelection:selection];
      selectionViewController.delegate = self;
      [self addChildViewController:selectionViewController];
    }
  }
  return self;
}

- (void)loadView {
  self.view = [[UIView alloc] initWithFrame:CGRectZero];
}

- (void)viewDidLayoutSubviews {
  [super viewDidLayoutSubviews];

  // Assign to bounds since this is child within a child.
  [self currentChildViewController].view.frame = self.view.bounds;
}

- (void)viewDidLoad {
  [super viewDidLoad];

  UIViewController *viewController = [self currentChildViewController];
  [self.view addSubview:viewController.view];
  [viewController didMoveToParentViewController:self];
}

#pragma mark - PLDLinkBankMFASelectionViewControllerDelegate

- (UIViewController *)currentChildViewController {
  return [self.childViewControllers firstObject];
}

- (void)selectionViewController:(PLDLinkBankMFASelectionViewController *)viewController
                didChooseAnswer:(NSString *)answer {
  [_answers addObject:answer];
  if ([_answers count] < [_selections count]) {
    [self showNextViewController];
    return;
  }
  [self submitMFAStepResponse:_answers options:nil completion:^(NSError *error) {
    
  }];
}

- (void)showNextViewController {
  UIViewController *currentViewController = [self currentChildViewController];
  [currentViewController.view removeFromSuperview];
  [currentViewController removeFromParentViewController];
  currentViewController = [self currentChildViewController];
  [self.view addSubview:currentViewController.view];
  [currentViewController didMoveToParentViewController:self];
}

@end
