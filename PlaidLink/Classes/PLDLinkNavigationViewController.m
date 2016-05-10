//
//  PLDLinkNavigationViewController.m
//  PlaidLink
//
//  Created by Simon Levy on 10/14/15.
//

#import "PLDLinkNavigationViewController.h"

#import "Plaid.h"
#import "PLDInstitution.h"

#import "PLDLinkBankMFAContainerViewController.h"
#import "PLDLinkBankSelectionViewController.h"
#import "PLDLinkSelectionToLoginAnimator.h"
#import "NSString+Localization.h"

@interface PLDLinkNavigationViewController()<UINavigationControllerDelegate,
    PLDLinkBankSelectionViewControllerDelegate, PLDLinkBankMFAContainerViewControllerDelegate>
@end

@implementation PLDLinkNavigationViewController {
  UIVisualEffectView *_bgBlurView;
  PLDLinkSelectionToLoginAnimator *_animator;
}

- (void)setEnvironment:(PlaidEnvironment)environment {
  _environment = environment;
  [Plaid sharedInstance].environment = _environment;
}

- (instancetype)initWithEnvironment:(PlaidEnvironment)environment
                            product:(PlaidProduct)product {
  PLDLinkBankSelectionViewController *rootViewController =
      [[PLDLinkBankSelectionViewController alloc] initWithProduct:product];
  if (self = [super initWithRootViewController:rootViewController]) {
    rootViewController.delegate = self;
    rootViewController.title = [NSString stringWithIdentifier:@"bank_selection_title"];

    _environment = environment;
    _product = product;
    _animator = [[PLDLinkSelectionToLoginAnimator alloc] init];

    self.delegate = self;
    
    _options = [[NSDictionary alloc] init];
    
    UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleExtraLight];
    _bgBlurView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
    [self.view insertSubview:_bgBlurView atIndex:0];

    [self.navigationBar setTranslucent:YES];
    [self.navigationBar setTintColor:[UIColor blackColor]];
    [self.navigationBar setShadowImage:[UIImage new]];
    [self.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    [self.navigationBar setTitleTextAttributes:
        @{NSFontAttributeName:[UIFont systemFontOfSize:20 weight:UIFontWeightLight]}];
  }
  return self;
}

- (void)viewDidLayoutSubviews {
  _bgBlurView.frame = self.view.frame;
}

#pragma mark - PLDLinkBankSelectionViewControllerDelegate

- (void)bankSelectionViewController:(PLDLinkBankSelectionViewController *)viewController
           didFinishWithInstitution:(PLDInstitution *)institution {
  PLDLinkBankMFAContainerViewController *nextViewController =
    [[PLDLinkBankMFAContainerViewController alloc] initWithInstitution:institution
                                                               product:_product];

  nextViewController.delegate = self;
  nextViewController.options = _options;
  [self pushViewController:nextViewController animated:YES];
}

- (void)bankSelectionViewControllerCancelled:(PLDLinkBankSelectionViewController *)viewController {
  [_linkDelegate linkNavigationControllerDidCancel:self];
}

- (void)bankSelectionViewControllerDidFinishWithBankNotListed:(PLDLinkBankSelectionViewController *)viewController {
  [_linkDelegate linkNavigationControllerDidFinishWithBankNotListed:self];
}

#pragma mark - PLDLinkBankMFAContainerViewControllerDelegate

- (void)mfaContainerViewController:(PLDLinkBankMFAContainerViewController *)viewController
       didFinishWithAuthentication:(PLDAuthentication *)authentication {
  [_linkDelegate linkNavigationContoller:self
                didFinishWithAccessToken:authentication.accessToken];
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

@end
