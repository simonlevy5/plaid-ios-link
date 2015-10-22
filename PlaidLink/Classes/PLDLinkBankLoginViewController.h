//
//  PLDLinkBankLoginViewController.h
//  Plaid
//
//  Created by Simon Levy on 10/14/15.
//  Copyright © 2015 Vouch Financial, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "PLDDefines.h"

@class PLDAuthentication;
@class PLDLinkBankLoginViewController;
@class PLDInstitution;

@protocol PLDLinkBankLoginViewControllerDelegate <NSObject>

- (void)loginViewController:(PLDLinkBankLoginViewController *)loginViewController
    didFinishWithAuthentication:(PLDAuthentication *)authentication;

@end

@interface PLDLinkBankLoginViewController : UIViewController

@property(nonatomic, weak) id<PLDLinkBankLoginViewControllerDelegate> delegate;

- (instancetype)initWithInstitution:(PLDInstitution *)institution
                            product:(PlaidProduct)product;

@end
