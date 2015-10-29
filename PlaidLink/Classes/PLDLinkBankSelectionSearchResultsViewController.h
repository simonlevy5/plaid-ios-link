//
//  PLDLinkBankSelectionSearchResultsViewController.h
//  PlaidLink
//
//  Created by Simon Levy on 10/28/15.
//  Copyright © 2015 Simon Levy. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PLDLongTailInstitution;
@class PLDLinkBankSelectionSearchResultsViewController;

@protocol PLDLinkBankSelectionSearchResultsViewControllerDelegate <NSObject>

- (void)searchResultsViewController:(PLDLinkBankSelectionSearchResultsViewController *)viewController
       didSelectLongTailInstitution:(PLDLongTailInstitution *)institution;
- (void)searchResultsViewControllerWillDisappear:(PLDLinkBankSelectionSearchResultsViewController *)viewController;

@end

@interface PLDLinkBankSelectionSearchResultsViewController : UICollectionViewController

@property(nonatomic, weak) id<PLDLinkBankSelectionSearchResultsViewControllerDelegate> delegate;
@property(nonatomic) NSArray *institutions;

@end
