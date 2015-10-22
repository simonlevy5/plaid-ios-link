//
//  PLDLinkBankMFASelectionViewController.h
//  Plaid
//
//  Created by Simon Levy on 10/21/15.
//  Copyright © 2015 Vouch Financial, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PLDLinkBankMFASelectionViewController;
@class PLDMFAAuthenticationSelection;

@protocol PLDLinkBankMFASelectionViewControllerDelegate <NSObject>

- (void)selectionViewController:(PLDLinkBankMFASelectionViewController *)viewController
                didChooseAnswer:(NSString *)answer;

@end

@interface PLDLinkBankMFASelectionViewController : UIViewController

@property(nonatomic, weak) id<PLDLinkBankMFASelectionViewControllerDelegate> delegate;

- (instancetype)initWithAuthenticationSelection:(PLDMFAAuthenticationSelection *)selection;

@end
