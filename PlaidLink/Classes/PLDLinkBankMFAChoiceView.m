//
//  PLDLinkBankMFAChoiceView.m
//  PlaidLink
//
//  Created by Andres Ugarte on 10/22/15.
//

#import "PLDLinkBankMFAChoiceView.h"

#import "PLDAuthentication.h"

#import "PLDLinkBankMFAExplainerView.h"
#import "PLDLinkStyledButton.h"
#import "NSString+Localization.h"

static CGFloat const kExplainerHeight = 24.0;
static CGFloat const kInputVerticalPadding = 16.0;
static CGFloat const kInputHorizontalPadding = 24.0;
static CGFloat const kButtonHeight = 46.0;

@implementation PLDLinkBankMFAChoiceView {
  NSMutableArray *_choiceButtons;
}

- (instancetype)initWithFrame:(CGRect)frame tintColor:(UIColor *)tintColor{
  if (self = [super initWithFrame:frame]) {
    self.tintColor = tintColor;
    _choiceButtons = [NSMutableArray array];

    NSString *explainerText = [NSString stringWithIdentifier:@"mfa_choice_title"];
    _explainer = [[PLDLinkBankMFAExplainerView alloc] initWithFrame:CGRectZero tintColor:tintColor];
    [_explainer setExplainerText:explainerText];
    [self addSubview:_explainer];

    _inputLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    _inputLabel.textColor = [UIColor whiteColor];
    _inputLabel.text = [NSString stringWithIdentifier:@"mfa_choice_subtitle"];
    _inputLabel.numberOfLines = 0;
    _inputLabel.font = [UIFont systemFontOfSize:16];
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
  _inputLabel.frame = CGRectMake(kInputHorizontalPadding,
                                 CGRectGetMaxY(_explainer.frame) + kInputVerticalPadding,
                                 self.bounds.size.width - 2 * kInputHorizontalPadding,
                                 0);
  [_inputLabel sizeToFit];

  CGFloat buttonY = CGRectGetMaxY(_inputLabel.frame) + kInputVerticalPadding + 4;
  CGFloat buttonWidth = self.bounds.size.width - kInputHorizontalPadding * 2;
  for (UIButton *button in _choiceButtons) {
    button.frame = CGRectMake(kInputHorizontalPadding, buttonY, buttonWidth, kButtonHeight);
    buttonY += kButtonHeight + kInputVerticalPadding;
  }
}

- (void)sizeToFit {
  [self layoutSubviews];

  CGRect frame = self.frame;
  UIButton *lastButton = _choiceButtons.lastObject;
  frame.size.height = CGRectGetMaxY(lastButton.frame) + kInputHorizontalPadding;
  self.frame = frame;
}

@end