//
//  PLDLinkBankMFAQuestionOrCodeView.m
//  PlaidLink
//
//  Created by Andres Ugarte on 10/22/15.
//  Copyright © 2015 Simon Levy. All rights reserved.
//

#import "PLDLinkBankMFAQuestionOrCodeView.h"

static CGFloat const kPadding = 20.0;
static CGFloat const kInputHeight = 40.0;

@implementation PLDLinkBankMFAQuestionOrCodeView

- (instancetype)initWithFrame:(CGRect)frame {
  if (self = [super initWithFrame:frame]) {
    _inputLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    _inputLabel.textColor = [UIColor whiteColor];
    _inputLabel.text = @"InputLabel";
    [_inputLabel sizeToFit];
    [self addSubview:_inputLabel];

    _inputTextField = [[UITextField alloc] initWithFrame:CGRectZero];
    _inputTextField.placeholder = @"placeholder";
    _inputTextField.textColor = [UIColor whiteColor];
    [self addSubview:_inputTextField];

    _submitButton = [[UIButton alloc] initWithFrame:CGRectZero];
    _submitButton.backgroundColor = [UIColor grayColor];
    [_submitButton setTitle:@"Submit" forState:UIControlStateNormal];
    [_submitButton addTarget:self
                      action:@selector(didTapSubmit)
            forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_submitButton];
  }
  return self;
}

- (void)layoutSubviews {
  [super layoutSubviews];

  CGRect bounds = self.bounds;
  CGFloat paddedWidth = bounds.size.width - kPadding * 2;
  _inputLabel.frame = CGRectMake(kPadding,
                                 kPadding,
                                 paddedWidth,
                                 kInputHeight);
  _inputTextField.frame = CGRectMake(kPadding,
                                     CGRectGetMaxY(_inputLabel.frame) + kPadding,
                                     paddedWidth,
                                     kInputHeight);
  _submitButton.frame = CGRectMake(kPadding,
                                   CGRectGetMaxY(_inputTextField.frame) + kPadding,
                                   paddedWidth,
                                   kInputHeight);
}

- (void)didTapSubmit {
  [_delegate inputView:self didTapSubmitWithResponse:_inputTextField.text];
}

@end
