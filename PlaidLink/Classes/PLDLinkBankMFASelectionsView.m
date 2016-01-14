//
//  PLDLinkBankMFASelectionsView.m
//  PlaidLink
//
//  Created by Andres Ugarte on 10/28/15.
//

#import "PLDLinkBankMFASelectionsView.h"

#import "PLDLinkBankMFAExplainerView.h"
#import "NSString+Localization.h"

static CGFloat const kExplainerHeight = 24.0;

@implementation PLDLinkBankMFASelectionsView {
  UIView *_currentContent;
}

- (instancetype)initWithFrame:(CGRect)frame tintColor:(UIColor *)tintColor {
  if (self = [super initWithFrame:frame]) {
    _explainer = [[PLDLinkBankMFAExplainerView alloc] initWithFrame:CGRectZero tintColor:tintColor];
    _explainer.explainerText = [NSString stringWithIdentifier:@"mfa_selections_explainer"];
    [self addSubview:_explainer];
  }
  return self;
}

- (void)setCurrentSelectionView:(UIView *)selectionView {
  if (_currentContent) {
    [self animateCurrentSelectionOutWithCompletion:^(BOOL finished) {
      [_currentContent removeFromSuperview];
      _currentContent = selectionView;
      [self addSubview:_currentContent];
      [self setNeedsLayout];
      [self layoutIfNeeded];
      [self animateCurrentSelectionIn:^(BOOL finished) {
        [_currentContent becomeFirstResponder];
      }];
    }];
  } else {
    _currentContent = selectionView;
    [self addSubview:_currentContent];
    [self setNeedsLayout];
  }
}

- (void)layoutSubviews {
  [super layoutSubviews];

  CGRect bounds = self.bounds;

  _explainer.frame = CGRectMake(0, 0, bounds.size.width, kExplainerHeight);

  _currentContent.frame = CGRectMake(0,
                                     CGRectGetMaxY(_explainer.frame),
                                     bounds.size.width,
                                     200);
  [_currentContent sizeToFit];
}

- (void)sizeToFit {
  [self layoutSubviews];

  CGRect frame = self.frame;
  frame.size.height = CGRectGetMaxY(_currentContent.frame);
  self.frame = frame;
}

- (void)animateCurrentSelectionOutWithCompletion:(void (^ __nullable)(BOOL finished))completion {
  [UIView animateWithDuration:0.2
                        delay:0
                      options:UIViewAnimationOptionCurveEaseIn
                   animations:^{
                     _currentContent.alpha = 0;
                   } completion:completion];
}

- (void)animateCurrentSelectionIn:(void (^ __nullable)(BOOL finished))completion {
  _currentContent.alpha = 0;
  _currentContent.transform = CGAffineTransformMakeTranslation(CGRectGetWidth(self.bounds), 0);
  [UIView animateWithDuration:0.25
                        delay:0
                      options:UIViewAnimationOptionCurveEaseOut
                   animations:^{
                     _currentContent.alpha = 1;
                     _currentContent.transform = CGAffineTransformIdentity;
                     [self layoutSubviews];
                   } completion:completion];
}

@end
