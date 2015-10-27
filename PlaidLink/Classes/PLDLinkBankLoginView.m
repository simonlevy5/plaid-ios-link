//
//  PLDLinkBankLoginView.m
//  Plaid
//
//  Created by Simon Levy on 10/14/15.
//  Copyright © 2015 Vouch Financial, Inc. All rights reserved.
//

#import "PLDLinkBankLoginView.h"

#import "PLDLinkStyledButton.h"
#import "PLDLinkStyledTextField.h"
#import "UIColor+PLDLinkUIColor.h"

static CGFloat const kInputVerticalPadding = 12.0;
static CGFloat const kInputHorizontalPadding = 24.0;
static CGFloat const kTextFieldHeight = 36.0;
static CGFloat const kButtonHeight = 46.0;

@implementation PLDLinkBankLoginView

- (instancetype)initWithFrame:(CGRect)frame tintColor:(UIColor *)tintColor {
  if (self = [super initWithFrame:frame]) {
    _usernameTextField = [[PLDLinkStyledTextField alloc] initWithFrame:CGRectZero
                                                             tintColor:tintColor
                                                           placeholder:@"username"];
    _usernameTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    [self addSubview:_usernameTextField];

    _passwordTextField = [[PLDLinkStyledTextField alloc] initWithFrame:CGRectZero
                                                             tintColor:tintColor
                                                           placeholder:@"password"];
    _passwordTextField.secureTextEntry = YES;
    _passwordTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    [self addSubview:_passwordTextField];
    
    _pinTextField = [[UITextField alloc] initWithFrame:CGRectZero];
    _pinTextField.secureTextEntry = YES;
    _pinTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    _pinTextField.hidden = YES;
    _pinTextField.textColor = [UIColor whiteColor];
    _pinTextField.tintColor = [UIColor whiteColor];
    _pinTextField.attributedPlaceholder =
        [[NSAttributedString alloc] initWithString:@"pin"
                                        attributes:@{NSForegroundColorAttributeName: [tintColor lighterColorForText]}];
    [self addSubview:_pinTextField];

    _submitButton = [[PLDLinkStyledButton alloc] initWithFrame:CGRectZero tintColor:tintColor];
    [_submitButton setTitle:@"Submit" forState:UIControlStateNormal];
    [self addSubview:_submitButton];
  }
  return self;
}

- (void)layoutSubviews {
  [super layoutSubviews];

  CGRect bounds = self.bounds;
  _usernameTextField.frame = CGRectMake(kInputHorizontalPadding,
                                        kInputVerticalPadding,
                                        bounds.size.width - kInputHorizontalPadding * 2,
                                        kTextFieldHeight);
  _passwordTextField.frame = CGRectMake(kInputHorizontalPadding,
                                        CGRectGetMaxY(_usernameTextField.frame) + kInputVerticalPadding,
                                        bounds.size.width - kInputHorizontalPadding * 2,
                                        kTextFieldHeight);
  if (_pinTextField) {
    _pinTextField.frame = CGRectMake(kInputHorizontalPadding,
                                     CGRectGetMaxY(_passwordTextField.frame) + kInputVerticalPadding,
                                     bounds.size.width - kInputHorizontalPadding * 2,
                                     kTextFieldHeight);
  }

  CGFloat submitButtonY = _isPinRequired ? CGRectGetMaxY(_pinTextField.frame) + kInputVerticalPadding :
      CGRectGetMaxY(_passwordTextField.frame) + kInputVerticalPadding;
  _submitButton.frame = CGRectMake(kInputHorizontalPadding,
                                   submitButtonY + kInputVerticalPadding,
                                   bounds.size.width - kInputHorizontalPadding * 2,
                                   kButtonHeight);
}

- (void)sizeToFit {
  [self layoutSubviews];

  CGRect frame = self.frame;
  frame.size.height = CGRectGetMaxY(_submitButton.frame) + kInputVerticalPadding * 2;
  self.frame = frame;
}

@end
