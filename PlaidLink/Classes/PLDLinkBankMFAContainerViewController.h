//
//  PLDLinkBankMFAContainerViewController.h
//  PlaidLink
//
//  Created by Simon Levy on 10/21/15.
//

#import <UIKit/UIKit.h>

#import <plaid_ios_sdk/PLDDefines.h>

@class PLDAuthentication;
@class PLDInstitution;
@class PLDLinkBankMFAContainerViewController;

@protocol PLDLinkBankMFAContainerViewControllerDelegate <NSObject>

- (void)mfaContainerViewController:(PLDLinkBankMFAContainerViewController *)viewController
       didFinishWithAuthentication:(PLDAuthentication *)authentication;

@end

@interface PLDLinkBankMFAContainerViewController : UIViewController

@property(nonatomic, weak) id<PLDLinkBankMFAContainerViewControllerDelegate> delegate;

@property(nonatomic, copy) NSDictionary *options;

- (instancetype)initWithInstitution:(PLDInstitution *)institution
                            product:(PlaidProduct)product;

@end
