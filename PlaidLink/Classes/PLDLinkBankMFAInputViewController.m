//
//  PLDLinkBankMFAInputViewController.m
//  Plaid
//
//  Created by Simon Levy on 10/20/15.
//  Copyright © 2015 Vouch Financial, Inc. All rights reserved.
//

#import "PLDLinkBankMFAInputViewController.h"

#import "PLDAuthentication.h"
#import "PLDLinkBankContainerView.h"

static CGFloat const kPadding = 20.0;
static CGFloat const kInputHeight = 40.0;

@protocol PLDLinkBankMFAInputViewDelegate <NSObject>

- (void)inputView:(UIView *)view didTapSubmitWithResponse:(NSString *)response;

@end

@interface PLDLinkBankMFAInputView : UIView

@property(nonatomic, weak) id<PLDLinkBankMFAInputViewDelegate> delegate;
@property(nonatomic, readonly) UILabel *inputLabel;
@property(nonatomic, readonly) UILabel *inputSublabel;
@property(nonatomic, readonly) UITextField *inputTextField;
@property(nonatomic, readonly) UIButton *submitButton;

@end

@implementation PLDLinkBankMFAInputView

- (instancetype)initWithFrame:(CGRect)frame {
  if (self = [super initWithFrame:frame]) {
    self.backgroundColor = [UIColor whiteColor];
    
    _inputLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    _inputLabel.text = @"InputLabel";
    [_inputLabel sizeToFit];
    [self addSubview:_inputLabel];
    
    _inputSublabel = [[UILabel alloc] initWithFrame:CGRectZero];
    _inputSublabel.font = [UIFont fontWithName:@"Helvetica" size:13.0];
    _inputSublabel.text = @"Sublabel";
    [_inputSublabel sizeToFit];
    [self addSubview:_inputSublabel];
    
    _inputTextField = [[UITextField alloc] initWithFrame:CGRectZero];
    _inputTextField.placeholder = @"placeholder";
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
  _inputSublabel.frame = CGRectMake(kPadding,
                                    CGRectGetMaxY(_inputLabel.frame),
                                    paddedWidth,
                                    kInputHeight);
  _inputTextField.frame = CGRectMake(kPadding,
                                     CGRectGetMaxY(_inputSublabel.frame) + kPadding,
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

@interface PLDLinkBankMFAInputViewController ()<PLDLinkBankMFAInputViewDelegate>
@end

@implementation PLDLinkBankMFAInputViewController {
  PLDLinkBankMFAInputView *_view;
}

- (void)loadView {
  _view = [[PLDLinkBankMFAInputView alloc] initWithFrame:CGRectZero];
  self.view = _view;
}

- (void)viewDidLoad {
  [super viewDidLoad];

  _view.delegate = self;
  if (self.authentication.mfa.type == kPLDMFATypeQuestion) {
    _view.inputLabel.text = @"Enter your code";
    _view.inputTextField.placeholder = @"Code";
    _view.inputSublabel.text = self.authentication.mfa.data;
  } else if (self.authentication.mfa.type == kPLDMFATypeCode) {
    _view.inputLabel.text = self.authentication.mfa.data;
    _view.inputTextField.placeholder = @"Answer";
    _view.inputSublabel.hidden = YES;
  } else {
    NSAssert(NO, @"Inproper mfa type for PLDLinkBankMFAInputViewController");
  }
}

#pragma mark - PLDLinkBankMFAInputViewDelegate

- (void)inputView:(UIView *)view didTapSubmitWithResponse:(NSString *)response {
  [self submitMFAStepResponse:response options:nil completion:^(NSError *error) {

  }];
}

@end
