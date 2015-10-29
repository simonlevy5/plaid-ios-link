//
//  PLDLinkBankMFASelectionViewController.h
//  PlaidLink
//
//  Created by Simon Levy on 10/21/15.
//

#import <UIKit/UIKit.h>

@class PLDInstitution;
@class PLDLinkBankMFASelectionViewController;
@class PLDMFAAuthenticationSelection;

@protocol PLDLinkBankMFASelectionViewControllerDelegate <NSObject>

- (void)selectionViewController:(PLDLinkBankMFASelectionViewController *)viewController
                didChooseAnswer:(NSString *)answer;

@end

@interface PLDLinkBankMFASelectionViewController : UIViewController

@property(nonatomic, weak) id<PLDLinkBankMFASelectionViewControllerDelegate> delegate;

- (instancetype)initWithAuthenticationSelection:(PLDMFAAuthenticationSelection *)selection
                                    institution:(PLDInstitution *)institution;

@end
