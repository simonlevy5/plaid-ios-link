//
//  PLDLinkBankMFAViewController.h
//  Plaid
//
//  Created by Simon Levy on 10/14/15.
//  Copyright © 2015 Vouch Financial, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PLDAuthentication;
@class PLDLinkBankMFAViewController;

@protocol PLDLinkBankMFAViewControllerDelegate <NSObject>

- (void)bankMFAViewController:(PLDLinkBankMFAViewController *)viewController
    didFinishWithAuthentication:(PLDAuthentication *)authentication;

@end

@interface PLDLinkBankMFAViewController : UIViewController

@property(nonatomic, weak) id<PLDLinkBankMFAViewControllerDelegate> delegate;
@property(nonatomic, readonly) PLDAuthentication *authentication;

- (instancetype)initWithAuthentication:(PLDAuthentication *)authentication;

- (void)submitMFAStepResponse:(id)response
                      options:(NSDictionary *)options
                   completion:(void (^)(NSError *))completion;

@end
