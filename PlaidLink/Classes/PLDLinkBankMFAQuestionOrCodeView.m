//
//  PLDLinkBankMFAQuestionOrCodeView.m
//  PlaidLink
//
//  Created by Andres Ugarte on 10/22/15.
//

#import "PLDLinkBankMFAQuestionOrCodeView.h"

#import "PLDLinkBankMFAExplainerView.h"
#import "PLDLinkStyledButton.h"
#import "PLDLinkStyledTextField.h"
#import "NSString+Localization.h"

static CGFloat const kInputVerticalPadding = 16.0;
static CGFloat const kInputHorizontalPadding = 24.0;
static CGFloat const kTextFieldHeight = 36.0;
static CGFloat const kButtonHeight = 46.0;

@implementation PLDLinkBankMFAQuestionOrCodeView

- (instancetype)initWithFrame:(CGRect)frame tintColor:(UIColor *)tintColor {
  if (self = [super initWithFrame:frame]) {
    self.tintColor = tintColor;

    _explainer = [[PLDLinkBankMFAExplainerView alloc] initWithFrame:CGRectZero tintColor:tintColor];
    [self addSubview:_explainer];

    _inputLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    _inputLabel.textColor = [UIColor whiteColor];
    _inputLabel.font = [UIFont systemFontOfSize:16];
    _inputLabel.numberOfLines = 0;
    [self addSubview:_inputLabel];

    _inputTextField = [[PLDLinkStyledTextField alloc] initWithFrame:CGRectZero
                                                          tintColor:tintColor
                                                        placeholder:@""];
    [self addSubview:_inputTextField];

    NSString *submitTitle = [NSString stringWithIdentifier:@"button_submit"];
    _submitButton = [[PLDLinkStyledButton alloc] initWithFrame:CGRectZero tintColor:self.tintColor];
    [_submitButton setTitle:submitTitle forState:UIControlStateNormal];
    [_submitButton addTarget:self
                      action:@selector(didTapSubmit)
            forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_submitButton];
  }
  return self;
}

- (BOOL)becomeFirstResponder {
  return [_inputTextField becomeFirstResponder];
}

- (void)didTapSubmit {
  [_delegate inputView:self didTapSubmitWithResponse:_inputTextField.text];
}

- (void)layoutSubviews {
  [super layoutSubviews];

  CGRect bounds = self.bounds;
  CGFloat paddedWidth = bounds.size.width - kInputHorizontalPadding * 2;

  _explainer.frame = CGRectMake(0, 0, bounds.size.width, 24);
  _inputLabel.frame = CGRectMake(kInputHorizontalPadding,
                                 CGRectGetMaxY(_explainer.frame) + kInputVerticalPadding,
                                 paddedWidth,
                                 kTextFieldHeight);
  [_inputLabel sizeToFit];

  _inputTextField.frame = CGRectMake(kInputHorizontalPadding,
                                     CGRectGetMaxY(_inputLabel.frame) + kInputVerticalPadding,
                                     paddedWidth,
                                     kTextFieldHeight);
  _submitButton.frame = CGRectMake(kInputHorizontalPadding,
                                   CGRectGetMaxY(_inputTextField.frame) + kInputVerticalPadding,
                                   paddedWidth,
                                   kButtonHeight);
}

- (void)sizeToFit {
  [self layoutSubviews];

  CGRect frame = self.frame;
  frame.size.height = CGRectGetMaxY(_submitButton.frame) + kInputHorizontalPadding;
  self.frame = frame;
}

@end
