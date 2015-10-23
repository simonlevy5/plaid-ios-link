//
//  PLDLinkBankLoginView.m
//  Plaid
//
//  Created by Simon Levy on 10/14/15.
//  Copyright © 2015 Vouch Financial, Inc. All rights reserved.
//

#import "PLDLinkBankLoginView.h"

static CGFloat const kInputPadding = 24.0;
static CGFloat const kInputHeight = 48.0;

@implementation PLDLinkBankLoginView

- (instancetype)initWithFrame:(CGRect)frame tintColor:(UIColor *)tintColor {
  if (self = [super initWithFrame:frame]) {
    _usernameTextField = [[UITextField alloc] initWithFrame:CGRectZero];
    _usernameTextField.placeholder = @"username";
    _usernameTextField.autocorrectionType = UITextAutocorrectionTypeNo;
    _usernameTextField.textColor = [UIColor whiteColor];
    [self addSubview:_usernameTextField];

    _passwordTextField = [[UITextField alloc] initWithFrame:CGRectZero];
    _passwordTextField.placeholder = @"password";
    _passwordTextField.secureTextEntry = YES;
    _passwordTextField.textColor = [UIColor whiteColor];
    [self addSubview:_passwordTextField];
    
    _pinTextField = [[UITextField alloc] initWithFrame:CGRectZero];
    _pinTextField.placeholder = @"pin";
    _pinTextField.secureTextEntry = YES;
    _pinTextField.hidden = YES;
    _pinTextField.textColor = [UIColor whiteColor];
    [self addSubview:_pinTextField];

    _submitButton = [[UIButton alloc] initWithFrame:CGRectZero];
    _submitButton.layer.cornerRadius = 8.0;
    _submitButton.backgroundColor = [UIColor colorWithWhite:1 alpha:0.3];
    _submitButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    [_submitButton setTitle:@"Submit" forState:UIControlStateNormal];
    [_submitButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self addSubview:_submitButton];
  }
  return self;
}

- (void)layoutSubviews {
  [super layoutSubviews];

  CGRect bounds = self.bounds;
  _usernameTextField.frame = CGRectMake(kInputPadding,
                                        kInputPadding,
                                        bounds.size.width - kInputPadding * 2,
                                        kInputHeight);
  _passwordTextField.frame = CGRectMake(kInputPadding,
                                        CGRectGetMaxY(_usernameTextField.frame),
                                        bounds.size.width - kInputPadding * 2,
                                        kInputHeight);
  if (_pinTextField) {
    _pinTextField.frame = CGRectMake(kInputPadding,
                                     CGRectGetMaxY(_passwordTextField.frame) + kInputPadding,
                                     bounds.size.width - kInputPadding * 2,
                                     kInputHeight);
  }

  CGFloat submitButtonY = _isPinRequired ? CGRectGetMaxY(_pinTextField.frame) + kInputPadding :
      CGRectGetMaxY(_passwordTextField.frame) + kInputPadding;
  _submitButton.frame = CGRectMake(kInputPadding,
                                   submitButtonY,
                                   bounds.size.width - kInputPadding * 2,
                                   kInputHeight);
}

@end
