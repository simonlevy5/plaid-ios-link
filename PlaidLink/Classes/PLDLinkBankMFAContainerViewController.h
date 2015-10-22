//
//  PLDLinkBankMFAContainerViewController.h
//  Plaid
//
//  Created by Simon Levy on 10/21/15.
//  Copyright © 2015 Vouch Financial, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "PLDDefines.h"

@class PLDAuthentication;
@class PLDInstitution;
@class PLDLinkBankMFAContainerViewController;

@protocol PLDLinkBankMFAContainerViewControllerDelegate <NSObject>

- (void)mfaContainerViewController:(PLDLinkBankMFAContainerViewController *)viewController
       didFinishWithAuthentication:(PLDAuthentication *)authentication;

@end

@interface PLDLinkBankMFAContainerViewController : UIViewController

@property(nonatomic, weak) id<PLDLinkBankMFAContainerViewControllerDelegate> delegate;

- (instancetype)initWithInstitution:(PLDInstitution *)institution product:(PlaidProduct)product;

@end
