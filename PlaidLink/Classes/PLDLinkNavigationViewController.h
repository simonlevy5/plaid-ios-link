//
//  PLDLinkNavigationViewController.h
//  PlaidLink
//
//  Created by Simon Levy on 10/14/15.
//

#import <UIKit/UIKit.h>

#import <plaid_ios_sdk/PLDDefines.h>

@class PLDLinkNavigationViewController;

/**
 Protocol adopted by classes that listen for callbacks from the PLDLinkNavigationViewController. Callbacks occur when the Plaid Link process has completed or cancelled.
 */
@protocol PLDLinkNavigationControllerDelegate <NSObject>

/**
 Called when the PLDLinkNavigationController has successfully logged a user in and obtained an access token for that user.
 
 @param navigationController The navigation controller presenting Plaid Link.
 @param accessToken A valid access token for a user to access the Plaid system.
 */
- (void)linkNavigationContoller:(PLDLinkNavigationViewController *)navigationController
       didFinishWithAccessToken:(NSString *)accessToken;

/**
 Called when a user taps the "I don't see my bank" cell.

 Implementing classes should dismiss the PLDLinkNavigationViewController when this is called, and probably give the option to manually enter bank information.

 @param navigationController The navigation controller presenting Plaid Link.
 */
- (void)linkNavigationControllerDidFinishWithBankNotListed:(PLDLinkNavigationViewController *)navigationController;

/**
 Called when a user taps the 'X' in the top right corner of the navigation controller with the intention of cancelling their bank login process.
 
 Implementing classes should dismiss the PLDLinkNavigationViewController when this is called.
 
 @param navigationController The navigation controller presenting Plaid Link.
 */
- (void)linkNavigationControllerDidCancel:(PLDLinkNavigationViewController *)navigationController;

@end

/**
 The container for the entire bank login process using Plaid. This navigation controller handles bank selection, login, and multi-factor authentication to a user's financial institution via Plaid.
 
 For further documentation please see https://github.com/plaid/link
 */
@interface PLDLinkNavigationViewController : UINavigationController

/**
 The object receiving callbacks from the PLDLinkNavigationController. 
 
 @see PLDLinkNavigationControllerDelegate
 */
@property(nonatomic, weak) id<PLDLinkNavigationControllerDelegate> linkDelegate;

/**
 The Plaid environment to use when authenticating a user via Plaid.
 */
@property(nonatomic, readonly) PlaidEnvironment environment;
/**
 The Plaid product to authenticate a user into.
 
 @see https://plaid.com/ for further details.
 */
@property(nonatomic, readonly) PlaidProduct product;

// Optional Properties
@property(nonatomic, copy) NSDictionary *options;

/**
 Create a new PLDLinkNavigationController instance to present the authentication workflow to a user.
 
 @param environment The Plaid environment to use for authentication.
 @param product The Plaid product to authentication the user into.
 
 @return A new instance of PLDLinkNavigationController.
 */
- (instancetype)initWithEnvironment:(PlaidEnvironment)environment
                            product:(PlaidProduct)product;

@end
