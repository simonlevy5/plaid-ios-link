//
//  PLDLinkBankMFAChoiceView.m
//  PlaidLink
//
//  Created by Andres Ugarte on 10/22/15.
//  Copyright © 2015 Simon Levy. All rights reserved.
//

#import "PLDLinkBankMFAChoiceView.h"

#import "PLDAuthentication.h"

static CGFloat const kButtonHeight = 50.0;
static CGFloat const kPadding = 20.0;

@implementation PLDLinkBankMFAChoiceView {
  NSMutableArray *_choiceButtons;
}

- (void)setChoices:(NSArray *)choices {
  _choices = choices;
  for (UIButton *button in _choiceButtons) {
    [button removeFromSuperview];
    [_choiceButtons removeAllObjects];
  }
  for (PLDMFAAuthenticationChoice *choice in _choices) {
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectZero];
    button.backgroundColor = [UIColor grayColor];
    [button setTitle:choice.displayText forState:UIControlStateNormal];
    [button addTarget:self
               action:@selector(didTapChoiceButton:)
     forControlEvents:UIControlEventTouchUpInside];
    [_choiceButtons addObject:button];
    [self addSubview:button];
  }
}

- (instancetype)initWithFrame:(CGRect)frame {
  if (self = [super initWithFrame:frame]) {
    _choiceButtons = [NSMutableArray array];
  }
  return self;
}

- (void)didTapChoiceButton:(id)sender {
  NSUInteger index = [_choiceButtons indexOfObject:sender];
  PLDMFAAuthenticationChoice *choice = [_choices objectAtIndex:index];
  [self.delegate choiceView:self didSelectChoice:choice.choice];
}

- (void)layoutSubviews {
  [super layoutSubviews];

  CGFloat buttonY = kPadding;
  CGFloat buttonWidth = self.bounds.size.width - kPadding * 2;
  for (UIButton *button in _choiceButtons) {
    button.frame = CGRectMake(kPadding, buttonY, buttonWidth, kButtonHeight);
    buttonY += kButtonHeight + kPadding;
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