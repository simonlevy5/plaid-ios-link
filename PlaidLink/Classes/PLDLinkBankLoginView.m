//
//  PLDLinkBankLoginView.m
//  Plaid
//
//  Created by Simon Levy on 10/14/15.
//  Copyright © 2015 Vouch Financial, Inc. All rights reserved.
//

#import "PLDLinkBankLoginView.h"

static CGFloat const kInputVerticalPadding = 12.0;
static CGFloat const kInputHorizontalPadding = 24.0;
static CGFloat const kInputHeight = 46.0;

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
  _usernameTextField.frame = CGRectMake(kInputHorizontalPadding,
                                        kInputVerticalPadding,
                                        bounds.size.width - kInputHorizontalPadding * 2,
                                        kInputHeight);
  _passwordTextField.frame = CGRectMake(kInputHorizontalPadding,
                                        CGRectGetMaxY(_usernameTextField.frame),
                                        bounds.size.width - kInputHorizontalPadding * 2,
                                        kInputHeight);
  if (_pinTextField) {
    _pinTextField.frame = CGRectMake(kInputHorizontalPadding,
                                     CGRectGetMaxY(_passwordTextField.frame) + kInputVerticalPadding,
                                     bounds.size.width - kInputHorizontalPadding * 2,
                                     kInputHeight);
  }

  CGFloat submitButtonY = _isPinRequired ? CGRectGetMaxY(_pinTextField.frame) + kInputVerticalPadding :
      CGRectGetMaxY(_passwordTextField.frame) + kInputVerticalPadding;
  _submitButton.frame = CGRectMake(kInputHorizontalPadding,
                                   submitButtonY,
                                   bounds.size.width - kInputHorizontalPadding * 2,
                                   kInputHeight);
}

- (void)sizeToFit {
  [self layoutSubviews];

  CGRect frame = self.frame;
  frame.size.height = CGRectGetMaxY(_submitButton.frame) + kInputVerticalPadding * 2;
  self.frame = frame;
}

@end
