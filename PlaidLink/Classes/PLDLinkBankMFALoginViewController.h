//
//  PLDLinkBankLoginViewController.h
//  PlaidLink
//
//  Created by Simon Levy on 10/14/15.
//

#import <UIKit/UIKit.h>

#import <plaid_ios_sdk/PLDDefines.h>

@class PLDAuthentication;
@class PLDLinkBankMFALoginViewController;
@class PLDInstitution;

@protocol PLDLinkBankLoginViewControllerDelegate <NSObject>

- (void)loginViewController:(PLDLinkBankMFALoginViewController *)loginViewController
    didFinishWithAuthentication:(PLDAuthentication *)authentication;

@end

@interface PLDLinkBankMFALoginViewController : UIViewController

@property(nonatomic, weak) id<PLDLinkBankLoginViewControllerDelegate> delegate;

@property(nonatomic, copy) NSDictionary *options;

- (instancetype)initWithInstitution:(PLDInstitution *)institution
                            product:(PlaidProduct)product;

@end
