//
//  PLDLinkBankLoginView.m
//  PlaidLink
//
//  Created by Simon Levy on 10/14/15.
//

#import "PLDLinkBankMFALoginView.h"

#import "PLDLinkStyledButton.h"
#import "PLDLinkStyledTextField.h"
#import "NSString+Localization.h"
#import "UIColor+PLDLinkUIColor.h"

static CGFloat const kInputVerticalPadding = 12.0;
static CGFloat const kInputHorizontalPadding = 24.0;
static CGFloat const kTextFieldHeight = 36.0;
static CGFloat const kButtonHeight = 46.0;

@implementation PLDLinkBankMFALoginView

- (instancetype)initWithFrame:(CGRect)frame tintColor:(UIColor *)tintColor {
  if (self = [super initWithFrame:frame tintColor:tintColor]) {
    self.tintColor = tintColor;
    NSString *usernamePlaceholder = [NSString stringWithIdentifier:@"login_username_placeholder"];
    _usernameTextField = [[PLDLinkStyledTextField alloc] initWithFrame:CGRectZero
                                                             tintColor:tintColor
                                                           placeholder:usernamePlaceholder];
    _usernameTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    [self addSubview:_usernameTextField];

    NSString *passwordPlaceholder = [NSString stringWithIdentifier:@"login_password_placeholder"];
    _passwordTextField = [[PLDLinkStyledTextField alloc] initWithFrame:CGRectZero
                                                             tintColor:tintColor
                                                           placeholder:passwordPlaceholder];
    _passwordTextField.secureTextEntry = YES;
    _passwordTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    [self addSubview:_passwordTextField];

    _submitButton = [[PLDLinkStyledButton alloc] initWithFrame:CGRectZero tintColor:tintColor];
    [_submitButton setTitle:@"Log in" forState:UIControlStateNormal];
    [self addSubview:_submitButton];
  }
  return self;
}

- (void)setIsPinRequired:(BOOL)isPinRequired {
  _isPinRequired = isPinRequired;
  if (_isPinRequired) {
    NSString *pinPlaceholder = [NSString stringWithIdentifier:@"login_pin_placeholder"];
    _pinTextField = [[PLDLinkStyledTextField alloc] initWithFrame:CGRectZero
                                                        tintColor:self.tintColor
                                                      placeholder:pinPlaceholder];
    _pinTextField.secureTextEntry = YES;
    _pinTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    [self addSubview:_pinTextField];
  } else {
    _pinTextField = nil;
  }
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
  frame.size.height = CGRectGetMaxY(_submitButton.frame) + kInputHorizontalPadding;
  self.frame = frame;
}

@end
