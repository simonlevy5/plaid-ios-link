//
//  PLDLinkNavigationViewController.h
//  Plaid
//
//  Created by Simon Levy on 10/14/15.
//  Copyright © 2015 Vouch Financial, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "PLDDefines.h"

@class PLDLinkNavigationViewController;

@protocol PLDLinkNavigationControllerDelegate <NSObject>

- (void)linkNavigationContoller:(PLDLinkNavigationViewController *)navigationController
       didFinishWithAccessToken:(NSString *)accessToken;

- (void)linkNavigationControllerCancelled:(PLDLinkNavigationViewController *)navigationController;

@end

@interface PLDLinkNavigationViewController : UINavigationController

@property(nonatomic, weak) id<PLDLinkNavigationControllerDelegate> linkDelegate;

@property(nonatomic, assign) PlaidEnvironment environment;
@property(nonatomic, assign) PlaidProduct product;
@property(nonatomic, copy) NSString *publicKey;

// Optional Properties
@property(nonatomic, copy) NSString *dataToken;
@property(nonatomic, assign) BOOL longtail;
@property(nonatomic, copy) NSString *webhook;

- (instancetype)initWithEnvironment:(PlaidEnvironment)environment
                            product:(PlaidProduct)product
                          publicKey:(NSString *)publicKey;

@end
