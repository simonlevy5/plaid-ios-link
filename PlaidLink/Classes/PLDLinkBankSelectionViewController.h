//
//  PLDLinkBankSelectionViewController.h
//  Plaid
//
//  Created by Simon Levy on 10/13/15.
//  Copyright © 2015 Vouch Financial, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "PLDDefines.h"

@class PLDLinkBankSelectionViewController;
@class PLDInstitution;

@protocol PLDLinkBankSelectionViewControllerDelegate <NSObject>

- (void)bankSelectionViewController:(PLDLinkBankSelectionViewController *)viewController
           didFinishWithInstitution:(PLDInstitution *)institution;

- (void)bankSelectionViewControllerCancelled:(PLDLinkBankSelectionViewController *)viewController;

@end

@interface PLDLinkBankSelectionViewController : UIViewController

@property(nonatomic, weak) id<PLDLinkBankSelectionViewControllerDelegate> delegate;

@end
