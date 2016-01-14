//
//  PLDLinkBankLoginView.h
//  PlaidLink
//
//  Created by Simon Levy on 10/14/15.
//

#import <UIKit/UIKit.h>

#import "PLDLinkBankMFABaseStepView.h"

@class PLDLinkStyledButton;

@interface PLDLinkBankMFALoginView : PLDLinkBankMFABaseStepView

@property(nonatomic, assign) BOOL isPinRequired;

@property(nonatomic, readonly) UITextField *usernameTextField;
@property(nonatomic, readonly) UITextField *passwordTextField;
@property(nonatomic, readonly) UITextField *pinTextField;
@property(nonatomic, readonly) PLDLinkStyledButton *submitButton;

- (instancetype)initWithFrame:(CGRect)frame tintColor:(UIColor *)tintColor;

@end
