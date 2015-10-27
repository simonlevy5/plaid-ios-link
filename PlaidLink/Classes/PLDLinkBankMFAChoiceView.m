//
//  PLDLinkBankMFAChoiceView.m
//  PlaidLink
//
//  Created by Andres Ugarte on 10/22/15.
//  Copyright © 2015 Simon Levy. All rights reserved.
//

#import "PLDLinkBankMFAChoiceView.h"

#import "PLDAuthentication.h"

#import "PLDLinkBankMFAExplainerView.h"
#import "PLDLinkStyledButton.h"

static CGFloat const kButtonHeight = 50.0;
static CGFloat const kPadding = 20.0;
static CGFloat const kExplainerHeight = 24.0;

@implementation PLDLinkBankMFAChoiceView {
  NSMutableArray *_choiceButtons;
}

- (instancetype)initWithFrame:(CGRect)frame tintColor:(UIColor *)tintColor{
  if (self = [super initWithFrame:frame]) {
    self.tintColor = tintColor;
    _choiceButtons = [NSMutableArray array];

    _explainer = [[PLDLinkBankMFAExplainerView alloc] initWithFrame:CGRectZero tintColor:tintColor];
    [_explainer setExplainerText:@"SEND SECURITY CODE"];
    [self addSubview:_explainer];

    _inputLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    _inputLabel.textColor = [UIColor whiteColor];
    _inputLabel.text = @"Where would you like to send it?";
    [_inputLabel sizeToFit];
    [self addSubview:_inputLabel];
  }
  return self;
}

- (void)setChoices:(NSArray *)choices {
  _choices = choices;
  for (UIButton *button in _choiceButtons) {
    [button removeFromSuperview];
    [_choiceButtons removeAllObjects];
  }
  for (PLDMFAAuthenticationChoice *choice in _choices) {
    PLDLinkStyledButton *button = [[PLDLinkStyledButton alloc] initWithFrame:CGRectZero
                                                                   tintColor:self.tintColor];
    [button setTitle:choice.displayText forState:UIControlStateNormal];
    [button addTarget:self
               action:@selector(didTapChoiceButton:)
     forControlEvents:UIControlEventTouchUpInside];
    [_choiceButtons addObject:button];
    [self addSubview:button];
  }
}

- (void)didTapChoiceButton:(id)sender {
  NSUInteger index = [_choiceButtons indexOfObject:sender];
  PLDMFAAuthenticationChoice *choice = [_choices objectAtIndex:index];
  [self.delegate choiceView:self didSelectChoice:choice.choice];
}

- (void)layoutSubviews {
  [super layoutSubviews];

  _explainer.frame = CGRectMake(0, 0, self.bounds.size.width, kExplainerHeight);
  _inputLabel.frame = CGRectMake(kPadding,
                                 CGRectGetMaxY(_explainer.frame) + kPadding,
                                 self.bounds.size.width - 2 * kPadding,
                                 0);
  [_inputLabel sizeToFit];

  CGFloat buttonY = CGRectGetMaxY(_inputLabel.frame) + kPadding;
  CGFloat buttonWidth = self.bounds.size.width - kPadding * 2;
  for (UIButton *button in _choiceButtons) {
    button.frame = CGRectMake(kPadding, buttonY, buttonWidth, kButtonHeight);
    buttonY += kButtonHeight + kPadding / 2;
  }
}

- (void)sizeToFit {
  [self layoutSubviews];

  CGRect frame = self.frame;
  UIButton *lastButton = _choiceButtons.lastObject;
  frame.size.height = CGRectGetMaxY(lastButton.frame) + kPadding;
  self.frame = frame;
}

@end