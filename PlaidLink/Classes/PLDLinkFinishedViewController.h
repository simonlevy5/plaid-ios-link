//
//  PLDLinkFinishedViewController.h
//  Plaid
//
//  Created by Simon Levy on 10/19/15.
//  Copyright © 2015 Vouch Financial, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PLDLinkFinishedViewController;

@protocol PLDLinkFinishedViewControllerDelegate <NSObject>

- (void)finishedViewControllerDidFinish:(PLDLinkFinishedViewController *)viewController;

@end

@interface PLDLinkFinishedViewController : UIViewController

@property(nonatomic, weak) id<PLDLinkFinishedViewControllerDelegate> delegate;
@property(nonatomic) NSString *linkSuccessName;

@end
