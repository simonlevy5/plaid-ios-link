//
//  PLDLinkBankSelectionViewController.h
//  PlaidLink
//
//  Created by Simon Levy on 10/13/15.
//

#import <UIKit/UIKit.h>

#import <plaid_ios_sdk/PLDDefines.h>

@class PLDLinkBankSelectionViewController;
@class PLDInstitution;

@protocol PLDLinkBankSelectionViewControllerDelegate <NSObject>

- (void)bankSelectionViewController:(PLDLinkBankSelectionViewController *)viewController
           didFinishWithInstitution:(PLDInstitution *)institution;
- (void)bankSelectionViewControllerDidFinishWithBankNotListed:(PLDLinkBankSelectionViewController *)viewController;
- (void)bankSelectionViewControllerCancelled:(PLDLinkBankSelectionViewController *)viewController;

@end

@interface PLDLinkBankSelectionViewController : UIViewController

@property(nonatomic, weak) id<PLDLinkBankSelectionViewControllerDelegate> delegate;

- (instancetype)initWithProduct:(PlaidProduct)product;

@end
