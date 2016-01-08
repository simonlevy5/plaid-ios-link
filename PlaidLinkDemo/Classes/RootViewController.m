//
//  RootViewController.m
//  PlaidLink
//
//  Created by Andres Ugarte on 10/22/15.
//

#import "RootViewController.h"

#import "PLDLinkNavigationViewController.h"

@interface RootViewController ()<PLDLinkNavigationControllerDelegate>

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@end

@implementation RootViewController

- (IBAction)didTapConnect:(id)sender {
  PLDLinkNavigationViewController *plaidLink =
      [[PLDLinkNavigationViewController alloc] initWithEnvironment:PlaidEnvironmentTartan
                                                           product:PlaidProductConnect];

  plaidLink.linkDelegate = self;
  plaidLink.providesPresentationContextTransitionStyle = YES;
  plaidLink.definesPresentationContext = YES;
  plaidLink.modalPresentationStyle = UIModalPresentationCustom;

  [self presentViewController:plaidLink animated:YES completion:nil];
}

#pragma mark - PLDLinkNavigationControllerDelegate

- (void)linkNavigationContoller:(PLDLinkNavigationViewController *)navigationController
       didFinishWithAccessToken:(NSString *)accessToken {
  _titleLabel.text = @"Success!";
  [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)linkNavigationControllerDidFinishWithBankNotListed:(PLDLinkNavigationViewController *)navigationController {
  _titleLabel.text = @"Manually enter bank info?";
  [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)linkNavigationControllerDidCancel:(PLDLinkNavigationViewController *)navigationController {
  [self dismissViewControllerAnimated:YES completion:nil];
}

@end
