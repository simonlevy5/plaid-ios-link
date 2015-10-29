//
//  PLDLinkBankMFASelectionView.m
//  PlaidLink
//
//  Created by Andres Ugarte on 10/28/15.
//

#import "PLDLinkBankMFASelectionView.h"

#import "PLDAuthentication.h"

#import "PLDLinkBankMFAExplainerView.h"
#import "PLDLinkStyledButton.h"

static CGFloat const kButtonHeight = 50.0;
static CGFloat const kPadding = 20.0;

@implementation PLDLinkBankMFASelectionView {
  NSMutableArray *_answerButtons;
}

- (instancetype)initWithSelection:(PLDMFAAuthenticationSelection *)selection tintColor:(UIColor *)tintColor {
  if (self = [super initWithFrame:CGRectZero]) {
    _questionLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    _questionLabel.text = selection.question;
    _questionLabel.textColor = [UIColor whiteColor];
    _questionLabel.numberOfLines = 0;
    _questionLabel.font = [UIFont systemFontOfSize:16];
    [self addSubview:_questionLabel];

    _answers = selection.answers;
    _answerButtons = [NSMutableArray array];
    for (NSString *answer in _answers) {
      UIButton *button = [[PLDLinkStyledButton alloc] initWithFrame:CGRectZero tintColor:tintColor];
      [button setTitle:answer forState:UIControlStateNormal];
      [button addTarget:self
                 action:@selector(didTapAnswerButton:)
       forControlEvents:UIControlEventTouchUpInside];
      [_answerButtons addObject:button];
      [self addSubview:button];
    }
  }
  return self;
}

- (void)layoutSubviews {
  [super layoutSubviews];

  CGRect bounds = self.bounds;
  CGFloat paddedWidth = bounds.size.width - kPadding * 2;

  _questionLabel.frame = CGRectMake(kPadding, kPadding, paddedWidth, 40.0);
  [_questionLabel sizeToFit];

  CGFloat buttonY = CGRectGetMaxY(_questionLabel.frame) + kPadding;
  CGFloat buttonWidth = self.bounds.size.width - kPadding * 2;
  for (UIButton *button in _answerButtons) {
    button.frame = CGRectMake(kPadding, buttonY, buttonWidth, kButtonHeight);
    buttonY += kButtonHeight + kPadding;
  }
}

- (void)sizeToFit {
  [self layoutSubviews];

  CGRect frame = self.frame;
  UIButton *lastButton = _answerButtons.lastObject;
  frame.size.height = CGRectGetMaxY(lastButton.frame) + kPadding;
  self.frame = frame;
}

- (void)didTapAnswerButton:(id)sender {
  NSUInteger index = [_answerButtons indexOfObject:sender];
  NSString *answer = [_answers objectAtIndex:index];
  [_delegate selectionView:self didChooseAnswer:answer];
}

@end
