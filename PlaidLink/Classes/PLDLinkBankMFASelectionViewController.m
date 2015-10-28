//
//  PLDLinkBankMFASelectionViewController.m
//  Plaid
//
//  Created by Simon Levy on 10/21/15.
//  Copyright © 2015 Vouch Financial, Inc. All rights reserved.
//

#import "PLDLinkBankMFASelectionViewController.h"

#import "PLDAuthentication.h"
#import "PLDLinkBankMFAContainerView.h"

static CGFloat const kButtonHeight = 50.0;
static CGFloat const kPadding = 20.0;

@protocol PLDLinkBankMFASelectionViewDelegate <NSObject>

- (void)selectionView:(UIView *)view didChooseAnswer:(NSString *)answer;

@end

@interface PLDLinkBankMFASelectionView : UIView

@property(nonatomic, weak) id<PLDLinkBankMFASelectionViewDelegate> delegate;
@property(nonatomic, readonly) UILabel *questionLabel;
@property(nonatomic, readonly) NSArray *answers;

@end

@implementation PLDLinkBankMFASelectionView {
  NSMutableArray *_answerButtons;
}

- (instancetype)initWithSelection:(PLDMFAAuthenticationSelection *)selection {
  if (self = [super initWithFrame:CGRectZero]) {
    _questionLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    _questionLabel.text = selection.question;
    [self addSubview:_questionLabel];

    _answers = selection.answers;
    _answerButtons = [NSMutableArray array];
    for (NSString *answer in _answers) {
      UIButton *button = [[UIButton alloc] initWithFrame:CGRectZero];
      button.backgroundColor = [UIColor grayColor];
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
  _questionLabel.frame = CGRectMake(kPadding, 0, paddedWidth, 40.0);

  CGFloat buttonY = CGRectGetMaxY(_questionLabel.frame) + kPadding;
  CGFloat buttonWidth = self.bounds.size.width - kPadding * 2;
  for (UIButton *button in _answerButtons) {
    button.frame = CGRectMake(kPadding, buttonY, buttonWidth, kButtonHeight);
    buttonY += kButtonHeight + kPadding;
  }
}

- (void)didTapAnswerButton:(id)sender {
  NSUInteger index = [_answerButtons indexOfObject:sender];
  NSString *answer = [_answers objectAtIndex:index];
  [_delegate selectionView:self didChooseAnswer:answer];
}

@end

@interface PLDLinkBankMFASelectionViewController ()<PLDLinkBankMFASelectionViewDelegate>
@end

@implementation PLDLinkBankMFASelectionViewController {
  PLDMFAAuthenticationSelection *_selection;
  PLDLinkBankMFASelectionView *_view;
}

- (instancetype)initWithAuthenticationSelection:(PLDMFAAuthenticationSelection *)selection {
  if (self = [super init]) {
    _selection = selection;
  }
  return self;
}

- (void)loadView {
  _view = [[PLDLinkBankMFASelectionView alloc] initWithSelection:_selection];
  _view.delegate = self;
  self.view = _view;
}

#pragma mark - PLDLinkBankMFASelectionViewDelegate

- (void)selectionView:(UIView *)view didChooseAnswer:(NSString *)answer {
  [_delegate selectionViewController:self didChooseAnswer:answer];
}

@end
