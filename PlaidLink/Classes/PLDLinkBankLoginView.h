//
//  PLDLinkBankLoginView.h
//  Plaid
//
//  Created by Simon Levy on 10/14/15.
//  Copyright © 2015 Vouch Financial, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PLDLinkBankLoginView : UIView

@property(nonatomic, assign) BOOL isPinRequired;

@property(nonatomic, readonly) UITextField *usernameTextField;
@property(nonatomic, readonly) UITextField *passwordTextField;
@property(nonatomic, readonly) UITextField *pinTextField;
@property(nonatomic, readonly) UIButton *submitButton;

- (instancetype)initWithFrame:(CGRect)frame tintColor:(UIColor *)tintColor;

@end
