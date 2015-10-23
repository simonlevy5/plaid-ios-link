//
//  PLDLinkBankMFAQuestionOrCodeView.m
//  PlaidLink
//
//  Created by Andres Ugarte on 10/22/15.
//  Copyright © 2015 Simon Levy. All rights reserved.
//

#import "PLDLinkBankMFAQuestionOrCodeView.h"

static CGFloat const kInputVerticalPadding = 12.0;
static CGFloat const kInputHorizontalPadding = 24.0;
static CGFloat const kInputHeight = 46.0;

@implementation PLDLinkBankMFAQuestionOrCodeView

- (instancetype)initWithFrame:(CGRect)frame {
  if (self = [super initWithFrame:frame]) {
    _inputLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    _inputLabel.textColor = [UIColor whiteColor];
    _inputLabel.text = @"InputLabel";
    [_inputLabel sizeToFit];
    [self addSubview:_inputLabel];

    _inputTextField = [[UITextField alloc] initWithFrame:CGRectZero];
    _inputTextField.autocorrectionType = UITextAutocorrectionTypeNo;
    _inputTextField.placeholder = @"placeholder";
    _inputTextField.textColor = [UIColor whiteColor];
    [self addSubview:_inputTextField];

    _submitButton = [[UIButton alloc] initWithFrame:CGRectZero];
    _submitButton.layer.cornerRadius = 8.0;
    _submitButton.backgroundColor = [UIColor colorWithWhite:1 alpha:0.3];
    [_submitButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_submitButton setTitle:@"Submit" forState:UIControlStateNormal];
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
  _inputLabel.frame = CGRectMake(kInputHorizontalPadding,
                                 kInputVerticalPadding,
                                 paddedWidth,
                                 kInputHeight);
  _inputTextField.frame = CGRectMake(kInputHorizontalPadding,
                                     CGRectGetMaxY(_inputLabel.frame) + kInputVerticalPadding,
                                     paddedWidth,
                                     kInputHeight);
  _submitButton.frame = CGRectMake(kInputHorizontalPadding,
                                   CGRectGetMaxY(_inputTextField.frame) + kInputVerticalPadding,
                                   paddedWidth,
                                   kInputHeight);
}

- (void)sizeToFit {
  [self layoutSubviews];

  CGRect frame = self.frame;
  frame.size.height = CGRectGetMaxY(_submitButton.frame) + kInputVerticalPadding * 2;
  self.frame = frame;
}

@end
