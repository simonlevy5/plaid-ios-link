//
//  PLDLinkNavigationViewController.m
//  Plaid
//
//  Created by Simon Levy on 10/14/15.
//  Copyright © 2015 Vouch Financial, Inc. All rights reserved.
//

#import "PLDLinkNavigationViewController.h"

#import "Plaid.h"
#import "PLDInstitution.h"
#import "PLDLinkBankMFAContainerViewController.h"
#import "PLDLinkBankSelectionViewController.h"
#import "PLDLinkFinishedViewController.h"
#import "PLDLinkSelectionToLoginAnimator.h"

@interface PLDLinkNavigationViewController()<UINavigationControllerDelegate,
    PLDLinkBankSelectionViewControllerDelegate, PLDLinkBankMFAContainerViewControllerDelegate,
    PLDLinkFinishedViewControllerDelegate>
@end

@implementation PLDLinkNavigationViewController {
  NSString *_accessToken;
  PLDLinkSelectionToLoginAnimator *_animator;
}

- (void)setEnvironment:(PlaidEnvironment)environment {
  _environment = environment;
  [Plaid sharedInstance].environment = _environment;
}

- (instancetype)initWithEnvironment:(PlaidEnvironment)environment
                            product:(PlaidProduct)product
                          publicKey:(NSString *)publicKey {
  PLDLinkBankSelectionViewController *rootViewController =
      [[PLDLinkBankSelectionViewController alloc] init];
  if (self = [super initWithRootViewController:rootViewController]) {
    rootViewController.delegate = self;
    _environment = environment;
    _product = product;
    _publicKey = publicKey;

    self.delegate = self;
    _animator = [[PLDLinkSelectionToLoginAnimator alloc] init];

    self.navigationBar.translucent = NO;
    [self.navigationBar setTintColor:[UIColor blackColor]];
    [self.navigationBar setShadowImage:[UIImage new]];
    [self.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    [self.navigationBar setTitleTextAttributes:
        @{NSFontAttributeName:[UIFont systemFontOfSize:20 weight:UIFontWeightLight]}];
  }
  return self;
}

#pragma mark - PLDLinkBankSelectionViewControllerDelegate

- (void)bankSelectionViewController:(PLDLinkBankSelectionViewController *)viewController
           didFinishWithInstitution:(PLDInstitution *)institution {
  PLDLinkBankMFAContainerViewController *nextViewController =
      [[PLDLinkBankMFAContainerViewController alloc] initWithInstitution:institution
                                                                 product:_product];
  nextViewController.delegate = self;
  [self pushViewController:nextViewController animated:YES];
}

#pragma mark - PLDLinkBankMFAContainerViewControllerDelegate

- (void)mfaContainerViewController:(PLDLinkBankMFAContainerViewController *)viewController
       didFinishWithAuthentication:(PLDAuthentication *)authentication {
  _accessToken = authentication.accessToken;
  [self presentFinishedViewController];
}

#pragma mark - PLDLinkFinishedViewControllerDelegate

- (void)finishedViewControllerDidFinish:(PLDLinkFinishedViewController *)viewController {
  [_linkDelegate linkNavigationContoller:self didFinishWithAccessToken:_accessToken];
}

#pragma mark - UINavigationControllerDelegate

- (id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController
                                  animationControllerForOperation:(UINavigationControllerOperation)operation
                                               fromViewController:(UIViewController *)fromVC
                                                 toViewController:(UIViewController *)toVC {
  if ([fromVC isMemberOfClass:[PLDLinkBankSelectionViewController class]] ||
      [toVC isMemberOfClass:[PLDLinkBankSelectionViewController class]]) {
    _animator.reverse = operation == UINavigationControllerOperationPop;
    return _animator;
  }
  return nil;
}


#pragma mark - Private

- (void)presentFinishedViewController {
  self.navigationItem.hidesBackButton = YES;

  PLDLinkFinishedViewController *nextViewController = [[PLDLinkFinishedViewController alloc] init];
  nextViewController.delegate = self;
  [self pushViewController:nextViewController animated:YES];
}

@end
