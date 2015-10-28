//
//  PLDLinkBankLoginView.h
//  Plaid
//
//  Created by Simon Levy on 10/14/15.
//  Copyright © 2015 Vouch Financial, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PLDLinkStyledButton;

@interface PLDLinkBankMFALoginView : UIView

@property(nonatomic, assign) BOOL isPinRequired;

@property(nonatomic, readonly) UITextField *usernameTextField;
@property(nonatomic, readonly) UITextField *passwordTextField;
@property(nonatomic, readonly) UITextField *pinTextField;
@property(nonatomic, readonly) PLDLinkStyledButton *submitButton;

- (instancetype)initWithFrame:(CGRect)frame tintColor:(UIColor *)tintColor;

@end
